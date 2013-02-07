Ascribe = require "../ascribe.coffee"

fs = require "fs"
data = JSON.parse(fs.readFileSync("test/data.json"))

Ascribe.bars(data, width: 96, height: 20, y_units: "ms", x_units: "requests")
