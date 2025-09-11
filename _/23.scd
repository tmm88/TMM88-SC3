// Iteration 10: Phase Modulation & Waveshaping Complex
(
{
    var modRate = 3.14 * 2.5;

    // Multi-stage modulation
    var carrierFreq = LFDNoise1.kr(modRate * 0.3, 300, 320).abs;
    var mod1Freq = LFDNoise0.kr(modRate, 2.0, 3.0).abs;
    var mod2Depth = LFDNoise2.kr(modRate * 0.7, 0.8, 1.2).abs;

    // Phase modulation synthesis
    var modulator = SinOsc.ar(carrierFreq * mod1Freq) * mod2Depth * 2pi;
    var snd = SinOsc.ar(carrierFreq, modulator, 0.5);

    // Waveshaping distortion
    snd = (snd * 2.0).distort * 0.5;

    // Dynamic filtering
    var filterFreq = LFDNoise1.kr(modRate * 0.5, 800, 1000).abs;
    snd = RLPF.ar(snd, filterFreq, 0.3);

    snd = snd * 0.3;
}.play;
)