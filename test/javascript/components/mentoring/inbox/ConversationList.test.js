import React from 'react'
import { setConsole } from 'react-query'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import '@testing-library/jest-dom/extend-expect'
import { ConversationList } from '../../../../../app/javascript/components/mentoring/inbox/ConversationList.jsx'

const server = setupServer(
  rest.get('https://exercism.test/conversations', (req, res, ctx) => {
    return res(ctx.status(500, 'Internal server error'))
  })
)

// Don't output logging from react-query
setConsole({
  log: () => {},
  warn: () => {},
  error: () => {},
})

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('allow retry after loading error', async () => {
  const setPage = jest.fn()

  render(
    <ConversationList
      request={{
        endpoint: 'https://exercism.test/conversations',
        query: { page: 2 },
        options: { retry: false },
      }}
      setPage={setPage}
    />
  )

  await waitFor(() => expect(screen.getByText('Retry')).toBeInTheDocument())

  server.use(
    rest.get('https://exercism.test/conversations', (req, res, ctx) => {
      return res(
        ctx.json({
          results: [
            {
              trackTitle: 'Ruby',
              exerciseTitle: 'Bob',
              isStarred: false,
              isNewSubmission: false,
              haveMentoredPreviously: false,
            },
          ],
          meta: { totalPages: 2 },
        })
      )
    })
  )

  fireEvent.click(screen.getByText('Retry'))

  await waitFor(() => expect(screen.getByText('on Bob')).toBeInTheDocument())
  expect(screen.queryByText('Retry')).not.toBeInTheDocument()
})
