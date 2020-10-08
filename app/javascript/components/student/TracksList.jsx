import React, { useReducer } from 'react'
import { useRequestQuery } from '../../hooks/request-query'
import { Search } from './tracks-list/Search'
import { StatusFilter } from './tracks-list/StatusFilter'
import { TagsFilter } from './tracks-list/TagsFilter'
import { List } from './tracks-list/List'
import { Header } from './tracks-list/Header'
import { Loading } from '../common/Loading'

function reducer(state, action) {
  switch (action.type) {
    case 'criteria.changed':
      return {
        ...state,
        query: { ...state.query, criteria: action.payload.criteria },
        options: { ...state.options, initialData: undefined },
      }
    case 'status.changed':
      return {
        ...state,
        query: { ...state.query, status: action.payload.status },
        options: { ...state.options, initialData: undefined },
      }
    case 'tags.changed':
      return {
        ...state,
        query: { ...state.query, tags: action.payload.tags },
        options: { ...state.options, initialData: undefined },
      }
  }
}

export function TracksList({ statusOptions, tagOptions, ...props }) {
  const [request, dispatch] = useReducer(reducer, props.request)
  const { data, isSuccess, isError, isLoading } = useRequestQuery(
    'track-list',
    request
  )

  return (
    <div className="c-tracks-list">
      <section className="search-bar">
        <div className="md-container">
          <Search dispatch={dispatch} />
          <TagsFilter dispatch={dispatch} options={tagOptions} />
        </div>
      </section>
      <section className="md-container">
        {isSuccess && <Header data={data} query={request.query} />}
        <StatusFilter
          value={request.query.status}
          dispatch={dispatch}
          options={statusOptions}
        />

        {isLoading && <Loading />}
        {isError && <p>Something went wrong</p>}
        {isSuccess && <List data={data} />}
      </section>
    </div>
  )
}
