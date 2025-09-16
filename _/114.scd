(
// Massive Iteration 3: Enhanced polyrhythmic chaos with expanded modulation and granular textures
{
	var base = 280 + LFNoise1.kr([0.08, 0.12], 70, 120).mean + SinOsc.kr([0.03, 0.07], mul: 25); // More complex wobbling base
	var fm1 = SinOsc.ar(LFNoise0.kr(0.6).range(35, 180), 0, LFNoise1.kr(0.4, 120, 180));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.9).range(50, 220), 0, LFNoise1.kr(0.5, 150, 200));
	var fm3 = LFTri.ar(LFNoise0.kr(0.3).range(0.2, 2), 0, LFNoise1.kr(0.2, 80, 120)); // Additional FM source

	// More complex polyrhythmic patterns with nested rhythms
	var pulseA = LFPulse.kr([4.3, 4.7], 0, [0.4, 0.6]) * Demand.kr(Dust.kr([0.4, 0.6]), 0, Dseq([1, 0, 1, 0, 1, 1, 0], inf));
	var pulseB = LFPulse.kr([5.9, 6.3], 0, [0.25, 0.35]) * Demand.kr(Dust.kr([0.5, 0.8]), 0, Dseq([1, 1, 0, 0, 1, 0, 1, 0], inf));
	var pulseC = LFPulse.kr([7.5, 8.1], 0, [0.15, 0.25]) * Demand.kr(Dust.kr([0.7, 0.4]), 0, Dseq([0, 1, 1, 0, 1, 0, 0], inf));
	var pulseD = LFPulse.kr([3.2, 3.8], 0, [0.3, 0.45]) * Demand.kr(Dust.kr(0.9), 0, Dseq([1, 0, 0, 1, 1], inf)); // Additional rhythm

	// Core synth layers with enhanced ring modulation
	var sig1 = SinOsc.ar(base + fm1) * pulseA;
	var sig2 = Saw.ar(base * [0.49, 0.51] + fm2 * 1.7) * pulseB * 0.25;
	var sig3 = Pulse.ar(base * 1.25 + fm3, LFNoise1.kr(0.2).range(0.2, 0.8)) * pulseD * 0.15; // Additional pulse oscillator

	// Multiple ring modulation layers
	var ringMod1 = sig1 * SinOsc.ar(base * [0.72, 0.78]) * 0.35;
	var ringMod2 = sig2 * LFTri.ar(base * 1.1 + fm3) * 0.2;

	// Expanded swarm with more detuning and movement
	var swarm = SinOsc.ar(
		(base * [0.96, 0.98, 1.01, 1.03, 1.05, 1.08]) +
		SinOsc.kr(0.1, 0, 5)
	) * 0.15 * LFNoise1.kr(0.2).range(0.7, 1.0);

	// More dynamic formant section
	var formantFreq = LFNoise1.kr(0.18).range(400, 800);
	var formantSig = Formant.ar(
		Saw.ar(base * [2.3, 2.7]),
		formantFreq,
		LFNoise1.kr(0.2).range(60, 250),
		LFNoise1.kr(0.15).range(120, 300)
	) * pulseC * 0.15;

	// Granular-inspired noise texture
	var noiseAtmo = HPF.ar(
		GrayNoise.ar() + BrownNoise.ar(0.3),
		LFNoise1.kr(0.3).range(3000, 8000)
	) * LFNoise1.kr(0.25).range(0, 0.1) * pulseA;

	// Additional texture: filtered chaotic impulses
	var impulses = RLPF.ar(
		Dust2.ar(LFNoise1.kr(0.15).range(5, 40)),
		LFNoise1.kr(0.2).range(800, 4000),
		0.3
	) * 0.2;

	var sig = sig1 + sig2 + sig3 + ringMod1 + ringMod2 + swarm + formantSig + noiseAtmo + impulses;
	sig = Splay.ar(sig, spread: 0.8, center: LFNoise1.kr(0.1));

	// Multi-tap delay for enhanced spatialization
	sig = AllpassC.ar(sig, 0.8, [0.15, 0.22, 0.3, 0.35], [4, 5, 6]) * 0.7;

	// Dynamic distortion with modulated intensity
	var distortionAmt = LFNoise1.kr(0.15).range(0.8, 1.5);
	sig = (sig * distortionAmt).tanh * 0.9;

	// Multi-voice pitch shifting with different rates
	var pitchShift1 = PitchShift.ar(sig, 0.2, [1.12, 1.18], 0.02, 0.04) * 0.4;
	var pitchShift2 = PitchShift.ar(sig, 0.3, [0.85, 0.92], 0.03, 0.05) * 0.3;
	sig = sig + pitchShift1 + pitchShift2;

	// Expanded reverb section with modulated parameters
	var revSig = GVerb.ar(
		sig,
		roomsize: LFNoise1.kr(0.08).range(40, 90),
		revtime: LFNoise1.kr(0.1).range(2.5, 4),
		damping: LFNoise1.kr(0.05).range(0.2, 0.6),
		spread: 50
	) * 0.5;

	sig = XFade2.ar(sig, revSig, LFNoise1.kr(0.2).range(-0.3, 0.3));
	sig = Compander.ar(sig, sig, 0.35, 1, 0.25, 0.01, 0.1);
	sig * 0.45;
}.play;
)