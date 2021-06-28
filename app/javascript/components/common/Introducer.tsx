import React, { useRef, useState } from 'react'
import { GraphicalIcon, Icon } from './'
import { useMutation } from 'react-query'
import { sendRequest } from '../../utils/send-request'
import { useIsMounted } from 'use-is-mounted'
import { FormButton } from './FormButton'
import { ErrorBoundary, ErrorMessage } from '../ErrorBoundary'

const DEFAULT_ERROR = new Error('Unable to hide introducer')

export const Introducer = ({
  icon,
  content,
  children,
  endpoint,
  hidden: defaultHidden = false,
}: React.PropsWithChildren<{
  icon: string
  content?: string
  hidden?: boolean
  endpoint: string
}>): JSX.Element | null => {
  const [hidden, setHidden] = useState(defaultHidden)
  const ref = useRef<HTMLDivElement | null>(null)
  const isMountedRef = useIsMounted()
  const [mutation, { status, error }] = useMutation(
    () => {
      return sendRequest({
        endpoint: endpoint,
        method: 'PATCH',
        body: null,
        isMountedRef: isMountedRef,
      })
    },
    {
      onSuccess: () => {
        setHidden(true)
      },
    }
  )

  if (hidden) {
    return null
  }

  return (
    <div ref={ref} className="c-introducer">
      <GraphicalIcon icon={icon} category="graphics" className="visual-icon" />
      {content ? (
        <div className="info" dangerouslySetInnerHTML={{ __html: content }} />
      ) : null}
      {children ? <div className="info">{children}</div> : null}
      {endpoint ? (
        <>
          <FormButton
            className="close"
            type="button"
            onClick={() => mutation()}
            status={status}
          >
            <Icon icon="close" alt="Permanently hide this introducer" />
          </FormButton>
          <ErrorBoundary resetKeys={[status]}>
            <ErrorMessage error={error} defaultError={DEFAULT_ERROR} />
          </ErrorBoundary>
        </>
      ) : null}
    </div>
  )
}
