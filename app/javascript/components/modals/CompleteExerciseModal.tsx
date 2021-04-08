import React, { useState } from 'react'
import { PublishExerciseModal } from './PublishExerciseModal'
import { ExerciseCompletedModal } from './ExerciseCompletedModal'
import { TutorialCompletedModal } from './TutorialCompletedModal'

export type ExerciseCompletion = {
  exercise: CompletedExercise
  conceptProgressions: {
    name: string
    from: number
    to: number
    total: number
  }[]
  unlockedExercises: Exercise[]
  unlockedConcepts: Concept[]
}

export type CompletedExercise = Exercise & { links: { self: string } }

export type Exercise = {
  title: string
  iconUrl: string
  isTutorial: boolean
  links: {
    self: string
  }
}

export type Concept = {
  name: string
}

export const CompleteExerciseModal = ({
  endpoint,
  open,
}: {
  endpoint: string
  open: boolean
}): JSX.Element => {
  const [completion, setCompletion] = useState<ExerciseCompletion | null>(null)

  if (completion) {
    return completion.exercise.isTutorial ? (
      <TutorialCompletedModal open={open} />
    ) : (
      <ExerciseCompletedModal completion={completion} open={open} />
    )
  } else {
    return (
      <PublishExerciseModal
        open={open}
        endpoint={endpoint}
        onSuccess={(completion) => {
          setCompletion(completion)
        }}
      />
    )
  }
}
