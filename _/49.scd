(
// Massive Iteration 2: Polyrhythmic chaos with ring modulation and distortion
{
	var base = 300 + LFNoise1.kr(0.1!2, 50, 100).mean + SinOsc.kr(0.05, mul: 20); // Wobbling base
	var fm1 = SinOsc.ar(LFNoise0.kr(0.5).range(40, 150), 0, LFNoise1.kr(0.3, 100, 150));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.7).range(60, 200), 0, LFNoise1.kr(0.4, 120, 180));

	// Complex polyrhythmic pulses
	var pulseA = LFPulse.kr(4.5, 0, 0.5) * Demand.kr(Dust.kr(0.5), 0, Dseq([1, 0, 1, 0, 1], inf));
	var pulseB = LFPulse.kr(6.1, 0, 0.3) * Demand.kr(Dust.kr(0.7), 0, Dseq([1, 1, 0, 0, 1, 0], inf));
	var pulseC = LFPulse.kr(7.8, 0, 0.2) * Demand.kr(Dust.kr(0.6), 0, Dseq([0, 1, 1, 0], inf));

	// Core synth layers with ring modulation
	var sig1 = SinOsc.ar(base + fm1) * pulseA;
	var sig2 = Saw.ar(base * 0.5 + fm2 * 1.5) * pulseB * 0.2;
	var ringMod = sig1 * SinOsc.ar(base * 0.75) * 0.3; // Ring modulation layer

	// Dense swarm with more detuning
	var swarm = SinOsc.ar([base * 1.01, base * 0.99, base * 1.03, base * 1.05, base * 0.97]) * 0.2;
	// Formant with modulated bandwidth
	var formantSig = Formant.ar(Saw.ar(base * 2.5), 500, LFNoise1.kr(0.15).range(50, 200), LFNoise1.kr(0.12).range(100, 250)) * pulseC * 0.12;

	// Noise with high-pass filter for airiness
	var noiseAtmo = HPF.ar(WhiteNoise.ar(), 4000) * LFNoise1.kr(0.25).range(0, 0.08);

	var sig = sig1 + sig2 + ringMod + swarm + formantSig + noiseAtmo;
	sig = Pan2.ar(sig, LFNoise1.kr(0.25));

	// Multiple comb delays for spatial depth
	sig = AllpassC.ar(sig, 0.8, [0.2, 0.25, 0.3], 5) * 0.75;
	// Subtle distortion for warmth
	sig = (sig * LFNoise1.kr(0.1, 0.5, 1)).softclip * 0.8;
	// Dual pitch shift for harmonic richness
	sig = sig + (PitchShift.ar(sig, 0.5, [1.15, 1.25], 0.05, 0.05) * 0.35).sum;
	// Deep reverb
	sig = FreeVerb.ar(sig, 0.9, 0.95, 0.3) * 0.6;
	sig = Compander.ar(sig, sig, 0.4, 1, 0.3);
	sig * 0.4;
}.play;
)