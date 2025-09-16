(
{
	var base = 300 + LFNoise1.kr(0.15!2, 60, 120).mean + SinOsc.kr(0.04, mul: 25); // Smoother, deeper wobble
	var fm1 = SinOsc.ar(LFNoise0.kr(0.6).range(50, 160), 0, LFNoise1.kr(0.35, 120, 160));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.8).range(70, 220), 0, LFNoise1.kr(0.45, 140, 200));

	// Enhanced polyrhythmic pulses with more variation
	var pulseA = LFPulse.kr(4.7, 0, 0.45) * Demand.kr(Dust.kr(0.55), 0, Dseq([1, 0, 1, 0, 1, 1, 0], inf));
	var pulseB = LFPulse.kr(6.3, 0, 0.35) * Demand.kr(Dust.kr(0.75), 0, Dseq([1, 0, 0, 1, 1, 0, 1], inf));
	var pulseC = LFPulse.kr(8.1, 0, 0.25) * Demand.kr(Dust.kr(0.65), 0, Dseq([0, 1, 0, 1, 1, 0, 0], inf));
	var pulseD = LFPulse.kr(5.2, 0, 0.4) * Demand.kr(Dust.kr(0.4), 0, Dseq([1, 1, 0, 0, 1], inf)); // New pulse layer

	// Core synth layers with expanded ring modulation
	var sig1 = SinOsc.ar(base + fm1) * pulseA * 0.5;
	var sig2 = Saw.ar(base * 0.48 + fm2 * 1.7) * pulseB * 0.25;
	var ringMod = sig1 * SinOsc.ar(base * [0.74, 0.76]).mean * 0.35; // Dual-frequency ring mod

	// Denser swarm with slight phase modulation
	var swarm = SinOsc.ar([base * 1.02, base * 0.98, base * 1.04, base * 1.06, base * 0.96],
		phase: LFNoise1.kr(0.2!5, 0.1)) * 0.22;
	// Dynamic formant with modulated frequency
	var formantSig = Formant.ar(Saw.ar(base * 2.7 + LFNoise1.kr(0.2, 50)),
		600 + SinOsc.kr(0.1, mul: 100),
		LFNoise1.kr(0.18).range(60, 220),
		LFNoise1.kr(0.14).range(120, 280)) * pulseC * 0.15;

	// Noise with modulated filter for evolving texture
	var noiseAtmo = HPF.ar(WhiteNoise.ar(), 4000 + LFNoise1.kr(0.3, 2000)) * LFNoise1.kr(0.3).range(0, 0.1);

	// Combine signals with new pulseD modulation
	var sig = sig1 + sig2 + ringMod + swarm + formantSig + noiseAtmo + (SinOsc.ar(base * 0.5) * pulseD * 0.15);
	sig = Pan2.ar(sig, LFNoise1.kr(0.3));

	// Layered comb delays with modulated delay times
	sig = AllpassC.ar(sig, 0.9, [0.18, 0.23, 0.28, 0.33] * LFNoise1.kr(0.05).range(0.9, 1.1), 6) * 0.7;
	// Dynamic distortion with modulated intensity
	sig = (sig * LFNoise1.kr(0.12, 0.6, 1.2)).tanh * 0.85;
	// Triple pitch shift for richer harmonics
	sig = sig + (PitchShift.ar(sig, 0.6, [1.1, 1.2, 1.3], 0.04, 0.06) * 0.3).sum;
	// Lush reverb with modulated parameters
	sig = FreeVerb.ar(sig, 0.85, LFNoise1.kr(0.1).range(0.9, 1), 0.35) * 0.65;
	sig = Compander.ar(sig, sig, 0.35, 1, 0.25);
	sig * 0.45;
}.play;
)