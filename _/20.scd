// Iteration 7: Modular Modulation Matrix
(
{
    var baseRate = 3.14 * 2;
    // Independent modulators for different parameters
    var freqMod = LFDNoise3.kr(baseRate * Rand(0.8, 1.2), 1200, 200).abs;
    var pulseMod = LFDNoise1.kr(baseRate * 0.3, 0.4, 0.5).abs;
    var fmIndexMod = LFDNoise2.kr(baseRate * 0.5, 3, 2).abs;

    // Complex oscillator with multiple modulation paths
    var fm = SinOsc.ar(freqMod * 0.5) * fmIndexMod;
    var snd = Pulse.ar(
        freq: freqMod.clip(80, 2000),       // Frequency modulation
        width: pulseMod.clip(0.1, 0.9),     // Pulse width modulation
        mul: 0.3
    );

    // Apply gentle filtering
    snd = MoogFF.ar(snd, freqMod * 1.5 + 800, 1.5);
    snd = snd * 0.4;
}.play;
)