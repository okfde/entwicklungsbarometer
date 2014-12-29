$ ->
  if $('#friedensfoerderung').length > 0
    civilMilitaryPath = "#{rootPath}/data/security/friedensfoerderung/military-civil-germany.csv"
    d3.csv civilMilitaryPath, (data) ->
      data.forEach (d) ->
        d.year = new Date(d.year,0,1)
      stackedData = ["civil","military"].map (name) ->
        {
          name: name
          values: data.map (d) ->
            { date: d.year, y: parseFloat(d[name]) }
        }
      options = { width: $('.zmf').width(), height: 300, margin: { top: 40, right: 50, left: 50, bottom: 20 } }
      chart = new @AreaChart(stackedData, options)
      chart.setYDomain([0, d3.max(data, (d) -> parseFloat(d.military) + parseFloat(d.civil) )])
      chart.setXDomain(d3.extent(data, (d) -> d.year ))
      chart.setDateKey("date")
      chart.setDataKey("y")
      chart.render(".zmf")
