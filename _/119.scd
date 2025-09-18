// Iteration 9: Enhanced Probabilistic Event Engine with Layered Textures
(
SynthDef(\modSineEvent, {
    |freq=400, modRate=2, atk=0.01, sus=0.2, rel=0.3, amp=0.3, pan=0, modDepth=0.5|
    var env = EnvGen.kr(Env([0, 1, 0.7, 0], [atk, sus, rel], [3, 0, -3]), doneAction: 2);
    var mod = LFDNoise3.kr(modRate, freq * modDepth, freq);
    var snd = SinOsc.ar(mod.clip(50, 5000)) * 0.7;
    // Add secondary oscillator for richer texture
    var snd2 = Saw.ar(mod * 0.5) * 0.3;
    snd = (snd + snd2) * env * amp;
    Out.ar(0, Pan2.ar(snd, pan));
}).add;

// Secondary synth for harmonic layering
SynthDef(\pulseLayer, {
    |freq=200, modRate=1, atk=0.02, sus=0.3, rel=0.5, amp=0.2, pan=0|
    var env = EnvGen.kr(Env([0, 1, 0.5, 0], [atk, sus, rel], [2, -2, -4]), doneAction: 2);
    var mod = LFDNoise1.kr(modRate, freq * 0.3, freq);
    var snd = Pulse.ar(mod.clip(50, 3000)) * env * amp;
    Out.ar(0, Pan2.ar(snd, pan));
}).add;

// Main event stream with probabilistic parameters
Pbindef(\eventStream,
    \instrument, \modSineEvent,
    \dur, Pwhite(0.04, 0.25, inf),
    \freq, Pexprand(80, 2500, inf),
    \modRate, Pwhite(0.5, 10, inf),
    \modDepth, Pwhite(0.2, 0.8, inf),
    \atk, Pwhite(0.001, 0.04, inf),
    \sus, Pwhite(0.1, 0.5, inf),
    \rel, Pwhite(0.1, 0.8, inf),
    \amp, Pwhite(0.05, 0.25, inf),
    \pan, Pwhite(-1.0, 1.0, inf)
).play;

// Secondary layer with sparser events
Pbindef(\pulseLayer,
    \instrument, \pulseLayer,
    \dur, Pwhite(0.2, 0.8, inf),
    \freq, Pexprand(60, 1500, inf),
    \modRate, Pwhite(0.3, 5, inf),
    \atk, Pwhite(0.01, 0.06, inf),
    \sus, Pwhite(0.2, 0.6, inf),
    \rel, Pwhite(0.2, 1.2, inf),
    \amp, Pwhite(0.03, 0.15, inf),
    \pan, Pwhite(-0.7, 0.7, inf)
).play(quant: 1);
)