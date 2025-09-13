(
{
    var base = 80;
    var source = Mix.fill(4, { |i|
        Pulse.ar(base * (i+1) * LFNoise1.kr(0.1, 0.02, 1), 0.5, 0.05)
    });
    var chain = FFT(LocalBuf(2048), source); // Analyze the source
    // Randomly freeze and shift the spectrum
    chain = PV_MagFreeze(chain, LFNoise1.kr(0.1) > 0.7); // Freeze randomly
    chain = PV_BinShift(chain, LFNoise1.kr(0.05).range(0.9, 1.1)); // Stretch/Shift
    chain = PV_MagSmear(chain, LFNoise1.kr(0.2).range(0, 10)); // Smear the magnitudes

    var drone = IFFT(chain) * 0.7; // Convert back to audio

    var sig = drone;
    sig = GVerb.ar(sig, 150, 60, 0.9, 0.7, 45, drylevel:0.3) * 0.5 + (sig * 0.3);
    sig = LPF.ar(sig, 2000);
    Pan2.ar(sig, 0);
}.play;
)