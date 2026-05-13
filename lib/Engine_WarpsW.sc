// MiWarps.ar(carrier, modulator, lev1, lev2, algo, timb, osc, freq, vgain, easteregg)
//   carrier:   audio-rate carrier (0 = use internal oscillator)
//   modulator: audio-rate modulator input
//   lev1:      0-1 carrier drive (internally squared)
//   lev2:      0-1 modulator drive (internally squared)
//   algo:      0-8 modulation algorithm (continuous morph; *0.125 internally)
//   timb:      0-1 timbre / modulation character
//   osc:       0-3 internal oscillator shape (sine/tri/saw/pulse)
//   freq:      0-15000 Hz internal oscillator frequency
//   vgain:     1-10 limiter pre-gain
//   easteregg: 0/1 meta-modulator v2 mode
// Returns 2 channels: [out, aux]
// carrier=0 activates internal oscillator; audio in[0] used as modulator

Engine_WarpsW : CroneEngine {

  var <synth;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {

    SynthDef(\WarpsW, {
      arg out, freq=110, lev1=0.8, lev2=0.0, algo=0.0, timb=0.5,
          osc=0, vgain=1.0, easteregg=0, mul=1.0,
          verb_time=0.5, verb_wet=0.0, verb_damp=0.5, verb_hp=0.05, verb_diff=0.625;

      var mod, warps, sound, verbOut;
      mod = SoundIn.ar(0);
      warps = MiWarps.ar(0, mod, lev1, lev2, algo, timb, osc, freq, vgain, easteregg);
      sound = [warps[0], warps[1]] * mul;
      verbOut = MiVerb.ar(sound, verb_time, verb_wet, verb_damp, verb_hp, 0, verb_diff);
      Out.ar(out, verbOut);
    }).add;

    context.server.sync;

    synth = Synth.new(\WarpsW, [
      \out,        context.out_b.index,
      \freq,       110,
      \lev1,       0.8,
      \lev2,       0.0,
      \algo,       0.0,
      \timb,       0.5,
      \osc,        0,
      \vgain,      1.0,
      \easteregg,  0,
      \mul,        1.0,
      \verb_time,  0.5,
      \verb_wet,   0.0,
      \verb_damp,  0.5,
      \verb_hp,    0.05,
      \verb_diff,  0.625
    ], context.xg);

    this.addCommand("freq",      "f", {|msg| synth.set(\freq,      msg[1])});
    this.addCommand("lev1",      "f", {|msg| synth.set(\lev1,      msg[1])});
    this.addCommand("lev2",      "f", {|msg| synth.set(\lev2,      msg[1])});
    this.addCommand("algo",      "f", {|msg| synth.set(\algo,      msg[1])});
    this.addCommand("timb",      "f", {|msg| synth.set(\timb,      msg[1])});
    this.addCommand("osc",       "i", {|msg| synth.set(\osc,       msg[1])});
    this.addCommand("vgain",     "f", {|msg| synth.set(\vgain,     msg[1])});
    this.addCommand("easteregg", "i", {|msg| synth.set(\easteregg, msg[1])});
    this.addCommand("mul",       "f", {|msg| synth.set(\mul,       msg[1])});
    this.addCommand("verb_time", "f", {|msg| synth.set(\verb_time, msg[1])});
    this.addCommand("verb_wet",  "f", {|msg| synth.set(\verb_wet,  msg[1])});
    this.addCommand("verb_damp", "f", {|msg| synth.set(\verb_damp, msg[1])});
  }

  free { synth.free }
}
