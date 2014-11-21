formatCurrency = d3.numberFormat("$,.2f")

@formatCountry = (countryString) ->
  countryString.replace(" ","")

getGesamtExportsFreeAndNotFree = (data) ->
  not_free_data = _.filter(data, (d) -> d.status == "NF")
  free_data = _.filter(data, (d) -> d.status == "F")
  partial_free_data = _.filter(data, (d) -> d.status == "PF")
  not_free_ruestung = _.reduce(not_free_data,((sum, d) -> return sum + parseInt(d.ruestung)), 0)
  free_ruestung = _.reduce(free_data,((sum, d) -> return sum + parseInt(d.ruestung)), 0)
  partial_free_ruestung = _.reduce(partial_free_data,((sum, d) -> return sum + parseInt(d.ruestung)), 0)
  all_ruestung = _.reduce(data,((sum, d) -> return sum + parseInt(d.ruestung)), 0)
  { not_free: not_free_ruestung, all: all_ruestung, free: free_ruestung, partial_free: partial_free_ruestung }

getNumberReducedByMagnitude = (number, magnitude) ->
  Math.ceil(number/magnitude)

generateDataForLargeMultipleFreeNotFreeRuestung = (data) ->
  freeNotFreeObject = getGesamtExportsFreeAndNotFree(data)
  freeNotFreeArray = [freeNotFreeObject.not_free, freeNotFreeObject.all, freeNotFreeObject.partial_free_ruestung, freeNotFreeObject.free]
  magnitudeFreeNotFree = magnitude(d3.min(freeNotFreeArray))
  freeNotFreeObject.not_free = getNumberReducedByMagnitude(freeNotFreeObject.not_free, magnitudeFreeNotFree)*5
  freeNotFreeObject.all = getNumberReducedByMagnitude(freeNotFreeObject.all, magnitudeFreeNotFree)*5
  freeNotFreeObject.free = getNumberReducedByMagnitude(freeNotFreeObject.free, magnitudeFreeNotFree)*5
  freeNotFreeObject.partial_free = getNumberReducedByMagnitude(freeNotFreeObject.partial_free, magnitudeFreeNotFree)*5
  freeNotFreeObject
changeDiffClass = (value) ->
  if value != 0
    if value > 0 then "positive" else "negative"
