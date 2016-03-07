require '../stylus/main'
domready = require 'domready'
Show = require './_sortingShow'

domready () ->
  svg = document.getElementById 'sort'
  sortingTitle = document.getElementById 'sortTitle'
  landingImg = document.getElementById 'langingImg'
  sortStarted = false

  show = new Show svg
  show.onPivotColorChange (color) ->
    sortingTitle.style.color = color

  window.addEventListener 'scroll', (e) ->
    landingImg.style.transform = "translateY(-#{~~(window.scrollY/3)}px)"
    if window.scrollY > 500 and !sortStarted
      sortStarted = true
      show.start()
