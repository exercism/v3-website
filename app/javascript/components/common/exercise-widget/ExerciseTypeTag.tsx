import React from 'react'
import { GraphicalIcon } from '../../common'
import { Size } from '../../types'

type Type = 'concept' | 'tutorial'

export const ExerciseTypeTag = ({
  type,
  size,
}: {
  type: Type
  size?: Size
}): JSX.Element => {
  const sizeClassName = size ? `--${size}` : ''

  switch (type) {
    case 'concept':
      return (
        <div className={`c-exercise-type-tag --concept ${sizeClassName}`}>
          <GraphicalIcon icon="concept-exercise" /> Learning Exercise
        </div>
      )
    case 'tutorial':
      return (
        <div className={`c-exercise-type-tag --tutorial ${sizeClassName}`}>
          Tutorial Exercise
        </div>
      )
  }
}
