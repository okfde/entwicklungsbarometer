class @PointGraph extends @D3Graph
  constructor: (@data, @options = {}) ->
    @options = _.defaults(@options, {
      width: 900
      height: 350
      margin:
        {
          top: 40
          right: 30
          bottom: 10
          left: 40
        }
      circles: {
        radius: 12
        padding: 10
      }
    })
    @value1Key = "key1"
    @value2Key = "key2"
    @valueClass1 = "value-1"
    @valueClass2 = "value-2"

  setValueKeys: (value1, value2) ->
    @value1Key = value1
    @value2Key = value2

  setValueClasses: (valueClasses) ->
    @valueClasses = valueClasses

  valueClasss: (d,i) =>
    for value in @valueClasses
      if i in value.range
        className = value.className
    className

  draw: (data) ->
    data = (data[0] for num in [data[0][@value1Key]..1])
    teiler = Math.floor(@options.width/(2*@options.circles.radius + @options.circles.padding))
    graphGroup = @svgSelection.selectAll('g.multiples').data(data)
    graphGroup.enter().append("g")
    graphGroup
      .attr("class", "multiples")
      .attr("transform", (d,i) =>
        translateX = (i % teiler)*(2*@options.circles.radius+@options.circles.padding)
        translateY = @options.height - (Math.ceil((i+1) / teiler)*(@options.circles.padding+2*@options.circles.radius))
        "translate(#{translateX},#{translateY})"
      )
    graphGroup.selectAll("circle").remove()
    graphGroup
      .append("circle")
      .attr("r",@options.circles.radius)
      .attr("class",@valueClasss)
    graphGroup.exit().remove()

  render: (@element) ->
    @createSvg()
    @draw(@data)

  update: (@data) ->
    @draw(@data)
