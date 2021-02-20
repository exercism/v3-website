import React from 'react'
import { GraphicalIcon } from '../../common/GraphicalIcon'
import { RepresenterFeedback } from './RepresenterFeedback'
import { AnalyzerFeedback } from './AnalyzerFeedback'
import {
  Student,
  AnalyzerFeedback as AnalyzerFeedbackProps,
  RepresenterFeedback as RepresenterFeedbackProps,
} from '../Session'

export const AutomatedFeedbackSummary = ({
  analyzerFeedback,
  representerFeedback,
  userIsStudent,
}: {
  analyzerFeedback?: AnalyzerFeedbackProps
  representerFeedback?: RepresenterFeedbackProps
  userIsStudent: boolean
}): JSX.Element => {
  const addressedTo = userIsStudent ? 'You' : 'Your student'

  return (
    <details className="c-details auto-feedback">
      <summary>
        <GraphicalIcon icon="alert-circle" className="info-icon" />
        <div className="info">{addressedTo} received automated feedback</div>
        <GraphicalIcon icon="chevron-right" className="--closed-icon" />
        <GraphicalIcon icon="chevron-down" className="--open-icon" />
      </summary>
      {representerFeedback ? (
        <RepresenterFeedback {...representerFeedback} />
      ) : null}
      {analyzerFeedback ? <AnalyzerFeedback {...analyzerFeedback} /> : null}
    </details>
  )
}
