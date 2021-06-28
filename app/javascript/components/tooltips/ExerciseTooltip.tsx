import React, { useState, useEffect } from 'react'
import { Exercise, Track, SolutionForStudent } from '../types'
import { Icon, ExerciseWidget } from '../common'
import { useRequestQuery } from '../../hooks/request-query'
import { useIsMounted } from 'use-is-mounted'
import { FetchingBoundary } from '../FetchingBoundary'

const DEFAULT_ERROR = new Error('Unable to load information')

const LoadingComponent = () => {
  const [isShowing, setIsShowing] = useState(false)

  useEffect(() => {
    const timer = setTimeout(() => {
      setIsShowing(true)
    }, 200)

    return () => clearTimeout(timer)
  }, [])

  return isShowing ? (
    <Icon icon="spinner" alt="Loading exercise data" className="--spinner" />
  ) : null
}

export const ExerciseTooltip = React.forwardRef<
  HTMLDivElement,
  React.HTMLProps<HTMLDivElement> & { endpoint: string; slug: string }
>(({ endpoint, slug, ...props }, ref) => {
  const isMountedRef = useIsMounted()
  const { data, error, status } = useRequestQuery<{
    track: Track
    exercise: Exercise
    solution: SolutionForStudent
  }>(
    `exercise-tooltip-${slug}`,
    { endpoint: endpoint, options: { staleTime: 0 } },
    isMountedRef
  )

  return (
    <div className="c-exercise-tooltip" {...props} ref={ref}>
      <FetchingBoundary
        status={status}
        error={error}
        defaultError={DEFAULT_ERROR}
        LoadingComponent={LoadingComponent}
      >
        {data ? (
          /* If we want the track we need to add a pivot to this,
           * and use track={data.track}*/
          <ExerciseWidget
            exercise={data.exercise}
            solution={data.solution}
            renderAsLink={false}
          />
        ) : (
          <span>Unable to load information</span>
        )}
      </FetchingBoundary>
    </div>
  )
})
