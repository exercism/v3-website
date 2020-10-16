import React, { useReducer, useEffect } from 'react'
import { Submission, TestRunStatus } from '../Editor'
import consumer from '../../../utils/action-cable-consumer'

export type TestRun = {
  submissionUuid: string
  status: TestRunStatus
  message: string
  tests: Test[]
}

type Test = {
  name: string
  status: TestStatus
  output: string
}

enum TestStatus {
  PASS = 'pass',
  FAIL = 'fail',
}

function reducer(state: any, action: any) {
  switch (action.type) {
    case 'testRun.received':
      return action.payload
    case 'testRun.timeout':
      return { ...state, status: 'timeout' }
  }
}

export function TestRunSummary({
  submission,
  timeout,
}: {
  submission: Submission
  timeout: number
}) {
  const RESOLVED_TEST_STATUSES = [
    TestRunStatus.PASS,
    TestRunStatus.FAIL,
    TestRunStatus.ERROR,
    TestRunStatus.OPS_ERROR,
  ]
  const [testRun, dispatch] = useReducer(reducer, {
    submissionUuid: submission.uuid,
    status: submission.testsStatus,
    message: '',
    tests: [],
  })
  const haveTestsResolved = RESOLVED_TEST_STATUSES.includes(testRun.status)

  useEffect(() => {
    const subscription = consumer.subscriptions.create(
      {
        channel: 'Submission::TestRunsChannel',
        submission_uuid: submission.uuid,
      },
      {
        received: ({ test_run: testRun }: any) => {
          dispatch({
            type: 'testRun.received',
            payload: {
              submissionUuid: testRun.submission_uuid,
              status: testRun.status,
              message: testRun.message,
              tests: testRun.tests,
            },
          })
        },
      }
    )

    return () => {
      subscription.unsubscribe()
    }
  }, [submission.uuid])

  useEffect(() => {
    if (haveTestsResolved) {
      return
    }

    setTimeout(() => dispatch({ type: 'testRun.timeout' }), timeout)
  }, [testRun.status])

  let content
  switch (testRun.status) {
    case TestRunStatus.PASS:
    case TestRunStatus.FAIL:
      content = testRun.tests.map((test: Test) => (
        <p key={test.name}>
          name: {test.name}, status: {test.status}, output: {test.output}
        </p>
      ))
      break
    case TestRunStatus.ERROR:
    case TestRunStatus.OPS_ERROR:
      content = <p>{testRun.message}</p>
      break
  }

  return (
    <div>
      <p>Status: {testRun.status}</p>
      {content}
    </div>
  )
}
