(
// Iteration 4: Ethereal Hologram V2
{
	// Configuration
	var numVoices = 24; // Increased for richer texture
	var baseFreq = 1000 + LFNoise1.kr(0.15!numVoices, 400, 600).mean; // Smoother base frequency drift

	// Expanded FM modulation with layered oscillators
	var fm1 = SinOsc.ar(LFNoise0.kr(1.5).range(300, 1000), 0, LFNoise1.kr(0.4, 250, 500));
	var fm2 = LFTri.ar(LFNoise0.kr(2.5).range(200, 800)) * 350;
	var fm3 = BPF.ar(PinkNoise.ar(), 1000, 0.7) * LFPulse.kr(5.7, 0, 0.4) * 450;
	var fm4 = SinOsc.ar(LFNoise1.kr(0.3).range(50, 150)) * LFNoise1.kr(0.2).range(100, 300); // New low-frequency modulator

	// Complex pulse patterns with stochastic variations
	var pulseA = LFPulse.kr([7.8, 7.81], 0, LFNoise1.kr(0.12).range(0.2, 0.5));
	var pulseB = LFPulse.kr([8.9, 8.92], 0, LFNoise1.kr(0.18).range(0.3, 0.65)) *
		Demand.kr(Dust.kr(1.2), 0, Dseq([1, 0.3, 0.7, 0.9, 0.4], inf));
	var pulseC = LFPulse.kr(10.2, 0, 0.25) * Impulse.kr(LFNoise0.kr(0.2).range(0.2, 0.5));
	var pulseD = LFSaw.kr(6.5, 0, 0.3) * LFNoise1.kr(0.25).range(0.1, 0.4); // New rhythmic pulse

	// Core signals with enhanced modulation
	var sig1 = PMOsc.ar(baseFreq + fm1 + fm4, fm2, LFNoise1.kr(0.07).range(2.0, 5.0)) * pulseA * 0.28;
	var sig2 = Formant.ar(baseFreq * 0.55 + fm3, 2800, 700) * pulseB * 0.22;
	var sig3 = Gendy2.ar(5, 5, 1.0, 1.0, baseFreq/2.5, 0.2, 0.7, 0.7) * pulseC * 0.18;
	var sig4 = SinOscFB.ar(baseFreq * 1.2 + fm4, LFNoise1.kr(0.1).range(0.5, 1.5)) * pulseD * 0.15; // New feedback oscillator

	// Expanded swarm with detuned oscillators and micro-variations
	var swarm = Mix.fill(48, { |i|
		var detune = (i-24) * LFNoise1.kr(0.25).range(0.002, 0.01);
		var freq = baseFreq * (1 + detune);
		var mod = LFNoise1.kr(0.2).range(0.01, 0.06);
		Pan2.ar(SinOsc.ar(freq) * mod, LFNoise1.kr(0.3).range(-0.8, 0.8))
	}) * 0.8;

	// Enhanced granular cloud with dynamic parameters
	var grain = GrainFM.ar(
		numChannels: 2,
		trigger: Impulse.kr(LFNoise1.kr(0.25).range(12, 24)),
		dur: LFNoise1.kr(0.35).range(0.08, 0.25),
		carfreq: baseFreq * LFNoise1.kr(0.15).range(0.6, 1.4),
		modfreq: LFNoise1.kr(0.3).range(1.2, 7.0),
		modindex: LFNoise1.kr(0.2).range(0.5, 1.5),
		pan: LFNoise1.kr(0.4).range(-0.7, 0.7)
	) * 0.35;

	// Resonant comb filtering with evolving delays
	var spec = CombC.ar(swarm + grain, 0.9,
		{LFNoise1.kr(0.08).exprange(0.006, 0.05)}!8,
		{LFNoise1.kr(0.06).range(3.0, 6.0)}!8
	) * 0.7;

	// Additional resonant filter for warmth
	var resFilter = RLPF.ar(spec, LFNoise1.kr(0.1).exprange(800, 2000), 0.3) * 0.6;

	// Combine all signals
	var sig = sig1 + sig2 + sig3 + sig4 + swarm + grain + spec.sum + resFilter;

	// Spatialize with 8-channel ambisonics
	sig = SplayAz.ar(8, sig, spread: LFNoise1.kr(0.05).range(0.8, 1.2), center: LFNoise1.kr(0.03).range(-0.5, 0.5));

	// Evolving delay matrix with feedback
	sig = AllpassC.ar(sig, 1.2,
		{LFNoise1.kr(0.08).exprange(0.04, 0.5)}!8,
		{LFNoise1.kr(0.04).range(2.5, 6.5)}!8
	) * 0.75;

	// Dual pitch-shifting for harmonic depth
	sig = sig + (PitchShift.ar(sig, 0.25, [0.4, 1.6], 0.04, 0.1) * 0.25);

	// Convolution reverb with dynamic impulse response
	sig = PartConv.ar(sig, 4096, LFNoise1.kr(0.05).range(0.5, 1.5)) * 0.55 + (sig * 0.35);

	// Dynamic compression and limiting
	sig = Compander.ar(sig, sig, 0.4, 1, 0.25, 0.01, 0.1);
	sig = Limiter.ar(sig, 0.85);

	// Final output with subtle amplitude modulation
	sig = sig * LFNoise1.kr(0.03).range(0.7, 1.0);
	sig.sum * 0.45;
}.play;
)