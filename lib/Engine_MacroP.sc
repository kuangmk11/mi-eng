//		pitch=60.0, eng=0, harm=0.1, timbre=0.5, morph=0.5, trigger=0.0, level=0, fm_mod=0.0, timb_mod=0.0,
//		morph_mod=0.0, decay=0.5, lpg_colour=0.5, mul=1.0;

Engine_MacroP : CroneEngine {
  
	var <synth;
	
  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
  	
    SynthDef(\MacroP, {
      arg out, pitch=60.0, eng=0, harm=0.1, timbre=0.5, morph=0.5, trigger=0.0, level=0, fm_mod=0.0, timb_mod=0.0, morph_mod=0.0, decay=0.5, lpg_colour=0.5, mul=0.3,
            // reverb
            verb_time=0.5, verb_wet=0.0, verb_damp=0.5, verb_hp=0.05, verb_diff=0.625;
      var sound, verbOut;
      sound = MiPlaits.ar(pitch,eng,harm,timbre,morph,trigger,level,fm_mod,timb_mod,morph_mod,lpg_colour,mul) !2;
      verbOut = MiVerb.ar(sound, verb_time, verb_wet, verb_damp, verb_hp, 0, verb_diff);
      Out.ar(out, verbOut);
    }).add;

    context.server.sync;

    synth = Synth.new(\MacroP, [
		\out, context.out_b.index,
		\pitch, 60.0,
		\eng, 0,
		\harm, 0.1,
		\timbre, 0.5,
		\morph, 0.5,
		\trigger, 0,
		\level, 0,
		\fm_mod, 0.0,
		\timb_mod, 0.0,
		\morph_mod, 0.0,
		\decay, 0.5,
		\lpg_colour, 0.5,
		\mul, 0.3,
		\verb_time, 0.5,
		\verb_wet, 0.0,
		\verb_damp, 0.5,
		\verb_hp, 0.05,
		\verb_diff, 0.625
      ],
    context.xg);

	//noteOn(note, vel)
    this.addCommand("noteOn", "ii", {|msg|
      synth.set(\pitch, msg[1]);
      synth.set(\trigger, 1);
      synth.set(\level, msg[2]);
    }); 
 
     this.addCommand("noteOff", "i", {|msg|
      synth.set(\trigger, 0);
      synth.set(\level, 0);
    }); 
    

    this.addCommand("pitch", "i", {|msg|
      synth.set(\pitch, msg[1]);
    });
    this.addCommand("eng", "i", {|msg|
      synth.set(\eng, msg[1]);
    });
    this.addCommand("harm", "f", {|msg|
      synth.set(\harm, msg[1]);
    });
    this.addCommand("timbre", "f", {|msg|
      synth.set(\timbre, msg[1]);
    });
    this.addCommand("morph", "f", {|msg|
      synth.set(\morph, msg[1]);
    });
    this.addCommand("trigger", "f", {|msg|
      synth.set(\trigger, msg[1]);
    });

    this.addCommand("level", "f", {|msg|
      synth.set(\level, msg[1]);
    });
    this.addCommand("fm_mod", "f", {|msg|
      synth.set(\fm_mod, msg[1]);
    });
    this.addCommand("timb_mod", "f", {|msg|
      synth.set(\timb_mod, msg[1]);
    });
    this.addCommand("morph_mod", "f", {|msg|
      synth.set(\morph_mod, msg[1]);
    });
     this.addCommand("decay", "f", {|msg|
      synth.set(\decay, msg[1]);
    });
    this.addCommand("lpg_colour", "f", {|msg|
      synth.set(\lpg_colour, msg[1]);
    });
    this.addCommand("mul", "f", {|msg|
      synth.set(\mul, msg[1]);
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
