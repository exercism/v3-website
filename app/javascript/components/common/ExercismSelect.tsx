import React, { useCallback } from 'react'
import { Icon } from '.'
import { useDropdown } from '../dropdowns/useDropdown'

export const ExercismSelect = <T extends unknown>({
  options,
  value,
  setValue,
  SelectedComponent,
  OptionComponent,
  componentClassName = '',
  buttonClassName = '',
  panelClassName = '',
}: {
  value: T
  options: readonly T[]
  setValue: (value: T) => void
  SelectedComponent: React.ComponentType<{ value: T }>
  OptionComponent: React.ComponentType<{ option: T }>
  componentClassName?: string
  buttonClassName?: string
  panelClassName?: string
}): JSX.Element => {
  const {
    buttonAttributes,
    panelAttributes,
    listAttributes,
    itemAttributes,
    setOpen,
    open,
  } = useDropdown(
    options.length,
    (i) => {
      handleItemSelect(i)
    },
    {
      placement: 'bottom',
      modifiers: [
        {
          name: 'offset',
          options: {
            offset: [0, 8],
          },
        },
      ],
    }
  )
  const handleChange = useCallback(
    (option: T) => {
      setValue(option)
      setOpen(false)
    },
    [setOpen, setValue]
  )
  const handleItemSelect = useCallback(
    (index) => {
      handleChange(options[index])
    },
    [handleChange, options]
  )

  return (
    <div className={componentClassName}>
      <button className={buttonClassName} {...buttonAttributes}>
        <SelectedComponent value={value} />
        <Icon
          icon="chevron-down"
          alt="Click to change"
          className="action-icon"
        />
      </button>
      {open ? (
        <div {...panelAttributes} className={panelClassName}>
          <ul {...listAttributes}>
            {options.map((option, i) => {
              return (
                <li key={i} {...itemAttributes(i)}>
                  <label className="c-radio-wrapper">
                    <input
                      type="radio"
                      onChange={() => handleChange(option)}
                      checked={option === value}
                    />
                    <div className="row">
                      <OptionComponent option={option} />
                    </div>
                  </label>
                </li>
              )
            })}
          </ul>
        </div>
      ) : null}
    </div>
  )
}