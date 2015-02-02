valueClassesForData = (data) ->
  [
    {
      range: [928-data...928]
      className: "german-exports-gdp"
    } ]
wertschoepfungPerYear = (data,year="2013") ->
  _.findWhere(data, { year: year })
$ ->
  if $('#german-gdp').length > 0
    gdpPath = rootPath+"/data/security/gdp/wertschoepfung-magnitudes.csv"
    d3.csv gdpPath, (data) ->
      data = wertschoepfungPerYear(data, "2011")
      options = { height:750, circles: { radius: 6, padding: 5 } }
      pointGraph = new PointGraph([data], options)
      pointGraph.setValueClasses(valueClassesForData(data["GDP.Ruestung"]))
      pointGraph.setValueKeys("GDP","GDP.Ruestung")
      pointGraph.render(".german-gdp")
