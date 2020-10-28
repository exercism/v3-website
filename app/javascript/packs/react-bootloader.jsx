import ReactDOM from 'react-dom'
import { createPopper } from '@popperjs/core'

const render = (elem, component) => {
  ReactDOM.render(component, elem)

  const unloadOnce = () => {
    ReactDOM.unmountComponentAtNode(elem)
    document.removeEventListener('turbolinks:before-render', unloadOnce)
  }
  document.addEventListener('turbolinks:before-render', unloadOnce)
}

export const initReact = (mappings) => {
  document.addEventListener('turbolinks:load', () => {
    for (const [name, generator] of Object.entries(mappings)) {
      const selector = '[data-react-' + name + ']'
      console.log(selector)
      document.querySelectorAll(selector).forEach((elem) => {
        const data = JSON.parse(elem.dataset.reactData)
        render(elem, generator(data))
      })
    }

    document
      .querySelectorAll('[data-tooltip-type][data-tooltip-url]')
      .forEach((elem) => {
        const name = elem.dataset['tooltipType'] + '-tooltip'
        const generator = mappings[name]

        const componentData = { endpoint: elem.dataset['tooltipUrl'] }
        const component = generator(componentData)

        // Create an element render the React component in
        const tooltipElem = document.createElement('div')
        elem.insertAdjacentElement('afterend', tooltipElem)

        // Link the tooltip element with the reference element
        const popperOptions = {
          placement: elem.dataset['placement'] || 'auto',
        }
        createPopper(elem, tooltipElem, popperOptions)

        elem.addEventListener('mouseenter', () =>
          render(tooltipElem, component)
        )

        elem.addEventListener('mouseleave', () =>
          ReactDOM.unmountComponentAtNode(tooltipElem)
        )
      })
  })
}
