(
// Massive Iteration 4: Immersive Swarm Synth with Adaptive Spectral Flow
{
	// Base frequency with smooth stochastic drift
	var baseFreq = 220 + LFNoise1.kr(0.08!5, 90, 180).mean;
	var modDepth = 0.6;

	// Frequency modulators with evolving timbres
	var fm1 = SinOsc.ar(LFNoise0.kr(0.35).range(50, 200), 0, LFNoise1.kr(0.25, 80, 150) * modDepth);
	var fm2 = SinOsc.ar(LFNoise0.kr(0.55).range(25, 160), 0, LFNoise1.kr(0.3, 110, 190) * modDepth);
	var fm3 = SinOsc.ar(LFNoise0.kr(0.45).range(35, 130), 0, LFNoise1.kr(0.35, 55, 100) * modDepth);

	// Polyrhythmic pulses with probabilistic variation
	var pulseA = LFPulse.kr(5.8, 0, 0.3) * Demand.kr(Dust.kr(0.8), 0, Dseq([1, 0.7, 1, 0.3], inf));
	var pulseB = LFPulse.kr(4.3, 0, 0.25) * Demand.kr(Dust.kr(0.6), 0, Dseq([1, 0.4, 0.9, 1], inf));

	// Core signal generation with rich modulation
	var sig1 = SinOsc.ar(baseFreq + fm1 + fm2, 0, 0.5) * pulseA;
	var sig2 = Saw.ar(baseFreq * 0.65 + fm3, 0.15) * pulseB;

	// Dense swarm with 11 detuned oscillators and micro-modulation
	var swarm = Mix.fill(11, { |i|
		var detune = (i - 5) * 0.002;
		var ampMod = LFNoise1.kr(0.15).range(0.6, 1.0);
		SinOsc.ar(baseFreq * (1 + detune), 0, 0.07 * ampMod)
	});

	// Granular cloud with dynamic density and texture
	var grainTrig = Impulse.kr(LFNoise0.kr(0.25).range(15, 25));
	var grain = GrainIn.ar(2, grainTrig, 0.07, BrownNoise.ar(0.35), LFNoise1.kr(0.2).range(-0.8, 0.8)) * 0.28;

	// Spectral sculpting with adaptive filter bank
	var filterFreqs = [350, 900, 2000, 3600];
	var filterRqs = [0.12, 0.15, 0.1, 0.18];
	var spec = BPF.ar(swarm + grain, filterFreqs, filterRqs).sum * 0.4;

	// Combine core signals
	var sig = sig1 + sig2 + swarm + grain + spec;

	// Adaptive spatialization with smooth panning
	var panPos = LFNoise1.kr(0.18).range(-0.6, 0.6);
	sig = Pan2.ar(sig, panPos);

	// Modulated delay network with feedback variation
	var delayTime = LFNoise1.kr(0.12).range(0.04, 0.3);
	sig = CombC.ar(sig, 0.6, delayTime, 2.8) * 0.75;

	// Harmonic layering with fifths, octaves, and subtle distortion
	var pitchShift = PitchShift.ar(sig, 0.2, [1.5, 2.0], 0.008, 0.015) * 0.18;
	sig = sig + pitchShift.sum + (sig * 0.05).tanh;

	// Deep reverb for immersive depth
	sig = GVerb.ar(sig, 70, 6.5, 0.55, 0.65, 18, -5, 0.45, 0.25) * 0.32;

	// Dynamic range control with smooth compression
	sig = Compander.ar(sig, sig, 0.28, 1, 0.35, 0.01, 0.03);

	// Final output with balanced gain
	sig * 0.42;
}.play;
)