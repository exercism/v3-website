import { usePaginatedQuery, useQuery } from 'react-query'
import { UrlParams } from '../utils/url-params'
import fetch from 'isomorphic-fetch'
import { camelizeKeys } from 'humps'

function handleFetch(key, url, query) {
  return fetch(`${url}?${new UrlParams(query).toString()}`)
    .then((response) => response.json())
    .then((json) => camelizeKeys(json))
}

export function usePaginatedRequestQuery(key, request) {
  return usePaginatedQuery(
    [key, request.endpoint, request.query],
    handleFetch,
    camelizeKeys(request.options)
  )
}

export function useRequestQuery(key, request) {
  return useQuery(
    [key, request.endpoint, request.query],
    handleFetch,
    camelizeKeys(request.options)
  )
}
