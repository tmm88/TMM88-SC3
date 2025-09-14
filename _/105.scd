(
{
    // -------------------------------
    // Control and Trigger Generators
    // -------------------------------

    // Modulate trigger rate with a slow LFO
    var lfoRate = SinOsc.kr(0.2).range(1, 7); 
    var mainTrig = Impulse.kr(lfoRate);

    // Secondary, syncopated triggers
    var subTrig = Impulse.kr(lfoRate * 0.5);

    // Additional random burst trigger
    var chaosTrig = Dust.kr(3); // Sparse, random bursts

    // -------------------------------
    // Frequency Sources
    // -------------------------------

    // Main frequency array (4 polyphonic voices)
    var freqs = Array.fill(4, {
        Demand.kr(mainTrig, 0, Dwhite(120, 2400, inf))
    });

    // Sub layer frequencies (3 voices)
    var subFreqs = Array.fill(3, {
        Demand.kr(subTrig, 0, Dwhite(40, 300, inf))
    });

    // Chaos frequency layer
    var chaosFreqs = Array.fill(2, {
        Demand.kr(chaosTrig, 0, Dwhite(80, 6000, inf))
    });

    // -------------------------------
    // Envelope Generators
    // -------------------------------

    var mainEnv = Decay2.kr(mainTrig, 0.005, TExpRand.kr(0.1, 0.5, mainTrig));
    var subEnv = Decay2.kr(subTrig, 0.01, TExpRand.kr(0.08, 0.4, subTrig));
    var chaosEnv = Decay2.kr(chaosTrig, 0.003, 0.15);

    // -------------------------------
    // Amplitude and Filter Sequences
    // -------------------------------

    var ampSeq = Demand.kr(mainTrig, 0, Dseq([0.6, 0.3, 0.8, 0.2], inf));
    var resSeq = Demand.kr(mainTrig, 0, Dseq([0.1, 0.3, 0.25, 0.4, 0.15], inf));

    // -------------------------------
    // Oscillator Layers
    // -------------------------------

    // Main voice with vibrato, saw/sine blend
    var mainSig = Mix(freqs.collect { |freq, i|
        var vibrato = SinOsc.kr(4 + Rand(0.1, 0.6)).range(0.98, 1.02);
        var base = freq * vibrato;
        (
            SinOsc.ar(base) * (0.4 / (i + 1)) +
            Saw.ar(base) * (0.2 / (i + 1))
        )
    });

    // Sub voices using square waves
    var subSig = Mix(subFreqs.collect { |freq|
        Pulse.ar(freq, Rand(0.3, 0.7)) * 0.2
    }) * subEnv;

    // Chaos voices with FM
    var chaosSig = Mix(chaosFreqs.collect { |freq|
        var mod = SinOsc.ar(freq * 1.5, 0, freq * 0.25);
        SinOsc.ar(freq + mod) * 0.25
    }) * chaosEnv;

    // -------------------------------
    // Noise and Texture Layers
    // -------------------------------

    var pinkLayer = PinkNoise.ar() * subEnv * 0.06;
    var grainLayer = Crackle.ar(1.9) * chaosEnv * 0.05;

    // -------------------------------
    // Filter and Distortion
    // -------------------------------

    var combinedSig = mainSig + subSig + chaosSig + pinkLayer + grainLayer;

    // Dynamic filter frequency modulation
    var filterFreq = freqs[0] * 2 * SinOsc.kr(0.1).range(0.4, 1.5);
    var filtered = RLPF.ar(combinedSig, filterFreq, resSeq);

    // Soft distortion with modulation
    var distorted = (filtered * 1.2).tanh * SinOsc.kr(0.1).range(0.2, 0.5);

    // Mix pre- and post-filter/distortion layers
    var postFX = (combinedSig * 0.4) + (distorted * 0.6);

    // Apply envelope and amp sequence
    postFX = postFX * mainEnv * ampSeq * 0.6;

    // -------------------------------
    // Spatial Effects
    // -------------------------------

    // Random delay time
    var delayTime = Demand.kr(mainTrig, 0, Dwhite(0.1, 0.4, inf));
    var delayed = CombC.ar(postFX, 0.5, delayTime, 0.4) * 0.3;

    // Smooth stereo auto-panning
    var panPos = SinOsc.kr(0.3).range(-1.0, 1.0) * Demand.kr(mainTrig, 0, Dwhite(0.3, 1.0, inf));
    var panned = Pan2.ar(postFX + delayed, panPos);

    // Reverb with subtle modulated room size
    var reverb = FreeVerb.ar(panned, mix: 0.35, room: SinOsc.kr(0.05).range(0.6, 0.9), damp: 0.5);

    // Output
    reverb;
}.play;
)
