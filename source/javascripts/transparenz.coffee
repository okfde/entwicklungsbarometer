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

class @SaferWorlSubViz extends @VerticalBarchart
  constructor: (@data, @options = {}) ->
    super(@data, @options)

  setup: ->
    @setValueKey('Germany')
    @setGroupKey('Indikator')
    @setYDomain(@data.map((d) -> d.Indikator))
    @setXDomain([d3.min(@data, (d) -> d.Germany),100])

  drawValueText: ->
    @countries.selectAll('text').remove()
    @countries.append('text')
      .text((d) => d[@valueKey])
      .attr('x', (d) => @xScale(100)+ 10 )
      .attr('y', @yScale.rangeBand()/2 + 2)
      .attr('text-anchor', 'middle')
      .attr('class', 'label')
    @countries.append('text')
      .text((d,i) => @yScale.domain()[i])
      .attr('y', @yScale.rangeBand()/2 + 4)
      .attr('x', 5)

  mouseover: (d) ->
    $('.saferworld-sub .description').html(d.Description)

saferworlSubViz = (data) ->
  options = { width: $('.saferworld-sub').width(), margin: { top: 50, bottom: 10, right: 20, left: 0 }, showExtent: true, rotate: { x: true } }
  subViz = new @SaferWorlSubViz(data, options)
  subViz.setup()
  subViz.render('.saferworld-sub .barchart')
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
