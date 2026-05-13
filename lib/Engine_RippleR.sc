// MiRipples.ar(in, cutoff, resonance, fm, gain, mul, add)
//   cutoff:    0-1 normalized (0=min freq, 1=max freq ~18Hz-18kHz)
//   resonance: 0-1 (self-oscillates near 1.0)
//   fm:        FM amount 0-1 (modulates cutoff via audio in[1])
//   gain:      VCA gain 0-1
// Audio in[0] = signal to filter, in[1] = FM source (optional)

Engine_RippleR : CroneEngine {

  var <synth;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {

    SynthDef(\RippleR, {
      arg out, cutoff=0.5, resonance=0.5, fm=0.0, gain=1.0, mul=1.0,
          verb_time=0.5, verb_wet=0.0, verb_damp=0.5, verb_hp=0.05, verb_diff=0.625;

      var in, sound, verbOut;
      in = SoundIn.ar([0, 1]);
      sound = MiRipples.ar(in[0], cutoff, resonance, fm * in[1], gain, mul) !2;
      verbOut = MiVerb.ar(sound, verb_time, verb_wet, verb_damp, verb_hp, 0, verb_diff);
      Out.ar(out, verbOut);
    }).add;

    context.server.sync;

    synth = Synth.new(\RippleR, [
      \out, context.out_b.index,
      \cutoff,    0.5,
      \resonance, 0.5,
      \fm,        0.0,
      \gain,      1.0,
      \mul,       1.0,
      \verb_time, 0.5,
      \verb_wet,  0.0,
      \verb_damp, 0.5,
      \verb_hp,   0.05,
      \verb_diff, 0.625
    ], context.xg);

    this.addCommand("cutoff",    "f", {|msg| synth.set(\cutoff,    msg[1])});
    this.addCommand("resonance", "f", {|msg| synth.set(\resonance, msg[1])});
    this.addCommand("fm",        "f", {|msg| synth.set(\fm,        msg[1])});
    this.addCommand("gain",      "f", {|msg| synth.set(\gain,      msg[1])});
    this.addCommand("mul",       "f", {|msg| synth.set(\mul,       msg[1])});
    this.addCommand("verb_time", "f", {|msg| synth.set(\verb_time, msg[1])});
    this.addCommand("verb_wet",  "f", {|msg| synth.set(\verb_wet,  msg[1])});
    this.addCommand("verb_damp", "f", {|msg| synth.set(\verb_damp, msg[1])});
  }

  free { synth.free }
}
