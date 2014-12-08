class PeacekeepingPersonal extends @D3Linechart
  constructor: (@rawData, @options = {}) ->
    @options = _.defaults(@options, { width: 800, height: 300, margin: {top: 40, right: 30, bottom: 150, left: 80}, ticks: { y: 7, x: 8 } })

  lineClassForElement:  (d) ->
    d[0].Country.toLowerCase()

  setScalesAndDomain: (data)->
    @setDataKey('TotalPercent')
    @setDateKey('year')
    @setYDomain([0, d3.max(data, (d) ->
      d3.max(d, (d) ->
        d.TotalPercent
      )
    )])
    @setXDomain(d3.extent(data[0], (d) => @parseDateFromYear(d.year)))
    @

  drawPersonal: (countries = []) ->
    @data = _.filter(@rawData, (d) -> _.contains(countries, d.Country))
    @data = _.groupBy(@data, (d) -> d.Country)
    @data = _.map(@data, (data) =>
      _.sortBy(data, (d) => @parseDateFromYear(d.year))
    )
    @data.forEach((d) => d.forEach((d) => d.TotalPercent = parseFloat(d.TotalCost)*100))
    @setScalesAndDomain(@data)
    @data.forEach((d) => d.forEach((d) => d.year = @parseDateFromYear(d.year)))

  dataFormat: ->
    d3.numberFormat(",.3f")

  mouseout: (d) =>
    d3.select(".#{d.Country.toLowerCase()} path").classed("country-hover", false)
    @focus.attr("transform", "translate(-100,-100)")

  mouseover: (d) =>
    d3.select(".#{d.Country.toLowerCase()} path").classed("country-hover", true)
    @focus.attr("transform", "translate(#{@xScale(d[@dateKey])},#{@yScale(d[@dataKey])})")
    @focus.select("text").text("#{d.Country}: #{@dataFormat()(d[@dataKey])} % of GDP")
$ ->
  if $('#personal').length > 0
    personalPath = "#{rootPath}/data/security/peacekeeping/peacekeepingPersonal.csv"
    d3.csv personalPath, (data) ->
      countries = ['Austria', 'Finland', 'Germany', 'Luxembourg','EU', 'Slovakia']
      personal = new PeacekeepingPersonal(data)
      personal.setLineClass('countries')
      personal.drawPersonal(countries)
      personal.render('#personal')
