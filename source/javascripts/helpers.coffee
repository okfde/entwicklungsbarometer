@magnitude = (n) ->
  order = Math.floor(Math.log(n) / Math.LN10)
  Math.pow(10,order)
