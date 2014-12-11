$ ->
  if $('#ruestung').length > 0
    exportPath = "#{rootPath}/data/security/armsexports/weighted_exports_historical.csv"
    d3.csv exportPath, (data) ->
      options = { rotate: { x: true } }
      exportChart = new @Barchart(data, options)
      _.map(data, (d) -> d.WeightedExports = parseFloat(d.WeightedExports)*(-1))
      data = _.sortBy(data, (d) -> d.WeightedExports)
      exportChart.setXDomain(data.map((d) -> d.Country))
      exportChart.setYDomain(d3.extent(data, (d) -> parseFloat(d.WeightedExports)))
      exportChart.setValueKey('WeightedExports')
      exportChart.setGroupKey('Country')
      exportChart.render('.exports-percent-gdp')
