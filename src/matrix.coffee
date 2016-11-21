window.Matrix = () ->

    # Public
    margin = top: 10, right: 10, bottom: 10, left: 10
    width = null
    height = null
    getCellColor = ->
        '#ffffff'
        #d3.scale.category20().range()
    xScale = d3.scale.ordinal()
    yScale = d3.scale.ordinal()
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
                    x = i - sideLength*y
                xScale x

            getCellY = (d, i) ->
                yScale _getY i
            
            # Calculate width/height of the matrix
            # which is based automatically on the container width.
            availableWidth = (width or parseInt(container.style 'width') or 400) \
                - margin.left - margin.right
            availableHeight = (height or parseInt(container.style 'height') or 400) \
                - margin.top - margin.bottom

            xScale.rangeBands([0, availableWidth]).domain range
            yScale.rangeBands([0, availableHeight]).domain range

            cellHeight = yScale.rangeBand()
            cellWidth = xScale.rangeBand()

            # Display noData message if there's nothing to show.
            if data?.length
                container.selectAll('.noData').remove()
            else
                container.selectAll('g').remove()
                noDataText = container.selectAll('.no-data').data([ noData ])
                noDataText.enter().append('text').attr('class', 'no-data').attr('dy', '-.7em').style 'text-anchor', 'middle'
                noDataText.attr('x', margin.left + width / 2).attr('y', margin.top + width / 2).text (d) -> d
                return chart

            wrap = container.selectAll('g.matrix').data([ data ])
            gEnter = wrap.enter().append('g').attr('class', 'wrapper matrix chart').append('g')
            g = wrap.select('g')
            gEnter.append('rect').attr 'class', 'background'
            gEnter.append('g').attr 'class', 'cells'
            backgroundWrap = wrap.select('.background').attr('width', availableWidth).attr('height', availableHeight)
            cellsWrap = wrap.select('.cells')
            wrap.attr 'transform', 'translate(' + margin.left + ',' + margin.top + ')'
            container.style(
                'height': availableHeight + margin.top + margin.bottom + 'px'
                'width': availableWidth + margin.left + margin.right + 'px'
            )

            # Draw main elements
            cell = undefined

            chart.render = () ->
                cell = cellsWrap.selectAll('.cell').data(
                    data,
                    (d, i) -> if d.id? then d.id else i
                )

                # update
                cell
                .attr( width: cellWidth, height: cellHeight )
                .style( 'fill': getCellColor )
                .transition()
                .duration(transitionDuration)
                .attr( 'x': getCellX, 'y': getCellY )

                # enter
                cell.enter()
                .append('rect')
                .classed( 'cell': true )
                .transition()
                .duration(transitionDuration)
                .attr(
                    'width': cellWidth, 'height': cellHeight,
                    'x': getCellX, 'y': getCellY
                )
                .style( 'fill': getCellColor )

                # exit
                cell.exit().remove()

            chart.render()

            cell.on('click', dispatch.cellClick)
                .on 'dblclick', dispatch.cellDblClick
            cell.on('mouseover', dispatch.cellMouseOver)
                .on 'mouseout', dispatch.cellMouseOut

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
