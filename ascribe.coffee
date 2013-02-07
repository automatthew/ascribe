require("./statistics.js")

# MONKEYPATCH
Array.prototype.slices = (slice_count, callback) ->
  multiplier = @length / slice_count
  for i in [0..slice_count-1]
    index = i * multiplier
    indices = [Math.floor(index), Math.floor(index + multiplier) - 1]
    if indices[0] == indices[1]
      val = @[indices[0]]
      callback [val]
    else
      callback @slice(indices...)

module.exports = class Ascribe
  @bars: (args...) ->
    new @(args...).bars()

  constructor: (@data, options) ->
    options ||= {}
    @x_units = options.x_units || "units"
    @y_units = options.y_units || "units"
    @width = options.width || 72
    @height = options.height || 8
    @display = new Display(@width, @height)

    @y_axis = @display.sub
      x0: 0, x1: 2
      y0: 2, y1: @height - 1
      #clear: "|"

    @x_axis = @display.sub
      x0: 1, x1: @width - 1
      y0: 0, y1: 1
      #clear: "_"

    @y_axis.vertical_line 2, 0, @y_axis.height, "|"
    @x_axis.horizontal_line 1, 1, @x_axis.width - 1, "-"

    @main = @display.sub
      x0: 3, x1: @width - 1
      y0: 2, y1: @height - 1

    @sample_function = options.sample_function || "mean"

  bars: (char="*") ->
    normed = @sample_data(@data, @main.width, @sample_function)

    min = normed.min()
    max = normed.max()
    bar_max = max - min

    @y_axis.vertical_text 0, @y_axis.height - 1, max.toString()
    label = "#{min.toString()} #{@y_units}"
    @y_axis.vertical_text 0, label.length - 1, label

    label = "#{@data.length} #{@x_units}"
    @x_axis.horizontal_text (@x_axis.width - label.length), 0, label
    @x_axis.center_text 0, "-- time -->"


    multiplier = @main.height / bar_max
    for i in [0..normed.length-1]
      val = normed[i] - min
      num = Math.floor(val * multiplier)
      @main.vertical_line(i, 0, num || 1, char)
    @display.print()

  sample_data: (data, width, sample_function) ->
    if data.length > width
      norm = []
      data.slices width, (values) ->
        norm.push Math.floor(values[sample_function]())
      norm
    else
      data



Ascribe.Display = class Display

  constructor: (@width, @height, char=" ") ->
    @data = new Array(@height)
    for x, i in @data
      @data[i] = new Array(@width)
    @clear(char)

  print: ->
    console.log()
    # Can't print from bottom to top, so reverse the rows
    @data.reverse().forEach (row) ->
      console.log row.join("")
    console.log()

  clear: (char) ->
    for y in [0..@height - 1]
      @horizontal_line(0, y, @width, char)

  write: (x, y, char) ->
    if x > @width - 1
      throw new Error("X value out of bounds")
    else if y > @height - 1
      throw new Error("Y value out of bounds")
    else
      @data[y][x] = char

  # readability oriented
  horizontal_text: (x, y, string) ->
    l = string.length
    if x + l > @width
      throw new Error("Horizontal string will not fit in display")
    for char, i in string
      @write x + i, y, char

  # readability oriented
  vertical_text: (x, y, string) ->
    l = string.length
    if (y + 1) - l < 0
      console.log x, y, l
      throw new Error("Vertical string will not fit in display")
    for char, i in string
      @write x, y - i, char

  center_text: (y, string) ->
    l = string.length
    index = Math.floor(@width / 2 - l / 2)
    @horizontal_text index, y, string

  # axis oriented
  vertical_line: (x, y, height, char="*") ->
    for i in [0..height-1]
      @write x, y + i, char

  # axis oriented
  horizontal_line: (x, y, length, char="*") ->
    for i in [0..length-1]
      @write x + i, y, char

  # TODO: move to Chart class
  axes: ->
    for x in [0..@width-1]
      @write x, 0, "-"
    for y in [1..@height-1]
      @write 0, y, "|"

  sub: (options) ->
    new SubDisplay(@, options)


class SubDisplay extends Display

  #sub = display.sub
    #x0: 25
    #x1: 50
    #y0: 4
    #y1: 8
    #clear: "%"
  constructor: (@display, options) ->
    {@x0, @x1, @y0, @y1} = options
    @height = @y1 - @y0 + 1
    @width = @x1 - @x0 + 1
    if options.clear
      @clear(options.clear)

  write: (x, y, char) ->
    if x > @width - 1
      throw new Error("X value out of bounds")
    else if y > @height - 1
      throw new Error("Y value out of bounds")
    @display.write @x0 + x, @y0 + y, char

  print: ->
    throw new Error("Can't print subdisplay")


