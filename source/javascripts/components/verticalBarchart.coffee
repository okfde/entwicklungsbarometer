class @VerticalBarchart extends @Barchart
  constructor: (@data, @options = {}) ->
    super(@data, @options)

  createAxisAndScales: (data) ->
    @yScale = d3.scale.ordinal()
          .rangeRoundBands([0, @options.height], .1)
          .domain(@yScaleDomain)
    @xScale = d3.scale.linear()
          .range([0,@options.width])
          .domain(@xScaleDomain)
    @xAxisScale = d3.scale.linear()
          .range([0,@options.width])
          .domain(@xScaleDomain)
    @yAxisScale = d3.scale.ordinal()
          .rangeRoundBands([0, @options.height], .1)
          .domain(@yScaleDomain)
    @xAxis = d3.svg.axis()
    .scale(@xAxisScale)
    .orient("bottom")
    @yAxis = d3.svg.axis()
    .scale(@yAxisScale)
    .orient("left")

  appendAxis: ->
    @createYAxis()

  showExtent: ->
    @countries.append('rect')
      .attr('x',0)
      .attr('height', @yScale.rangeBand())
      .attr('width', @options.width)
      .attr('class', @extentClass)

  drawValueText: ->
    @countries.append('text')
      .text((d) => d[@valueKey])
      .attr('x', (d) => @xScale(d[@valueKey])+ 10 )
      .attr('y', @yScale.rangeBand()/2 + 2)
      .attr('text-anchor', 'middle')
      .attr('class', 'label')

  drawGroups: ->
    @countries
      .enter()
      .append('g')
      .attr('class', (d) => "countries #{d[@groupKey]}")
      .attr('transform', (d) => "translate(0,#{@yScale(d[@groupKey])})")
      .on("mouseover", @mouseover)

  drawValues: ->
    values = @countries.append('rect')
    values
      .attr('y', (d) => @yScale(d[@valueKey]))
      .attr('height', @yScale.rangeBand())
      .attr('width', (d,i) => @xScale(d[@valueKey]))
    values
