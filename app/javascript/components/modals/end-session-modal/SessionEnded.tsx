import React, { useReducer } from 'react'
import { Discussion, Relationship } from '../EndSessionModal'
import { MentorAgainStep } from './session-ended/MentorAgainStep'
import { FavoriteStep } from './session-ended/FavoriteStep'
import { EndStep } from './session-ended/EndStep'

type State = {
  discussion: Discussion
  step: ModalStep
}

type ModalStep = 'mentorAgain' | 'favorite' | 'end'

type ActionType = 'MENTOR_AGAIN' | 'WONT_MENTOR_AGAIN' | 'FAVORITED'

type Action = {
  type: ActionType
  payload: { relationship: Relationship }
}

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'MENTOR_AGAIN':
      return {
        discussion: {
          ...state.discussion,
          relationship: action.payload.relationship,
        },
        step: 'favorite',
      }
    case 'WONT_MENTOR_AGAIN':
      return {
        discussion: {
          ...state.discussion,
          relationship: action.payload.relationship,
        },
        step: 'end',
      }
    case 'FAVORITED':
      return {
        discussion: {
          ...state.discussion,
          relationship: action.payload.relationship,
        },
        step: 'end',
      }
  }
}

export const SessionEnded = ({
  discussion,
}: {
  discussion: Discussion
}): JSX.Element => {
  const [state, dispatch] = useReducer(reducer, {
    discussion: discussion,
    step: 'mentorAgain',
  })

  return (
    <div>
      <h1>
        You&apos;ve ended your discussion with {discussion.student.handle}.
      </h1>
      {state.step === 'mentorAgain' ? (
        <MentorAgainStep
          discussion={state.discussion}
          onYes={(relationship) => {
            dispatch({
              type: 'MENTOR_AGAIN',
              payload: { relationship: relationship },
            })
          }}
          onNo={(relationship) => {
            dispatch({
              type: 'WONT_MENTOR_AGAIN',
              payload: { relationship: relationship },
            })
          }}
        />
      ) : null}
      {state.step === 'favorite' ? (
        <FavoriteStep
          discussion={state.discussion}
          onFavorite={(relationship) => {
            dispatch({
              type: 'FAVORITED',
              payload: { relationship: relationship },
            })
          }}
        />
      ) : null}
      {state.step === 'end' ? <EndStep discussion={state.discussion} /> : null}
    </div>
  )
}
