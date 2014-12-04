class @D3Linechart extends @D3Graph
  constructor: (@data, @options = {}) ->
    @options = _.defaults(@options, { width: 200, height: 200, margin: {top: 40, right: 30, bottom: 150, left: 40}, ticks: { y: 5, x: 4 } })

  createYAxis: ->
    @svgSelection.append("g")
    .attr("class", "y axis")
    .attr("transform", "translate(0,0)")
    .call(@yAxis)

  setDataKey: (key = 'value') ->
    @dataKey = key

  setDateKey: (key = 'date') ->
    @dateKey = key

  setLineClass: (key = 'lines') ->
    @lineClass = key

  lineClassForElement: (d) ->
    d[@dataKey]

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
    .ticks(@options.ticks.y)
    @xAxis = d3.svg.axis()
    .scale(@xScale)
    .orient("bottom")
    .ticks(@options.ticks.x)

  setGrid: ->
    @yGrid = d3.svg.axis()
      .scale(@yScale)
      .orient("left")
      .ticks(@options.ticks.y)

  draw: (data) ->
    graphGroup = @svgSelection.selectAll("g.#{@lineClass}").data(data)
    graphs = graphGroup.enter().append("g")
      .attr('class', (d) => "#{@lineClass} #{@lineClassForElement(d)}")
    line = graphs.append("path")
    line.attr('class', 'line').attr("d", @line)

  createAxisAndScales: ->
    @setLine()
    @setScales()
    @setAxis()
    @setGrid()

  parseDateFromYear: (year) ->
    new Date(year,0,1)

  render: (@element) ->
    @createAxisAndScales(@data)
    @createSvg()
    @createYAxis()
    @draw(@data)
