(
// First, create a buffer with some source material
b = Buffer.alloc(s, s.sampleRate * 2, 1);
b.sine2Msg([1, 1.5, 2.3, 3.4], [1, 0.6, 0.3, 0.1], true); // A harmonic-rich sound

{
    var trig = Dust.kr(LFNoise1.kr(0.1).range(5, 40)); // Random grain triggers
    var rate = LFNoise1.kr(0.15).range(0.4, 1.1);
    var pos = LFNoise2.kr(0.1).range(0, 1); // Slowly drift through the buffer
    var pan = WhiteNoise.kr(0.8); // Pan grains randomly
    var env = LFNoise1.kr(7).range(0.05, 0.2); // Grain size

    var gran = GrainBuf.ar(
        2, // numChannels
        trig, // trigger
        env, // grain duration
        b.bufnum, // buffer
        rate, // playback rate
        pos, // pos in buffer
        2, // interpolation
        pan, // pan
        -1 // grain envelope (-1: Hann window)
    ) * 0.4;

    var sub = LFSaw.ar(LFNoise1.kr(0.05).range(30, 32), 0, 0.1);

    var sig = gran + sub;
    sig = AllpassC.ar(sig, 0.2, [0.1, 0.15], 5) + sig;
    sig = LPF.ar(sig, 1500);
    Splay.ar(sig, 0.8, 1, 0, true) * 0.7;
}.play;
)