(
{
    var base = 110;
    var exc = PinkNoise.ar(Decay2.kr(Impulse.kr(LFNoise1.kr(0.2).range(0.1, 0.5)), 0.01, 0.5)) * 0.4;
    var specs = Ref([
        `[ [1, 1.57, 2.31, 3.41, 4.92] * base, nil, [1, 0.7, 0.4, 0.2, 0.1] ], // freqs, phases, amps
        `[ [2.0, 3.1, 4.4, 6.3, 8.9] * base, nil, [0.5, 0.8, 0.3, 0.1, 0.05] ]
    ]).choose;
    var klank = Klank.ar(specs, exc);
    var lfo = LFNoise1.kr([0.1, 0.12]).range(0.7, 1.3);
    var modSig = klank * SinOsc.ar(333 * lfo, 0, 0.2); // Ring modulation

    var sig = klank + modSig;
    sig = CombC.ar(sig, 0.2, [0.13, 0.17], 4) * 0.3 + sig;
    sig = BRF.ar(sig, LinExp.kr(LFNoise1.kr(0.15), -1, 1, 300, 5000), 0.3);
    sig = GVerb.ar(sig, 80, 5, 0.7, 0.6, 15, 0.5) * 0.3 + (sig * 0.4);
    Limiter.ar(sig, 0.7);
}.play;
)