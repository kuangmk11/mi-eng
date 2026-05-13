--- TidesT Engine lib
-- Engine params and functions.
--
-- @module TidesT
-- @release v0.1.0
-- @author kuangmk11
--
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local cs = require 'controlspec'

local TidesT = {}

function TidesT.add_params()

  params:add_separator("Tides")

  params:add{type = "control", id = "freq", name = "frequency",
    controlspec = cs.new(0.01, 5000, "exp", 0, 1.0, "Hz"), action = engine.freq}
  params:add{type = "control", id = "shape", name = "shape",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.shape}
  params:add{type = "control", id = "slope", name = "slope",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.slope}
  params:add{type = "control", id = "smooth", name = "smooth",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.smooth}
  params:add{type = "control", id = "shift", name = "shift",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.2, ""), action = engine.shift}

  params:add{type = "option", id = "output_mode", name = "output mode",
    options = {"Gates", "Frequency", "Phase", "Degree"}, default = 2,
    action = function(v) engine.output_mode(v - 1) end}
  params:add{type = "option", id = "ramp_mode", name = "ramp mode",
    options = {"AD", "Loop", "AR"}, default = 2,
    action = function(v) engine.ramp_mode(v - 1) end}
  params:add{type = "control", id = "ratio", name = "clock ratio",
    controlspec = cs.new(0, 18, "lin", 1, 9, ""), action = function(v) engine.ratio(math.floor(v)) end}
  params:add{type = "option", id = "rate", name = "rate",
    options = {"Control", "Audio"}, default = 2,
    action = function(v) engine.rate(v - 1) end}

  params:add{type = "control", id = "mul", name = "mul",
    controlspec = cs.new(0.00, 10.0, "lin", 0.1, 1.0, ""), action = engine.mul}

  params:add_separator("Reverb")
  params:add{type = "control", id = "verb_time", name = "verb time",
    controlspec = cs.new(0.0, 1.25, "lin", 0.01, 0.5, ""), action = engine.verb_time}
  params:add{type = "control", id = "verb_wet", name = "verb wet",
    controlspec = cs.new(0.0, 1.0,  "lin", 0.01, 0.0, ""), action = engine.verb_wet}
  params:add{type = "control", id = "verb_damp", name = "verb damp",
    controlspec = cs.new(0.0, 1.0,  "lin", 0.01, 0.5, ""), action = engine.verb_damp}

end

return TidesT
