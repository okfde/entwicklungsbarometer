(function() {
  var changeDiffClass, formatCurrency,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  formatCurrency = locale_de_DE.numberFormat("$,.2f");

  this.formatCountry = function(countryString) {
    return countryString.replace(" ", "");
  };

  changeDiffClass = function(value) {
    if (value !== 0) {
      if (value > 0) {
        return "positive";
      } else {
        return "negative";
      }
    }
  };

  $(function() {
    var export2012_13Path, gesamt2013Path;
    if ($('#tables').length > 0) {
      export2012_13Path = rootPath + "/data/exporte_2012_2013.csv";
      gesamt2013Path = rootPath + "/data/gesamt_exporte_2013.csv";
      return queue().defer(d3.csv, export2012_13Path).defer(d3.csv, gesamt2013Path).await(function(error, data, gesamt) {
        var exporte, gesamt2013, gesamtRuestung2013, margin, notFreeTable, options, ruestung2012, ruestung2013, ruestungExporte2013, tBody, tHeadTr, trs, width;
        this.data = data;
        ruestung2013 = _.filter(this.data, function(num) {
          return num.ruestung > 0;
        });
        ruestung2013 = _.sortBy(ruestung2013, function(num) {
          return -num.ruestung;
        });
        gesamtRuestung2013 = _.reduce(ruestung2013, (function(sum, d) {
          return sum + parseInt(d.ruestung);
        }), 0);
        gesamt2013 = _.reduce(gesamt, (function(sum, d) {
          return sum + parseInt(d.ruestung);
        }), 0);
        ruestung2012 = _.filter(this.data, function(num) {
          var _ref;
          return _ref = num.Country, __indexOf.call(ruestung2013.map(function(d) {
            return d.Country;
          }), _ref) >= 0;
        });
        ruestung2012 = _.sortBy(ruestung2012, function(num) {
          return -num.ruestung;
        });
        d3.select('#ruestung .gesamt-ruestung').html(formatCurrency(gesamtRuestung2013));
        d3.select('#ruestung .gesamt').html(formatCurrency(gesamt2013));
        width = parseInt(d3.select('.ruestung-2013-chart').style('width'));
        margin = {
          top: 10,
          right: 30,
          bottom: 120,
          left: 40
        };
        options = {
          height: 300,
          width: width - 20,
          margin: margin
        };
        exporte = new Exporte(ruestung2013, options);
        exporte.setYDomain([
          0, d3.max(ruestung2013, function(d) {
            return parseInt(d.ruestung);
          })
        ]);
        exporte.setXDomain(ruestung2013.map(function(d) {
          return d.Country;
        }));
        exporte.setDataKey();
        exporte.render('.ruestung-2013-chart .chart');
        $('.ruestung-2013-chart form input').change(function(e) {
          if (this.value === '2012') {
            exporte.setDataKey('Ruestung_2012');
            exporte.setYDomain([
              0, d3.max(ruestung2012, function(d) {
                return parseInt(d.Ruestung_2012);
              })
            ]);
            return exporte.update(ruestung2012);
          } else {
            exporte.setDataKey('ruestung');
            exporte.setYDomain([
              0, d3.max(ruestung2013, function(d) {
                return parseInt(d.ruestung);
              })
            ]);
            return exporte.update(ruestung2013);
          }
        });
        ruestungExporte2013 = d3.select('#exporte-2013').append('table');
        ruestungExporte2013.attr('class', 'table-borders');
        tHeadTr = ruestungExporte2013.append('thead').append('tr');
        tHeadTr.append('th').text('Land');
        tHeadTr.append('th').text('2013');
        tHeadTr.append('th').text('Differenz zu 2012');
        tBody = ruestungExporte2013.append('tbody');
        trs = tBody.selectAll('tr').data(ruestung2013);
        trs.enter().append('tr').attr('class', function(d) {
          return formatCountry(d.Country);
        });
        trs.append('td').text(function(d) {
          return d.Country;
        });
        trs.append('td').text(function(d) {
          return formatCurrency(d.ruestung);
        });
        trs.append('td').text(function(d) {
          return formatCurrency(d.ruestung - d.Ruestung_2012);
        }).attr('class', function(d) {
          return changeDiffClass(d.ruestung - d.Ruestung_2012);
        });
        notFreeTable = d3.select('#all-exports').append('table');
        notFreeTable.attr('class', 'table-borders');
        tHeadTr = notFreeTable.append('thead').append('tr');
        tHeadTr.append('th').text('Land');
        tHeadTr.append('th').text('Exporte 2013');
        tHeadTr.append('th').text('Rüstungsexporte 2013');
        tHeadTr.append('th').text('Differenz Gesamtexporte zu 2012');
        tHeadTr.append('th').text('Differenz Rüstungsexporte zu 2012');
        tBody = notFreeTable.append('tbody');
        trs = tBody.selectAll('tr').data(this.data);
        trs.enter().append('tr');
        trs.append('td').text(function(d) {
          return d.Country;
        });
        trs.append('td').text(function(d) {
          return formatCurrency(d.gesamt);
        });
        trs.append('td').text(function(d) {
          return formatCurrency(d.ruestung);
        });
        trs.append('td').text(function(d) {
          return formatCurrency(d.gesamt - d.Gesamt_2012);
        }).attr('class', function(d) {
          return changeDiffClass(d.gesamt - d.Gesamt_2012);
        });
        return trs.append('td').text(function(d) {
          return formatCurrency(d.ruestung - d.Ruestung_2012);
        }).attr('class', function(d) {
          return changeDiffClass(d.ruestung - d.Ruestung_2012);
        });
      });
    }
  });

}).call(this);
