(
// Prepare a simple loop buffer
b = Buffer.alloc(s, s.sampleRate * 4, 1); // 4 second buffer
// Record a simple chord into it (do this first, then stop recording)
// ...or use a synth to fill it:
{
    var source = Mix([Saw.ar(110, 0.1), Saw.ar(138.6, 0.1), Saw.ar(164.8, 0.05)]);
    RecordBuf.ar(source, b, loop: 1, doneAction: 2);
}.play;
)

// Now the drone:
(
{
    var rate = 1.0; // Playback rate
    var freqScale = 1.0; // Pitch
    var windowSize = 0.2; // Grain window size
    var env = 1; // Envelope ratio
    // The magic: a slowly moving pointer with random wobbles
    var pointer = LFNoise2.kr(0.05).range(0.1, 0.9);
    // Add a slow, subtle vibrato to the frequency
    var vib = SinOsc.kr(0.4, 0, 0.002, 1);

    var tape = Warp1.ar(
        1, // numChannels
        b.bufnum, // buffer
        pointer, // pos
        freqScale * vib, // rate with vibrato
        windowSize, // window size
        -1, // envbuf ( -1: uses a built-in window)
        8, // overlaps
        0.2 // output amplitude
    ) * 0.5;

    var noiseHiss = WhiteNoise.ar(LFPulse.kr(2, 0, 0.5, 0.01)); // Tape hiss
    var dust = Dust2.ar(0.3, 0.1); // Tape dropouts

    var sig = tape + noiseHiss + dust;
    sig = LPF.ar(sig, 6000);
    sig = AnalogTape.ar(sig, 0.2, 0.8, 0.1); // Apply a tape saturation effect (if you have the Quark)
    Pan2.ar(sig, LFNoise1.kr(0.1));
}.play;
)