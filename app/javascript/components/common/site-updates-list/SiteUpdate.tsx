import React, { useCallback } from 'react'
import { fromNow } from '../../../utils/date'
import { Avatar } from '../Avatar'
import { SiteUpdateIcon } from './SiteUpdateIcon'
import { ExpandedInfo } from './ExpandedInfo'
import { SiteUpdate as SiteUpdateProps, SiteUpdateContext } from '../../types'

export const SiteUpdate = ({
  update,
  context,
}: {
  update: SiteUpdateProps
  context: SiteUpdateContext
}): JSX.Element => {
  return (
    <div className="c-site-update">
      <SiteUpdateIcon
        icon={update.icon}
        context={context}
        track={update.track}
      />
      <div className="content">
        <div className="standard">
          <div className="info">
            <div
              className="desc"
              dangerouslySetInnerHTML={{ __html: update.text }}
            />
            <time dateTime={update.publishedAt}>
              {fromNow(update.publishedAt)}
            </time>
          </div>
          <div className="c-faces --static">
            {update.makers.map((maker) => (
              <Avatar
                key={maker.handle}
                src={maker.avatarUrl}
                handle={maker.handle}
                className="face"
              />
            ))}
          </div>
        </div>
        {update.expanded ? (
          <ExpandedInfo
            icon={update.icon}
            track={update.track}
            expanded={update.expanded}
            pullRequest={update.pullRequest}
            conceptWidget={update.conceptWidget}
            exerciseWidget={update.exerciseWidget}
          />
        ) : null}
      </div>
    </div>
  )
}
