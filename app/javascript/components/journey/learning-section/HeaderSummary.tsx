import React from 'react'
import { TrackProgress, TrackProgressList } from '../../types'

const MAX_TRACKS = 4

export const HeaderSummary = ({
  tracks,
}: {
  tracks: TrackProgressList
}): JSX.Element => {
  const tracksToDisplay = tracks.sort().items.slice(0, MAX_TRACKS)

  return (
    <p>
      You&apos; progressed the furthest in{' '}
      <SummaryText tracks={tracksToDisplay} />
    </p>
  )
}

const TrackSummary = ({ track }: { track: TrackProgress }): JSX.Element => {
  const classNames = ['track', `t-b-${track.slug}`]

  return (
    <span className={classNames.join(' ')}>
      {track.title} ({track.completion.toFixed(2)}%)
    </span>
  )
}

const SummaryText = ({
  tracks,
}: {
  tracks: readonly TrackProgress[]
}): JSX.Element | null => {
  switch (tracks.length) {
    case 4:
      return (
        <React.Fragment>
          <TrackSummary track={tracks[0]} />
          {', '} followed by <TrackSummary track={tracks[1]} />
          {', '}
          <TrackSummary track={tracks[2]} />
          {' and '}
          <TrackSummary track={tracks[3]} />.
        </React.Fragment>
      )
    case 3:
      return (
        <React.Fragment>
          <TrackSummary track={tracks[0]} />
          {', '} followed by <TrackSummary track={tracks[1]} />
          {' and '}
          <TrackSummary track={tracks[2]} />.
        </React.Fragment>
      )
    case 2:
      return (
        <React.Fragment>
          <TrackSummary track={tracks[0]} /> followed by{' '}
          <TrackSummary track={tracks[1]} />.
        </React.Fragment>
      )
    case 1:
      return (
        <React.Fragment>
          <TrackSummary track={tracks[0]} />.
        </React.Fragment>
      )
    default:
      return null
  }
}
