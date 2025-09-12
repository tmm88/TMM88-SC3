(
// Massive Iteration 3: Evolving textures with vocoder and frequency shifting
{
	var base = 300 + LFNoise1.kr(0.1!2, 50, 100).mean + LFTri.kr(0.08, mul: 30); // Triangular base modulation
	var fm1 = SinOsc.ar(LFNoise0.kr(0.5).range(40, 150), 0, LFNoise1.kr(0.3, 100, 150));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.7).range(60, 200), 0, LFNoise1.kr(0.4, 120, 180));

	// Intricate rhythmic patterns
	var pulseA = LFPulse.kr(4.5, 0, 0.5) * Demand.kr(Dust.kr(0.5), 0, Dseq([1, 0, 1, 0, 0, 1], inf));
	var pulseB = LFPulse.kr(6.1, 0, 0.3) * Demand.kr(Dust.kr(0.7), 0, Dseq([1, 1, 0, 0, 1, 1], inf));
	var pulseC = LFPulse.kr(7.8, 0, 0.2) * Demand.kr(Dust.kr(0.6), 0, Dseq([0, 1, 0, 1, 0], inf));

	// Core synth layers with additional FM
	var sig1 = SinOsc.ar(base + fm1 + SinOsc.ar(50, 0, 100)) * pulseA;
	var sig2 = Saw.ar(base * 0.5 + fm2 * 1.5) * pulseB * 0.25;

	// Dense swarm with vibrato
	var swarm = SinOsc.ar([base * 1.01, base * 0.99, base * 1.03, base * 1.04] + SinOsc.kr(0.2, mul: 5)) * 0.22;
	// Vocoder for vocal-like texture
	var vocoder = Vocoder.ar(Saw.ar(base * 2), PinkNoise.ar(), 16, LFNoise1.kr(0.2).range(0.1, 0.5)) * pulseC * 0.15;
	// Formant with dynamic formant frequencies
	var formantSig = Formant.ar(Saw.ar(base * 2.5), LFNoise1.kr(0.1).range(400, 700), LFNoise1.kr(0.1).range(50, 150), LFNoise1.kr(0.12).range(100, 200)) * pulseC * 0.1;

	// Evolving noise atmosphere
	var noiseAtmo = LPF.ar(BrownNoise.ar(), LFNoise1.kr(0.3).range(1000, 3000)) * LFNoise1.kr(0.2).range(0, 0.12);

	var sig = sig1 + sig2 + swarm + vocoder + formantSig + noiseAtmo;
	sig = Pan2.ar(sig, LFNoise1.kr(0.3));

	// Complex delay network
	sig = AllpassC.ar(sig, 0.8, [0.2, 0.25, 0.3, 0.35], 6) * 0.7;
	// Frequency shifting for surreal effect
	sig = sig + (FreqShift.ar(sig, LFNoise1.kr(0.2).range(-50, 50)) * 0.3);
	// Deep, evolving reverb
	sig = FreeVerb.ar(sig, 0.9, 1.0, 0.4) * 0.6;
	sig = Compander.ar(sig, sig, 0.4, 1, 0.3);
	sig * 0.38;
}.play;
)