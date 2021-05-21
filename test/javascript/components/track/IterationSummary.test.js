import React from 'react'
import { render, screen } from '@testing-library/react'
import '@testing-library/jest-dom/extend-expect'
import { IterationSummary } from '../../../../app/javascript/components/track/IterationSummary'

test('shows details', async () => {
  render(
    <IterationSummary
      iteration={{
        idx: 2,
        submissionMethod: 'cli',
        createdAt: Date.now() - 1,
        testsStatus: 'queued',
        numEssentialAutomatedComments: 2,
      }}
      showSubmissionMethod={true}
      showFeedbackIndicator={true}
    />
  )

  expect(screen.getByText('Iteration 2')).toBeInTheDocument()
  expect(screen.getByAltText('Submitted via CLI')).toBeInTheDocument()
  expect(screen.getByTestId('details')).toHaveTextContent(
    'Submitted via CLI, a few seconds ago'
  )
  expect(
    screen.getByRole('status', { name: 'Processing status' })
  ).toHaveTextContent('Passed')
  expect(
    screen.getByRole('status', { name: 'Analysis status' })
  ).toHaveTextContent('2')
})

test('honours showSubmissionMethod', async () => {
  render(
    <IterationSummary
      iteration={{
        idx: 2,
        submissionMethod: 'cli',
        createdAt: Date.now() - 1,
        testsStatus: 'queued',
        numEssentialAutomatedComments: 2,
      }}
      showSubmissionMethod={false}
    />
  )

  expect(screen.getByText('Iteration 2')).toBeInTheDocument()
  expect(screen.getByTestId('details')).toHaveTextContent(
    'Submitted a few seconds ago'
  )
})

test('shows published tag when published', async () => {
  render(
    <IterationSummary
      iteration={{
        idx: 2,
        submissionMethod: 'cli',
        createdAt: Date.now() - 1,
        testsStatus: 'queued',
        numEssentialAutomatedComments: 2,
        isPublished: true,
      }}
    />
  )

  expect(screen.getByText('Published')).toBeInTheDocument()
})

test('hides published tag when not published', async () => {
  render(
    <IterationSummary
      iteration={{
        idx: 2,
        submissionMethod: 'cli',
        createdAt: Date.now() - 1,
        testsStatus: 'queued',
        numEssentialAutomatedComments: 2,
        isPublished: false,
      }}
    />
  )

  expect(screen.queryByText('Published')).not.toBeInTheDocument()
})
