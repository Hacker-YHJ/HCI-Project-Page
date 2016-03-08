require '../stylus/main'
domready = require 'domready'
SortingShow = require './_sortingShow'
QueueShow = require './_queueShow'
StackShow = require './_stackShow'

domready () ->
  sortSvg = document.getElementById 'sort'
  queueSvg = document.getElementById 'queue'
  stackSvg = document.getElementById 'stack'
  sortingTitle = document.getElementById 'sortTitle'
  landingImg = document.getElementById 'langingImg'
  sortStarted = false
  queueStarted = false
  stackStarted = false

  sshow = new SortingShow sortSvg
  qshow = new QueueShow queueSvg
  stshow = new StackShow stackSvg

  sshow.onPivotColorChange (color) ->
    sortingTitle.style.color = color

  window.addEventListener 'scroll', (e) ->
    landingImg.style.transform = "translateY(-#{~~(window.scrollY/3)}px)"

    if !sortStarted
      sortRect = sortSvg.getBoundingClientRect()
      if sortRect.top < window.innerHeight - 200 and sortRect.bottom > 240
        sortStarted = true
        sshow.start()

    if !queueStarted
      queueRect = queueSvg.getBoundingClientRect()
      if queueRect.top < window.innerHeight - 200 and queueRect.bottom > 240
        queueStarted = true
        qshow.start()

    if !stackStarted
      stackRect = stackSvg.getBoundingClientRect()
      if stackRect.top < window.innerHeight - 120 and stackRect.bottom > 160
        stackStarted = true
        stshow.start()
