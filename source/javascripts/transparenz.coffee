$ ->
  if $('#transparenz .saferworld').length > 0
    saferworldPath = "#{rootPath}/data/security/transparenz/saferworld.csv"
    d3.csv saferworldPath, (data) ->
      saferworldChart = new @Barchart(data)
      _.map(data, (d) -> d.Average = parseInt(d.Average))
      data = _.sortBy(data, (d) -> d.Average)
      saferworldChart.setXDomain(data.map((d) -> d.Country))
      saferworldChart.setYDomain(d3.extent(data, (d) -> d.Average))
      saferworldChart.setValueKey('Average')
      saferworldChart.setGroupKey('Country')
      saferworldChart.render('.saferworld')
