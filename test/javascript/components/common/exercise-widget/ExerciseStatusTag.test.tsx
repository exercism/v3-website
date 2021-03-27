import React from 'react'
import { render, screen } from '@testing-library/react'
import '@testing-library/jest-dom/extend-expect'
import { ExerciseStatusTag } from '../../../../../app/javascript/components/common/exercise-widget/ExerciseStatusTag'
import { Exercise } from '../../../../../app/javascript/components/types'

test('renders recommended when exercise is recommended', async () => {
  const exercise: Exercise = {
    slug: 'lasagna',
    title: "Lucian's Luscious Lasagna",
    iconUrl: 'https://exercism.test/exercise_icon',
    blurb: 'Tasty exercise',
    difficulty: 'easy',
    isUnlocked: true,
    isCompleted: true,
    isRecommended: true,
    links: {
      self: 'https://exercism.test/exercise',
    },
  }

  const { container } = render(<ExerciseStatusTag exercise={exercise} />)

  expect(container.firstChild).toHaveAttribute(
    'class',
    'c-exercise-status-tag --recommended'
  )
  expect(screen.getByText('Recommended')).toBeInTheDocument()
})

test('renders available when exercise is available', async () => {
  const exercise: Exercise = {
    slug: 'lasagna',
    title: "Lucian's Luscious Lasagna",
    iconUrl: 'https://exercism.test/exercise_icon',
    blurb: 'Tasty exercise',
    difficulty: 'easy',
    isUnlocked: true,
    isCompleted: true,
    isRecommended: false,
    links: {
      self: 'https://exercism.test/exercise',
    },
  }

  const { container } = render(<ExerciseStatusTag exercise={exercise} />)

  expect(container.firstChild).toHaveAttribute(
    'class',
    'c-exercise-status-tag --available'
  )
  expect(screen.getByText('Available')).toBeInTheDocument()
})

test('renders locked when exercise is locked', async () => {
  const exercise: Exercise = {
    slug: 'lasagna',
    title: "Lucian's Luscious Lasagna",
    iconUrl: 'https://exercism.test/exercise_icon',
    blurb: 'Tasty exercise',
    difficulty: 'easy',
    isUnlocked: false,
    isCompleted: true,
    isRecommended: false,
  }

  const { container } = render(<ExerciseStatusTag exercise={exercise} />)

  expect(container.firstChild).toHaveAttribute(
    'class',
    'c-exercise-status-tag --locked'
  )
  expect(screen.getByText('Locked')).toBeInTheDocument()
})
