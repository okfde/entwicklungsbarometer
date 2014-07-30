@cdi_index = (element, key='Overall') ->
  d3.csv rootPath+'/data/cdi.csv', (err, data) ->
    data = _.sortBy(data, (d) -> d[key])
    heights = [40,20]
    dx = [0,10]
    classes = ['max-score', 'score']
    margin = {top: 10, right: 30, bottom: 150, left: 40}
    width = 900
    height = 300
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
    countries.enter().append('g').attr('class', (d) -> d.Country).attr('transform', (d) -> "translate(#{x(d.Country)},0)")
    countries.append('rect').attr('y',0).attr('width', x.rangeBand()).attr('height', height).attr('class', classes[0])
    score = countries.append('rect')
    score
      .attr('y', (d) -> y(d[key]))
      .attr('width', x.rangeBand())
      .attr('height', (d,i) -> height - y(d[key]))
      .attr('class', (d,i) -> classes[1])
    countries.append('text').text((d) -> d[key]).attr('y', (d) -> y(d[key]) - 10).attr('dx', x.rangeBand()/6)
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
