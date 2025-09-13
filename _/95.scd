(
{
    var chaos = {LFNoise2.kr(0.1).range(0.1, 10)}!8; // Array of chaotic rates
    var modFreq = 55 * chaos; // Multiply by chaos for FM
    var modIndex = LFNoise1.kr(0.2).range(10, 100); // Dynamic modulation index

    var carriers = [60, 61.5, 90, 121.5]; // Slightly detuned carriers
    var fmOps = carriers.collect { |cfreq|
        var modulator = SinOsc.ar(modFreq.choose, 0, modIndex);
        SinOsc.ar(cfreq + modulator, 0, 0.1)
    };

    var drone = Mix(fmOps);
    var sub = SinOsc.ar(30, 0, 0.15);

    var sig = drone + sub;
    // A resonant filter that also modulates
    sig = RLPF.ar(sig, LFNoise1.kr(0.15).range(200, 2000), LFNoise1.kr(0.1).range(0.1, 0.7));
    sig = (sig * 10).tanh * 0.2; // Soft clipping distortion
    sig = Greyhole.ar(sig, 0.5, 0.7, 4.0, 0.707, 0.6); // Alternative delay/reverb
    Splay.ar(sig, 0.5, 0.7);
}.play;
)