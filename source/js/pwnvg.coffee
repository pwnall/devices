# Wraps a SVG element.
class Pwnvg
  # Creates a SVG element inside a container.
  #
  # @param svgContainer a DOM element that will receive the new SVG element
  # @param minX left of the SVG coordinate system
  # @param maxX right of the SVG coordinate system
  # @param minY top of the SVG coordinate system
  # @param maxY bottom of the SVG coordinate system
  constructor: (@minX, @minY, @maxX, @maxY) ->
    @svg = document.createElementNS 'http://www.w3.org/2000/svg', 'svg'
    @svg.setAttribute 'version', '1.2'
    @svg.setAttribute 'viewBox',
                      "#{@minX} #{@minY} #{@maxX - @minX} #{@maxY - @minY}"
    @svg.setAttribute 'preserveAspectRatio', 'xMidYMid meet'

  # Creates a path inside the SVG element.
  path: (pathData) ->
    dom = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
    dom.setAttribute 'd', pathData.toString()
    @svg.appendChild dom
    new PwnvgElement dom

  # Creates a rectangle inside the SVG element.
  rect: (x1, y1, x2, y2) ->
    [x2, x1] = [x1, x2] if x1 > x2
    [y2, y1] = [y1, y2] if y1 > y2
    dom = document.createElementNS 'http://www.w3.org/2000/svg', 'rect'
    dom.setAttribute 'x', x1
    dom.setAttribute 'y', y1
    dom.setAttribute 'width', x2 - x1
    dom.setAttribute 'height', y2 - y1
    @svg.appendChild dom
    new PwnvgElement dom

  # Creates a circle inside the SVG element.
  circle: (x, y, r) ->
    dom = document.createElementNS 'http://www.w3.org/2000/svg', 'circle'
    dom.setAttribute 'cx', x
    dom.setAttribute 'cy', y
    dom.setAttribute 'r', r
    @svg.appendChild dom
    new PwnvgElement dom

  # @return {SVGElement} the wrapped SVG element
  svg: null

  # Helper for building a path data string.
  #
  # @return a new PwnvgPathBuilder instance
  @path: ->
    new PwnvgPathBuilder()

  # Creates a rounded rectangle inside the SVG element.
  roundedRect: (x1, y1, x2, y2, radius) ->
    [x2, x1] = [x1, x2] if x1 > x2
    [y2, y1] = [y1, y2] if y1 > y2
    @path Pwnvg.path().
        moveTo(x1, y1 + radius).
        arcTo(x1 + radius, y1, radius, radius, 0, false, true).
        lineTo(x2 - radius, y1).
        arcTo(x2, y1 + radius, radius, radius, 0, false, true).
        lineTo(x2, y2 - radius).
        arcTo(x2 - radius, y2, radius, radius, 0, false, true).
        lineTo(x1 + radius, y2).
        arcTo(x1, y2 - radius, radius, radius, 0, false, true).
        close()

# Wraps a SVG element like a path.
class PwnvgElement
  # Creates a wrapper around a SVG DOM element.
  constructor: (@dom) ->

  # True if the element's class list includes the given argument.
  hasClass: (klass) ->
    @dom.classList.contains klass

  # Adds a class to the element's class list.
  #
  # @return the element to facilitate method chaining
  addClass: (klass) ->
    @dom.classList.add klass
    @

  # Removes a class from the element's class list.
  #
  # @return the element to facilitate method chaining
  removeClass: (klass) ->
    @dom.classList.remove klass
    @

  # Sets the element's id.
  #
  # @return the element to facilitate method chaining
  id: (newId) ->
    @dom.id = newId
    @

  # Removes the element from the SVG.
  #
  # @return the element to facilitate method chaining
  remove: ->
    @dom.parentNode.removeChild @dom
    @

  # Moves the element above all the other elements in its container.
  moveToTop: ->
    parent = @dom.parentNode
    parent.removeChild @dom
    parent.appendChild @dom
    @

  # Moves the element below all the other elements in its container.
  moveToBottom: ->
    parent = @dom.parentNode
    parent.removeChild @dom
    parent.insertBefore @dom, parent.firstChild
    @

  # Sets the element's fill color.
  fill: (colorSpec) ->
    @dom.setAttribute 'fill', colorSpec
    @

  # Sets the element's stroke color.
  stroke: (colorSpec) ->
    @dom.setAttribute 'stroke', colorSpec
    @

  # Sets the element's stroke width.
  strokeWidth: (width) ->
    @dom.setAttribute 'stroke-width', width.toString()
    @

  # Indicates that the stroke width is expressed in screen coordinates.
  nonScalingStroke: ->
    @dom.setAttribute 'vector-effect', 'non-scaling-stroke'
    @

  # Indicates that the stroke width is expressed in drawing coordinates.
  scalingStroke: ->
    @dom.removeAttribute 'vector-effect', 'non-scaling-stroke'
    @


