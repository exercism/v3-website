import React, {
  useReducer,
  useRef,
  useEffect,
  useCallback,
  useState,
  createRef,
  createContext,
} from 'react'
import { FileEditor, FileEditorHandle } from './editor/FileEditor'
import { typecheck } from '../utils/typecheck'
import {
  Submission,
  TestRun,
  TestRunStatus,
  File,
  Keybindings,
  WrapSetting,
} from './editor/types'
import { fetchJSON } from '../utils/fetch-json'
import { useRequest, APIError } from '../hooks/use-request'
import { Iteration } from './track/IterationSummary'
import { Header } from './editor/Header'
import { InstructionsPanel } from './editor/InstructionsPanel'
import { TestsPanel } from './editor/TestsPanel'
import { ResultsPanel } from './editor/ResultsPanel'
import { InstructionsTab } from './editor/InstructionsTab'
import { TestsTab } from './editor/TestsTab'
import { ResultsTab } from './editor/ResultsTab'
import { EditorStatusSummary } from './editor/EditorStatusSummary'
import { RunTestsButton } from './editor/RunTestsButton'
import { SubmitButton } from './editor/SubmitButton'
import { useIsMounted } from 'use-is-mounted'
import { camelizeKeys } from 'humps'

export enum EditorStatus {
  INITIALIZED = 'initialized',
  CREATING_SUBMISSION = 'creatingSubmission',
  SUBMISSION_CREATED = 'submissionCreated',
  CREATING_ITERATION = 'creatingIteration',
  SUBMISSION_CANCELLED = 'submissionCancelled',
}

type State = {
  submission?: Submission
  status: EditorStatus
  apiError?: APIError
}

enum ActionType {
  CREATING_SUBMISSION = 'creatingSubmission',
  SUBMISSION_CREATED = 'submissionCreated',
  CREATING_ITERATION = 'creatingIteration',
  SUBMISSION_CANCELLED = 'submissionCancelled',
  SUBMISSION_CHANGED = 'submissionChanged',
}

type EditorRef = {
  file: File
  ref: React.RefObject<FileEditorHandle>
}

type Action =
  | { type: ActionType.CREATING_SUBMISSION }
  | {
      type: ActionType.SUBMISSION_CREATED
      payload: { submission: Submission }
    }
  | { type: ActionType.SUBMISSION_CANCELLED; payload?: { apiError?: APIError } }
  | { type: ActionType.CREATING_ITERATION }
  | {
      type: ActionType.SUBMISSION_CHANGED
      payload: { testRun: TestRun }
    }

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case ActionType.CREATING_SUBMISSION:
      return {
        ...state,
        apiError: undefined,
        submission: undefined,
        status: EditorStatus.CREATING_SUBMISSION,
      }
    case ActionType.SUBMISSION_CREATED:
      return {
        ...state,
        submission: {
          ...action.payload.submission,
          testRun: {
            id: null,
            submissionUuid: action.payload.submission.uuid,
            status: TestRunStatus.QUEUED,
            tests: [],
            message: '',
          },
        },
        status: EditorStatus.SUBMISSION_CREATED,
      }
    case ActionType.SUBMISSION_CANCELLED:
      return {
        ...state,
        apiError: action.payload?.apiError,
        status: EditorStatus.SUBMISSION_CANCELLED,
      }
    case ActionType.CREATING_ITERATION:
      return {
        ...state,
        status: EditorStatus.CREATING_ITERATION,
      }
    case ActionType.SUBMISSION_CHANGED:
      return {
        ...state,
        submission: {
          ...(state.submission as Submission),
          testRun: action.payload.testRun,
        },
      }
    default:
      return state
  }
}

export enum TabIndex {
  INSTRUCTIONS = 'instructions',
  TESTS = 'tests',
  RESULTS = 'results',
}

export const TabsContext = createContext({
  tab: TabIndex.INSTRUCTIONS,
  switchToTab: (index: TabIndex) => {},
})

