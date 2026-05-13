// MiTides.ar(freq, shape, slope, smooth, shift, trig, clock, output_mode, ramp_mode, ratio, rate, mul, add)
//   freq:        Hz (internally normalized by SR, range ~0.01-19200 Hz)
//   shape:       0-1 waveform shape
//   slope:       0-1 rise/fall asymmetry
//   smooth:      0-1 smoothness
//   shift:       0-1 phase shift between the 4 outputs
//   trig:        audio-rate gate/trigger
//   clock:       audio-rate external clock (0 = unused)
//   output_mode: 0=Gates 1=Frequency 2=Phase 3=Degree
//   ramp_mode:   0=AD 1=Loop 2=AR
//   ratio:       0-18 clock ratio index (9 = 1:1)
//   rate:        0=Control range 1=Audio range
// Returns 4 channels (outputs are scaled by 0.1 in C plugin)
// Use [0] and [1] for stereo; shift controls spread between them

Engine_TidesT : CroneEngine {

  var <synth;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {

    SynthDef(\TidesT, {
      arg out, freq=1.0, shape=0.5, slope=0.5, smooth=0.5, shift=0.2,
          gate=0, output_mode=1, ramp_mode=1, ratio=9, rate=1, mul=1.0,
          verb_time=0.5, verb_wet=0.0, verb_damp=0.5, verb_hp=0.05, verb_diff=0.625;

      var trig, tides, sound, verbOut;
      trig = K2A.ar(gate);
      tides = MiTides.ar(freq, shape, slope, smooth, shift, trig, 0,
                         output_mode, ramp_mode, ratio, rate, mul);
      sound = [tides[0], tides[1]];
      verbOut = MiVerb.ar(sound, verb_time, verb_wet, verb_damp, verb_hp, 0, verb_diff);
      Out.ar(out, verbOut);
    }).add;

    context.server.sync;

    synth = Synth.new(\TidesT, [
      \out,         context.out_b.index,
      \freq,        1.0,
      \shape,       0.5,
      \slope,       0.5,
      \smooth,      0.5,
      \shift,       0.2,
      \gate,        0,
      \output_mode, 1,
      \ramp_mode,   1,
      \ratio,       9,
      \rate,        1,
      \mul,         1.0,
      \verb_time,   0.5,
      \verb_wet,    0.0,
      \verb_damp,   0.5,
      \verb_hp,     0.05,
      \verb_diff,   0.625
    ], context.xg);

    this.addCommand("freq",        "f", {|msg| synth.set(\freq,        msg[1])});
    this.addCommand("shape",       "f", {|msg| synth.set(\shape,       msg[1])});
    this.addCommand("slope",       "f", {|msg| synth.set(\slope,       msg[1])});
    this.addCommand("smooth",      "f", {|msg| synth.set(\smooth,      msg[1])});
    this.addCommand("shift",       "f", {|msg| synth.set(\shift,       msg[1])});
    this.addCommand("gate",        "f", {|msg| synth.set(\gate,        msg[1])});
    this.addCommand("output_mode", "i", {|msg| synth.set(\output_mode, msg[1])});
    this.addCommand("ramp_mode",   "i", {|msg| synth.set(\ramp_mode,   msg[1])});
    this.addCommand("ratio",       "i", {|msg| synth.set(\ratio,       msg[1])});
    this.addCommand("rate",        "i", {|msg| synth.set(\rate,        msg[1])});
    this.addCommand("mul",         "f", {|msg| synth.set(\mul,         msg[1])});
    this.addCommand("verb_time",   "f", {|msg| synth.set(\verb_time,   msg[1])});
    this.addCommand("verb_wet",    "f", {|msg| synth.set(\verb_wet,    msg[1])});
    this.addCommand("verb_damp",   "f", {|msg| synth.set(\verb_damp,   msg[1])});
  }

  free { synth.free }
}
