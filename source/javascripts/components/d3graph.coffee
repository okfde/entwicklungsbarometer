class @D3Graph
  constructor: (@data, @options = {}) ->
    @options = _.defaults(@options, { width: 900, height: 200, margin: {top: 40, right: 30, bottom: 150, left: 40} })

  createSvg: ->
    @svgSelection ||= d3.select(@element).append('svg')
    .attr('width', @options.width + @options.margin.left + @options.margin.right)
    .attr('height', @options.height + @options.margin.top + @options.margin.bottom)
    .append("g")
    .attr("transform", "translate(" + @options.margin.left + "," + @options.margin.top + ")")

    @svgSelection.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + @options.height + ")")
    .call(@xAxis)

  createAxisAndScales: (data) ->
    @yScale = d3.scale.linear()
          .range([@options.height, 0])
          .domain(@yScaleDomain)
    @xScale = d3.scale.ordinal()
          .rangeRoundBands([0, @options.width], .1)
          .domain(@xScaleDomain)
    @xAxisScale = d3.scale.ordinal()
          .rangeRoundBands([0, @options.width], .1)
          .domain(@xScaleDomain)
    @xAxis = d3.svg.axis()
    .scale(@xAxisScale)
    .orient("bottom")

  setXDomain: (domain) ->
    @xScaleDomain = domain

  setYDomain: (domain) ->
    @yScaleDomain = domain

  draw: (data) ->
    graphGroup = @svgSelection.selectAll('g.graphs').data(data)
    graphGroup.enter().append('g').attr('transform', (d,i) => "translate(#{@xScale(d)},0)").attr('class', 'graphs')
    graphGroup.exit().remove()

  render: (@element) ->
    @createAxisAndScales(@data)
    @createSvg()
    @draw(@data)

  update: (@data) ->
    @createAxisAndScales(@data)
    @draw(data)