export function Editor({
  endpoint,
  timeout = 60000,
  initialSubmission,
  files,
  language,
  exercisePath,
  trackTitle,
  exerciseTitle,
  introduction,
  instructions,
  exampleSolution,
}: {
  endpoint: string
  timeout?: number
  initialSubmission?: Submission
  files: File[]
  language: string
  exercisePath: string
  trackTitle: string
  exerciseTitle: string
  introduction: string
  instructions: string
  exampleSolution: string
}) {
  const [tab, switchToTab] = useState(TabIndex.INSTRUCTIONS)
  const [theme, setTheme] = useState('vs')
  const [keybindings, setKeybindings] = useState<Keybindings>(
    Keybindings.DEFAULT
  )
  const [wrap, setWrap] = useState<WrapSetting>('on')
  const isMountedRef = useIsMounted()
  const [{ submission, status, apiError }, dispatch] = useReducer(reducer, {
    status: EditorStatus.INITIALIZED,
    submission: initialSubmission,
  })
  const controllerRef = useRef<AbortController | undefined>(
    new AbortController()
  )
  const editorsRef = useRef<EditorRef[]>(
    files.map((file) => {
      return { file: file, ref: createRef<FileEditorHandle>() } as EditorRef
    })
  )
  const abort = useCallback(() => {
    controllerRef.current?.abort()
    controllerRef.current = undefined
  }, [controllerRef])

  const sendRequest = useCallback(
    (endpoint: string, body: any, method: string) => {
      abort()
      const [request, cancel] = useRequest(endpoint, body, method)
      controllerRef.current = cancel

      return request
        .then((json: any) => {
          if (!isMountedRef.current) {
            throw new Error('Component not mounted')
          }

          return json
        })
        .catch((err) => {
          if (err.message === 'Component not mounted') {
            return
          }

          throw err
        })
        .finally(() => {
          controllerRef.current = undefined
        })
    },
    [controllerRef, isMountedRef]
  )

  const runTests = useCallback(() => {
    const files = editorsRef.current.map((editor) => {
      return editor.ref.current?.getFile()
    })

    dispatch({ type: ActionType.CREATING_SUBMISSION })

    sendRequest(endpoint, JSON.stringify({ files: files }), 'POST')
      .then((json: any) => {
        if (!json) {
          return
        }

        dispatch({
          type: ActionType.SUBMISSION_CREATED,
          payload: { submission: typecheck<Submission>(json, 'submission') },
        })
        switchToTab(TabIndex.RESULTS)
      })
      .catch((err) => {
        if (err instanceof Error) {
          dispatch({ type: ActionType.SUBMISSION_CANCELLED })
        }

        if (err instanceof Response) {
          err.json().then((res: any) => {
            dispatch({
              type: ActionType.SUBMISSION_CANCELLED,
              payload: { apiError: res.error },
            })
          })
        }
      })
  }, [sendRequest, dispatch, editorsRef])

  const submit = useCallback(() => {
    if (!submission) {
      return
    }

    dispatch({ type: ActionType.CREATING_ITERATION })

    sendRequest(submission.links.submit, JSON.stringify({}), 'POST').then(
      (json: any) => {
        if (!json) {
          return
        }

        const iteration = typecheck<Iteration>(json, 'iteration')
        location.assign(iteration.links.self)
      }
    )
  }, [sendRequest, dispatch, submission])

  const cancel = useCallback(() => {
    abort()
    dispatch({ type: ActionType.SUBMISSION_CANCELLED })
  }, [dispatch, abort])

  const updateSubmission = useCallback(
    (testRun: TestRun) => {
      dispatch({
        type: ActionType.SUBMISSION_CHANGED,
        payload: { testRun: testRun },
      })
    },
    [dispatch]
  )

  useEffect(() => {
    return abort
  }, [abort])

  useEffect(() => {
    if (!initialSubmission) {
      return
    }

    sendRequest(initialSubmission.links.testRun, null, 'GET').then(
      (json: any) => {
        if (!json) {
          return
        }

        updateSubmission(typecheck<TestRun>(camelizeKeys(json), 'testRun'))
      }
    )
  }, [sendRequest, initialSubmission, updateSubmission])

  return (
    <TabsContext.Provider value={{ tab, switchToTab }}>
      <div id="page-editor">
        <div className="header">
          <Header.Back exercisePath={exercisePath} />
          <Header.Title trackTitle={trackTitle} exerciseTitle={exerciseTitle} />
          <Header.ActionHints />
          <Header.ActionKeyboardShortcuts />
          <Header.ActionSettings
            theme={theme}
            keybindings={keybindings}
            wrap={wrap}
            setTheme={setTheme}
            setKeybindings={setKeybindings}
            setWrap={setWrap}
          />
          <Header.ActionMore />
        </div>

        <div className="main-lhs">
          {editorsRef.current.map((editor) => (
            <FileEditor
              key={editor.file.filename}
              file={editor.file}
              ref={editor.ref}
              language={language}
              theme={theme}
              keybindings={keybindings}
              wrap={wrap}
              onRunTests={runTests}
            />
          ))}
        </div>

        <div className="main-rhs">
          <InstructionsPanel
            introduction={introduction}
            instructions={instructions}
            exampleSolution={exampleSolution}
          />
          <TestsPanel />
          <ResultsPanel
            submission={submission}
            timeout={timeout}
            onUpdate={updateSubmission}
          />
        </div>

        <div className="footer-lhs">
          <EditorStatusSummary
            status={status}
            onCancel={cancel}
            error={apiError?.message}
          />
          <RunTestsButton onClick={runTests} />
          <SubmitButton
            onClick={submit}
            disabled={submission?.testRun?.status !== TestRunStatus.PASS}
          />
        </div>

        <div className="footer-rhs">
          <div className="tabs">
            <InstructionsTab />
            <TestsTab />
            <ResultsTab />
          </div>
        </div>
      </div>
    </TabsContext.Provider>
  )
}
