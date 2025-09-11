(
{
    var numVoices = 28;
    var duration = 60;
    var masterAmp = 0.02;

    Mix.fill(numVoices, { |i|
        var fundamental = exprand(60, 1000);
        var harmonic = fundamental * rrand(1, 16).round(1);
        var freqEnv = XLine.kr(harmonic, harmonic * rrand(0.5, 2.0), duration);

        var pmFreq = rrand(0.1, 20);
        var pmIndex = rrand(0.1, 3.0);
        var phaseMod = SinOsc.ar(pmFreq, 0, pmIndex);

        var saw = Saw.ar(freqEnv + phaseMod);

        var spectralEnv = EnvGen.kr(Env.new(
            [rrand(0.1, 0.5), 1.0, rrand(0.2, 0.6)],
            [duration * 0.3, duration * 0.7],
            \exp
        ));

        var resonator = Klank.ar(
            `[
                Array.fill(8, { exprand(200, 8000) }),
                Array.fill(8, { rrand(0.1, 0.5) }),
                Array.fill(8, { rrand(0.5, 2.0) })
            ],
            saw
        ) * 0.3;

        var spatial = GVerb.ar(resonator, roomsize: rrand(10, 80), revtime: rrand(1, 3));
        var pan = VarLag.kr(LFNoise0.kr(rrand(0.05, 0.2)), 2.0);

        Pan2.ar((saw * 0.7 + resonator * 0.3) * spectralEnv, pan) * masterAmp;
    });
}.play;
)