$ ->
  if $('#ruestung').length > 0
    export2012_13Path = rootPath+"/data/exporte_2012_2013.csv"
    gesamt2013Path = rootPath+"/data/gesamt_exporte_2013.csv"
    exporte2013Path = rootPath+"/data/exporte_2013.csv"
    queue()
    .defer(d3.csv, export2012_13Path)
    .defer(d3.csv, gesamt2013Path)
    .defer(d3.csv, exporte2013Path)
    .await (error, @data, gesamt, exporte2013) ->
      ruestung2013 = _.filter(@data,(num) -> num.ruestung > 0)
      ruestung2013 = _.sortBy(ruestung2013, (num) -> -num.ruestung)
      gesamtRuestung2013 = _.reduce(ruestung2013,((sum, d) -> return sum + parseInt(d.ruestung)), 0)
      gesamt2013 = _.reduce(gesamt,((sum, d) -> return sum + parseInt(d.ruestung)), 0)
      ruestung2012 = _.filter(@data, (num) -> num.Country in (ruestung2013.map((d) -> d.Country)))
      ruestung2012 = _.sortBy(ruestung2012, (num) -> -num.ruestung)

      d3.select('#ruestung .gesamt-ruestung').html(formatCurrency(gesamtRuestung2013))
      d3.select('#ruestung .gesamt').html(formatCurrency(gesamt2013))

      width = parseInt(d3.select('.ruestung-2013-chart').style('width'))
      margin = {top: 10, right: 30, bottom: 120, left: 40}
      options = { height: 300, width: width - 20 , margin: margin }

      exporte = new Exporte(ruestung2013, options)
      exporte.setYDomain([0, d3.max(ruestung2013, (d) -> parseInt(d.ruestung) )])
      exporte.setXDomain(ruestung2013.map((d) -> d.Country))
      exporte.setDataKey()
      exporte.render('.ruestung-2013-chart .chart')
      $('.ruestung-2013-chart form input').change (e) ->
        if(this.value == '2012')
          exporte.setDataKey('Ruestung_2012')
          exporte.setYDomain([0, d3.max(ruestung2012, (d) -> parseInt(d.Ruestung_2012) )])
          exporte.update(ruestung2012)
        else
          exporte.setDataKey('ruestung')
          exporte.setYDomain([0, d3.max(ruestung2013, (d) -> parseInt(d.ruestung) )])
          exporte.update(ruestung2013)

      ruestungExporte2013 = d3.select('#exporte-2013').append('table')
      ruestungExporte2013.attr('class','table-borders')
      tHeadTr = ruestungExporte2013.append('thead').append('tr')
      tHeadTr.append('th').text('Land')
      tHeadTr.append('th').text('2013')
      tHeadTr.append('th').text('Differenz zu 2012')
      tBody = ruestungExporte2013.append('tbody')
      trs = tBody.selectAll('tr').data(ruestung2013)
      trs.enter().append('tr').attr('class', (d) -> formatCountry(d.Country))
      trs.append('td').text((d) -> d.Country)
      trs.append('td').text((d) -> formatCurrency(d.ruestung))
      trs.append('td').text((d) -> formatCurrency(d.ruestung - d.Ruestung_2012)).attr('class', (d) -> changeDiffClass(d.ruestung - d.Ruestung_2012))

      notFreeTable = d3.select('#all-exports').append('table')
      notFreeTable.attr('class','table-borders')
      tHeadTr = notFreeTable.append('thead').append('tr')
      tHeadTr.append('th').text('Land')
      tHeadTr.append('th').text('Exporte 2013')
      tHeadTr.append('th').text('Rüstungsexporte 2013')
      tHeadTr.append('th').text('Differenz Gesamtexporte zu 2012')
      tHeadTr.append('th').text('Differenz Rüstungsexporte zu 2012')
      tBody = notFreeTable.append('tbody')
      trs = tBody.selectAll('tr').data(@data)
      trs.enter().append('tr')

      trs.append('td').text((d) -> d.Country)
      trs.append('td').text((d) -> formatCurrency(d.gesamt))
      trs.append('td').text((d) -> formatCurrency(d.ruestung))
      trs.append('td').text((d) -> formatCurrency(d.gesamt - d.Gesamt_2012)).attr('class', (d) -> changeDiffClass(d.gesamt - d.Gesamt_2012))
      trs.append('td').text((d) -> formatCurrency(d.ruestung - d.Ruestung_2012)).attr('class', (d) -> changeDiffClass(d.ruestung - d.Ruestung_2012))
      multiplesData = generateDataForLargeMultipleFreeNotFreeRuestung(exporte2013)
      multipleOptions = { height: 100, circles: { radius: 8, padding: 5 } }
      lm_free = new @LargeMultiples([multiplesData], multipleOptions)
      lm_free.setValueKeys("all","free")
      lm_free.render("#multiples #free")
      lm_not_free = new @LargeMultiples([multiplesData], multipleOptions)
      lm_not_free.setValueKeys("all","not_free")
      lm_not_free.render("#multiples #not_free")
      lm_partial_free = new @LargeMultiples([multiplesData], multipleOptions)
      lm_partial_free.setValueKeys("all","partial_free")
      lm_partial_free.render("#multiples #partial_free")
      $('#multiples form input').change (e) ->
        if(this.value == 'f')
          lm.setValueKeys("all","free")
          lm.render([multiplesData])
        else if(this.value == 'pf')
          lm.setValueKeys("all","partial_free")
          lm.render([multiplesData])
        else
          lm.setValueKeys("all","not_free")
          lm.render([multiplesData])


