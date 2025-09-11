// Iteration 4: Richer texture
(
{
    var baseFreq = LFDNoise0.kr(3.14*3, 800, 100).abs;
    var snd = [
        SinOsc.ar(baseFreq),            // Sine wave (fundamental)
        Saw.ar(baseFreq * 0.99),        // Detuned Saw wave
        Pulse.ar(baseFreq * 1.01, 0.4)  // Detuned Pulse wave
    ];
    Splay.ar(snd) * 0.2; // Spread them out and reduce volume
}.play;
)