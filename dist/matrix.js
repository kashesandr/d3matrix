(function(window){
"use strict";
window.Matrix = function() {
  var chart, dispatch, getCellColor, height, margin, noData, transitionDuration, width, xScale, yScale;
  margin = {
    top: 10,
    right: 10,
    bottom: 10,
    left: 10
  };
  width = null;
  height = null;
  getCellColor = function() {
    return '#ffffff';
  };
  xScale = d3.scale.ordinal();
  yScale = d3.scale.ordinal();
  dispatch = d3.dispatch('renderEnd', 'cellClick', 'cellDblClick', 'cellMouseOver', 'cellMouseOut');
  transitionDuration = 500;
  noData = 'No data provided.';
  chart = function(selection) {
    return selection.each(function(data) {
      var _getY, availableHeight, availableWidth, backgroundWrap, cell, cellHeight, cellWidth, cellsWrap, container, g, gEnter, getCellX, getCellY, noDataText, range, sideLength, wrap;
      container = d3.select(this);
      chart.container = this;
      chart.update = function() {
        if (transitionDuration !== 0) {
          container.transition().duration(transitionDuration);
        }
        container.call(chart);
      };
      sideLength = Math.ceil(Math.sqrt(data.length));
      range = d3.range(sideLength);
      xScale.domain(range);
      yScale.domain(range);
      _getY = function(i) {
        return Math.floor(i / sideLength);
      };
      getCellX = function(d, i) {
        var x, y;
        x = null;
        if (i < sideLength) {
          x = i;
        } else {
          y = _getY(i);
          x = i - sideLength * y;
        }
        return xScale(x);
      };
      getCellY = function(d, i) {
        return yScale(_getY(i));
      };
      availableWidth = (width || parseInt(container.style('width')) || 400) - margin.left - margin.right;
      availableHeight = (height || parseInt(container.style('height')) || 400) - margin.top - margin.bottom;
      xScale.rangeBands([0, availableWidth]).domain(range);
      yScale.rangeBands([0, availableHeight]).domain(range);
      cellHeight = yScale.rangeBand();
      cellWidth = xScale.rangeBand();
      if (data != null ? data.length : void 0) {
        container.selectAll('.noData').remove();
      } else {
        container.selectAll('g').remove();
        noDataText = container.selectAll('.no-data').data([noData]);
        noDataText.enter().append('text').attr('class', 'no-data').attr('dy', '-.7em').style('text-anchor', 'middle');
        noDataText.attr('x', margin.left + width / 2).attr('y', margin.top + width / 2).text(function(d) {
          return d;
        });
        return chart;
      }
      wrap = container.selectAll('g.matrix').data([data]);
      gEnter = wrap.enter().append('g').attr('class', 'wrapper matrix chart').append('g');
      g = wrap.select('g');
      gEnter.append('rect').attr('class', 'background');
      gEnter.append('g').attr('class', 'cells');
      backgroundWrap = wrap.select('.background').attr('width', availableWidth).attr('height', availableHeight);
      cellsWrap = wrap.select('.cells');
      wrap.attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');
      container.style({
        'height': availableHeight + margin.top + margin.bottom + 'px',
        'width': availableWidth + margin.left + margin.right + 'px'
      });
      cell = void 0;
      chart.render = function() {
        cell = cellsWrap.selectAll('.cell').data(data, function(d, i) {
          if (d.id != null) {
            return d.id;
          } else {
            return i;
          }
        });
        cell.attr({
          width: cellWidth,
          height: cellHeight
        }).style({
          'fill': getCellColor
        }).transition().duration(transitionDuration).attr({
          'x': getCellX,
          'y': getCellY
        });
        cell.enter().append('rect').classed({
          'cell': true
        }).transition().duration(transitionDuration).attr({
          'width': cellWidth,
          'height': cellHeight,
          'x': getCellX,
          'y': getCellY
        }).style({
          'fill': getCellColor
        });
        return cell.exit().remove();
      };
      chart.render();
      cell.on('click', dispatch.cellClick).on('dblclick', dispatch.cellDblClick);
      return cell.on('mouseover', dispatch.cellMouseOver).on('mouseout', dispatch.cellMouseOut);
    });
  };
  chart.xScale = xScale;
  chart.yScale = yScale;
  chart.dispatch = dispatch;
  chart.width = function(_) {
    if (!arguments.length) {
      return width;
    }
    width = _;
    return chart;
  };
  chart.height = function(_) {
    if (!arguments.length) {
      return height;
    }
    height = _;
    return chart;
  };
  chart.margin = function(_) {
    if (!arguments.length) {
      return margin;
    }
    margin.top = typeof _.top !== 'undefined' ? _.top : margin.top;
    margin.right = typeof _.right !== 'undefined' ? _.right : margin.right;
    margin.bottom = typeof _.bottom !== 'undefined' ? _.bottom : margin.bottom;
    margin.left = typeof _.left !== 'undefined' ? _.left : margin.left;
    return chart;
  };
  chart.cellColor = function(_) {
    var cellColor;
    if (!arguments.length) {
      return cellColor;
    }
    cellColor = _;
    return chart;
  };
  chart.transitionDuration = function(_) {
    if (!arguments.length) {
      return transitionDuration;
    }
    transitionDuration = _;
    return chart;
  };
  chart.noData = function(_) {
    if (!arguments.length) {
      return noData;
    }
    noData = _;
    return chart;
  };
  return chart;
};

})(window);