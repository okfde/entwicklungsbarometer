$ ->
  if $('#ruestung').length > 0
    exportPath = "#{rootPath}/data/security/armsexports/weighted_exports_historical.csv"
    d3.csv exportPath, (data) ->
      exportChart = new @Barchart(data)
      _.map(data, (d) -> d.WeightedExports = parseFloat(d.WeightedExports)*(-1))
      exportChart.setXDomain(data.map((d) -> d.Country))
      exportChart.setYDomain(d3.extent(data, (d) -> parseFloat(d.WeightedExports)))
      exportChart.setValueKey('WeightedExports')
      exportChart.setGroupKey('Country')
      exportChart.render('.exports-percent-gdp')
