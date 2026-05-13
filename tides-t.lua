--
--   tides lfo / function generator
--
--   v0.1.0 @kuangmk11
--
--
-- E1: frequency
-- E2: shape
-- E3: slope
-- K2: cycle ramp mode (AD / Loop / AR)
-- K3: gate
-- grid/MIDI: set frequency by note
--
-- Based on the norns scripts by okyeron <https://github.com/okyeron/mi-eng>
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local UI = require "ui"
local TidesT = require "mi-eng/lib/TidesT_engine"
local IntervalsGrid = include "mi-eng/lib/intervals_grid"

engine.name = "TidesT"

local note_names = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"}
local function note_name(n)
  return note_names[(n % 12) + 1] .. math.floor(n / 12 - 1)
end

local function note_to_freq(n)
  return 440 * 2^((n - 69) / 12)
end

local current_note = 69

function init()

  controls = {}
  controls.freq      = {ui = nil}
  controls.shape     = {ui = nil}
  controls.slope     = {ui = nil}
  controls.smooth    = {ui = nil}
  controls.shift     = {ui = nil}
  controls.mul       = {ui = nil}
  controls.verb_wet  = {ui = nil}
  controls.verb_time = {ui = nil}

  params:add{type = "control", id = "midi_channel", name = "MIDI channel",
    controlspec = controlspec.new(0, 16, "", 1, 0, ""), action = function() end}

  local mo = midi.connect()
  mo.event = function(data)
    local d = midi.to_msg(data)
    if params:get("midi_channel") == 0 or d.ch == params:get("midi_channel") then
      if d.type == "note_on" then
        current_note = d.note
        local f = note_to_freq(d.note)
        params:set("freq", f)
        controls.freq.ui:set_value(f)
        engine.gate(1)
        IntervalsGrid.note_on(d.note)
        redraw()
      elseif d.type == "note_off" then
        engine.gate(0)
        IntervalsGrid.note_off(d.note)
      end
    end
  end

  TidesT.add_params()

  -- UI
  local row1 = 11
  local row2 = 29

  local offset = 24
  local col1 = 8
  local col2 = col1 + offset
  local col3 = col2 + offset
  local col4 = col3 + offset
  local col5 = col4 + offset

  controls.freq.ui      = UI.Dial.new(col1, row1, 10, 1.0, 0.01, 5000, 1.0,  0, {}, "Hz", "frq")
  controls.shape.ui     = UI.Dial.new(col2, row1, 10, 0.5, 0,    1,    0.01, 0, {}, "",   "shp")
  controls.slope.ui     = UI.Dial.new(col3, row1, 10, 0.5, 0,    1,    0.01, 0, {}, "",   "slp")
  controls.smooth.ui    = UI.Dial.new(col4, row1, 10, 0.5, 0,    1,    0.01, 0, {}, "",   "smt")
  controls.shift.ui     = UI.Dial.new(col5, row1, 10, 0.2, 0,    1,    0.01, 0, {}, "",   "sft")

  controls.mul.ui       = UI.Dial.new(col1, row2, 10, 1.0, 0,    10,   0.1,  0, {}, "",   "mul")
  controls.verb_wet.ui  = UI.Dial.new(col2, row2, 10, 0.0, 0,    1,    0.01, 0, {}, "",   "wet")
  controls.verb_time.ui = UI.Dial.new(col3, row2, 10, 0.5, 0,    1.25, 0.01, 0, {}, "",   "rvb")

  for k, v in pairs(controls) do
    controls[k].ui:set_value(params:get(k))
  end

  IntervalsGrid.init(
    function(n, vel)
      current_note = n
      local f = note_to_freq(n)
      params:set("freq", f)
      controls.freq.ui:set_value(f)
      engine.gate(1)
      redraw()
    end,
    function()
      engine.gate(0)
    end
  )

  redraw()
end

function key(n, z)
  if n == 2 and z == 1 then
    local rm = params:get("ramp_mode")
    params:set("ramp_mode", (rm % 3) + 1)
    redraw()
  elseif n == 3 then
    engine.gate(z)
  end
end

function enc(n, d)
  if n == 1 then
    params:delta("freq", d)
    controls.freq.ui:set_value(params:get("freq"))
  elseif n == 2 then
    params:delta("shape", d)
    controls.shape.ui:set_value(params:get("shape"))
  elseif n == 3 then
    params:delta("slope", d)
    controls.slope.ui:set_value(params:get("slope"))
  end
  redraw()
end

local ramp_mode_names = {"AD", "Loop", "AR"}

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
  screen.text("tides-t")

  screen.move(64, 8)
  screen.text_center(ramp_mode_names[params:get("ramp_mode")])

  screen.move(128, 8)
  screen.text_right(note_name(current_note))

  screen.update()
end

function cleanup() end
