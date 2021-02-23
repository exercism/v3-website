import React, { useState } from 'react'
import { usePaginatedRequestQuery } from '../../../hooks/request-query'
import { useIsMounted } from 'use-is-mounted'
import { TracksList } from './choose-track-step/TracksList'
import { SelectedTracksMessage } from './choose-track-step/SelectedTracksMessage'
import { ContinueButton } from './choose-track-step/ContinueButton'
import { SearchBar } from './choose-track-step/SearchBar'
import { useList } from '../../../hooks/use-list'

export type APIResponse = {
  tracks: readonly Track[]
}

export type Track = {
  id: string
  title: string
  iconUrl: string
  avgWaitTime: string
  numSolutionsQueued: number
}

export const ChooseTrackStep = ({
  endpoint,
}: {
  endpoint: string
}): JSX.Element => {
  const isMountedRef = useIsMounted()
  const [selected, setSelected] = useState<string[]>([])
  const { request, setCriteria } = useList({ endpoint: endpoint, options: {} })
  const { status, resolvedData, isFetching, error } = usePaginatedRequestQuery<
    APIResponse
  >('tracks', request, isMountedRef)

  return (
    <section className="tracks-section">
      <h2>Select the tracks you want to mentor</h2>
      <p>
        This allows us to only show you the solutions you want to mentor.
        <strong>
          Don’t worry, you can change these selections at anytime.
        </strong>
      </p>
      <div className="c-search-bar">
        <SearchBar
          value={request.query.criteria || ''}
          setValue={setCriteria}
        />
        {isFetching ? <span>Fetching</span> : null}
        <SelectedTracksMessage numSelected={selected.length} />
        <ContinueButton disabled={selected.length === 0} />
      </div>
      <div className="tracks">
        <TracksList
          status={status}
          selected={selected}
          setSelected={setSelected}
          data={resolvedData}
          error={error}
        />
      </div>
    </section>
  )
}
