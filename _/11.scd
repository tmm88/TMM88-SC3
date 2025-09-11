(
{
    var numVoices = 16;
    var duration = 60;
    var masterAmp = 0.01;

    var ecosystem = Mix.fill(numVoices, { |i|
        // Frequency ecosystem with inter-voice communication
        var baseFreq = exprand(30, 8000);
        var freqEnv = EnvGen.kr(Env(
            [baseFreq, baseFreq * rrand(0.25, 4.0), baseFreq * rrand(0.5, 2.0)],
            [duration * 0.4, duration * 0.6],
            \sin
        ));

        // Complex modulation network
        var modBus = LocalIn.kr(1, 0) + 0.01;
        LocalOut.kr(SinOsc.kr(rrand(0.01, 0.2)) * 0.9);

        var chaoticMod = HenonN.ar(
            SampleRate.ir() / rrand(1000, 4000),
            rrand(1.1, 1.4),
            rrand(0.2, 0.3),
            rrand(0.1, 0.5)
        );

        // Multi-stage oscillator
        var carrier = Saw.ar(freqEnv * (1 + (chaoticMod * 0.1 * modBus)));
        var modulator = SinOsc.ar(freqEnv * rrand(0.99, 1.01) * rrand(1, 4), 0, rrand(0.5, 2.0));
        var pmOsc = PMOsc.ar(freqEnv, freqEnv * rrand(0.5, 2.0), modulator, 0, carrier);

        // Dynamic spectral processing
        var spectralGate = CompanderD.ar(pmOsc, 0.1, 0.5, 4, 0.01, 0.1);
        var formantShift = PitchShift.ar(spectralGate, 0.2, rrand(0.5, 2.0), 0, 0.01);

        // Advanced spatialization
        var binaural = Rotate2.ar(formantShift, formantShift * 0.7, SinOsc.kr(rrand(0.05, 0.2)));
        var ambisonic = PanAz.ar(4, binaural, LFNoise1.kr(rrand(0.1, 0.5)), 1, 2, 0.5);

        // Multi-tap delay with feedback network
        var delayTimes = [0.1, 0.23, 0.37, 0.53] * rrand(0.8, 1.2);
        var delayFb = 0.7;
        var delayed = CombN.ar(ambisonic, 1.0, delayTimes, delayTimes * 4).sum;

        // Environmental effects
        var naturalDecay = EnvGen.kr(Env.perc(rrand(0.5, 3.0), duration * 0.9, 1, -4));
        var weather = BrownNoise.ar(0.02) * LFNoise1.kr(0.1);

        (delayed * 0.4 + ambisonic * 0.6 + weather) * naturalDecay * masterAmp;
    });

    // Master processing
    var compressed = Compander.ar(ecosystem, ecosystem, 0.1, 1, 0.5, 0.01, 0.1);
    var final = FreeVerb.ar(compressed, 0.3, 0.8, 0.5);

    final * EnvGen.kr(Env([0, 1, 1, 0], [8, duration - 16, 8]));
}.play;
)