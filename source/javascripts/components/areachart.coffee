class @AreaChart extends @D3Linechart
  constructor: (@data, @options = {}) ->
    super(@data, @options)

  stack: ->
    d3.layout.stack()
    .values( (d) -> d.values )
  area: ->
    d3.svg.area().x((d) =>
      @xScale(d.date)
    ).y0((d) =>
      @yScale(d.y0)
    ).y1((d) =>
      @yScale(d.y0 + d.y)
    )

  color: ->
    d3.scale.category20().domain(["civic","military"])

  draw: (data) =>
    zmf = @svgSelection.selectAll(".zmf")
      .data(@stack()(@data))
      .enter()
      .append("g")
      .attr("class", "zmf")
    zmf.append("path").attr("class", "area").attr("d", (d) =>
      @area()(d.values)
    ).style "fill", (d) =>
      @color()(d.name)

  setVoronoi: ->
    @voronoi = d3.geom.voronoi()
      .x((d) =>
        @xScale(d[@dateKey]))
      .y((d) =>
        @yScale(d.y0 + d.y))
      .clipExtent([
        [-@options.margin.left, -@options.margin.top],
        [@options.width + @options.margin.right, @options.height + @options.margin.bottom]
      ])

  setVoronoiData: ->
    @voronoiData = _.flatten(@data.map( (d) -> d.values))

  mouseout: (d) =>
    @focus.attr("transform", "translate(-100,-100)")

  mouseover: (d) =>
    @focus.attr("transform", "translate(#{@xScale(d[@dateKey])},#{@yScale(d.y + d.y0)})")
    @focus.select("text").text("$#{Math.round(d[@dataKey])} Mio").attr("text-anchor","middle")
