// Iteration 10: Revamped Probabilistic Event Engine with Nested Patterns and Noise Layer
(
SynthDef(\modSineEvent, {
    |freq=400, modRate=2, modDepth=0.5, atk=0.01, sus=0.2, rel=0.3, amp=0.3, pan=0|
    var env = EnvGen.kr(Env([0, 1, 0.6, 0], [atk, sus, rel], [4, -2, -4]), doneAction: 2);
    var mod = LFNoise2.kr(modRate).range(freq * (1 - modDepth), freq * (1 + modDepth));
    var snd = SinOsc.ar(mod.clip(50, 6000)) * 0.8;
    var sub = Pulse.ar(mod * 0.25) * 0.2; // Sub-oscillator for depth
    snd = (snd + sub) * env * amp;
    Out.ar(0, Pan2.ar(snd, pan));
}).add;

// Noise-based layer for texture
SynthDef(\noiseLayer, {
    |freq=200, modRate=1, atk=0.02, sus=0.4, rel=0.6, amp=0.15, pan=0|
    var env = EnvGen.kr(Env([0, 1, 0.4, 0], [atk, sus, rel], [3, -1, -5]), doneAction: 2);
    var mod = LFNoise0.kr(modRate, freq * 0.4, freq);
    var snd = WhiteNoise.ar() * 0.5;
    snd = RLPF.ar(snd, mod.clip(100, 4000), 0.3) * env * amp;
    Out.ar(0, Pan2.ar(snd, pan));
}).add;

// Main event stream with nested probabilistic parameters
Pbindef(\eventStream,
    \instrument, \modSineEvent,
    \dur, Pn(Pshuf([0.05, 0.1, 0.15, 0.2, 0.3], 1), inf),
    \freq, Pexprand(100, 3000, inf),
    \modRate, Pwhite(0.5, 8, inf),
    \modDepth, Pwhite(0.3, 1.0, inf),
    \atk, Pwhite(0.002, 0.03, inf),
    \sus, Pwhite(0.1, 0.4, inf),
    \rel, Pwhite(0.1, 0.7, inf),
    \amp, Pseg(Pwhite(0.05, 0.25, inf), Pwhite(2, 8, inf), \lin, inf),
    \pan, Pwhite(-0.9, 0.9, inf),
    \rest, Pfunc { |ev| if(0.3.coin) { \rest } { ev } } // Probabilistic rests
).play;

// Secondary noise layer with sparser events
Pbindef(\noiseLayer,
    \instrument, \noiseLayer,
    \dur, Pwhite(0.3, 1.0, inf),
    \freq, Pexprand(150, 2000, inf),
    \modRate, Pwhite(0.2, 4, inf),
    \atk, Pwhite(0.01, 0.05, inf),
    \sus, Pwhite(0.3, 0.8, inf),
    \rel, Pwhite(0.2, 1.0, inf),
    \amp, Pwhite(0.02, 0.12, inf),
    \pan, Pwhite(-0.8, 0.8, inf),
    \rest, Pfunc { |ev| if(0.4.coin) { \rest } { ev } } // Higher chance of rests
).play(quant: 1);
)