# Builder for path data strings.
class PwnvgPathBuilder
  # Creates an empty path.
  constructor: ->
    @command = []

  # Adds an absolute-move command to the path.
  #
  # @param {Number} x the X coordinate to move the pen to
  # @param {Number} y the Y coordinate to move the pen to
  # @return the path builder to facilitate method chaining
  moveTo: (x, y) ->
    @command.push 'M'
    @command.push x
    @command.push ','
    @command.push y
    @

  # Adds a relative-move command to the path.
  #
  # @param {Number} dx how much to move the pen along the X axis
  # @param {Number} dy how much to move the pen along the Y axis
  # @return the path builder to facilitate method chaining
  moveBy: (dx, dy) ->
    @command.push 'm'
    @command.push dx
    @command.push ','
    @command.push dy
    @

  # Adds an absolute-move-and-draw-line command to the path.
  #
  # @param {Number} x the X coordinate to move the pen to
  # @param {Number} y the Y coordinate to move the pen to
  # @return the path builder to facilitate method chaining
  lineTo: (x, y) ->
    @command.push 'L'
    @command.push x
    @command.push ','
    @command.push y
    @

  # Adds a relative-move-and-draw-line command to the path.
  #
  # @param {Number} dx how much to move the pen along the X axis
  # @param {Number} dy how much to move the pen along the Y axis
  # @return the path builder to facilitate method chaining
  lineBy: (dx, dy) ->
    @command.push 'l'
    @command.push dx
    @command.push ','
    @command.push dy
    @

  # Adds an absolute-move-and-draw-an-ellipsis-arc comamnd to the path.
  #
  # @param {Number} x the X coordinate to move the pen to
  # @param {Number} y the Y coordinate to move the pen to
  # @param {Number} xRadius the ellipsis' radius along the X axis
  # @param {Number} yRadius the ellipsis' radius along the Y axis
  # @param {Number} xRotation
  # @param {Boolean} isLarge if true, the pen draws a 180+ degree arc;
  #   otherwise, it draws an arc smaller than 180 degrees; together with
  #   isClockwise, this flag helps disambiguate between four possible arcs
  # @param {Boolean} isClockwise if true, the pen moves clockwise when drawing
  #   the ellipsis; this is called the sweep flag in the SVG specification;
  #   together with isLarge, this flag helps disambiguate between four possible
  #   arcs
  # @return the path builder to facilitate method chaining
  arcTo: (x, y, xRadius, yRadius, xRotation, isLarge, isClockwise) ->
    @command.push 'A'
    @command.push xRadius
    @command.push ','
    @command.push yRadius
    @command.push ','
    @command.push xRotation
    @command.push ','
    @command.push(if isLarge then 1 else 0)
    @command.push ','
    @command.push(if isClockwise then 1 else 0)
    @command.push ','
    @command.push x
    @command.push ','
    @command.push y
    @

  # Adds a relative-move-and-draw-an-ellipsis-arc comamnd to the path.
  #
  # @param {Number} dx how much to move the pen along the X axis
  # @param {Number} dy how much to move the pen along the Y axis
  # @param {Number} xRadius the ellipsis' radius along the X axis
  # @param {Number} yRadius the ellipsis' radius along the Y axis
  # @param {Number} xRotation
  # @param {Boolean} isLarge if true, the pen draws a 180+ degree arc;
  #   otherwise, it draws an arc smaller than 180 degrees; together with
  #   isClockwise, this flag helps disambiguate between four possible arcs
  # @param {Boolean} isClockwise if true, the pen moves clockwise when drawing
  #   the ellipsis; this is called the sweep flag in the SVG specification;
  #   together with isLarge, this flag helps disambiguate between four possible
  #   arcs
  # @return the path builder to facilitate method chaining
  arcBy: (dx, dy, xRadius, yRadius, xRotation, isLarge, isClockwise) ->
    @command.push 'a'
    @command.push xRadius
    @command.push ','
    @command.push yRadius
    @command.push ','
    @command.push xRotation
    @command.push ','
    @command.push(if isLarge then 1 else 0)
    @command.push ','
    @command.push(if isClockwise then 1 else 0)
    @command.push ','
    @command.push dx
    @command.push ','
    @command.push dy
    @

  # Closes the path.
  #
  # @return the path builder to facilitate method chaining
  close: ->
    @command.push 'Z'
    @

  # The path data string constructed by this builder.
  toString: ->
    @command.join ''

# Export the Pwnvg class.
window.Pwnvg = Pwnvg
