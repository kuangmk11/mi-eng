// MiGrids.ar(on_off, bpm, map_x, map_y, chaos, bd_dens, sd_dens, hh_dens,
//             clock_trig, reset_trig, ext_clock, mode, swing, config, reso)
//   on_off:     0/1 run/stop
//   bpm:        20-511 tempo
//   map_x:      0-1 X position in drum map
//   map_y:      0-1 Y position in drum map
//   chaos:      0-1 randomness
//   bd/sd/hh_dens: 0-1 density per drum part
//   clock_trig: audio-rate external clock (ext_clock=0 = unused)
//   reset_trig: audio-rate reset trigger
//   ext_clock:  0/1 use external clock
//   mode:       0 = drums (note: IN0(11)==0 maps to true internally)
//   swing:      0/1
//   config:     0/1 output clock mode (0 = drum triggers)
//   reso:       0-2 clock resolution (constructor-only, hardcoded 2)
// Returns 8 channels: [bd, sd, hh, bd_acc, sd_acc, hh_acc, clock, reset]

Engine_GridsG : CroneEngine {

  var <synth;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {

    SynthDef(\GridsG, {
      arg out, bpm=120, map_x=0.5, map_y=0.5, chaos=0.0,
          bd_dens=0.5, sd_dens=0.4, hh_dens=0.6, swing=0, on_off=1, reset_val=0,
          bd_tune=60, bd_decay=0.35,
          sd_tune=0.3, sd_decay=0.12,
          hh_tune=0.7, hh_decay=0.06,
          bd_vol=0.9, sd_vol=0.7, hh_vol=0.55,
          mul=1.0,
          verb_time=0.4, verb_wet=0.2, verb_damp=0.6, verb_hp=0.05, verb_diff=0.625;

      var reset_ar, grids;
      var bd_trig, sd_trig, hh_trig;
      var bd_pitch, bd, sd, hh, mix, verbOut;

      reset_ar = K2A.ar(reset_val);

      grids = MiGrids.ar(on_off, bpm, map_x, map_y, chaos,
                         bd_dens, sd_dens, hh_dens,
                         0, reset_ar, 0,
                         0, swing, 0, 2);

      bd_trig = grids[0];
      sd_trig = grids[1];
      hh_trig = grids[2];

      // BD: 808-style sine kick with pitch envelope
      bd_pitch = EnvGen.ar(Env.new([bd_tune * 3, bd_tune], [0.04], [-8]), bd_trig);
      bd = SinOsc.ar(bd_pitch) *
           EnvGen.ar(Env.perc(0.005, bd_decay, 1, -4), bd_trig) * bd_vol;

      // SD: noise + body tone
      sd = (HPF.ar(WhiteNoise.ar, 600 + sd_tune * 3000) * 0.7 +
            SinOsc.ar(180 + sd_tune * 120) * 0.3) *
           EnvGen.ar(Env.perc(0.003, sd_decay, 1, -5), sd_trig) * sd_vol;

      // HH: high-pass noise, decay controls open/closed character
      hh = HPF.ar(WhiteNoise.ar, 5000 + hh_tune * 12000) *
           EnvGen.ar(Env.perc(0.001, hh_decay, 1, -8), hh_trig) * hh_vol;

      mix = (bd + sd + hh) * mul ! 2;
      verbOut = MiVerb.ar(mix, verb_time, verb_wet, verb_damp, verb_hp, 0, verb_diff);
      Out.ar(out, verbOut);
    }).add;

    context.server.sync;

    synth = Synth.new(\GridsG, [
      \out,       context.out_b.index,
      \bpm,       120,
      \map_x,     0.5,
      \map_y,     0.5,
      \chaos,     0.0,
      \bd_dens,   0.5,
      \sd_dens,   0.4,
      \hh_dens,   0.6,
      \swing,     0,
      \on_off,    1,
      \reset_val, 0,
      \bd_tune,   60,
      \bd_decay,  0.35,
      \sd_tune,   0.3,
      \sd_decay,  0.12,
      \hh_tune,   0.7,
      \hh_decay,  0.06,
      \bd_vol,    0.9,
      \sd_vol,    0.7,
      \hh_vol,    0.55,
      \mul,       1.0,
      \verb_time, 0.4,
      \verb_wet,  0.2,
      \verb_damp, 0.6,
      \verb_hp,   0.05,
      \verb_diff, 0.625
    ], context.xg);

    this.addCommand("bpm",       "f", {|msg| synth.set(\bpm,       msg[1])});
    this.addCommand("map_x",     "f", {|msg| synth.set(\map_x,     msg[1])});
    this.addCommand("map_y",     "f", {|msg| synth.set(\map_y,     msg[1])});
    this.addCommand("chaos",     "f", {|msg| synth.set(\chaos,     msg[1])});
    this.addCommand("bd_dens",   "f", {|msg| synth.set(\bd_dens,   msg[1])});
    this.addCommand("sd_dens",   "f", {|msg| synth.set(\sd_dens,   msg[1])});
    this.addCommand("hh_dens",   "f", {|msg| synth.set(\hh_dens,   msg[1])});
    this.addCommand("swing",     "i", {|msg| synth.set(\swing,     msg[1])});
    this.addCommand("on_off",    "i", {|msg| synth.set(\on_off,    msg[1])});
    this.addCommand("reset_val", "f", {|msg| synth.set(\reset_val, msg[1])});
    this.addCommand("bd_tune",   "f", {|msg| synth.set(\bd_tune,   msg[1])});
    this.addCommand("bd_decay",  "f", {|msg| synth.set(\bd_decay,  msg[1])});
    this.addCommand("sd_tune",   "f", {|msg| synth.set(\sd_tune,   msg[1])});
    this.addCommand("sd_decay",  "f", {|msg| synth.set(\sd_decay,  msg[1])});
    this.addCommand("hh_tune",   "f", {|msg| synth.set(\hh_tune,   msg[1])});
    this.addCommand("hh_decay",  "f", {|msg| synth.set(\hh_decay,  msg[1])});
    this.addCommand("bd_vol",    "f", {|msg| synth.set(\bd_vol,    msg[1])});
    this.addCommand("sd_vol",    "f", {|msg| synth.set(\sd_vol,    msg[1])});
    this.addCommand("hh_vol",    "f", {|msg| synth.set(\hh_vol,    msg[1])});
    this.addCommand("mul",       "f", {|msg| synth.set(\mul,       msg[1])});
    this.addCommand("verb_time", "f", {|msg| synth.set(\verb_time, msg[1])});
    this.addCommand("verb_wet",  "f", {|msg| synth.set(\verb_wet,  msg[1])});
    this.addCommand("verb_damp", "f", {|msg| synth.set(\verb_damp, msg[1])});
  }

  free { synth.free }
}
