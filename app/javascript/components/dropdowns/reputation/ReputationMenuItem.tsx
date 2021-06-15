import React from 'react'
import { fromNow } from '../../../utils/time'
import { GraphicalIcon, Reputation } from '../../common'
import { ReputationToken } from '../Reputation'

export const ReputationMenuItem = ({
  internalUrl,
  externalUrl,
  iconUrl,
  text,
  earnedOn,
  value,
  isSeen,
}: ReputationToken): JSX.Element => {
  const url = internalUrl ? internalUrl : externalUrl
  const icon = internalUrl ? (
    <GraphicalIcon icon="chevron-right" className="action-icon" />
  ) : (
    <GraphicalIcon icon="external-link" className="action-icon" />
  )

  return (
    <a href={url} className="token">
      <img alt="" role="presentation" src={iconUrl} className="reason-icon" />
      <div className="content">
        <div
          className="description"
          dangerouslySetInnerHTML={{ __html: text }}
        />
        <div className="earned-on">{fromNow(earnedOn)}</div>
      </div>
      <Reputation value={`+${value}`} />
      <div className={'indicator ' + (isSeen ? 'seen' : 'unseen')} />
      {icon}
    </a>
  )
}
