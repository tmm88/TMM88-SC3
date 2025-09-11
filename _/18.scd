// Iteration 5: FM Synthesis
(
{
    var modFreq = LFDNoise0.kr(0.5, 500, 600).abs; // Slower modulation rate
    var carrierFreq = 200;
    // Simple 2-operator FM: modulator -> carrier
    PMOsc.ar(
        carrierFreq,        // Carrier Frequency
        modFreq,            // Modulation Frequency
        pmindex: 4          // Modulation Index (controls intensity)
    ) * 0.3;
}.play;
)