import React, { useState } from 'react'
import { Student, Iteration, MentorDiscussion } from '../../types'
import { FinishedWizard, ModalStep } from './FinishedWizard'
import { DiscussionPostList } from './DiscussionPostList'

export const DiscussionDetails = ({
  discussion,
  iterations,
  student,
  userId,
}: {
  discussion: MentorDiscussion
  iterations: readonly Iteration[]
  student: Student
  userId: number
}): JSX.Element => {
  const [defaultStep, setDefaultStep] = useState<ModalStep>(
    discussion.isFinished ? 'finish' : 'mentorAgain'
  )

  return (
    <React.Fragment>
      <DiscussionPostList
        endpoint={discussion.links.posts}
        iterations={iterations}
        userIsStudent={false}
        discussionId={discussion.id}
        userId={userId}
      />
      {discussion.isFinished ? (
        <FinishedWizard student={student} defaultStep={defaultStep} />
      ) : null}
    </React.Fragment>
  )
}
