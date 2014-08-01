@subIndex = (data, countryName='Germany') ->
  margin = {top: 10, right: 30, bottom: 150, left: 40}
  width = 900
  subHeight = 200
  classes = ['max-score', 'score']
  country = _.rest(_.values(_.findWhere(data, {Country: countryName})))
  subY = d3.scale.linear()
        .range([subHeight, 0])
        .domain([0, 10])
  subX = d3.scale.ordinal()
        .rangeRoundBands([0, width], .1)
        .domain([0...country.length])
  axisSubX = d3.scale.ordinal()
        .rangeRoundBands([0, width], .1)
        .domain(_.rest(_.keys(data[0])))
  d3.select('.cdi-country-sub-index h2').text(countryName)
  subSvg = d3.select('.cdi-country-sub-index svg')
  .attr("width", width + margin.left + margin.right)
  .attr("height", subHeight + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
  indicators = subSvg.selectAll('g').data(country)
  indicators.enter().append('g').attr('transform', (d,i) -> "translate(#{subX(i)},0)")
  indicators.append('rect').attr('y',0).attr('width', subX.rangeBand()).attr('height', subHeight).attr('class', classes[0])
  indicators.append('text').text((d) -> d).attr('y', (d) -> subY(d) - 10).attr('x', subX.rangeBand()/2).attr("text-anchor", "middle")
  score = indicators.append('rect')
  score
    .attr('y', (d) -> subY(d))
    .attr('width', subX.rangeBand())
    .attr('height', (d,i) -> subHeight - subY(d))
    .attr('class', (d,i) -> classes[1])
  subXAxis = d3.svg.axis()
  .scale(axisSubX)
  .orient("bottom")
  subSvg.append("g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + subHeight + ")")
  .call(subXAxis)
  .selectAll("text")
  .attr("y", 0)
  .attr("x", 9)
  .attr("dy", ".30em")
  .attr("transform", "rotate(90)")
  .style("text-anchor", "start")
@cdi_index = (element, key='Overall') ->
  d3.csv rootPath+'/data/cdi.csv', (err, data) ->
    data = _.sortBy(data, (d) -> d[key])
    heights = [40,20]
    dx = [0,10]
    classes = ['max-score', 'score']
    margin = {top: 10, right: 30, bottom: 150, left: 40}
    width = 900
    height = 300
    subHeight = 200
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
    countries.append('rect').attr('y',0).attr('width', x.rangeBand()).attr('height', height).attr('class', classes[0])
    score = countries.append('rect')
    score
      .attr('y', (d) -> y(d[key]))
      .attr('width', x.rangeBand())
      .attr('height', (d,i) -> height - y(d[key]))
      .attr('class', (d,i) -> classes[1])
    countries.append('text').text((d) -> d[key]).attr('y', (d) -> y(d[key]) - 10).attr('x', x.rangeBand()/2).attr('text-anchor', 'middle')
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
      d3.select('.cdi-country-sub-index').append('h2').text('Germany')
      d3.select('.cdi-country-sub-index').append('svg')
      subIndex(data)

