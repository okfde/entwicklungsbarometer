formatCurrency = d3.numberFormat(",")

getNumberReducedByMagnitude = (number, magnitude) ->
  Math.round(number/magnitude)

generateDataForLargeMultipleFreeNotFreeRuestung = (data, year, multiplokator=15) ->
  freedomIndexObject = _.findWhere(data, { time: year })
  freeNotFreeArray = [parseInt(freedomIndexObject.not_free), parseInt(freedomIndexObject.sum), parseInt(freedomIndexObject.partial_free), parseInt(freedomIndexObject.free)]
  magnitudeFreeNotFree = magnitude(d3.min(freeNotFreeArray))
  freedomIndexObject.not_free = getNumberReducedByMagnitude(freedomIndexObject.not_free, magnitudeFreeNotFree)*multiplokator
  freedomIndexObject.sum = getNumberReducedByMagnitude(freedomIndexObject.sum, magnitudeFreeNotFree)*multiplokator
  freedomIndexObject.free = getNumberReducedByMagnitude(freedomIndexObject.free, magnitudeFreeNotFree)*multiplokator
  freedomIndexObject.partial_free = getNumberReducedByMagnitude(freedomIndexObject.partial_free, magnitudeFreeNotFree)*multiplokator
  freedomIndexObject

valueClassesForData = (data) ->
  [
    {
      range: [0...data.free]
      className: "free"
    },
    {
      range: [data.free...(data.free+data.partial_free)]
      className: "partial-free"
    },
    {
      range: [(data.free+data.partial_free)...data.sum]
      className: "not-free"
    }
  ]

@drawFreedomIndexPointVisualization = (data) ->
  sumAllTime= _.findWhere(data, { time: "all" }).sum
  sum2013 = _.findWhere(data, { time: "2013" }).sum
  generateDataForLargeMultipleFreeNotFreeRuestung(data, "all", 15)
  multiplesData = generateDataForLargeMultipleFreeNotFreeRuestung(data, "2013", 5)
  multipleOptions = { height: 100, circles: { radius: 8, padding: 5 } }
  largeMultiple = new @LargeMultiples([multiplesData], multipleOptions)
  largeMultiple.setValueKeys("sum","free")

  largeMultiple.setValueClasses(valueClassesForData(multiplesData))
  largeMultiple.render("#multiples #multiple-exports")
  $('.export-volumes h2').text("$#{formatCurrency(sum2013)}")

  $('#multiples form input').change (e) ->
    if(this.value == 'all')
      multiplesData = _.findWhere(data, { time: 'all' })
      largeMultiple.setValueClasses(valueClassesForData(multiplesData))
      largeMultiple.update([multiplesData])
      $('.export-volumes h2').text("$#{formatCurrency(sumAllTime)}")
    else
      multiplesData = _.findWhere(data, { time: '2013' })
      largeMultiple.setValueClasses(valueClassesForData(multiplesData))
      largeMultiple.update([multiplesData])
      $('.export-volumes h2').text("$#{formatCurrency(sum2013)}")

$ ->
  if $('#freedom-index').length > 0
    freedomIndexExportsPath = rootPath+"/data/freedom_index_exports.csv"
    d3.csv freedomIndexExportsPath, (data) ->
      @drawFreedomIndexPointVisualization(data)
