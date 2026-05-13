--- WarpsW Engine lib
-- Engine params and functions.
--
-- @module WarpsW
-- @release v0.1.0
-- @author kuangmk11
--
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local cs = require 'controlspec'

local WarpsW = {}

function WarpsW.add_params()

  params:add_separator("Warps")

  params:add{type = "control", id = "freq", name = "frequency",
    controlspec = cs.new(20, 15000, "exp", 0, 110, "Hz"), action = engine.freq}
  params:add{type = "control", id = "lev1", name = "carrier level",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.8, ""), action = engine.lev1}
  params:add{type = "control", id = "lev2", name = "mod level",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.0, ""), action = engine.lev2}
  params:add{type = "control", id = "algo", name = "algorithm",
    controlspec = cs.new(0.0, 8.0, "lin", 0.1, 0.0, ""), action = engine.algo}
  params:add{type = "control", id = "timb", name = "timbre",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.timb}
  params:add{type = "option", id = "osc", name = "osc shape",
    options = {"Sine", "Triangle", "Sawtooth", "Pulse"}, default = 1,
    action = function(v) engine.osc(v - 1) end}
  params:add{type = "control", id = "vgain", name = "limiter gain",
    controlspec = cs.new(1.0, 10.0, "lin", 0.1, 1.0, ""), action = engine.vgain}
  params:add{type = "option", id = "easteregg", name = "easter egg",
    options = {"Off", "On"}, default = 1,
    action = function(v) engine.easteregg(v - 1) end}
  params:add{type = "control", id = "mul", name = "mul",
    controlspec = cs.new(0.00, 2.00, "lin", 0.01, 1.0, ""), action = engine.mul}

  params:add_separator("Reverb")
  params:add{type = "control", id = "verb_time", name = "verb time",
    controlspec = cs.new(0.0, 1.25, "lin", 0.01, 0.5, ""), action = engine.verb_time}
  params:add{type = "control", id = "verb_wet", name = "verb wet",
    controlspec = cs.new(0.0, 1.0,  "lin", 0.01, 0.0, ""), action = engine.verb_wet}
  params:add{type = "control", id = "verb_damp", name = "verb damp",
    controlspec = cs.new(0.0, 1.0,  "lin", 0.01, 0.5, ""), action = engine.verb_damp}

end

return WarpsW
