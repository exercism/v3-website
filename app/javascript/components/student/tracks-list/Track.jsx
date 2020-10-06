import React from 'react'
import { TrackIcon } from '../../common/TrackIcon'
import { ProgressBar } from './ProgressBar'

export function Track({ track }) {
  return (
    <a className="c-track" href={track.webUrl}>
      <div className="content">
        <TrackIcon track={track} />
        <div className="info">
          <div className="s-flex s-items-center s-mb-8">
            <h3 className="title">{track.title}</h3>
            {track.isJoined && <div className="joined">Joined</div>}
          </div>
          <ul className="counts">
            <li>
              {track.numCompletedConceptExercises}/{track.numConceptExercises}{' '}
              concepts
            </li>
            <li>
              {track.numCompletedPracticeExercises}/{track.numPracticeExercises}{' '}
              exercises
            </li>
          </ul>
          <ul className="tags">
            {track.tags.slice(0, 3).map((tag) => {
              return <li key={tag}>{tag.split(':')[1]}</li>
            })}
          </ul>
        </div>
        <i>›</i>
      </div>

      {track.isJoined && (
        <ProgressBar
          numConceptExercises={track.numConceptExercises}
          numPracticeExercises={track.numPracticeExercises}
          numCompletedConceptExercises={track.numCompletedConceptExercises}
          numCompletedPracticeExercises={track.numCompletedPracticeExercises}
        />
      )}
    </a>
  )
}
