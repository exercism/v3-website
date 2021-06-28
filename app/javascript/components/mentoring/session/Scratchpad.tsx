import React, { useCallback, useState, useRef, useEffect } from 'react'
import {
  MarkdownEditor,
  MarkdownEditorHandle,
} from '../../common/MarkdownEditor'
import { sendRequest } from '../../../utils/send-request'
import { useIsMounted } from 'use-is-mounted'
import { typecheck } from '../../../utils/typecheck'
import { camelizeKeys } from 'humps'
import { Loading } from '../../common/Loading'
import { TrackIcon } from '../../common/TrackIcon'
import { Introducer } from '../../common'

type ScratchpadPage = {
  contentMarkdown: string
}

type Links = {
  markdown: string
  hideIntroducer: string
  self: string
}

export const Scratchpad = ({
  isIntroducerHidden,
  links,
}: {
  isIntroducerHidden: boolean
  links: Links
}): JSX.Element => {
  const isMountedRef = useIsMounted()
  const editorRef = useRef<MarkdownEditorHandle | null>()
  const [content, setContent] = useState('')
  const [error, setError] = useState('')
  const [page, setPage] = useState<ScratchpadPage | null>(null)

  const handleEditorDidMount = useCallback((editor: MarkdownEditorHandle) => {
    editorRef.current = editor

    if (editorRef.current) {
      setContent(editorRef.current.value() || '')
    }
  }, [])

  const handleChange = useCallback((content) => {
    setContent(content)
  }, [])

  const handleSubmit = useCallback(
    (e) => {
      e.preventDefault()

      if (!editorRef.current || !page) {
        return
      }

      setError('')

      sendRequest({
        endpoint: links.self,
        method: 'PATCH',
        body: JSON.stringify({
          scratchpad_page: { content_markdown: editorRef.current?.value() },
        }),
        isMountedRef: isMountedRef,
      })
        .then((json: any) => {
          if (!json) {
            return
          }

          setPage(
            typecheck<ScratchpadPage>(camelizeKeys(json), 'scratchpadPage')
          )
        })
        .catch((err) => {
          if (err instanceof Response) {
            err.json().then((res: any) => setError(res.error.message))
          }
        })
    },
    [links, isMountedRef, page]
  )

  const pullPage = useCallback(() => {
    sendRequest({
      endpoint: links.self,
      body: null,
      method: 'GET',
      isMountedRef: isMountedRef,
    })
      .then((json) => {
        const page = typecheck<ScratchpadPage>(
          camelizeKeys(json),
          'scratchpadPage'
        )

        setPage({
          ...page,
          contentMarkdown:
            page.contentMarkdown === null ? '' : page.contentMarkdown,
        })
      })
      .catch(() => {
        // TODO: do something
      })
  }, [links, isMountedRef])

  useEffect(pullPage, [pullPage])

  const revert = useCallback(() => {
    if (!editorRef.current || !page) {
      return
    }

    editorRef.current.value(page.contentMarkdown)
  }, [page])

  useEffect(() => {
    if (!editorRef.current || !page) {
      return
    }

    if (editorRef.current.value() !== '') {
      return
    }

    editorRef.current.value(page.contentMarkdown || '')
  }, [page])

  if (!page) {
    return <Loading />
  }

  return (
    <>
      <Introducer
        icon="scratchpad"
        endpoint={links.hideIntroducer}
        hidden={isIntroducerHidden}
      >
        <h3>Introducing your scratchpad</h3>
        <p>
          A <a href={links.markdown}>Markdown-supported</a> place for you to
          write notes and add code snippets you’d like to refer to during
          mentoring.
        </p>
      </Introducer>

      <div className="title">
        {/* TODO: Add real exercise/track for this */}
        Your notes for <strong>Hamming</strong> in
        <TrackIcon
          iconUrl="https://assets.exercism.io/tracks/ruby-hex-white.png"
          title="Ruby"
        />
        <strong>Ruby</strong>
      </div>

      <form onSubmit={handleSubmit} className="c-markdown-editor">
        <MarkdownEditor
          editorDidMount={handleEditorDidMount}
          onChange={handleChange}
          contextId={`scratchpad-${links.self}`}
          options={{ status: [] }}
        />
        <footer className="editor-footer">
          {content === page.contentMarkdown ? null : (
            <div className="--warning">Unsaved</div>
          )}

          {content === page.contentMarkdown ? null : (
            <button
              className="btn-small-discourage"
              type="button"
              onClick={revert}
            >
              Revert to saved
            </button>
          )}

          <button type="submit" className="btn-primary btn-s">
            Save
          </button>
        </footer>
      </form>
      {error ? <p>{error}</p> : null}
    </>
  )
}
