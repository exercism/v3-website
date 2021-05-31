import { useRef, useEffect } from 'react'
import { decamelizeKeys } from 'humps'
import { stringify } from 'qs'

export function removeEmpty<TParams extends Record<string, unknown>>(
  obj: TParams
): Record<string, unknown> {
  return Object.entries(obj)
    .filter(([_, v]) => {
      if (typeof v === 'string') {
        return v.length > 0
      } else {
        return v !== null
      }
    })
    .reduce((acc, [k, v]) => ({ ...acc, [k]: v }), {})
}

function toQuery<TParams extends Record<string, unknown>>(
  params: TParams
): string {
  return `?${stringify(decamelizeKeys(params as Record<string, unknown>), {
    arrayFormat: 'brackets',
  })}`
}

function pushState<TParams extends Record<string, unknown>>(params: TParams) {
  history.pushState(history.state, '', toQuery(params))
}

export function useHistory<TParams extends Record<string, unknown>>({
  pushOn,
}: {
  pushOn: TParams
}): void {
  const isMounted = useRef(false)

  useEffect(() => {
    if (!isMounted.current) {
      isMounted.current = true
      return
    }

    pushState(removeEmpty(pushOn))
  }, [JSON.stringify(pushOn)])
}
