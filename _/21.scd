// Iteration 8: Probabilistic Event Engine
(
SynthDef(\modSineEvent, {
    |freq=400, rate=2, atk=0.01, rel=0.3, amp=0.3, pan=0|
    var env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
    var mod = LFDNoise3.kr(rate, freq * 0.5, freq);
    var snd = SinOsc.ar(mod.clip(50, 5000));
    snd = snd * env * amp;
    Out.ar(0, Pan2.ar(snd, pan));
}).add;

// Event pattern with probabilistic parameters
Pbindef(\eventStream,
    \instrument, \modSineEvent,
    \dur, Pwhite(0.05, 0.3, inf),
    \freq, Pexprand(100, 2000, inf),
    \rate, Pwhite(1, 12, inf),
    \atk, Pwhite(0.001, 0.05, inf),
    \rel, Pwhite(0.1, 1.0, inf),
    \amp, Pwhite(0.05, 0.2, inf),
    \pan, Pwhite(-0.8, 0.8, inf)
).play;
)