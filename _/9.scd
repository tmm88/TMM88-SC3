(
{
    var numVoices = 32;
    var duration = 60;
    var masterAmp = 0.03;

    Mix.fill(numVoices, { |i|
        var baseFreq = exprand(80, 8000);
        var driftAmt = rrand(0.8, 1.2);
        var freqEnv = Line.kr(baseFreq, baseFreq * driftAmt, duration * rrand(0.8, 1.5));

        var lfoRate = rrand(0.05, 6);
        var lfoDepth = rrand(0.1, 0.3);
        var ampLFO = LFNoise1.kr(lfoRate, lfoDepth, 0.01);

        var formantFreq = rrand(200, 1200);
        var formantQ = rrand(0.7, 3.0);
        var filtered = BPF.ar(Saw.ar(freqEnv), formantFreq, formantQ.reciprocal);

        var panPos = LFNoise1.kr(rrand(0.1, 0.5));
        var env = EnvGen.kr(Env.perc(rrand(0.1, 2.0), duration * 0.9));

        Pan2.ar(filtered * ampLFO * env, panPos) * masterAmp;
    });
}.play;
)