import React from 'react'
import { Avatar } from '../../common/Avatar'
import { Reputation } from '../../common/Reputation'
import { RepresenterFeedback as RepresenterFeedbackProps } from '../../types'

export const RepresenterFeedback = ({
  html,
  author,
}: RepresenterFeedbackProps): JSX.Element => {
  return (
    <div className="feedback">
      <div className="c-textual-content --small">
        <p
          dangerouslySetInnerHTML={{
            __html: html,
          }}
        />
      </div>
      <div className="byline">
        <Avatar src={author.avatarUrl} handle={author.name} />
        <div className="name">by {author.name}</div>
        <Reputation value={author.reputation.toString()} />
      </div>
    </div>
  )
}
