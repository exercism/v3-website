import React from 'react'
import { useMutation } from 'react-query'
import { sendRequest } from '../../../utils/send-request'
import { GraphicalIcon } from '../../common/GraphicalIcon'
import { ErrorBoundary, useErrorHandler } from '../../ErrorBoundary'
import { Student } from '../../types'
import { FormButton } from '../../common'
import { typecheck } from '../../../utils/typecheck'

type ComponentProps = {
  endpoint: string
  onSuccess: (student: Student) => void
}

export const AddFavoriteButton = (props: ComponentProps): JSX.Element => {
  return (
    <ErrorBoundary>
      <Component {...props} />
    </ErrorBoundary>
  )
}

const DEFAULT_ERROR = new Error('Unable to mark student as a favorite')

const Component = ({
  endpoint,
  onSuccess,
}: ComponentProps): JSX.Element | null => {
  const [mutation, { status, error }] = useMutation<Student>(
    () => {
      const { fetch } = sendRequest({
        endpoint: endpoint,
        method: 'POST',
        body: null,
      })

      return fetch.then((json) => typecheck<Student>(json, 'student'))
    },
    {
      onSuccess: (student) => onSuccess(student),
    }
  )

  /* TODO: Style this */
  useErrorHandler(error, { defaultError: DEFAULT_ERROR })

  return (
    <FormButton
      onClick={() => {
        mutation()
      }}
      type="button"
      className="btn-small"
      status={status}
    >
      <GraphicalIcon icon="plus" />
      <span>Add to favorites</span>
    </FormButton>
  )
}
