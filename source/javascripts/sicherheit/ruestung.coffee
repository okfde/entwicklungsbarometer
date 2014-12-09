formatCurrency = d3.numberFormat("$,.2f")

@formatCountry = (countryString) ->
  countryString.replace(" ","")


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
    .await (error, @data, gesamt, exporte2013, freedomIndexExports) ->
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

