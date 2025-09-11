(
{
    var numVoices = 6;
    var freqs, signals, pans, dutyCycles;

    freqs = Array.fill(numVoices, {
        XLine.kr(
            TRand.kr(100, 500, Impulse.kr(1)),
            TRand.kr(600, 1800, Impulse.kr(0.5)),
            TRand.kr(2.0, 6.0)
        )
    });

    dutyCycles = Array.fill(numVoices, {
        LFNoise1.kr(0.2).range(0.2, 0.8)
    });

    pans = Array.fill(numVoices, { LFNoise2.kr(0.3).range(-1, 1) });

    signals = Array.fill(numVoices, { |i|
        var sig = LFPulse.ar(freqs[i], 0, dutyCycles[i]);
        sig = sig * 0.05;
        Pan2.ar(sig, pans[i]);
    });

    Mix.new(signals) * 0.8;
}.play;
)
