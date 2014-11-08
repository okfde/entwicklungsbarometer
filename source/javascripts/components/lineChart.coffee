class @D3Linechart extends @D3Graph
  constructor: (@data, @options = {}) ->
    @options = _.defaults(@options, { width: 200, height: 200, margin: {top: 40, right: 30, bottom: 150, left: 40} })

  setLine: ->
    @line = d3.svg.line()
    .x((d) =>
      @xScale(d[@dateKey]))
    .y((d) =>
      @yScale(d[@dataKey]))

  setScales: ->
    @yScale = d3.scale.linear()
          .range([@options.height, 0])
          .domain(@yScaleDomain)
    @xScale = d3.time.scale()
          .range([0,@options.width])
          .domain(@xScaleDomain)

  setAxis: ->
    @yAxis = d3.svg.axis()
    .scale(@yScale)
    .orient("left")
    .ticks(5)
    @xAxis = d3.svg.axis()
    .scale(@xScale)
    .orient("bottom")
    .ticks(4)

  setGrid: ->
    @yGrid = d3.svg.axis()
      .scale(@yScale)
      .orient("left")
      .ticks(5)

  createAxisAndScales: ->
    @setLine()
    @setScales()
    @setAxis()
    @setGrid()

  parseDateFromYear: (year) ->
    new Date(year,0,1)

