formatCurrency = d3.numberFormat("$,.2f")

changeDiffClass = (value) ->
  if value != 0
    if value > 0 then "positive" else "negative"

queue()
.defer(d3.csv, rootPath+"/data/exporte_2012_2013.csv")
.defer(d3.csv, rootPath+"/data/gesamt_exporte_2013.csv")
.await (error, data, gesamt) ->
  ruestung2013 = _.filter(data,(num) -> num.ruestung > 0)
  ruestung2013 = _.sortBy(ruestung2013, (num) -> -num.ruestung)
  gesamtRuestung2013 = _.reduce(ruestung2013,((sum, d) -> return sum + parseInt(d.ruestung)), 0)
  gesamt2013 = _.reduce(gesamt,((sum, d) -> return sum + parseInt(d.ruestung)), 0)

  d3.select('#ruestung .gesamt-ruestung').html(formatCurrency(gesamtRuestung2013))
  d3.select('#ruestung .gesamt').html(formatCurrency(gesamt2013))

  width = parseInt(d3.select('.ruestung-2013-chart').style('width'))
  margin = {top: 10, right: 30, bottom: 120, left: 40}
  width = width - margin.left - margin.right
  height = 300 - margin.top - margin.bottom

  y = d3.scale.linear()
    .range([height, 0])

  chart = d3.select(".chart")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
  y.domain([0, d3.max(ruestung2013, (d) -> parseInt(d.ruestung) )])
  x = d3.scale.ordinal()
      .rangeRoundBands([0, width], .1)
  x.domain(ruestung2013.map((d) -> d.Country))
  barWidth = (width - 20) / ruestung2013.length
  bar = chart.selectAll("g")
        .data(ruestung2013)
        .enter().append("g")
        .attr("transform", (d) -> "translate(" + x(d.Country) + ",0)")
  bar.append("rect")
      .attr("y", (d) -> y(d.ruestung))
      .attr("height", (d) -> height - y(d.ruestung))
      .attr("width", x.rangeBand())
  xAxis = d3.svg.axis()
  .scale(x)
  .orient("bottom")
  chart.append("g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + height + ")")
  .call(xAxis)
  .selectAll("text")
  .attr("y", 0)
  .attr("x", 9)
  .attr("dy", ".35em")
  .attr("transform", "rotate(90)")
  .style("text-anchor", "start")

  ruestungExporte2013 = d3.select('#exporte-2013').append('table')
  ruestungExporte2013.attr('class','table-borders')
  tHeadTr = ruestungExporte2013.append('thead').append('tr')
  tHeadTr.append('th').text('Land')
  tHeadTr.append('th').text('2013')
  tHeadTr.append('th').text('Differenz zu 2012')
  tBody = ruestungExporte2013.append('tbody')
  trs = tBody.selectAll('tr').data(ruestung2013)
  trs.enter().append('tr')
  trs.append('td').text((d) -> d.Country)
  trs.append('td').text((d) -> formatCurrency(d.ruestung))
  trs.append('td').text((d) -> formatCurrency(d.ruestung - d.Ruestung_2012)).attr('class', (d) -> changeDiffClass(d.ruestung - d.Ruestung_2012))

  notFreeTable = d3.select('#all-exports').append('table')
  notFreeTable.attr('class','table-borders')
  tHeadTr = notFreeTable.append('thead').append('tr')
  tHeadTr.append('th').text('Land')
  tHeadTr.append('th').text('Exporte 2013')
  tHeadTr.append('th').text('Rüstungsexporte 2013')
  tHeadTr.append('th').text('Differenz Gesamtexporte zu 2012')
  tHeadTr.append('th').text('Differenz Rüstungsexporte zu 2012')
  tBody = notFreeTable.append('tbody')
  trs = tBody.selectAll('tr').data(data)
  trs.enter().append('tr')

  trs.append('td').text((d) -> d.Country)
  trs.append('td').text((d) -> formatCurrency(d.gesamt))
  trs.append('td').text((d) -> formatCurrency(d.ruestung))
  trs.append('td').text((d) -> formatCurrency(d.gesamt - d.Gesamt_2012)).attr('class', (d) -> changeDiffClass(d.gesamt - d.Gesamt_2012))
  trs.append('td').text((d) -> formatCurrency(d.ruestung - d.Ruestung_2012)).attr('class', (d) -> changeDiffClass(d.ruestung - d.Ruestung_2012))
