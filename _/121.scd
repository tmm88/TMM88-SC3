// Iteration 11: Revamped Probabilistic Event Engine with Cross-Modulation and Tempo Shifts
(
SynthDef(\modSineEvent, {
    |freq=400, modRate=2, modDepth=0.5, crossMod=0, atk=0.01, sus=0.2, rel=0.3, amp=0.3, pan=0|
    var env = EnvGen.kr(Env([0, 1, 0.8, 0], [atk, sus, rel], [4, -1, -5]), doneAction: 2);
    var mod = LFNoise2.kr(modRate).range(freq * (1 - modDepth), freq * (1 + modDepth));
    var cross = In.kr(\crossModBus.kr(0), 1) * crossMod;
    var snd = SinOsc.ar((mod + cross).clip(50, 6000)) * 0.7;
    var sub = SinOsc.ar(mod * 0.5) * 0.3; // Sub-oscillator for harmonic depth
    snd = (snd + sub) * env * amp;
    Out.ar(0, Pan2.ar(snd, pan));
    Out.kr(\modOutBus.kr(0), mod * 0.01); // Output for cross-modulation
}).add;

// Resonant filter layer for texture
SynthDef(\resonLayer, {
    |freq=200, modRate=1, res=0.3, atk=0.02, sus=0.4, rel=0.6, amp=0.15, pan=0|
    var env = EnvGen.kr(Env([0, 1, 0.5, 0], [atk, sus, rel], [3, 0, -4]), doneAction: 2);
    var mod = LFNoise1.kr(modRate, freq * 0.5, freq);
    var snd = WhiteNoise.ar() * 0.4;
    snd = RHPF.ar(snd, mod.clip(100, 5000), res) * env * amp;
    Out.ar(0, Pan2.ar(snd, pan));
}).add;

// Bus for cross-modulation
~modBus = Bus.control(s, 1);

// Main event stream with nested patterns and probabilistic branching
Pbindef(\eventStream,
    \instrument, \modSineEvent,
    \dur, Pn(Pshuf([0.05, 0.1, 0.15, 0.25, 0.4], 1), inf) * Pseg(Pwhite(0.8, 1.2, inf), Pwhite(5, 15, inf), \lin, inf), // Probabilistic tempo shifts
    \freq, Pexprand(80, 3500, inf),
    \modRate, Pwrand([0.5, 2, 5, 8], [0.4, 0.3, 0.2, 0.1], inf),
    \modDepth, Pwhite(0.3, 1.2, inf),
    \crossMod, Pwhite(0.0, 0.5, inf),
    \atk, Pwhite(0.001, 0.04, inf),
    \sus, Pwhite(0.1, 0.5, inf),
    \rel, Pwhite(0.1, 0.8, inf),
    \amp, Pseg(Pwhite(0.05, 0.3, inf), Pwhite(3, 10, inf), \exp, inf),
    \pan, Pwhite(-1.0, 1.0, inf),
    \modOutBus, ~modBus,
    \crossModBus, ~modBus,
    \rest, Pfunc { |ev| if(0.25.coin) { \rest } { ev } } // Probabilistic rests
).play;

// Secondary resonant layer with sparser events
Pbindef(\resonLayer,
    \instrument, \resonLayer,
    \dur, Pwhite(0.3, 1.2, inf) * Pseg(Pwhite(0.9, 1.3, inf), Pwhite(4, 12, inf), \lin, inf),
    \freq, Pexprand(120, 2500, inf),
    \modRate, Pwhite(0.2, 3, inf),
    \res, Pwhite(0.1, 0.5, inf),
    \atk, Pwhite(0.01, 0.06, inf),
    \sus, Pwhite(0.2, 0.7, inf),
    \rel, Pwhite(0.3, 1.0, inf),
    \amp, Pwhite(0.03, 0.15, inf),
    \pan, Pwhite(-0.8, 0.8, inf),
    \rest, Pfunc { |ev| if(0.35.coin) { \rest } { ev } } // Higher rest probability
).play(quant: 1);
)