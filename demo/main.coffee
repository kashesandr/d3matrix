el = d3.select('#matrix svg')
updateData = document.querySelector '#updateData'

onCellClick = (d)-> console.log 'click', d
onCellDblClick = (d)-> console.log 'dblclick', d
onMouseOver = (d)-> console.log 'mouseOver', d
onMouseOut = (d)-> console.log 'mouseOut', d

getRandomInt = (min,max)->
    Math.floor(Math.random() * (max - min + 1)) + min

getRandomData = ->
    [1..Math.pow(getRandomInt(2,10),2)]

update = ->
    el.datum(getRandomData()).call matrix

updateData.addEventListener 'click', update

matrix = window.KashMatrix()
matrix.dispatch
    .on('cellClick', onCellClick)
    .on('cellDblClick', onCellDblClick)
    .on('cellMouseOver', onMouseOver)
    .on('cellMouseOut', onMouseOut)
update()