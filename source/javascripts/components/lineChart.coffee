class @D3Linechart extends @D3Graph
  constructor: (@data, @options = {}) ->
    @options = _.defaults(@options, { width: 800, height: 200, margin: {top: 40, right: 30, bottom: 150, left: 40}, ticks: { y: 5, x: 4 } })

  appendAxis: ->
    @svgSelection.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + @options.height + ")")
    .call(@xAxis)

    @svgSelection.append("g")
    .attr("class", "y axis")
    .attr("transform", "translate(0,0)")
    .call(@yAxis)

  appendAxisDescription: ->
    @svgSelection.append("text")
      .attr('class', 'x description')
      .attr("transform", "translate(" + (@options.width / 2) + " ," + (@options.height + @options.margin.bottom) + ")")
      .style("text-anchor", "middle")
      .text(@xAxisDescription)

    @svgSelection.append("text")
      .attr('class', 'y description')
      .attr("transform", "rotate(-90)")
      .attr('y', 0 - @options.margin.left)
      .attr('x', 0 - (@options.height / 2))
      .style("text-anchor", "middle")
      .attr("dy", "1em")
      .text(@yAxisDescription)

  createMeanLine: ->
    @meanLine = @svgSelection.append("g")
      .attr("class","mean")
      .append("path")
      .datum( @meanData )
      .attr('d', @meanLine)
      .attr('class', 'line mean')

  setMeanData: (data) ->
    @meanData = data
    @meanData.forEach((d) => d.year = @parseDateFromYear(d.year))

  setDataKey: (key = 'value') ->
    @dataKey = key

  setDateKey: (key = 'date') ->
    @dateKey = key

  setLineClass: (key = 'lines') ->
    @lineClass = key

  setXAxisDescription: (description = '') ->
    @xAxisDescription = description

  setYAxisDescription: (description = '') ->
    @yAxisDescription = description

  lineClassForElement: (d) ->
    d[@dataKey]

  setLine: ->
    @line = d3.svg.line()
    .x((d) =>
      @xScale(d[@dateKey]))
    .y((d) =>
      @yScale(d[@dataKey]))

  setMeanLine: ->
    @meanLine = d3.svg.line()
      .x((d) => @xScale(d[@dateKey]))
      .y((d) => @yScale(d.mean))

  setVoronoi: ->
    @voronoi = d3.geom.voronoi()
      .x((d) =>
        @xScale(d[@dateKey]))
      .y((d) =>
        @yScale(d[@dataKey]))
      .clipExtent([
        [-@options.margin.left, -@options.margin.top],
        [@options.width + @options.margin.right, @options.height + @options.margin.bottom]
      ])

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

  setVoronoiData: ->
    @voronoiData = _.flatten(@data)

  createFocusElement: ->
    @focus = @svgSelection.append("g")
    .attr("class", "focus")
    .attr("transform", "translate(-100,-100)")
    @focus.append("circle").attr("r", 4.5)
    @focus.append("text")
          .attr("y", -15)

  createOverlay: ->
    @voronoiGroup = @svgSelection.append("g")
          .attr("class", "voronoi")
    @voronoiGroup.selectAll("path")
      .data(@voronoi(@voronoiData))
      .enter().append("path")
      .attr("d", (d) -> if d? then "M#{d.join("L")}Z" else "")
      .datum((d) -> if d? then d.point)
      .on("mouseover", @mouseover)
      .on("mouseout", @mouseout)

  mouseout: (d) =>
    d3.select(@lineClassForElement(d)).classed("hover", false)
    @focus.attr("transform", "translate(-100,-100)")

  mouseover: (d) =>
    d3.select(@lineClassForElement(d)).classed("hover", true)
    @focus.attr("transform", "translate(#{@xScale(d[@dateKey])},#{@yScale(d[@dataKey])})")
    @focus.select("text").text("#{Math.round(d[@dataKey])}")

  draw: (data) ->
    graphGroup = @svgSelection.selectAll("g.#{@lineClass}").data(data)
    graphs = graphGroup.enter().append("g")
      .attr('class', (d) => "#{@lineClass} #{@lineClassForElement(d)}")
    line = graphs.append("path")
    line.attr('class', 'line').attr("d", @line)

  createAxisAndScales: ->
    @setLine()
    @setVoronoi()
    @setScales()
    @setAxis()
    @setGrid()
    @setVoronoiData()

  parseDateFromYear: (year) ->
    new Date(year,0,1)

  render: (@element) ->
    @createAxisAndScales(@data)
    @createSvg()
    @appendAxis()
    @appendAxisDescription()
    @createMeanLine()
    @draw(@data)
    @createFocusElement()
    @createOverlay()
