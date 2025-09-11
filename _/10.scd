(
{
    var numVoices = 24;
    var duration = 60;
    var masterAmp = 0.025;

    Mix.fill(numVoices, { |i|
        var baseFreq = exprand(50, 6000);
        var freqMod = LFNoise2.kr(rrand(0.01, 0.2), rrand(0.1, 0.5));
        var freq = baseFreq * (1 + freqMod);

        var trigRate = rrand(0.5, 8);
        var trig = Dust.kr(trigRate);
        var gate = Trig.kr(trig, rrand(0.1, 0.5));

        var ampEnv = EnvGen.kr(Env.perc(0.001, rrand(0.2, 2.0)), gate);
        var ampLFO = SinOsc.kr(rrand(0.1, 4), i * 0.3, rrand(0.1, 0.25));

        var saw = Saw.ar(freq, ampLFO * ampEnv);
        var filtered = MoogFF.ar(saw, freq * rrand(1.5, 4.0), rrand(1.5, 3.0));

        var pan = LFNoise1.kr(rrand(0.2, 1.0));
        var delay = CombC.ar(filtered, 0.2, rrand(0.01, 0.1), rrand(0.1, 0.8));

        Pan2.ar(filtered + (delay * 0.3), pan) * masterAmp;
    });
}.play;
)