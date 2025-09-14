(
{
// -------------------------------
// Control and Trigger Generators
// -------------------------------

// Master clock with tempo control (BPM)
var bpm = 120;
var clock = Impulse.kr(bpm/60);

// Modulate trigger rate with multiple LFOs
var lfoRate = LFNoise1.kr(0.2).range(1, 8);
var lfoRate2 = SinOsc.kr(0.15, pi/2).range(0.5, 4);
var mainTrig = Impulse.kr(lfoRate) + PulseDivider.kr(clock, 4, [0, 2]); // Sync some to clock

// Secondary, syncopated triggers with probability
var subTrigProb = Demand.kr(clock, 0, Dseq([0.7, 0.4, 0.9, 0.6], inf));
var subTrig = CoinGate.kr(subTrigProb, Impulse.kr(lfoRate * 0.75));

// Additional random burst triggers with different densities
var chaosTrig = Dust.kr([3, 1.5]); // Multiple densities
var percTrig = Dust.kr(0.5); // Occasional percussive elements

// -------------------------------
// Frequency Sources
// -------------------------------

// Scale-based frequencies instead of pure random
var scale = [60, 62, 65, 67, 69, 70, 72, 74].midicps; // C minor pentatonic
var scaleDemand = Dseq(scale.scramble, inf);

// Main frequency array (4 polyphonic voices)
var freqs = Array.fill(4, { |i|
    var baseFreq = Demand.kr(mainTrig, 0, scaleDemand) *
        [1, 2, 0.5, 4][i]; // Different octaves
    var randOffset = Demand.kr(mainTrig, 0, Dwhite(-2, 2, inf)).midiratio;
    baseFreq * randOffset
});

// Sub layer frequencies (3 voices) - more harmonic
var subFreqs = Array.fill(3, { |i|
    freqs[i % 4] / (2 ** (i + 1)) * LFNoise1.kr(0.1).range(0.99, 1.01)
});

// Chaos frequency layer with wider range
var chaosFreqs = Array.fill(2, {
    Demand.kr(chaosTrig, 0, Dexprand(40, 8000, inf))
});

// Percussive element frequencies
var percFreqs = [
    Demand.kr(percTrig, 0, Dwhite(200, 800, inf)),
    Demand.kr(percTrig, 0, Dexprand(80, 400, inf))
];

// -------------------------------
// Envelope Generators
// -------------------------------

var mainEnv = Decay2.kr(mainTrig, 0.002,
    TExpRand.kr(0.05, 1.2, mainTrig) * LFNoise1.kr(0.3).range(0.8, 1.2));

var subEnv = Decay2.kr(subTrig, 0.008,
    TExpRand.kr(0.1, 0.8, subTrig));

var chaosEnv = Decay2.kr(chaosTrig, 0.001,
    TExpRand.kr(0.05, 0.3, chaosTrig));

var percEnv = Decay2.kr(percTrig, 0.001, 0.1);

// -------------------------------
// Amplitude and Filter Sequences
// -------------------------------

var ampSeq = Demand.kr(mainTrig, 0,
    Dseq([0.8, 0.4, 0.6, 0.3, 0.9, 0.5], inf) *
    Dwhite(0.9, 1.1, inf));

var resSeq = Demand.kr(mainTrig, 0,
    Dseq([0.1, 0.3, 0.25, 0.4, 0.15, 0.5, 0.2], inf));

var filterMod = LFNoise2.kr(0.2).range(0.8, 1.5);

// -------------------------------
// Oscillator Layers
// -------------------------------

// Main voice with vibrato, saw/sine/pulse blend
var mainSig = Mix(freqs.collect { |freq, i|
    var vibrato = SinOsc.kr(Rand(3, 7), Rand(0, 2pi)).range(0.995, 1.005);
    var detune = LFNoise1.kr(0.1, 0.01, 1);
    var base = freq * vibrato * detune;
    var pulseWidth = SinOsc.kr(Rand(0.1, 0.5)).range(0.3, 0.7);

    (
        SinOsc.ar(base) * (0.3 / (i + 1)) +
        Saw.ar(base) * (0.25 / (i + 1)) +
        Pulse.ar(base, pulseWidth) * (0.15 / (i + 1))
    ) * LFNoise1.kr(0.2).range(0.9, 1.0)
});

// Sub voices using filtered square waves
var subSig = Mix(subFreqs.collect { |freq, i|
    var filteredPulse = LPF.ar(
        Pulse.ar(freq, LFNoise1.kr(0.1).range(0.4, 0.6)),
        freq * 4
    ) * (0.25 / (i + 1));
    filteredPulse * LFNoise1.kr(0.1).range(0.8, 1.0)
}) * subEnv;

// Chaos voices with FM and AM
var chaosSig = Mix(chaosFreqs.collect { |freq|
    var modIndex = chaosEnv * 5 + 0.5;
    var mod = SinOsc.ar(freq * 1.618, 0, freq * modIndex);
    var am = SinOsc.ar(Rand(5, 15), 0, 0.3, 0.7);
    Gendy1.ar(6, 6, 0.5, 0.5, freq * 0.5, freq * 2,
        decay: 0.1, durscale: 0.2) * 0.2 +
    SinOsc.ar(freq + mod) * am * 0.3
});

// Percussive elements
var percSig = Mix(percFreqs.collect { |freq|
    var env = percEnv * WhiteNoise.ar(1!2).abs;
    SinOsc.ar(freq) * env * 0.4
});

// -------------------------------
// Noise and Texture Layers
// -------------------------------

var pinkLayer = BPF.ar(
    PinkNoise.ar() * subEnv,
    freqs[0] * 2,
    0.3
) * 0.08;

var grainLayer = Gendy1.ar(6, 6, 0.8, 0.8, 200, 2000,
    decay: chaosEnv * 2) * chaosEnv * 0.1;

var crackleLayer = Crackle.ar(LFNoise1.kr(0.2).range(1.7, 1.95)) *
    chaosEnv * 0.07;

// -------------------------------
// Filter and Distortion
// -------------------------------

var combinedSig = mainSig + subSig + chaosSig + percSig +
                 pinkLayer + grainLayer + crackleLayer;

// Dynamic filter frequency modulation
var filterFreq = (freqs[0] * 1.5 * filterMod)
    .clip(100, 10000);

var filtered = MoogFF.ar(
    combinedSig,
    filterFreq,
    resSeq * 3.5,
    0
);

// Multi-stage distortion
var distorted = (filtered * 1.5).tanh;
distorted = (distorted * 0.8).softclip;
distorted = LeakDC.ar(distorted);

// Parallel processing
var clean = combinedSig * 0.4;
var processed = distorted * 0.6;

// Apply envelope and amp sequence with compression
var compressed = Compander.ar(
    clean + processed,
    clean + processed,
    thresh: 0.5,
    slopeBelow: 1,
    slopeAbove: 0.5,
    clampTime: 0.01,
    relaxTime: 0.1
);

var finalSig = compressed * mainEnv * ampSeq * 0.7;

// -------------------------------
// Spatial Effects
// -------------------------------

// Multi-tap delay with modulation
var delayTime1 = Demand.kr(mainTrig, 0, Dwhite(0.15, 0.35, inf));
var delayTime2 = delayTime1 * 1.618;
var delayMod = SinOsc.kr(0.17, [0, pi/2]).range(0.95, 1.05);

var delayed = [
    CombC.ar(finalSig, 0.5, delayTime1 * delayMod[0], 0.5),
    CombC.ar(finalSig, 0.5, delayTime2 * delayMod[1], 0.4)
] * 0.3;

// Chorus effect for width
var chorus = Mix.fill(4, { |i|
    var delay = 0.01 * (i + 1) * LFNoise1.kr(0.1).range(0.9, 1.1);
    DelayC.ar(finalSig, 0.1, delay) * 0.2
});

// Auto-panning with multiple LFOs
var panRate = [0.12, 0.18, 0.07];
var panDepth = Demand.kr(mainTrig, 0, Dwhite(0.4, 0.9, inf));
var panPos = [
    SinOsc.kr(panRate[0]).range(-1, 1),
    SinOsc.kr(panRate[1] + 0.1).range(-1, 1),
    SinOsc.kr(panRate[2] + 0.2).range(-1, 1)
].mean * panDepth;

var panned = Pan2.ar(finalSig + chorus + delayed, panPos);

// Reverb with modulated parameters
var revSize = LFNoise1.kr(0.1).range(0.7, 0.95);
var revDamp = LFNoise1.kr(0.15).range(0.3, 0.7);
var revDryWet = LFNoise1.kr(0.2).range(0.2, 0.4);

var reverb = GVerb.ar(
    panned,
    roomsize: revSize,
    revtime: revSize * 3,
    damping: revDamp,
    drylevel: 1 - revDryWet,
    earlyreflevel: revDryWet * 0.5,
    taillevel: revDryWet
).distort * 0.1;

// Final mix with limiter
var output = (panned * 0.8) + (reverb * 0.6);
output = Limiter.ar(output, 0.95, 0.01);

// Output
output;

}.play;
)