import React, { useState } from 'react'
import { Iteration } from '../../types'
import { IterationsList } from './IterationsList'
import { FilePanel } from './FilePanel'
import { IterationHeader } from './IterationHeader'
import { Icon } from '../../common/Icon'
import { useIsMounted } from 'use-is-mounted'
import { usePaginatedRequestQuery } from '../../../hooks/request-query'
import { FetchingBoundary } from '../../FetchingBoundary'
import { File } from '../../types'
import { ResultsZone } from '../../ResultsZone'

const DEFAULT_ERROR = new Error('Unable to load files')

export const IterationView = ({
  iterations,
  language,
  indentSize,
  isOutOfDate,
}: {
  iterations: readonly Iteration[]
  language: string
  indentSize: number
  isOutOfDate: boolean
}): JSX.Element => {
  const [currentIteration, setCurrentIteration] = useState(
    iterations[iterations.length - 1]
  )
  const isMountedRef = useIsMounted()
  const { resolvedData, error, status, isFetching } = usePaginatedRequestQuery<{
    files: File[]
  }>(
    currentIteration.links.files,
    { endpoint: currentIteration.links.files, options: {} },
    isMountedRef
  )

  return (
    <React.Fragment>
      <IterationHeader
        iteration={currentIteration}
        isLatest={iterations[iterations.length - 1] === currentIteration}
        isOutOfDate={isOutOfDate}
      />
      <ResultsZone isFetching={isFetching}>
        <FetchingBoundary
          error={error}
          status={status}
          defaultError={DEFAULT_ERROR}
        >
          {resolvedData ? (
            <FilePanel
              files={resolvedData.files}
              language={language}
              indentSize={indentSize}
            />
          ) : null}
        </FetchingBoundary>
      </ResultsZone>
      <footer className="c-iterations-footer">
        {iterations.length > 1 ? (
          <IterationsList
            iterations={iterations}
            onClick={setCurrentIteration}
            current={currentIteration}
          />
        ) : null}
        <button className="settings-button btn-keyboard-shortcut">
          <Icon icon="settings" alt="View settings" />
        </button>
      </footer>
    </React.Fragment>
  )
}
