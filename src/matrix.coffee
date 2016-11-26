window.KashMatrix = () ->

    # Public
    margin = top: 10, right: 10, bottom: 10, left: 10
    width = null
    height = null
    getCellColor = ->
        '#ffffff'
    #d3.scale.category20().range()
    xScale = d3.scaleBand()
    yScale = d3.scaleBand()
    dispatch = d3.dispatch(
        'renderEnd', 'cellClick', 'cellDblClick', 'cellMouseOver', 'cellMouseOut'
    )
    transitionDuration = 500
    noData = 'No data provided.'
    #state = todo: add a state

    chart = (selection) ->
        selection.each (data) ->
            container = d3.select(this)

            chart.container = this

            # Display noData message if there's nothing to show.
            if data?.length
                container.selectAll('.noData').remove()
            else
                container.selectAll('g').remove()
                noDataText = container.selectAll('.no-data').data([noData])
                noDataText.enter().append('text').attr('class', 'no-data').attr('dy', '-.7em').style 'text-anchor', 'middle'
                noDataText.attr('x', margin.left + width / 2).attr('y', margin.top + width / 2).text (d) -> d
                return chart

            chart.update = ->
                if transitionDuration isnt 0
                    container.transition().duration transitionDuration
                container.call chart
                return

            sideLength = Math.ceil Math.sqrt data.length
            range = d3.range sideLength
            xScale.domain range
            yScale.domain range

            _getY = (i)-> Math.floor i / sideLength

            getCellX = (d, i) ->
                x = null
                if i < sideLength
                    x = i
                else
                    y = _getY i
                    x = i - sideLength * y
                xScale x

            getCellY = (d, i) ->
                yScale _getY i

            # Calculate width/height of the matrix
            # which is based automatically on the container width.
            availableWidth = (width or parseInt(container.style 'width') or 400) \
                - margin.left - margin.right
            availableHeight = (height or parseInt(container.style 'height') or 400) \
                - margin.top - margin.bottom

            container
                .attr('height', availableHeight + margin.top + margin.bottom)
                .attr('width', availableWidth + margin.left + margin.right)

            xScale.rangeRound([0, availableWidth]).domain range
            yScale.rangeRound([0, availableHeight]).domain range

            cellHeight = yScale.bandwidth()
            cellWidth = xScale.bandwidth()

            wrap = container
                .selectAll('g.matrix')
                .data([data])
                .enter().append('g')
                .attr('class', 'wrapper matrix chart').append('g')
                .attr 'transform', 'translate(' + margin.left + ',' + margin.top + ')'

            backgroundWrap = wrap
                .append('rect')
                .attr 'class', 'background'
                .attr('width', availableWidth)
                .attr('height', availableHeight)

            cellsWrap = wrap
                .append('g')
                .attr 'class', 'cells'

            cell = cellsWrap.selectAll('.cell').data(data)

            # update
            cell
                .attr('width', cellWidth)
                .attr('height', cellHeight)
                .style('fill', getCellColor)
                .transition()
                .duration(transitionDuration)
                .attr('x', getCellX)
                .attr('y', getCellY)

            # exit
            cell.exit().remove()

            # enter
            cell.enter()
                .append('rect')
                .classed('cell', true)
                .attr('height', cellHeight)
                .attr('width', cellWidth)
                .attr('x', getCellX)
                .attr('y', getCellY)
                .style('fill', getCellColor)
                .on('click', (d)-> dispatch.call('cellClick', @, d))
                .on('dblclick', (d)-> dispatch.call('cellDblClick', @, d))
                .on('mouseover', (d)-> dispatch.call('cellMouseOver', @, d))
                .on('mouseout', (d)-> dispatch.call('cellMouseOut', @, d))

    chart.xScale = xScale
    chart.yScale = yScale
    chart.dispatch = dispatch

    chart.width = (_) ->
        if !arguments.length
            return width
        width = _
        chart

    chart.height = (_) ->
        if !arguments.length
            return height
        height = _
        chart

    chart.margin = (_) ->
        if !arguments.length
            return margin
        margin.top = if typeof _.top != 'undefined' then _.top else margin.top
        margin.right = if typeof _.right != 'undefined' then _.right else margin.right
        margin.bottom = if typeof _.bottom != 'undefined' then _.bottom else margin.bottom
        margin.left = if typeof _.left != 'undefined' then _.left else margin.left
        chart

    chart.cellColor = (_) ->
        # todo: update
        if !arguments.length
            return cellColor
        cellColor = _
        chart

    chart.transitionDuration = (_) ->
        if !arguments.length
            return transitionDuration
        transitionDuration = _
        chart

    chart.noData = (_) ->
        if !arguments.length
            return noData
        noData = _
        chart

    chart
