--- MacroB Engine lib
-- Engine params and functions.
--
-- @module MacroB
-- @release v0.3.1
-- @author Steven Noreyko @okyeron
--
-- 
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local cs = require 'controlspec'

local MacroB = {}

function MacroB.add_params()

  params:add_separator ("Macro Osc B")

  params:add{type = "control", id = "model", name = "model",
    controlspec = cs.new(1, 48, "lin", 1, 0, ""), action = engine.model}

  params:add{type = "control", id = "pitch", name = "pitch",
    controlspec = controlspec.MIDINOTE, action = engine.pitch}

  params:add{type = "control", id = "trig", name = "trig",
    controlspec = cs.new(0, 1, "lin", 1, 0, ""), action = engine.trig}

  params:add{type = "control", id = "timbre", name = "timbre",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.timbre}

  params:add{type = "control", id = "color", name = "color",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.color}

  params:add{type = "control", id = "resamp", name = "resamp",
    controlspec = cs.new(0, 2, "lin", 1, 0, ""), action = engine.resamp}

  params:add{type = "control", id = "decim", name = "decim",
    controlspec = cs.new(1, 32, "lin", 1, 0, ""), action = engine.decim}

  params:add{type = "control", id = "bits", name = "bits",
    controlspec = cs.new(1, 6, "lin", 1, 0, ""), action = engine.bits}

  params:add{type = "control", id = "ws", name = "ws",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.ws}

  params:add_separator ("ADSR")

  params:add{type = "control", id = "ampAtk", name = "ampAtk",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.ampAtk}

  params:add{type = "control", id = "ampDec", name = "ampDec",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.1, ""), action = engine.ampDec}

  params:add{type = "control", id = "ampSus", name = "ampSus",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 1.0, ""), action = engine.ampSus}

  params:add{type = "control", id = "ampRel", name = "ampRel",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 1.0, ""), action = engine.ampRel}

  params:add{type = "control", id = "mul", name = "mul",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 1.0, ""), action = engine.mul}

  params:add_separator("Reverb")
  params:add{type = "control", id = "verb_time", name = "verb time",
    controlspec = cs.new(0.0, 1.25, "lin", 0.01, 0.5, ""), action = engine.verb_time}
  params:add{type = "control", id = "verb_wet", name = "verb wet",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.0, ""), action = engine.verb_wet}
  params:add{type = "control", id = "verb_damp", name = "verb damp",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.5, ""), action = engine.verb_damp}

end

return MacroB
