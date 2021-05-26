import React, { useState, useEffect, useRef } from 'react'
import { EditorView, keymap, KeyBinding } from '@codemirror/view'
import { basicSetup } from '@codemirror/basic-setup'
import { EditorState, Compartment } from '@codemirror/state'
import { indentUnit } from '@codemirror/language'
import { Themes } from '../editor/types'
import { languageCompartment } from './CodeMirror/languageCompartment'
import { a11yTabBindingPanel } from './CodeMirror/a11yTabBinding'
import { defaultTabBinding } from '@codemirror/commands'

const wrapCompartment = new Compartment()
const themeCompartment = new Compartment()
const tabCaptureCompartment = new Compartment()

export type Handler = {
  setValue: (value: string) => void
  getValue: () => string
}
export const CodeMirror = ({
  hidden,
  value,
  language,
  commands,
  theme,
  wrap,
  useSoftTabs,
  tabSize,
  isTabCaptured,
  editorDidMount,
}: {
  hidden: boolean
  value: string
  language: string
  theme: Themes
  commands: KeyBinding[]
  wrap: boolean
  useSoftTabs: boolean
  isTabCaptured: boolean
  tabSize: number
  editorDidMount: (handler: Handler) => void
}): JSX.Element => {
  const [textarea, setTextarea] = useState<HTMLDivElement | null>(null)
  const viewRef = useRef<EditorView | null>(null)

  const setValue = (text: string) => {
    if (!viewRef.current) {
      return
    }

    const transaction = viewRef.current.state.update({
      changes: {
        from: 0,
        to: viewRef.current.state.doc.length,
        insert: text,
      },
    })

    viewRef.current.dispatch(transaction)
  }

  const getValue = () => {
    return viewRef.current?.state.doc.toString() || ''
  }

  useEffect(() => {
    if (!textarea) {
      return
    }

    if (viewRef.current) {
      return
    }

    const view = new EditorView({
      state: EditorState.create({
        doc: value,
        extensions: [
          basicSetup,
          a11yTabBindingPanel(),
          tabCaptureCompartment.of(
            keymap.of(isTabCaptured ? [defaultTabBinding] : [])
          ),
          languageCompartment(language),
          EditorState.tabSize.of(tabSize),
          indentUnit.of(useSoftTabs ? '  ' : '	'),
          wrapCompartment.of(wrap ? EditorView.lineWrapping : []),
          themeCompartment.of(
            EditorView.theme({}, { dark: theme === Themes.DARK })
          ),
          keymap.of(commands),
        ],
      }),
      parent: textarea,
    })

    viewRef.current = view

    editorDidMount({ setValue, getValue })
  })

  useEffect(() => {
    if (!viewRef.current) {
      return
    }

    viewRef.current.dispatch({
      effects: wrapCompartment.reconfigure(wrap ? EditorView.lineWrapping : []),
    })
  }, [wrap])

  useEffect(() => {
    if (!viewRef.current) {
      return
    }

    viewRef.current.dispatch({
      effects: themeCompartment.reconfigure(
        EditorView.theme({}, { dark: theme === Themes.DARK })
      ),
    })
  }, [theme])

  useEffect(() => {
    if (!viewRef.current) {
      return
    }

    viewRef.current.dispatch({
      effects: tabCaptureCompartment.reconfigure(
        keymap.of(isTabCaptured ? [defaultTabBinding] : [])
      ),
    })
  }, [isTabCaptured])

  return <div className="editor" hidden={hidden} ref={setTextarea} />
}
