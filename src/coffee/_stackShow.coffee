d3 = require 'd3'
Util = require './_util'

class StackShow
  numRect = 160
  colorPalette = ['#F6342B', '#F6342B', '#03CCFA']

  constructor: (@svg) ->
    @$svg = d3.select @svg
    @actionLoopId = null
    @rects = Util.shuffle([0...numRect]).map (e) ->
      {color: ~~(Math.random()*3), id: e}
    rect = @svg.getBoundingClientRect()
    @svg.setAttribute 'width', rect.width
    @svg.setAttribute 'height', rect.height

    @blue = @rects.filter((e) -> e.color is 2).length
    @red = 160 - @blue

  ####################
  ## private methods
  ####################

  executeAction: () =>
    count = 0
    @$svg.selectAll "rect.red"
      .transition()
      .duration 1500
      .delay (v, i) -> i * 10
      .ease 'exp-out-in'
      .attr 'y', -200
      .each 'end', () =>
        ++count
        if count is @red
          s = (940 - @blue*2)/2
          @$svg.selectAll "rect.blue"
            .transition()
            .ease 'exp-in-out'
            .duration 1500
            .delay (v, i) -> i * 10
            .attr 'x', (v, i) ->
              s+i*2



  ####################
  ## public methods
  ####################

  start: () =>
    c = colorPalette
    count = 0
    @$svg.selectAll 'rect'
      .data @rects
      .enter()
      .append 'rect'
      .attr 'class', (v) ->
        if v.color is 2 then 'blue' else 'red'
      .attr 'x', (v) -> v.id * 6 + 2
      .attr 'y', 100
      .attr 'width', 2
      .attr 'height', 200
      .attr 'fill', '#333'
    @$svg.selectAll 'rect'
      .transition()
      .duration 1000
      .delay (v) -> v.id*20
      .attr 'fill', (v) -> c[v.color]
      .each 'end', () =>
        ++count
        if count is 160
          # Util.loopFunc 60, @executeAction
          @executeAction()


exports = module.exports = StackShow
