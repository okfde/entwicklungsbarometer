class @Saferworld extends @Barchart
  constructor: (@data, @options = {}) ->
    super(@data, @options)
    @setValueKey('Average')
    @setGroupKey('Country')

  dataSetup: ->
    _.map(@data, (d) -> d.Average = parseInt(d.Average))
    @data = _.sortBy(@data, (d) -> d.Average)
    @setXDomain(@data.map((d) -> d.Country))
    @setYDomain([d3.min(@data, (d) -> d.Average),100])

  setSubscoreChart: (chart) ->
    @subViz = chart

  mouseover: (d) =>
    @subViz.setValueKey(d.Country)
    @subViz.update(@subViz.data)

saferworlSubViz = (data) ->
  options = { width: 300, margin: { top: 20, bottom: 20, right: 20, left: 550 }, showExtent: true, rotate: { x: true } }
  subViz = new VerticalBarchart(data, options)
  subViz.setValueKey('Germany')
  subViz.setGroupKey('Indikator')
  subViz.setYDomain(data.map((d) -> d.Indikator))
  subViz.setXDomain([d3.min(data, (d) -> d.Germany),100])
  subViz.render('.saferworld-sub')
  subViz

showSaferworldViz = ->
  saferworldPath = "#{rootPath}/data/security/transparenz/saferworld.csv"
  saferworldSubPath = "#{rootPath}/data/security/transparenz/saferworld_by_indikator.csv"
  queue()
    .defer(d3.csv, saferworldPath)
    .defer(d3.csv, saferworldSubPath)
    .await (error, saferWorld, saferWorldByIndikator) ->
      options = { showExtent: true, rotate: { x: true } }
      saferworlSubViz = saferworlSubViz(saferWorldByIndikator)
      saferworldChart = new @Saferworld(saferWorld, options)
      saferworldChart.dataSetup()
      saferworldChart.setSubscoreChart(saferworlSubViz)
      saferworldChart.render('.saferworld')

$ ->
  if $('#transparenz .saferworld').length > 0
    showSaferworldViz()
