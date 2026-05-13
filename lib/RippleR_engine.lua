--- RippleR Engine lib
-- Engine params and functions.
--
-- @module RippleR
-- @release v0.1.0
-- @author Steven Noreyko @okyeron
--
--
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local cs = require 'controlspec'

local RippleR = {}

function RippleR.add_params()

  params:add_separator("Ripple Filter")

  params:add{type = "control", id = "cutoff", name = "cutoff",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.cutoff}
  params:add{type = "control", id = "resonance", name = "resonance",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.resonance}
  params:add{type = "control", id = "fm", name = "fm",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.0, ""), action = engine.fm}
  params:add{type = "control", id = "gain", name = "gain",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 1.0, ""), action = engine.gain}
  params:add{type = "control", id = "mul", name = "mul",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 1.0, ""), action = engine.mul}

  params:add_separator("Reverb")
  params:add{type = "control", id = "verb_time", name = "verb time",
    controlspec = cs.new(0.0, 1.25, "lin", 0.01, 0.5, ""), action = engine.verb_time}
  params:add{type = "control", id = "verb_wet", name = "verb wet",
    controlspec = cs.new(0.0, 1.0,  "lin", 0.01, 0.0, ""), action = engine.verb_wet}
  params:add{type = "control", id = "verb_damp", name = "verb damp",
    controlspec = cs.new(0.0, 1.0,  "lin", 0.01, 0.5, ""), action = engine.verb_damp}

end

return RippleR
