(
{
    var numVoices = 6;
    var freqs, signals, pans, gates;

    freqs = Array.fill(numVoices, {
        TRand.kr(200, 1800, Impulse.kr(4 + Rand(0.0, 2.0)))
    });

    pans = Array.fill(numVoices, { LFNoise1.kr(0.5).range(-1, 1) });

    gates = Array.fill(numVoices, {
        LFPulse.kr(Rand(2, 8), 0, Rand(0.2, 0.6)) // rhythmic gates
    });

    signals = Array.fill(numVoices, { |i|
        var sig = Pulse.ar(freqs[i], 0.5);
        sig = sig * gates[i] * 0.06;
        Pan2.ar(sig, pans[i]);
    });

    Mix.new(signals) * 0.9;
}.play;
)
