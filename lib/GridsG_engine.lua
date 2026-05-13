--- GridsG Engine lib
-- Engine params and functions.
--
-- @module GridsG
-- @release v0.1.0
-- @author kuangmk11
--
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local cs = require 'controlspec'

local GridsG = {}

function GridsG.add_params()

  params:add_separator("Grids")

  params:add{type = "control", id = "bpm", name = "bpm",
    controlspec = cs.new(20, 511, "lin", 0.5, 120, "bpm"), action = engine.bpm}
  params:add{type = "control", id = "map_x", name = "map x",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.5, ""), action = engine.map_x}
  params:add{type = "control", id = "map_y", name = "map y",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.5, ""), action = engine.map_y}
  params:add{type = "control", id = "chaos", name = "chaos",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.0, ""), action = engine.chaos}
  params:add{type = "control", id = "bd_dens", name = "bd density",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.5, ""), action = engine.bd_dens}
  params:add{type = "control", id = "sd_dens", name = "sd density",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.4, ""), action = engine.sd_dens}
  params:add{type = "control", id = "hh_dens", name = "hh density",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.6, ""), action = engine.hh_dens}
  params:add{type = "option", id = "swing", name = "swing",
    options = {"Off", "On"}, default = 1,
    action = function(v) engine.swing(v - 1) end}

  params:add_separator("Bass Drum")

  params:add{type = "control", id = "bd_tune", name = "bd tune",
    controlspec = cs.new(20, 200, "exp", 0, 60, "Hz"), action = engine.bd_tune}
  params:add{type = "control", id = "bd_decay", name = "bd decay",
    controlspec = cs.new(0.05, 1.5, "lin", 0.01, 0.35, "s"), action = engine.bd_decay}
  params:add{type = "control", id = "bd_vol", name = "bd vol",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.9, ""), action = engine.bd_vol}

  params:add_separator("Snare")

  params:add{type = "control", id = "sd_tune", name = "sd tune",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.3, ""), action = engine.sd_tune}
  params:add{type = "control", id = "sd_decay", name = "sd decay",
    controlspec = cs.new(0.02, 0.5, "lin", 0.01, 0.12, "s"), action = engine.sd_decay}
  params:add{type = "control", id = "sd_vol", name = "sd vol",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.7, ""), action = engine.sd_vol}

  params:add_separator("Hi-Hat")

  params:add{type = "control", id = "hh_tune", name = "hh tune",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.7, ""), action = engine.hh_tune}
  params:add{type = "control", id = "hh_decay", name = "hh decay",
    controlspec = cs.new(0.005, 0.4, "lin", 0.005, 0.06, "s"), action = engine.hh_decay}
  params:add{type = "control", id = "hh_vol", name = "hh vol",
    controlspec = cs.new(0.0, 1.0, "lin", 0.01, 0.55, ""), action = engine.hh_vol}

  params:add_separator("Output")

  params:add{type = "control", id = "mul", name = "mul",
    controlspec = cs.new(0.0, 2.0, "lin", 0.01, 1.0, ""), action = engine.mul}

  params:add_separator("Reverb")
  params:add{type = "control", id = "verb_time", name = "verb time",
    controlspec = cs.new(0.0, 1.25, "lin", 0.01, 0.4, ""), action = engine.verb_time}
  params:add{type = "control", id = "verb_wet", name = "verb wet",
    controlspec = cs.new(0.0, 1.0,  "lin", 0.01, 0.2, ""), action = engine.verb_wet}
  params:add{type = "control", id = "verb_damp", name = "verb damp",
    controlspec = cs.new(0.0, 1.0,  "lin", 0.01, 0.6, ""), action = engine.verb_damp}

end

return GridsG
