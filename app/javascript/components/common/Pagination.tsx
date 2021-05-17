import React from 'react'

type PaginationProps = {
  disabled?: boolean
  current: number
  total: number
  around?: number
  setPage: (page: number) => void
}

export function Pagination({
  disabled = false,
  current = 1,
  total,
  setPage,
  around = 3,
}: PaginationProps) {
  if (total <= 1) {
    return null
  }

  const range = createRange(
    Math.max(current - around, 1),
    Math.min(current + around, total)
  )

  function createRange(start: number, end: number) {
    return Array(end - start + 1)
      .fill(0)
      .map((_, i) => start + i)
  }

  return (
    <div className="c-pagination">
      {current !== 1 ? (
        <button
          onClick={() => {
            setPage(1)
          }}
          disabled={disabled}
          aria-label="Go to first page"
        >
          First
        </button>
      ) : null}
      <div className="--pages">
        {range.map((page) => {
          return (
            <button
              key={page}
              onClick={() => {
                setPage(page)
              }}
              disabled={disabled || page === current}
              aria-label={`Go to page ${page}`}
              aria-current={page === current ? 'page' : undefined}
              className={page === current ? 'current' : undefined}
            >
              {page}
            </button>
          )
        })}
      </div>
      <button
        onClick={() => {
          setPage(total)
        }}
        disabled={disabled || current === total}
        aria-label="Go to last page"
        aria-current={current === total ? 'page' : undefined}
      >
        Last
      </button>
    </div>
  )
}
