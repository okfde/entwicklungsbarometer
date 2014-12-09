class @Peacekeeping extends @D3Linechart
  constructor: (@rawData, @options = {}) ->
    @options = _.defaults(@options, { width: 200, height: 200, margin: {top: 40, right: 30, bottom: 150, left: 40}, ticks: { y: 7, x: 8 } })

  lineClassForElement:  (d) ->
    d[0].country.toLowerCase()

  setScalesAndDomain: (data)->
    @setDataKey('per_capita')
    @setDateKey('year')
    @setYDomain([0, d3.max(data, (d) => Math.ceil(parseFloat(d[@dataKey])) )])
    @setXDomain(d3.extent(data, (d) => @parseDateFromYear(d.year)))
    @

  dataFormat: ->
    d3.numberFormat(",.2f")
  mouseout: (d) =>
    d3.select(".#{d.country.toLowerCase()} path").classed("country-hover", false)
    @focus.attr("transform", "translate(-100,-100)")

  mouseover: (d) =>
    d3.select(".#{d.country.toLowerCase()} path").classed("country-hover", true)
    @focus.attr("transform", "translate(#{@xScale(d[@dateKey])},#{@yScale(d[@dataKey])})")
    @focus.select("text").text("#{d.country}: $#{@dataFormat()(d[@dataKey])} Mio")

  drawSingle: (countryName) ->
    data = _.filter(@rawData, (d) -> d.country == countryName)
    data = _.sortBy(data, (d) => @parseDateFromYear(d.year))
    @data = [data]
    @setScalesAndDomain(@data[0])
    @data.forEach((d) => d.forEach((d) => d.year = @parseDateFromYear(d.year)))

  drawSpecific: (countries = []) ->
    @data = _.filter(@rawData, (d) -> _.contains(countries, d.country))
    @data = _.groupBy(@data, (d) -> d.country)
    @data = _.map(@data, (data) =>
      _.sortBy(data, (d) => @parseDateFromYear(d.year))
    )
    @setScalesAndDomain(@data[0])
    @data.forEach((d) => d.forEach((d) => d.year = @parseDateFromYear(d.year)))

$ ->
  if $('#peacekeeping .contributions').length > 0
    peacekeepingPath = "#{rootPath}/data/security/peacekeeping/peacekeeping_contributions.csv"
    peacekeepingMeanPath = "#{rootPath}/data/security/peacekeeping/means.csv"
    queue()
    .defer(d3.csv, peacekeepingPath)
    .defer(d3.csv, peacekeepingMeanPath)
    .await (error, data, meanData) ->
      options = {
        width: 800
        height: 400
        margin: { top: 20, left: 20, bottom: 20, right: 80 }
      }
      pk = new Peacekeeping(data, options)
      pk.setMeanData(meanData)
      pk.drawSpecific(['Germany', '','Norway','Denmark','Poland'])
      pk.setLineClass("countries")
      pk.setMeanLine()
      pk.render('.contributions')
