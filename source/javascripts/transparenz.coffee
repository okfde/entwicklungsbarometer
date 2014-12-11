$ ->
  if $('#transparenz .saferworld').length > 0
    saferworldPath = "#{rootPath}/data/security/transparenz/saferworld.csv"
    d3.csv saferworldPath, (data) ->
      options = { showExtent: true, rotate: { x: true } }
      saferworldChart = new @Barchart(data, options)
      _.map(data, (d) -> d.Average = parseInt(d.Average))
      data = _.sortBy(data, (d) -> d.Average)
      saferworldChart.setXDomain(data.map((d) -> d.Country))
      saferworldChart.setYDomain([d3.min(data, (d) -> d.Average),100])
      saferworldChart.setValueKey('Average')
      saferworldChart.setGroupKey('Country')
      saferworldChart.render('.saferworld')
