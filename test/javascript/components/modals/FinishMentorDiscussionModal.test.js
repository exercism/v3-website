import React from 'react'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import '@testing-library/jest-dom/extend-expect'
import { FinishMentorDiscussionModal } from '../../../../app/javascript/components/modals/FinishMentorDiscussionModal'
import { expectConsoleError } from '../../support/silence-console'
import { queryCache } from 'react-query'
import flushPromises from 'flush-promises'

test('disables buttons when loading', async () => {
  const server = setupServer(
    rest.patch('https://exercism.test/end', (req, res, ctx) => {
      return res(ctx.delay(10), ctx.status(200), ctx.json({ discussion: {} }))
    })
  )
  server.listen()

  render(
    <FinishMentorDiscussionModal
      open
      endpoint="https://exercism.test/end"
      ariaHideApp={false}
      onSuccess={() => null}
    />
  )
  await flushPromises()

  const endBtn = await screen.findByRole('button', {
    name: 'End discussion F3',
  })
  const cancelBtn = await screen.findByRole('button', { name: 'Cancel F2' })

  userEvent.click(endBtn)

  await waitFor(() => {
    expect(endBtn).toBeDisabled()
  })
  await waitFor(() => {
    expect(cancelBtn).toBeDisabled()
  })

  queryCache.cancelQueries()
  server.close()
})

test('shows loading message when loading', async () => {
  const server = setupServer(
    rest.patch('https://exercism.test/end', (req, res, ctx) => {
      return res(ctx.delay(10), ctx.status(200), ctx.json({ discussion: {} }))
    })
  )
  server.listen()

  render(
    <FinishMentorDiscussionModal
      open
      endpoint="https://exercism.test/end"
      ariaHideApp={false}
      onSuccess={() => {}}
    />
  )
  await flushPromises()
  userEvent.click(
    await screen.findByRole('button', { name: 'End discussion F3' })
  )

  expect(await screen.findByText('Loading')).toBeInTheDocument()

  server.close()
})

test('shows API errors', async () => {
  const server = setupServer(
    rest.patch('https://exercism.test/end', (req, res, ctx) => {
      return res(
        ctx.status(422),
        ctx.json({ error: { message: 'Unable to end discussion' } })
      )
    })
  )
  server.listen()

  render(
    <FinishMentorDiscussionModal
      open
      endpoint="https://exercism.test/end"
      ariaHideApp={false}
      onSuccess={() => {}}
    />
  )
  await expectConsoleError(async () => {
    userEvent.click(
      await screen.findByRole('button', { name: 'End discussion F3' })
    )

    expect(
      await screen.findByText('Unable to end discussion')
    ).toBeInTheDocument()
  })

  server.close()
})

test('shows generic error', async () => {
  render(
    <FinishMentorDiscussionModal
      open
      endpoint="https://weirdendpoint"
      ariaHideApp={false}
      onSuccess={() => {}}
    />
  )
  await expectConsoleError(async () => {
    userEvent.click(
      await screen.findByRole('button', { name: 'End discussion F3' })
    )
    expect(
      await screen.findByText('Unable to end discussion')
    ).toBeInTheDocument()
  })
})
