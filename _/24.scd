// Iteration 11: Granular Texture Engine
(
{
    var trigRate = LFDNoise1.kr(0.2).range(8, 40);
    var trig = Impulse.kr(trigRate);

    var basePitch = LFDNoise0.kr(0.1).range(36, 72).midicps;
    var pitchVar = LFDNoise2.kr(8).range(0.98, 1.02);

    var grainFreq = Demand.kr(trig, 0, Dwhite(basePitch * 0.5, basePitch * 2, inf));
    var grainDur = Demand.kr(trig, 0, Dwhite(0.05, 0.3, inf));

    // Granular synthesis
    var snd = GrainSin.ar(
        numChannels: 2,
        trigger: trig,
        dur: grainDur,
        freq: grainFreq * pitchVar,
        pan: WhiteNoise.kr(0.8),
        envbufnum: -1
    );

    // Spectral enhancement
    snd = snd + (BPF.ar(snd, 1200, 0.1) * 0.8);
    snd = snd * 0.4;
}.play;
)