import React from 'react'

export type AccordionContext = {
  id: string
  isOpen: boolean
  onClick: (id: string) => void
}

const Context = React.createContext<AccordionContext>({
  id: '',
  isOpen: false,
  onClick: (id: string) => {},
})

export const Accordion = ({
  id,
  isOpen,
  onClick,
  children,
}: {
  id: string
  isOpen: boolean
  onClick: (id: string) => void
  children?: React.ReactNode
}): JSX.Element => {
  return (
    <Context.Provider value={{ isOpen, id, onClick }}>
      {children}
    </Context.Provider>
  )
}

const AccordionHeader = ({
  children,
}: {
  children?: React.ReactNode
}): JSX.Element => {
  const { isOpen, id, onClick } = React.useContext(Context)

  return (
    <button
      type="button"
      onClick={() => onClick(id)}
      aria-expanded={isOpen}
      aria-controls={`accordion-panel-${id}`}
      id={`accordion-header-${id}`}
    >
      {children}
    </button>
  )
}
AccordionHeader.displayName = 'AccordionHeader'
Accordion.Header = AccordionHeader

const AccordionPanel = ({ children }: { children: React.ReactNode }) => {
  const { isOpen, id } = React.useContext(Context)

  return (
    <div
      id={`accordion-panel-${id}`}
      aria-labelledby={`accordion-panel-${id}`}
      hidden={!isOpen}
    >
      {children}
    </div>
  )
}

AccordionPanel.displayName = 'AccordionPanel'
Accordion.Panel = AccordionPanel
