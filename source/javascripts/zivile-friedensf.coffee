class ZivileFriedensfoerderung extends @D3Linechart
  constructor: (@rawData, @options = {}) ->
    @options = _.defaults(@options, { width: 800, height: 300, margin: {top: 40, right: 80, bottom: 40, left: 80}, ticks: { y: 7, x: 8 } })

  lineClassForElement:  (d) ->
    d[0].Country.toLowerCase()

  setScalesAndDomain: (data)->
    @setDataKey('value')
    @setDateKey('year')
    @setYDomain([0, d3.max(data, (d) ->
      d3.max(d, (d) ->
        parseInt(d.value)
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
    @setScalesAndDomain(@data)
    @data.forEach((d) => d.forEach((d) => d.year = @parseDateFromYear(d.year)))

  dataFormat: ->
    d3.numberFormat(",.")

  mouseout: (d) =>
    d3.select(".#{d.Country.toLowerCase()} path").classed("country-hover", false)
    @focus.attr("transform", "translate(-100,-100)")

  mouseover: (d) =>
    d3.select(".#{d.Country.toLowerCase()} path").classed("country-hover", true)
    @focus.attr("transform", "translate(#{@xScale(d[@dateKey])},#{@yScale(d[@dataKey])})")
    @focus.select("text").text("#{d.Country}: $#{@dataFormat()(d[@dataKey])} Mio")
$ ->
  if $('#friedensfoerderung .zivile').length > 0
    zivilePath = "#{rootPath}/data/security/friedensfoerderung/zivile.csv"
    d3.csv zivilePath, (data) ->
      countries = ['Österreich', 'USA', 'Deutschland', 'Vereinigtes Königreich', 'Norwegen']
      personal = new ZivileFriedensfoerderung(data)
      personal.setLineClass('countries')
      personal.drawPersonal(countries)
      personal.setYAxisDescription('in Mio $')
      personal.setXAxisDescription('Jahr')
      personal.render('#friedensfoerderung .zivile')
