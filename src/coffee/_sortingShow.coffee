d3 = require 'd3'
Util = require './_util'
SortingFuncGenerator = require './_sortingFunc'

class SortingShow
  numCircles = 60
  colorPalette= d3.interpolateRgb('#F6342B', '#03CCFA')

  constructor: (@svg) ->
    Util.addEvent window, 'resize', @svgOnResize
    @$svg = d3.select @svg
    @actions = []
    @circles = []
    @pivotCallbackFunc = []
    @actionLoopId = null
    @shuffledValue = Util.shuffle([0..numCircles])
    @circles = @shuffledValue.map (e) ->
      {color: colorPalette(e/numCircles), id: e, pivot: false}
    @svgOnResize()

    @sortingFunc = new SortingFuncGenerator(@actions, @shuffledValue).dump()
    @sortingFunc[~~(@sortingFunc.length*Math.random())].run()

  ####################
  ## private methods
  ####################
  svgOnResize: () =>
    rect = @svg.getBoundingClientRect()
    @svg.setAttribute 'width', rect.width
    @svg.setAttribute 'height', rect.height
    circlePosHeight = rect.height/2
    circlePosWidth = rect.width/(numCircles+2)
    @circles.forEach (e) ->
      e.cy = circlePosHeight
      e.cx = circlePosWidth
      e.w = circlePosWidth/3
      e.h = if e.pivot then circlePosWidth/3*6 else circlePosWidth/3
    @$svg.selectAll 'rect'
      .data @circles, (v) -> v.id
      .attr 'width', (v) -> v.w*2
      .attr 'height', (v) -> v.h*2
      .attr 'rx', (v) -> v.w
      .attr 'x', (v, i) -> v.cx*(i+1) - v.w
      .attr 'y', (v) -> v.cy - v.h
      .append 'title'
        .text (v) -> v.id

  executeAction: () =>
    if 0 is @actions.length
      clearInterval @actionLoopId
      return
    action = @actions.shift()
    if action.type is 'swap'
      t = @circles[action.m]
      @circles[action.m] = @circles[action.n]
      @circles[action.n] = t
      @$svg.selectAll 'rect'
        .data @circles, (v) -> v.id
        .transition()
        .duration 300
        .ease 'linear'
        .attr 'x', (v, i) -> v.cx*(i+1) - v.w
    else if action.type is 'pivot'
      for func in @pivotCallbackFunc
        func(@circles[action.val].color)
      @circles[action.val].h *= 8
      @circles[action.val].pivot = true
      @$svg.selectAll 'rect'
        .data @circles, (v) -> v.id
        .attr 'y', (v) -> v.cy - v.h
        .attr 'height', (v) -> v.h*2
    else throw InternalError 'unsupported action type'

  ####################
  ## public methods
  ####################
  onPivotColorChange: (func) =>
    if func instanceof Function and @pivotCallbackFunc.indexOf func isnt -1
      @pivotCallbackFunc.push func

  start: () =>
    @$svg.selectAll 'rect'
      .data @circles, (v) -> v.id
      .enter()
      .append 'rect'
      .attr 'width', (v) -> v.w*2
      .attr 'height', (v) -> v.h*2
      .attr 'rx', (v) -> v.w
      .attr 'x', (v, i) -> v.cx*(i+1) - v.w
      .attr 'y', (v) -> v.cy - v.h
      .attr 'fill', (v) -> v.color
    @actionLoopId = Util.loopFunc 60, @executeAction

exports = module.exports = SortingShow
