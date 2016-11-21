el = d3.select('#matrix svg')

onCellClick = (e, d)-> console.log 'click', e, d
onMouseOver = (e, d)-> console.log 'mouseOver', e,d
onMouseOut = (e, d)-> console.log 'mouseOut', e,d

matrix = window.Matrix()
matrix.dispatch
    .on('cellClick', onCellClick)
    .on('cellMouseOver', onMouseOver)
    .on('cellMouseOut', onMouseOut)

el.datum([0..99]).call(matrix)