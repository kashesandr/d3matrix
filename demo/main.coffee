el = d3.select('#matrix svg')

onCellClick = (d)-> console.log 'click', d
onCellDblClick = (d)-> console.log 'dblclick', d
onMouseOver = (d)-> console.log 'mouseOver', d
onMouseOut = (d)-> console.log 'mouseOut', d

matrix = window.KashMatrix()
matrix.dispatch
    .on('cellClick', onCellClick)
    .on('cellDblClick', onCellDblClick)
    .on('cellMouseOver', onMouseOver)
    .on('cellMouseOut', onMouseOut)

el.datum([0..99]).call(matrix)