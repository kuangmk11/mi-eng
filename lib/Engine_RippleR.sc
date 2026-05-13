// MiRipples.ar(in, cf, reson, drive)
//   cf:    cutoff frequency 0-1 normalized
//   reson: resonance 0-1 (self-oscillates near 1.0)
//   drive: input drive / VCA gain (0-2, unity at 1.0)

Engine_RippleR : CroneEngine {

  var <synth;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {

    SynthDef(\RippleR, {
      arg out, cf=0.3, reson=0.5, drive=1.0, mul=1.0,
          verb_time=0.5, verb_wet=0.0, verb_damp=0.5, verb_hp=0.05, verb_diff=0.625;

      var in, sound, verbOut;
      in = SoundIn.ar(0);
      sound = MiRipples.ar(in, cf, reson, drive) !2 * mul;
      verbOut = MiVerb.ar(sound, verb_time, verb_wet, verb_damp, verb_hp, 0, verb_diff);
      Out.ar(out, verbOut);
    }).add;

    context.server.sync;

    synth = Synth.new(\RippleR, [
      \out,       context.out_b.index,
      \cf,        0.3,
      \reson,     0.5,
      \drive,     1.0,
      \mul,       1.0,
      \verb_time, 0.5,
      \verb_wet,  0.0,
      \verb_damp, 0.5,
      \verb_hp,   0.05,
      \verb_diff, 0.625
    ], context.xg);

    this.addCommand("cf",        "f", {|msg| synth.set(\cf,        msg[1])});
    this.addCommand("reson",     "f", {|msg| synth.set(\reson,     msg[1])});
    this.addCommand("drive",     "f", {|msg| synth.set(\drive,     msg[1])});
    this.addCommand("mul",       "f", {|msg| synth.set(\mul,       msg[1])});
    this.addCommand("verb_time", "f", {|msg| synth.set(\verb_time, msg[1])});
    this.addCommand("verb_wet",  "f", {|msg| synth.set(\verb_wet,  msg[1])});
    this.addCommand("verb_damp", "f", {|msg| synth.set(\verb_damp, msg[1])});
  }

  free { synth.free }
}
