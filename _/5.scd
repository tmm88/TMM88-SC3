(
{
    var numVoices = 6;
    var freqs, signals, pans, mods;

    freqs = Array.fill(numVoices, {
        TRand.kr(250, 1500, Dust.kr(Rand(2.0, 6.0)))
    });

    pans = Array.fill(numVoices, { LFNoise1.kr(0.1).range(-1, 1) });

    mods = Array.fill(numVoices, {
        SinOsc.kr(Rand(2.0, 10.0)).range(0.3, 1.0)
    });

    signals = Array.fill(numVoices, { |i|
        var sig = Pulse.ar(freqs[i], 0.4);
        sig = sig * mods[i] * 0.06;
        Pan2.ar(sig, pans[i]);
    });

    Mix.new(signals) * 0.9;
}.play;
)
