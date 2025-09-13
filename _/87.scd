(
{
    var baseFreq = 45 + LFNoise2.kr(1/30!2, 15).mean; // Very slow drift
    var numHarmonics = 5;
    var drone = Mix.fill(numHarmonics, { |i|
        var detune = LFNoise2.kr(1/(10 + i)).range(0.98, 1.02); // Detune each harmonic independently
        var env = EnvGen.kr(Env.perc(30, 50, 0.1, \sine), 1); // Ultra-slow amplitude envelope
        Formant.ar(
            baseFreq * (i + 1.5) * detune,
            baseFreq * LFNoise2.kr(1/20, 0.2, 0.5),
            baseFreq * 2,
            env * 0.03
        )
    });
    var sub = SinOsc.ar(baseFreq * 0.25, 0, 0.1) * LFNoise2.kr(0.1).range(0.3, 1.0);

    var sig = drone + sub;
    sig = FreqShift.ar(sig, LFNoise2.kr(0.1).range(-5, 5)); // Subtle spectral shift
    sig = DelayN.ar(sig, 0.5, LFNoise1.kr(0.1).range(0.2, 0.5)) + sig; // Simpler delay
    sig = GVerb.ar(sig, 300, 100, 0.7, 0.9, 15, drylevel: 0.4) * 0.5; // Huge, diffuse reverb
    sig = LPF.ar(sig, 1200); // Low-pass for a distant feel
    Pan2.ar(sig, LFNoise2.kr(1/15));
}.play;
)