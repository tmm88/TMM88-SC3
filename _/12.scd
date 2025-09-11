(
{
    var numVoices = 20;
    var duration = 60;
    var masterAmp = 0.015;

    var system = Mix.fill(numVoices, { |i|
        var baseFreq = TChoose.kr(
            Dust.kr(rrand(0.01, 0.1)),
            [exprand(40, 200), exprand(300, 1000), exprand(1500, 6000)]
        );

        var freqDrift = LFNoise2.kr(rrand(0.005, 0.1), rrand(0.1, 0.8));
        var freq = baseFreq * (1 + freqDrift);

        var ampPattern = EnvGen.kr(Env(
            levels: [0, 1, rrand(0.3, 0.8), 0],
            times: [rrand(2, 10), rrand(5, 20), rrand(10, 30)],
            curve: \exp
        ));

        var modMatrix = [
            SinOsc.kr(rrand(0.01, 0.5), 0, rrand(0.1, 0.4)),
            LFNoise1.kr(rrand(0.1, 2), rrand(0.05, 0.2)),
            Pulse.kr(rrand(0.2, 3), rrand(0.3, 0.7), rrand(0.1, 0.3))
        ].wchoose([0.5, 0.3, 0.2]);

        var oscillator = SelectX.ar(
            rrand(0.3, 0.7),
            [
                Saw.ar(freq),
                Pulse.ar(freq, rrand(0.1, 0.9)),
                SinOsc.ar(freq * 0.99)
            ]
        );

        var filterEnv = EnvGen.kr(Env([rrand(0.1, 0.5), 1.0, rrand(0.3, 0.7)], [duration * 0.4, duration * 0.6]));
        var filtered = RLPF.ar(oscillator, freq * filterEnv * rrand(1.5, 6.0), rrand(0.1, 0.7));

        var spatialMove = LFNoise1.kr(rrand(0.05, 0.3));
        var delayNetwork = AllpassC.ar(filtered, 0.5, [0.1, 0.15, 0.23], rrand(1.5, 3.0)).mean;

        Pan2.ar((filtered * 0.6 + delayNetwork * 0.4) * ampPattern * modMatrix, spatialMove) * masterAmp;
    });

    system * EnvGen.kr(Env([0, 1, 1, 0], [5, duration - 10, 5]));
}.play;
)