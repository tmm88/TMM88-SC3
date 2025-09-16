(
{
	// 🎵 Core sound generation
	var baseFreq = 300 + (LFNoise1.kr(0.1!2, 50, 100).mean * SinOsc.kr(0.05, mul: 20)).softclip; // Wobbling, clipped base
	var fmMod1 = SinOsc.ar(LFNoise0.kr(0.5).range(40, 150), 0, LFNoise1.kr(0.3, 100, 150));
	var fmMod2 = SinOsc.ar(LFNoise0.kr(0.7).range(60, 200), 0, LFNoise1.kr(0.4, 120, 180));

	// 🥁 Complex polyrhythmic triggers
	var pulseA = LFPulse.kr(4.5, 0, 0.5) * Demand.kr(Dust.kr(0.5), 0, Dseq([1, 0, 1, 0, 1], inf));
	var pulseB = LFPulse.kr(6.1, 0, 0.3) * Demand.kr(Dust.kr(0.7), 0, Dseq([1, 1, 0, 0, 1, 0], inf));
	var pulseC = LFPulse.kr(7.8, 0, 0.2) * Demand.kr(Dust.kr(0.6), 0, Dseq([0, 1, 1, 0], inf));
	var pulseD = LFPulse.kr(8.5, 0, 0.4) * Demand.kr(Dust.kr(0.8), 0, Dseq([1, 0, 0, 1], inf));

	// 🔊 Synthesizer layers with more modulation
	var sig1 = SinOsc.ar(baseFreq + fmMod1) * pulseA;
	var sig2 = Saw.ar(baseFreq * 0.5 + fmMod2 * 1.5) * pulseB * 0.2;
	var ringMod = sig1 * SinOsc.ar(baseFreq * 0.75) * 0.3; // Ring modulation

	// 🌌 Detuned swarm and evolving formant
	var swarm = Mix.ar(SinOsc.ar(baseFreq * [1.01, 0.99, 1.03, 1.05, 0.97, 1.02, 0.98]) * 0.2); // Wider swarm
	var formantSig = Formant.ar(Saw.ar(baseFreq * 2.5), 500, LFNoise1.kr(0.15).range(50, 200), LFNoise1.kr(0.12).range(100, 250)) * pulseC * 0.12;

	// 🌬️ Evolving noise texture
	var noiseAtmo = HPF.ar(WhiteNoise.ar() * LFNoise1.kr(0.25).range(0.01, 0.08), 4000) +
					LPF.ar(BrownNoise.ar() * LFNoise1.kr(0.1).range(0.0, 0.05), 200);

	// 💥 Adding a gritty resonant filter sweep
	var filterSig = RLPF.ar(Saw.ar(baseFreq * 1.5), SinOsc.kr(0.1).range(500, 4000), 0.5) * pulseD * 0.15;

	// 🎧 Combining and processing the signal chain
	var sig = sig1 + sig2 + ringMod + swarm + formantSig + noiseAtmo + filterSig;
	sig = Pan2.ar(sig, LFNoise1.kr(0.25));

	// 🌊 Deeper spatial effects with layered delays
	sig = AllpassC.ar(sig, 0.8, [0.2, 0.25, 0.3, 0.4], 5) * 0.75;
	sig = CombC.ar(sig, 0.5, [0.1, 0.13, 0.15], 10) * 0.5;

	// 🌪️ More aggressive and dynamic distortion
	sig = (sig * 1.25).softclip + (sig * LFNoise1.kr(0.1, 0.5, 1)).distort; // Softclip + Distort combo

	// ✨ Richer pitch shifting and reverb
	sig = sig + (PitchShift.ar(sig, 0.5, [1.15, 1.25, 1.35], 0.05, 0.05) * 0.35).sum;
	sig = FreeVerb.ar(sig, 0.9, 0.95, 0.3) * 0.6;
	sig = Compander.ar(sig, sig, 0.4, 1, 0.3);
	sig * 0.4;
}.play;
)