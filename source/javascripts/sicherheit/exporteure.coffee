$ ->
  if $('#exporteure').length > 0
    layerUrl = 'http://frerichs.cartodb.com/api/v2/viz/7ac9ec4e-1d50-11e4-9308-0edbca4b5057/viz.json'
    cartodb.createVis("exporteure-map", layerUrl,
      tiles_loader: true
      center_lat: 51.27
      center_lon: 10.84
      zoom: 6
    ).done((vis, layers) ->
      subLayer = layers[1].getSubLayer(0)
      layers[1].setInteraction(true)
      layers[1].on 'featureOver', (e, latlng, pos, data, layerNumber) ->
        cartodb.log.log(e, latlng, pos, data, layerNumber)
      vis.addOverlay({
        type: 'tooltip',
        position: 'top|center',
        template: '<p>{{name_to_display}}</p>'
      })
      return
    ).error (err) ->
      console.log err
      return
