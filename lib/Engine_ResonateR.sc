// in=0, trig=0, pit=60.0, struct=0.25, bright=0.5, damp=0.7, pos=0.25, model=0, poly=1,
//		intern_exciter=0, easteregg=0, bypass=0, mul=1.0, add=0

Engine_ResonateR : CroneEngine {
  
  var <synth;
	
  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
    SynthDef(\ResonateR, {
      arg out, trig=0, pit=60.0, struct=0.25, bright=0.5, damp=0.7, pos=0.25, model=0, poly=1, intern_exciter=0, easteregg=0, bypass=0, mul=1.0, add=0,
            // reverb
            verb_time=0.5, verb_wet=0.0, verb_damp=0.5, verb_hp=0.05, verb_diff=0.625;
      var sound, verbOut;
      sound = MiRings.ar(SoundIn.ar([0,1]), trig, pit, struct, bright, damp, pos, model, poly, intern_exciter, easteregg, bypass, mul, add);
      verbOut = MiVerb.ar(sound, verb_time, verb_wet, verb_damp, verb_hp, 0, verb_diff);
      Out.ar(out, verbOut);
    }).add;

    context.server.sync;

    synth = Synth.new(\ResonateR, [
		\out, context.out_b.index,
		\trig, 0, 
		\pit, 60.0, 
		\struct, 0.25, 
		\bright, 0.5, 
		\damp, 0.7, 
		\pos, 0.25, 
		\model, 0, 
		\poly, 1, 
		\intern_exciter, 0, 
		\easteregg, 0, 
		\bypass, 0,
		\mul, 1.0,
		\add, 0,
		\verb_time, 0.5,
		\verb_wet, 0.0,
		\verb_damp, 0.5,
		\verb_hp, 0.05,
		\verb_diff, 0.625
      ],
    context.xg);

	//noteOn(note)
    this.addCommand("noteOn", "i", {|msg|
      synth.set(\pit, msg[1]);
      synth.set(\trig, 1);
      synth.set(\intern_exciter, 1);
    }); 
 
     this.addCommand("noteOff", "i", {|msg|
      synth.set(\trig, 0);
    }); 

    this.addCommand("trig", "f", {|msg|
      synth.set(\trig, msg[1]);
    }); 
    this.addCommand("pit", "f", {|msg|
      synth.set(\pit, msg[1]);
    });
    this.addCommand("struct", "f", {|msg|
      synth.set(\struct, msg[1]);
    });
    this.addCommand("bright", "f", {|msg|
      synth.set(\bright, msg[1]);
    });
    this.addCommand("damp", "f", {|msg|
      synth.set(\damp, msg[1]);
    });
    this.addCommand("pos", "f", {|msg|
      synth.set(\pos, msg[1]);
    });
    this.addCommand("model", "i", {|msg|
      synth.set(\model, msg[1]);
    });
    this.addCommand("poly", "i", {|msg|
      synth.set(\poly, msg[1]);
    });
    this.addCommand("intern_exciter", "i", {|msg|
      synth.set(\intern_exciter, msg[1]);
    });
    this.addCommand("easteregg", "i", {|msg|
      synth.set(\easteregg, msg[1]);
    });
     this.addCommand("bypass", "i", {|msg|
      synth.set(\bypass, msg[1]);
    });
    this.addCommand("mul", "i", {|msg|
      synth.set(\mul, msg[1]);
    });
    this.addCommand("add", "i", {|msg|
      synth.set(\add, msg[1]);
    });
    this.addCommand("verb_time", "f", {|msg|
      synth.set(\verb_time, msg[1]);
    });
    this.addCommand("verb_wet", "f", {|msg|
      synth.set(\verb_wet, msg[1]);
    });
    this.addCommand("verb_damp", "f", {|msg|
      synth.set(\verb_damp, msg[1]);
    });

  }

  free {
    synth.free;
  }
}