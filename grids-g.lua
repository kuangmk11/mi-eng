--
--   grids topographic drum sequencer
--
--   v0.1.0 @kuangmk11
--
--
-- E1: BPM
-- E2: map X (drum pattern character)
-- E3: map Y (drum pattern character)
-- K2: start / stop
-- K3: reset pattern
--
-- Based on the norns scripts by okyeron <https://github.com/okyeron/mi-eng>
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local UI = require "ui"
local GridsG = require "mi-eng/lib/GridsG_engine"

engine.name = "GridsG"

local running = true

function init()

  controls = {}
  controls.bpm     = {ui = nil}
  controls.map_x   = {ui = nil}
  controls.map_y   = {ui = nil}
  controls.chaos   = {ui = nil}
  controls.bd_dens = {ui = nil}
  controls.sd_dens = {ui = nil}
  controls.hh_dens = {ui = nil}
  controls.mul     = {ui = nil}

  GridsG.add_params()

  -- UI
  local row1 = 11
  local row2 = 29

  local offset = 28
  local col1 = 8
  local col2 = col1 + offset
  local col3 = col2 + offset
  local col4 = col3 + offset

  controls.bpm.ui     = UI.Dial.new(col1, row1, 10, 120,  20,   511,  0.5,  0, {}, "",  "bpm")
  controls.map_x.ui   = UI.Dial.new(col2, row1, 10, 0.5,  0,    1,    0.01, 0, {}, "",  "x")
  controls.map_y.ui   = UI.Dial.new(col3, row1, 10, 0.5,  0,    1,    0.01, 0, {}, "",  "y")
  controls.chaos.ui   = UI.Dial.new(col4, row1, 10, 0.0,  0,    1,    0.01, 0, {}, "",  "rnd")

  controls.bd_dens.ui = UI.Dial.new(col1, row2, 10, 0.5,  0,    1,    0.01, 0, {}, "",  "bd")
  controls.sd_dens.ui = UI.Dial.new(col2, row2, 10, 0.4,  0,    1,    0.01, 0, {}, "",  "sd")
  controls.hh_dens.ui = UI.Dial.new(col3, row2, 10, 0.6,  0,    1,    0.01, 0, {}, "",  "hh")
  controls.mul.ui     = UI.Dial.new(col4, row2, 10, 1.0,  0,    2,    0.01, 0, {}, "",  "mul")

  for k, v in pairs(controls) do
    controls[k].ui:set_value(params:get(k))
  end

  redraw()
end

function key(n, z)
  if n == 2 and z == 1 then
    running = not running
    engine.on_off(running and 1 or 0)
    redraw()
  elseif n == 3 then
    engine.reset_val(z)
  end
end

function enc(n, d)
  if n == 1 then
    params:delta("bpm", d)
    controls.bpm.ui:set_value(params:get("bpm"))
  elseif n == 2 then
    params:delta("map_x", d)
    controls.map_x.ui:set_value(params:get("map_x"))
  elseif n == 3 then
    params:delta("map_y", d)
    controls.map_y.ui:set_value(params:get("map_y"))
  end
  redraw()
end

function redraw()
  screen.clear()
  screen.aa(0)
  screen.font_face(1)
  screen.font_size(8)
  screen.level(15)

  screen.move(0, 0)
  screen.stroke()

  for k, v in pairs(controls) do
    controls[k].ui:redraw()
  end

  screen.move(2, 8)
  screen.text("grids-g")

  screen.move(64, 8)
  screen.text_center(running and ">" or "||")

  screen.move(128, 8)
  screen.text_right(math.floor(params:get("bpm")) .. " bpm")

  screen.update()
end

function cleanup() end
