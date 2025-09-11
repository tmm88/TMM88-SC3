// Iteration 9: Multi-Band Resonant Processor
(
{
    var baseFreq = LFDNoise0.kr(3.14 * 4, 1800, 200).abs;
    var raw = Saw.ar(baseFreq) * 0.4;

    // Parallel filter bank with different characteristics
    var band1 = BPF.ar(raw, baseFreq * 0.5, 0.1, 3);
    var band2 = BRF.ar(raw, baseFreq * 1.2, 0.05, 2);
    var band3 = RLPF.ar(raw, baseFreq * 3.0, 0.3, 2);

    // Modulated spatialization
    var panMod = LFDNoise1.kr(0.3).range(-0.8, 0.8);
    var snd = [
        Pan2.ar(band1, panMod),
        Pan2.ar(band2, panMod.neg),
        Pan2.ar(band3, LFNoise2.kr(0.5))
    ];

    // Mix down with amplitude control
    snd = Mix.ar(snd) * 0.3;

    // Add subtle ambient reverb
    snd = FreeVerb.ar(snd, 0.2, 0.8, 0.4);
}.play;
)