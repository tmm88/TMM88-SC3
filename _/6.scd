(
SynthDef(\ping, {
    |freq = 440, amp = 0.3, rate = 1|
    var trig = Impulse.kr(rate);
    var env = Env.perc(0.01, 0.3).kr(gate: trig);
    var sig = SinOsc.ar(freq, 0, env * amp);
    sig = Pan2.ar(sig, LFNoise1.kr(0.2).range(-1, 1)); // add movement
    Out.ar(0, sig);
}).add;

Routine {
    var baseFreq = 145;
    var harmonics = [1, 8, 16];
    var rates = [0.5, 2, 4] * 3.14;
    var waitTimes = [2, 4, 6, 8];
    var activeSynths;

    loop {
        // Free only the synths we start, not the whole server
        activeSynths.do({ |s| s.free });
        activeSynths = [];

        harmonics.do { |h|
            var freq = baseFreq * h;
            var rate = rates.choose;
            var synth = Synth(\ping, [\freq, freq, \rate, rate]);
            activeSynths = activeSynths.add(synth);
        };

        waitTimes.choose.wait;
    }
}.play;
)
