(
// Extreme random sound generator using your OF UGens
SynthDef(\extremeRandomSound, { |out=0, amp=48, pan=0, freqMod=1, revMix=0.3, delayTime=0.2|
    var sources, source, modulated, distorted, delayed, reverbed, panned;

    // Your pool of sources
    sources = [OFNanite.ar, OFLoFM.ar, OFLFDorm.ar, OFDemWhite.ar,
               OFBromate.ar, OFDinocap.ar, OFDagal.ar, OFVesica.ar];

    // Random choice (must evaluate at audio rate explicitly)
    source = Select.ar(IRand(0, sources.size - 1), sources);

    // Frequency modulation chaos
    modulated = source * SinOsc.ar(freqMod).range(0.5, 1.5);

    // Extreme distortion (clip was wrong → use clip2 or tanh directly)
    distorted = (modulated * amp).tanh;

    // Add delay
    delayed = CombC.ar(distorted, 0.5, delayTime, 2);

    // Add reverb
    reverbed = FreeVerb.ar(delayed, revMix, 0.8, 0.5);

    // Stereo panning
    panned = Pan2.ar(reverbed, pan);

    // Output with limiter
    Out.ar(out, Limiter.ar(panned, 0.99));
}).add;
)

(
// Spawn routine with layered synths
{
    var numLayers = 3;
    var numSynthsPerLayer = 8;

    numLayers.do { |layer|
        numSynthsPerLayer.do {
            Synth(\extremeRandomSound, [
                \amp, rrand(40, 60),         // Wide amplitude range
                \pan, rrand(-1.0, 1.0),      // Random stereo placement
                \freqMod, exprand(0.1, 10.0), // Chaotic FM rate
                \revMix, rrand(0.1, 0.5),    // Reverb variation
                \delayTime, rrand(0.05, 0.3) // Delay variation
            ]);
            rrand(0.05, 0.2).wait; // Short random delay between spawns
        };
        1.wait; // Pause between layers
    };
}.fork;
)
