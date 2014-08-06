class @Exporte extends @D3Graph
  constructor: (@data, @options = {}) ->
    @options = _.defaults(@options, { width: 900, height: 200, margin: {top: 40, right: 30, bottom: 150, left: 40} })

  setDataKey: (key='ruestung') ->
    @dataKey = key
  highlightTableForCountry: (d) ->
    $("#exporte-2013 tr.#{formatCountry(d.Country)}").addClass('active')
  unhighlightTableForCountry: (d) ->
    $("#exporte-2013 tr.#{formatCountry(d.Country)}").removeClass('active')
  draw: (data) ->
    graphGroup = @svgSelection.selectAll('g.graphs').data(data)
    graphGroup.enter().append('g').attr('transform', (d) => "translate(#{@xScale(d.Country)},0)").attr('class', 'graphs')
    graphGroup.exit().remove()

    bars = graphGroup.selectAll('rect').data((d) -> [d])
    bars.enter().append('rect')
    bars.exit().remove()
    bars.attr("y", (d) => @yScale(d[@dataKey]))
        .attr("height", (d) => @options.height - @yScale(d[@dataKey]))
        .attr("width", @xScale.rangeBand())
        .on('mouseover', @highlightTableForCountry)
        .on('mouseout', @unhighlightTableForCountry)
    @svgSelection.select('.axis.x')
    .selectAll("text")
    .attr("y", 0)
    .attr("x", 9)
    .attr("dy", ".35em")
    .attr("transform", "rotate(90)")
    .style("text-anchor", "start")
