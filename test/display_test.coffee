Display = require("../ascribe.coffee").Display

display = new Display(80, 20, " ")
display.horizontal_line 4, 7, 7, "0"
display.vertical_line 4, 7, 7, "X"

display.horizontal_text(5, 1, "Foo")
display.vertical_text(10, 12, "bar")

display.write 28, 6, "^"
display.write 28, 3, "^"
display.write 24, 3, "^"
display.write 24, 6, "^"
sub = display.sub
  x0: 24
  x1: 28
  y0: 4
  y1: 5
  clear: "."

sub.write 1, 0, "Y"
sub.write 2, 0, "e"
sub.write 3, 0, "s"

sub.vertical_text 0, 1, "NO"

display.print()


display.print()



