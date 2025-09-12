(
// Iteration 2: Quantum Chromatic Aberration
{
	var numVoices = 16;
	var base = 1800 + LFNoise1.kr(0.3!numVoices, 600, 800).mean; // High frequency base

	// Chaotic FM modulators in audio rate
	var fm1 = SinOsc.ar(LFNoise0.kr(3).range(800, 2500), 0, LFNoise1.kr(0.4, 300, 500));
	var fm2 = LFSaw.ar(LFNoise0.kr(4).range(500, 1500)) * 400;
	var fm3 = WhiteNoise.ar() * LFPulse.kr(7.3, 0, 0.3) * 600;

	// Hyper-polyrhythmic pulse patterns
	var pulseA = LFPulse.kr([11.3, 11.29], 0, LFNoise1.kr(0.2).range(0.1, 0.4));
	var pulseB = LFPulse.kr([8.7, 8.71], 0, LFNoise1.kr(0.3).range(0.2, 0.5)) *
		Demand.kr(Dust.kr(2.5), 0, Dseq([1, 0, 0.5, 0.8, 0.3], inf));
	var pulseC = LFPulse.kr(13.2, 0, 0.15) * Impulse.kr(0.5);

	// Core signals with extreme modulation
	var sig1 = PMOsc.ar(base + fm1, fm2, LFNoise1.kr(0.1).range(1.0, 5.0)) * pulseA * 0.2;
	var sig2 = Formant.ar(base * 0.75 + fm3, 3000, 800) * pulseB * 0.15;
	var sig3 = Gendy1.ar(6, 6, 1.0, 1.0, base/2, 0.1, 0.5, 0.5) * pulseC * 0.1;

	// Hyper-detuned swarm with random scaling
	var swarm = Mix.fill(24, { |i|
		var detune = (i-12) * LFNoise1.kr(0.5).range(0.001, 0.01);
		SinOsc.ar(base * (1 + detune)) * LFNoise1.kr(0.2).range(0.01, 0.03)
	});

	// Micro-sound granular cloud
	var grain = GrainFM.ar(2,
		Impulse.kr(LFNoise1.kr(0.3).range(25, 40)),
		LFNoise1.kr(0.4).range(0.02, 0.08),
		base * LFNoise1.kr(0.2).range(0.8, 1.2),
		LFNoise1.kr(0.3).range(1.0, 8.0),
		0.5
	) * 0.3;

	// Spectral comb filtering for metallic textures
	var spec = CombC.ar(swarm + grain, 0.2,
		[0.005, 0.0051, 0.007, 0.0071],
		LFNoise1.kr(0.1).range(2.0, 4.0)
	).sum * 0.2;

	var sig = sig1 + sig2 + sig3 + swarm + grain + spec;
	sig = SplayAz.ar(8, sig, spread: 1.5, center: 0); // 8-channel surround spread

	// Chaotic delay matrix
	sig = AllpassC.ar(sig, 0.5,
		{LFNoise1.kr(0.15).exprange(0.01, 0.2)}!8,
		{LFNoise1.kr(0.1).range(1.0, 3.0)}!8
	) * 0.6;

	// Extreme pitch-shifting cascade
	sig = sig + (PitchShift.ar(sig, 0.1, [0.25, 0.5, 1.5, 3.0], 0.02, 0.04) * [0.2, 0.15, 0.1, 0.05]).sum;

	// Crystalline reverb
	sig = PartConv.ar(sig, 2048, 1) * 0.4 + (sig * 0.3);

	sig = Compander.ar(sig, sig, 0.3, 1, 0.15, 0.005, 0.05);
	sig = Limiter.ar(sig, 0.7);
	sig.sum * 0.4;
}.play;
)