(
{
    var numVoices = 6;
    var freqs, signals, pans;

    // Random frequencies that change over time
    freqs = Array.fill(numVoices, {
        XLine.kr(
            TRand.kr(150, 300, Impulse.kr(0.5)),  // start
            TRand.kr(800, 2000, Impulse.kr(0.25)), // end
            TRand.kr(0.5, 4.0, Impulse.kr(0.3)),
			doneAction:2// duration
        )
    });

    // Stereo pan positions per voice
    pans = Array.fill(numVoices, { LFNoise1.kr(0.2).range(-1.0, 1.0) });

    // Pulse oscillators
    signals = Array.fill(numVoices, { |i|
        var sig = Pulse.ar(freqs[i], 0.5); // 50% duty cycle
        sig = sig * 0.05; // Adjust gain
        Pan2.ar(sig, pans[i]);
    });

	Mix.new(GVerb.ar(signals)) * 0.8;
}.play;
)
