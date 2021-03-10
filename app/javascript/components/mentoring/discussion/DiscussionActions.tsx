import React, { useCallback } from 'react'
import { MarkAsNothingToDoButton } from './MarkAsNothingToDoButton'
import { FinishButton } from './FinishButton'
import { GraphicalIcon } from '../../common'
import { SessionProps } from '../Session'
import { MentorDiscussion } from '../../types'

export const DiscussionActions = ({
  links,
  session,
  setSession,
  isFinished,
}: MentorDiscussion & {
  session: SessionProps
  setSession: (session: SessionProps) => void
}): JSX.Element => {
  const setDiscussion = useCallback(
    (discussion) => {
      setSession({ ...session, discussion: discussion })
    },
    [setSession, session]
  )

  return (
    <div>
      {links.markAsNothingToDo ? (
        <MarkAsNothingToDoButton endpoint={links.markAsNothingToDo} />
      ) : null}

      {isFinished ? (
        <div className="finished">
          <GraphicalIcon icon="completed-check-circle" />
          Ended
        </div>
      ) : links.finish ? (
        <FinishButton endpoint={links.finish} onSuccess={setDiscussion} />
      ) : null}
    </div>
  )
}
