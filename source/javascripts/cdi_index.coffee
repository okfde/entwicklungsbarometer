class @CDISubIndex
  constructor: (@data, @categories, @options = {}) ->
    @options = _.defaults(@options, { width: 900, height: 200, margin: {top: 40, right: 30, bottom: 150, left: 40} })
    @classes = ['max-score', 'score']
  createSvg: ->
    @svgSelection ||= d3.select(@element).append('svg')
    .attr('width', @options.width + @options.margin.left + @options.margin.right)
    .attr('height', @options.height + @options.margin.top + @options.margin.bottom)
    .append("g")
    .attr("transform", "translate(" + @options.margin.left + "," + @options.margin.top + ")")

    @svgSelection.append("g")
    .attr("class", "y axis")
    .attr("transform", "translate(-2,0)")
    .call(@yAxis)
  createAxisAndScales: (data) ->
    @yScale = d3.scale.ordinal()
          .rangeRoundBands([0, @options.height], .1)
          .domain([0...@categories.length])
    @xScale = d3.scale.linear()
          .range([0,@options.width])
          .domain([0, 13])
    @yAxisScale = d3.scale.ordinal()
          .rangeRoundBands([0, @options.height], .1)
          .domain(@categories)
    @yAxis = d3.svg.axis()
    .scale(@yAxisScale)
    .orient("left")

  draw: (data) ->
    indicators = @svgSelection.selectAll('g.graphs').data(data)
    indicators.enter().append('g')
    .attr('transform', (d,i) => "translate(0,#{@yScale(i)})").attr('class', 'graphs')
    indicators.exit().remove()
    max = indicators.selectAll("rect.#{@classes[0]}").data([1])
    max.enter().append('rect')
    max.attr('x',0).attr('height', @yScale.rangeBand())
      .attr('width', @options.width).attr('class', @classes[0])
    max.exit().remove()
    label = indicators.selectAll('text').data((d) -> [d])
    label.enter().append('text')
    label.text((d) -> d).attr('x', (d) => @xScale(d) + 15).attr('y', @yScale.rangeBand()/2+2).attr("text-anchor", "middle")
    label.exit().remove()
    score = indicators.selectAll("rect.#{@classes[1]}").data((d) -> [d])
    score.exit().remove()
    score.enter().append('rect')
    score
      .attr('y', (d) => @yScale(d))
      .attr('height', @yScale.rangeBand())
      .attr('width', (d,i) => @xScale(d))
      .attr('class', (d,i) => @classes[1])

  render: (@element) ->
    @createAxisAndScales(@data)
    @createSvg()
    @draw(@data)
  update: (@data) ->
    @draw(data)
@updateSubIndex = (data, countryName='Deutschland') ->
  if($('.cdi-country-sub-index').length > 0)
    country = _.rest(_.values(_.findWhere(data, {Country: countryName})))
    @subIndex = $('.cdi-index-overall').data('cdi-sub')
    $('.cdi-country-sub-index .country-sub-label').text(countryName)
    @subIndex.update(country)
@cdi_index = (element, key='Overall') ->
  d3.csv rootPath+'/data/cdi.csv', (err, data) ->
    data = _.sortBy(data, (d) -> d[key])
    heights = [40,20]
    dx = [0,10]
    classes = ['max-score', 'score']
    margin = {top: 10, right: 30, bottom: 150, left: 40}
    width = $(element).width() - margin.left - margin.right
    height = 300
    subHeight = 200
    country = _.rest(_.values(_.findWhere(data, {Country: 'Deutschland'})))
    categories = _.rest(_.keys(_.findWhere(data, {Country: 'Deutschland'})))
    subindexMargin = { left: 80, right: 25, top: 20, bottom: 1 }
    subIndexoptions = {height: 250, width: $('.cdi-country-sub-index').width()-margin.left-margin.right, margin: subindexMargin}
    @subIndex = new CDISubIndex(country, categories, subIndexoptions)
    scale = d3.scale.linear().domain([0, 10]).range([0, width])
    y = d3.scale.linear()
          .range([height, 0])
          .domain([0, 10])
    x = d3.scale.ordinal()
          .rangeRoundBands([0, width], .1)
          .domain(data.map((d) -> d.Country))
    svg = d3.select(element).append('svg')
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    countries = svg.selectAll('g').data(data)
    countries
      .enter()
      .append('g')
      .attr('class', (d) -> d.Country)
      .attr('transform', (d) -> "translate(#{x(d.Country)},0)")
      .on('mouseover', (d) => @updateSubIndex(data, d.Country))
    countries.append('rect').attr('y',0).attr('width', x.rangeBand()).attr('height', height).attr('class', classes[0])
    score = countries.append('rect')
    score
      .attr('y', (d) -> y(d[key]))
      .attr('width', x.rangeBand())
      .attr('height', (d,i) -> height - y(d[key]))
      .attr('class', (d,i) -> classes[1])
    countries.append('text').text((d) -> d[key]).attr('y', (d) -> y(d[key]) - 10).attr('x', x.rangeBand()/2).attr('text-anchor', 'middle').attr('class', 'label')
    xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")
    svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
    .selectAll("text")
    .attr("y", 0)
    .attr("x", 9)
    .attr("dy", ".30em")
    .attr("transform", "rotate(90)")
    .style("text-anchor", "start")

    if(key == 'Overall')
      @subIndex.render('.cdi-country-sub-index .graph')
      $('.cdi-index-overall').data('cdi-sub', @subIndex)

