import React from 'react'
import { useRequestQuery } from '../../../hooks/request-query'

export function TrackFilter({ request, setTrack, value }) {
  const { status, data } = useRequestQuery('track-filter', request)

  function handleChange(e) {
    setTrack(e.target.value)
  }

  return (
    <div className="track-filter">
      {status === 'loading' && <p>Loading</p>}
      {status === 'error' && <p>Something went wrong</p>}
      {status === 'success' && (
        <>
          <label htmlFor="track-filter-track">Track</label>
          <select id="track-filter-track" onChange={handleChange}>
            <option value={''}>All</option>
            {data.map((track) => {
              return (
                <option key={track.id} value={track.id}>
                  {track.title}
                </option>
              )
            })}
          </select>
        </>
      )}
    </div>
  )
}
