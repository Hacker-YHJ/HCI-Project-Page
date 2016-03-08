d3 = require 'd3'
Util = require './_util'

class QueueShow
  numCircles = 200
  colorPalette = ['#F6342B', '#03CCFA']

  constructor: (@svg) ->
    @$svg = d3.select @svg
    @circles = []
    @actionLoopId = null
    @circles = Util.shuffle([0...numCircles]).map (e) ->
      {color: e % 2, id: e}
    rect = @svg.getBoundingClientRect()
    @svg.setAttribute 'width', rect.width
    @svg.setAttribute 'height', rect.height

    @blue = []
    @red = []

  ####################
  ## private methods
  ####################

  executeAction: () =>
    red = @red
    blue = @blue

    # if @count is 200
      # clearInterval @actionLoopId
      # return

    c = @circles.shift()
    if c?
      @$svg.select "circle[data-id=\"#{c.id}\"]"
        .transition()
        .ease 'cubic'
        .duration 2000
        .attr 'cx', 280
        .attr 'cy', 200
        .each 'end', () ->
          d3.select(@)
            .attr 'class', 'entrance'
            .attr 'cy', 200

    @$svg.selectAll 'circle.entrance'
      .attr 'class', 'queue'
      .transition()
      .duration 1500
      .ease 'linear'
      .attr 'cx', 680
      .each 'end', () ->
        d3.select(@)
          .attr 'class', (v) ->
            if v.color is 0
              red.push v
              @.setAttribute 'pos-y', (red.length-1) % 10 * 20 + 210
              @.setAttribute 'pos-x', 940 - ~~((red.length-1) / 10) * 20
            else
              blue.push v
              @.setAttribute 'pos-y', 190 - (blue.length-1) % 10 * 20
              @.setAttribute 'pos-x', 940 - ~~((blue.length-1) / 10) * 20
            'exit'


    @$svg.selectAll 'circle.exit'
      .attr 'class', 'done'
      .transition()
      .duration 1500
      .ease 'cubic-out'
      .attr 'cx', () ->
        @.getAttribute 'pos-x'
      .attr 'cy', () ->
        @.getAttribute 'pos-y'
      .each 'end', () =>
        ++@count



  ####################
  ## public methods
  ####################

  start: () =>
    c = colorPalette
    count = 0
    @$svg.selectAll 'rect'
      .data [0..1]
      .enter()
      .append 'rect'
      .attr 'class', 'bar'
      .attr 'x', 280
      .attr 'y', (v) -> 190 + 20*v
      .attr 'rx', '2'
      .attr 'width', '400'
      .attr 'height', '2'
      .attr 'fill', 'white'

    @$svg.selectAll 'circle'
      .data @circles, (v) -> v.id
      .enter()
      .append 'circle'
      .attr 'data-id', (v) -> v.id
      .attr 'r', 0
      .attr 'cx', () -> Math.random()*200 + 10
      .attr 'cy', () -> Math.random()*380 + 10
      .attr 'fill', (v) -> c[v.color]

    @$svg.selectAll 'circle'
      .transition()
      .duration 200
      .delay (v) -> v.id*10
      .attr 'r', 5
      .each 'end', () =>
        ++count
        if count is 200
          @actionLoopId = Util.loopFunc 60, @executeAction

exports = module.exports = QueueShow
