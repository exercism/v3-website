import React, { useState } from 'react'
import { useDropdown } from './useDropdown'
import { Track } from '../types'
import { Icon, GraphicalIcon } from '../common'
import { ActivatePracticeModeModal } from './track-menu/ActivatePracticeModeModal'
import { ResetTrackModal } from './track-menu/ResetTrackModal'
import { LeaveTrackModal } from './track-menu/LeaveTrackModal'

export type Links = {
  repo: string
  documentation: string
  activatePracticeMode: string
  deactivatePracticeMode: string
  reset: string
  leave: string
}

type ModalType = 'practice' | 'reset' | 'leave'

export const TrackMenu = ({
  track,
  links,
}: {
  track: Track
  links: Links
}): JSX.Element => {
  const [modal, setModal] = useState<ModalType | null>(null)
  const {
    buttonAttributes,
    panelAttributes,
    listAttributes,
    itemAttributes,
    open,
  } = useDropdown(5, undefined, {
    placement: 'bottom-start',
    modifiers: [
      {
        name: 'offset',
        options: {
          offset: [0, 8],
        },
      },
    ],
  })

  return (
    <div className="c-track-menu">
      <button {...buttonAttributes}>
        <Icon icon="more-horizontal" alt="Track options" />
      </button>
      {open ? (
        <div {...panelAttributes} className="c-dropdown-generic-menu">
          <ul {...listAttributes}>
            <li {...itemAttributes(0)}>
              <a href={links.repo} target="_blank" rel="noreferrer">
                <GraphicalIcon icon="external-site-github" />
                See {track.title} track on Github
                <GraphicalIcon icon="external-link" className="external-link" />
              </a>
            </li>
            <li {...itemAttributes(1)}>
              <a href={links.documentation} target="_blank" rel="noreferrer">
                <GraphicalIcon icon="docs" />
                {track.title} documentation
              </a>
            </li>
            {links.activatePracticeMode ? (
              <li {...itemAttributes(2)}>
                <button type="button" onClick={() => setModal('practice')}>
                  <GraphicalIcon icon="practice-mode" />
                  Activate practice mode…
                </button>
              </li>
            ) : null}
            <li {...itemAttributes(3)}>
              <button type="button" onClick={() => setModal('reset')}>
                <GraphicalIcon icon="reset" />
                Reset track…
              </button>
            </li>
            <li {...itemAttributes(4)}>
              <button type="button" onClick={() => setModal('leave')}>
                <div className="emoji">👋</div>
                Leave track…
              </button>
            </li>
          </ul>
        </div>
      ) : null}
      <ActivatePracticeModeModal
        open={modal === 'practice'}
        onClose={() => setModal(null)}
        endpoint={links.activatePracticeMode}
      />
      <ResetTrackModal
        open={modal === 'reset'}
        onClose={() => setModal(null)}
        endpoint={links.reset}
      />
      <LeaveTrackModal
        open={modal === 'leave'}
        onClose={() => setModal(null)}
        endpoint={links.leave}
      />
    </div>
  )
}
