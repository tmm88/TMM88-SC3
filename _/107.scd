(
// --- A Comprehensive Generative Drone Synthesizer for SuperCollider ---
//
// This script creates a complex, evolving soundscape using multiple layers of
// generative sound, including modulated triggers, diverse frequency sources,
// and dynamic spatial effects. It's designed for ambient and experimental music.
//
// Author: [Your Name]
// Date: September 2025
//
// ----------------------------------------------------------------------------
// SECTION 1: Master Control and Trigger Generation
// ----------------------------------------------------------------------------
// This section establishes the rhythmic and temporal foundation of the synth.
// Triggers are no longer just simple pulses; they are modulated and
// probabilistically controlled to create a sense of organic, non-linear rhythm.

(
// Master tempo in Beats Per Minute (BPM)
var bpm = 120;
var tempo = Impulse.kr(bpm / 60);

// Main rhythmic triggers derived from multiple, intertwined LFOs
var mainTrigRate = LFTri.kr(0.1).range(0.5, 3); // Main rate LFO
var mainTrig = Impulse.kr(mainTrigRate);

// Sub-rhythmic triggers for syncopated events
var subTrigRate = LFTri.kr(0.15).range(1, 4);
var subTrigProb = LFTri.kr(0.08).range(0.2, 0.8);
var subTrig = CoinGate.kr(subTrigProb, Impulse.kr(subTrigRate));

// Stochastic, "chaotic" triggers for sudden bursts of sound
var chaosTrigRate = LFTri.kr(0.2).range(1.0, 5.0);
var chaosTrig = Dust.kr(chaosTrigRate); // Dust.kr generates random impulses

// ----------------------------------------------------------------------------
// SECTION 2: Frequency and Data Sequences
// ----------------------------------------------------------------------------
// Frequencies are no longer static or purely random. They are sourced from
// musical scales and dynamically sequenced, providing harmonic structure.

// Define the musical scale (C minor pentatonic) and convert to frequencies (Hz)
var scale = [60, 62, 65, 67, 69, 70, 72, 74].midicps;
var scaleSequence = Dseq(scale.scramble, inf); // Shuffle the scale each loop

// Main polyphonic frequency source (4 voices)
var mainFreqs = Array.fill(4, { |i|
    var baseFreq = Demand.kr(mainTrig, 0, scaleSequence) * [1, 2, 0.5, 4][i % 4];
    var vibrato = SinOsc.kr(Rand(3, 7), Rand(0, 2pi)).range(0.995, 1.005);
    baseFreq * vibrato
});

// Sub-layer frequencies for harmonic drones
var subFreqs = Array.fill(3, { |i|
    Demand.kr(subTrig, 0, Dseq(mainFreqs.midicps, inf)) * [0.5, 1, 2][i % 3]
});

// Chaotic frequency layer with a wide, random range
var chaosFreqs = Array.fill(2, { |i|
    Demand.kr(chaosTrig, 0, Dexprand(40, 8000, inf)) // Exponential distribution for more high/low frequencies
});

// Data sequences for amplitude and filter modulation
var ampSequence = Demand.kr(mainTrig, 0, Dseq([0.8, 0.4, 0.6, 0.3, 0.9, 0.5], inf));
var filterCutoffMod = Demand.kr(mainTrig, 0, Dseq([0.1, 0.3, 0.25, 0.4, 0.15, 0.5, 0.2], inf));
var filterResMod = LFPulse.kr(0.1).range(0.1, 0.8);

// ----------------------------------------------------------------------------
// SECTION 3: Envelope and Oscillator Layers
// ----------------------------------------------------------------------------
// This section constructs the fundamental sound sources (oscillators) and
// shapes them with dynamic envelopes. The original simple envelopes are
// replaced with more expressive ones that react to the music.

// Envelopes for each layer
var mainEnv = Decay2.kr(mainTrig, 0.002, TExpRand.kr(0.5, 2.0, mainTrig));
var subEnv = EnvGen.kr(Env.perc(0.01, 1.5, 1, -4), subTrig); // Percussive decay envelope
var chaosEnv = EnvGen.kr(Env.perc(0.001, 0.3), chaosTrig);

// Main polyphonic voice: a blend of Saw, Pulse, and Sine waves
var mainSynth = Mix(mainFreqs.collect { |freq|
    var detune = LFNoise1.kr(0.1).range(0.99, 1.01);
    var pulseWidth = LFTri.kr(0.5).range(0.1, 0.9);
    (
        Saw.ar(freq * detune) * 0.4 +
        Pulse.ar(freq * detune, pulseWidth) * 0.3 +
        SinOsc.ar(freq * 0.5) * 0.2 // Add a sub-bass sine component
    )
});

// Sub-drone voice: slowly evolving, filtered square waves
var subSynth = Mix(subFreqs.collect { |freq|
    var filteredPulse = LPF.ar(Pulse.ar(freq, 0.5), freq * 2);
    filteredPulse * 0.2
});

// Chaotic voice: random bursts of noise and granular synthesis
var chaosSynth = Mix(chaosFreqs.collect { |freq|
    var fmMod = SinOsc.ar(freq * 1.618, 0, freq * 0.5); // FM modulation
    var amMod = LFTri.ar(Rand(5, 15)).range(0.5, 1.0); // AM modulation
    (
        SinOsc.ar(freq + fmMod) * amMod * 0.5 +
        Gendy1.ar(6, 6, 0.5, 0.5, freq, freq * 2,
            decay: chaosEnv * 0.2,
            durscale: 0.2) * 0.2 // Granular texture
    )
});

// ----------------------------------------------------------------------------
// SECTION 4: Processing and Effects Chain
// ----------------------------------------------------------------------------
// This is where the layers are combined and shaped. A dynamic filter,
// sophisticated distortion, and a parallel processing chain are used to
// create a rich, textured output.

// Combine all the sound layers
var combinedSignal = (mainSynth * mainEnv) * ampSequence +
                     (subSynth * subEnv) +
                     (chaosSynth * chaosEnv);

// Dynamic filter with modulated cutoff and resonance
var filterFreq = (mainFreqs[0] * 2 + (filterCutoffMod * 1000))
    .clip(200, 12000);
var filteredSignal = RLPF.ar(combinedSignal, filterFreq, filterResMod);

// Multi-stage distortion and saturation
var distorted = (filteredSignal * 2).tanh;
distorted = (distorted * 0.8).softclip;
var saturated = Limiter.ar(distorted * 0.5, 0.9);

// Parallel processing mix: a clean signal path and a distorted path
var parallelMix = (combinedSignal * 0.5) + (saturated * 0.5);

// ----------------------------------------------------------------------------
// SECTION 5: Spatialization and Final Output
// ----------------------------------------------------------------------------
// The final signal is sent through a multi-tap delay, chorus, and reverb to
// create a wide, immersive stereo field.

// Multi-tap delay with independent feedback controls
var delayFeedback = LFTri.kr(0.1).range(0.3, 0.6);
var delay1 = CombC.ar(parallelMix, 0.5, LFTri.kr(0.2).range(0.2, 0.4), delayFeedback);
var delay2 = CombC.ar(parallelMix, 0.5, LFTri.kr(0.15).range(0.3, 0.5), delayFeedback * 0.8);
var delayedSignal = (delay1 + delay2) * 0.3;

// Chorus effect for stereo widening
var chorus = Mix.fill(4, { |i|
    var delayTime = 0.02 * (i + 1) * LFNoise1.kr(0.1).range(0.9, 1.1);
    DelayC.ar(parallelMix, 0.1, delayTime) * 0.15
});

// Reverb with dynamically modulated parameters
var reverb = GVerb.ar(
    parallelMix,
    roomsize: LFTri.kr(0.08).range(0.6, 0.9),
    revtime: LFTri.kr(0.1).range(3.0, 6.0),
    damping: LFTri.kr(0.12).range(0.2, 0.5),
    drylevel: 0.3,
    earlyreflevel: 0.4,
    taillevel: 0.7
);

// Final mix and output limiting
var finalMix = (parallelMix * 0.8) + (delayedSignal * 0.6) + (chorus * 0.5) + (reverb * 0.4);
finalMix = Limiter.ar(finalMix, 0.95, 0.01);

// Final output
Out.ar(0, finalMix!2);

}.play;
)
