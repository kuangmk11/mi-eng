--
--   warps meta-modulator
--
--   v0.1.0 @kuangmk11
--
--
-- E1: algorithm
-- E2: timbre
-- E3: modulator level
-- K2: cycle oscillator shape (Sine / Triangle / Saw / Pulse)
-- K3: toggle easter egg mode
-- grid/MIDI: set oscillator frequency by note
--
-- audio in[0] = modulator input (optional)
-- internal oscillator is always active as carrier
--
-- Based on the norns scripts by okyeron <https://github.com/okyeron/mi-eng>
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local UI = require "ui"
local WarpsW = require "mi-eng/lib/WarpsW_engine"
local IntervalsGrid = include "mi-eng/lib/intervals_grid"

engine.name = "WarpsW"

local note_names = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"}
local function note_name(n)
  return note_names[(n % 12) + 1] .. math.floor(n / 12 - 1)
end

local function note_to_freq(n)
  return 440 * 2^((n - 69) / 12)
end

local osc_names = {"Sine", "Tri", "Saw", "Pulse"}
local current_note = 45  -- A2 = 110 Hz

function init()

  controls = {}
  controls.algo      = {ui = nil}
  controls.timb      = {ui = nil}
  controls.lev1      = {ui = nil}
  controls.lev2      = {ui = nil}
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
        IntervalsGrid.note_on(d.note)
        redraw()
      elseif d.type == "note_off" then
        IntervalsGrid.note_off(d.note)
      end
    end
  end

  WarpsW.add_params()

  -- UI
  local row1 = 11
  local row2 = 29

  local offset = 28
  local col1 = 8
  local col2 = col1 + offset
  local col3 = col2 + offset
  local col4 = col3 + offset

  controls.algo.ui      = UI.Dial.new(col1, row1, 10, 0.0, 0,    8,    0.1,  0, {}, "",   "alg")
  controls.timb.ui      = UI.Dial.new(col2, row1, 10, 0.5, 0,    1,    0.01, 0, {}, "",   "tmb")
  controls.lev1.ui      = UI.Dial.new(col3, row1, 10, 0.8, 0,    1,    0.01, 0, {}, "",   "lv1")
  controls.lev2.ui      = UI.Dial.new(col4, row1, 10, 0.0, 0,    1,    0.01, 0, {}, "",   "lv2")

  controls.mul.ui       = UI.Dial.new(col1, row2, 10, 1.0, 0,    2,    0.01, 0, {}, "",   "mul")
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
      redraw()
    end,
    function() end
  )

  redraw()
end

function key(n, z)
  if n == 2 and z == 1 then
    local osc = params:get("osc")
    params:set("osc", (osc % 4) + 1)
    redraw()
  elseif n == 3 and z == 1 then
    local ee = params:get("easteregg")
    params:set("easteregg", (ee % 2) + 1)
    redraw()
  end
end

function enc(n, d)
  if n == 1 then
    params:delta("algo", d)
    controls.algo.ui:set_value(params:get("algo"))
  elseif n == 2 then
    params:delta("timb", d)
    controls.timb.ui:set_value(params:get("timb"))
  elseif n == 3 then
    params:delta("lev2", d)
    controls.lev2.ui:set_value(params:get("lev2"))
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
  screen.text("warps-w")

  screen.move(52, 8)
  screen.text(osc_names[params:get("osc")])

  if params:get("easteregg") == 2 then
    screen.move(90, 8)
    screen.text("EE")
  end

  screen.move(128, 8)
  screen.text_right(note_name(current_note))

  screen.update()
end

function cleanup() end
