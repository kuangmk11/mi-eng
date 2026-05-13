--
--   ripple filter
--
--   v0.1.0 @okyeron
--
--
-- E1: cutoff
-- E2: resonance
-- E3: gain (VCA)
-- K2: snap cutoff to current note
-- grid/MIDI: set filter cutoff by note
--
-- audio in[0] = signal to filter
-- audio in[1] = FM source (optional, scaled by fm param)
--
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--
-- requires MiRipples.so in ~/.local/share/SuperCollider/Extensions/MiRipples/
--

local UI = require "ui"
local RippleR = require "mi-eng/lib/RippleR_engine"
local IntervalsGrid = include "mi-eng/lib/intervals_grid"

engine.name = "RippleR"

local note_names = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"}
local function note_name(n)
  return note_names[(n % 12) + 1] .. math.floor(n / 12 - 1)
end

local current_note = 60

function init()

  controls = {}
  controls.cutoff    = {ui = nil, midi = nil}
  controls.resonance = {ui = nil, midi = nil}
  controls.fm        = {ui = nil, midi = nil}
  controls.gain      = {ui = nil, midi = nil}
  controls.mul       = {ui = nil, midi = nil}
  controls.verb_wet  = {ui = nil, midi = nil}
  controls.verb_time = {ui = nil, midi = nil}

  params:add{type = "control", id = "midi_channel", name = "MIDI channel",
    controlspec = controlspec.new(0, 16, "", 1, 0, ""), action = function() end}

  local mo = midi.connect()
  mo.event = function(data)
    local d = midi.to_msg(data)
    if params:get("midi_channel") == 0 or d.ch == params:get("midi_channel") then
      if d.type == "note_on" then
        current_note = d.note
        local c = d.note / 127
        params:set("cutoff", c)
        controls.cutoff.ui:set_value(c)
        IntervalsGrid.note_on(d.note)
        redraw()
      elseif d.type == "note_off" then
        IntervalsGrid.note_off(d.note)
      end
    end
  end

  RippleR.add_params()

  params:set("cutoff",    0.5)
  params:set("resonance", 0.5)
  params:set("fm",        0.0)
  params:set("gain",      1.0)

  -- UI
  local row1 = 11
  local row2 = 29

  local offset = 28
  local col1 = 8
  local col2 = col1 + offset
  local col3 = col2 + offset
  local col4 = col3 + offset

  controls.cutoff.ui    = UI.Dial.new(col1, row1, 10, 0, 0, 1,    0.01, 0, {}, "", "cut")
  controls.resonance.ui = UI.Dial.new(col2, row1, 10, 0, 0, 1,    0.01, 0, {}, "", "res")
  controls.fm.ui        = UI.Dial.new(col3, row1, 10, 0, 0, 1,    0.01, 0, {}, "", "fm")
  controls.gain.ui      = UI.Dial.new(col4, row1, 10, 0, 0, 1,    0.01, 0, {}, "", "gain")

  controls.mul.ui       = UI.Dial.new(col1, row2, 10, 0, 0, 1,    0.01, 0, {}, "", "mul")
  controls.verb_wet.ui  = UI.Dial.new(col2, row2, 10, 0, 0, 1,    0.01, 0, {}, "", "wet")
  controls.verb_time.ui = UI.Dial.new(col3, row2, 10, 0, 0, 1.25, 0.01, 0, {}, "", "rvb")

  for k, v in pairs(controls) do
    controls[k].ui:set_value(params:get(k))
  end

  IntervalsGrid.init(
    function(n, vel)
      current_note = n
      local c = n / 127
      params:set("cutoff", c)
      controls.cutoff.ui:set_value(c)
      redraw()
    end,
    function() end
  )

  redraw()
end

function key(n, z)
  if n == 2 and z == 1 then
    local c = current_note / 127
    params:set("cutoff", c)
    controls.cutoff.ui:set_value(c)
    redraw()
  end
end

function enc(n, d)
  if n == 1 then
    params:delta("cutoff", d)
    controls.cutoff.ui:set_value(params:get("cutoff"))
  elseif n == 2 then
    params:delta("resonance", d)
    controls.resonance.ui:set_value(params:get("resonance"))
  elseif n == 3 then
    params:delta("gain", d)
    controls.gain.ui:set_value(params:get("gain"))
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
  screen.text("ripple-r")

  screen.move(128, 8)
  screen.text_right(note_name(current_note))

  screen.update()
end

function cleanup() end
