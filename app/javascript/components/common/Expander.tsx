import React, { useState } from 'react'

export const Expander = ({
  content,
  buttonTextCompressed,
  buttonTextExpanded,
  className,
}: {
  content: string
  buttonTextCompressed: string
  buttonTextExpanded: string
  className?: string
}): JSX.Element => {
  const [isExpanded, setIsExpanded] = useState(false)

  const classNames = [
    className,
    'c-expander',
    isExpanded ? 'expanded' : 'compressed',
  ]

  const buttonText = isExpanded ? buttonTextExpanded : buttonTextCompressed

  return (
    <div className={classNames.join(' ')}>
      <div className="content" dangerouslySetInnerHTML={{ __html: content }} />
      <button
        type="button"
        onClick={() => {
          setIsExpanded(!isExpanded)
        }}
      >
        {buttonText}
      </button>
    </div>
  )
}
