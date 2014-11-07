class @Peacekeeping extends @D3Graph
  constructor: (@rawData, @options = {}) ->
    @options = _.defaults(@options, { width: 200, height: 200, margin: {top: 40, right: 30, bottom: 150, left: 40} })

  setDataKey: (key = 'per_capita') ->
    @dataKey = key

  createAxisAndScales: (data) ->
    @yScale = d3.scale.linear()
          .range([@options.height, 0])
          .domain(@yScaleDomain)
    @xScale = d3.time.scale()
          .range([0,@options.width])
          .domain(@xScaleDomain)
    @yAxis = d3.svg.axis()
    .scale(@yScale)
    .orient("left")
    .ticks(5)
    @xAxis = d3.svg.axis()
    .scale(@xScale)
    .orient("bottom")
    .ticks(4)
    @yGrid = d3.svg.axis()
      .scale(@yScale)
      .orient("left")
      .ticks(5)
  parseDateFromYear: (year) ->
    new Date(year,0,1)

  setScalesAndDomain: (data)->
    @setDataKey()
    @setYDomain([0, d3.max(data, (d) => Math.ceil(parseFloat(d[@dataKey])) )])
    @setXDomain(d3.extent(data, (d) => @parseDateFromYear(d.year)))
    @line = d3.svg.line()
    .x((d) =>
      @xScale(@parseDateFromYear(d.year)))
    .y((d) =>
      @yScale(d[@dataKey]))

  drawSingle: (countryName) ->
    @data = _.filter(@rawData, (d) -> d.country == countryName)
    @data = _.sortBy(@data, (d) => @parseDateFromYear(d.year))
    @setScalesAndDomain(@data)

  drawMultiples: ->
    @data = _.groupBy(@rawData, (d) -> d.country)
    @data = _.map(@data, (data) => _.sortBy(data, (d) => @parseDateFromYear(d.year)))
    @setScalesAndDomain(@data[0])
    @createSvg = ->
      @countries = d3.select(@element).selectAll('svg.countries').data(@data)

    @draw = (data) ->
      groups = @countries.enter().append('svg')
      .attr('class', (d) -> "#{d[0].country.toLowerCase()} countries")
      .attr('width', @options.width + @options.margin.left + @options.margin.right)
      .attr('height', @options.height + @options.margin.top + @options.margin.bottom)
      .append("g")
      .attr("transform", "translate(" + @options.margin.left + "," + @options.margin.top + ")")
      groups.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + @options.height + ")")
      .call(@xAxis)
      groups.append("g")
      .attr("class", "grid")
      .call(@yGrid.tickSize(-@options.height, 0, 0)
                  .tickFormat(""))
      groups.append("text")
      .attr("class","name")
      .text((d) -> d[0].country)
      .attr('transform', "translate(#{@options.width/2},5)")
      .attr('text-anchor', 'middle')

      groups.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(0,0)")
      .call(@yAxis)
      groups.append("path").datum( (d) -> d).attr('d', @line).attr('class', 'line')


  draw: (data) ->
    graphGroup = @svgSelection.selectAll('g.graphs')
    @svgSelection.append("path").attr('class', 'line').datum(data).attr("d", @line)

$ ->
  if $('#peacekeeping').length > 0
    peacekeepingPath = rootPath+"/data/peacekeeping_contributions.csv"
    d3.csv peacekeepingPath, (data) ->
      options = { width: 200, height: 200, margin: { top: 10, left: 20, bottom: 20, right: 10 } }
      pk = new Peacekeeping(data, options)
      #pk.drawSingle('Germany')
      pk.drawMultiples()
      pk.render('.contributions')

