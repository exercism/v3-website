import React from 'react'
import { Track } from './TrackList/Track'
import { TextFilter } from './TextFilter'
import { useList } from '../hooks/use_list'
import { useRequestQuery } from '../hooks/request_query'

export function TrackList(props) {
  const [request, setFilter, setSort, setPage] = useList(props.request)
  const { status, data, isFetching } = useRequestQuery('track-list', request)

  return (
    <div className="track-list">
      <TextFilter
        filter={request.query.filter}
        setFilter={setFilter}
        id="track-list-filter"
        placeholder="Search language tracks"
      />
      {status === 'error' && <p>Something went wrong</p>}
      {isFetching && <p>Loading</p>}
      {status === 'success' && (
        <table>
          <thead>
            <tr>
              <th>Track icon</th>
              <th>Track title</th>
              <th>Exercise count</th>
              <th>Concept exercise count</th>
              <th>Practice exercise count</th>
              <th>Student count</th>
              <th>New?</th>
              <th>Joined?</th>
              <th>Tags</th>
              <th>Completed exercise count</th>
              <th>Progress %</th>
              <th>URL</th>
            </tr>
          </thead>
          <tbody>
            {data.map((track) => {
              return <Track key={track.id} {...track} />
            })}
          </tbody>
        </table>
      )}
    </div>
  )
}
