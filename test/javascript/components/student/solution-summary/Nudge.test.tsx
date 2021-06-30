import React from 'react'
import { act, render } from '@testing-library/react'
import '@testing-library/jest-dom/extend-expect'
import { Nudge } from '../../../../../app/javascript/components/student/Nudge'
import {
  SolutionMentoringStatus,
  SolutionStatus,
} from '../../../../../app/javascript/components/types'
import flushPromises from 'flush-promises'

test('does not animate on initial load', async () => {
  const solution = {
    id: 'uuid',
    url: 'https://exercism.test/solutions/uuid',
    hasNotifications: false,
    status: 'started' as SolutionStatus,
    mentoringStatus: 'requested' as SolutionMentoringStatus,
    numIterations: 10,
    updatedAt: '',
    exercise: {
      slug: 'bob',
      title: 'Bob',
      iconUrl: '',
    },
    track: {
      slug: 'ruby',
      title: 'Ruby',
      iconUrl: '',
    },
  }

  const { container } = render(
    <Nudge
      solution={solution}
      exerciseType="concept"
      request={{ endpoint: 'https://exercism.test/iterations', options: {} }}
      discussions={[]}
      links={{
        mentoringInfo: '',
        completeExercise: '',
        requestMentoring: '',
        shareMentoring: '',
        pendingMentorRequest: '',
      }}
      track={{
        title: 'Ruby',
        medianWaitTime: '7 days',
      }}
    />
  )
  await flushPromises()

  expect(container.firstChild).toHaveAttribute(
    'class',
    'mentoring-request-nudge'
  )
})
