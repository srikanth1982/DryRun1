_ = require 'underscore-plus'
{Disposable} = require 'event-kit'

detectWhenVisible = (element, callback) ->
  mutationObserver.observe(document, subtree: true, attributes: true, childList: true) if observedElements.size is 0
  observedElements.set(element, callback)

  new Disposable ->
    observedElements.remove(element)
    mutationObserver.disconnect() if observedElements.size is 0

checkVisibility = ->
  observedElements.forEach (callback, element) ->
    if element.offsetParent?
      observedElements.delete(element)
      callback()

checkVisibility = _.debounce(checkVisibility, 200, true)

mutationObserver = new MutationObserver(checkVisibility)
observedElements = new Map

module.exports = detectWhenVisible
