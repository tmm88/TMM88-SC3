(
// Iteration 3: Ethereal Hologram
{
	var numVoices = 16;
	var base = 1200 + LFNoise1.kr(0.2!numVoices, 300, 500).mean;

	// Softer, wider-ranging FM
	var fm1 = SinOsc.ar(LFNoise0.kr(2).range(400, 1200), 0, LFNoise1.kr(0.5, 200, 400));
	var fm2 = LFSaw.ar(LFNoise0.kr(3).range(300, 900)) * 300;
	var fm3 = BPF.ar(WhiteNoise.ar(), 800, 0.8) * LFPulse.kr(6.3, 0, 0.3) * 400;

	// Slower, more gentle pulse patterns
	var pulseA = LFPulse.kr([8.3, 8.31], 0, LFNoise1.kr(0.15).range(0.3, 0.6));
	var pulseB = LFPulse.kr([9.1, 9.12], 0, LFNoise1.kr(0.2).range(0.4, 0.7)) *
		Demand.kr(Dust.kr(1.0), 0, Dseq([1, 0, 0.5, 0.8], inf));
	var pulseC = LFPulse.kr(11.5, 0, 0.2) * Impulse.kr(0.3);

	// Core signals with lush modulation
	var sig1 = PMOsc.ar(base + fm1, fm2, LFNoise1.kr(0.08).range(1.5, 4.0)) * pulseA * 0.3;
	var sig2 = Formant.ar(base * 0.6 + fm3, 2500, 600) * pulseB * 0.2;
	var sig3 = Gendy1.ar(6, 6, 1.0, 1.0, base/3, 0.15, 0.6, 0.6) * pulseC * 0.2;

	// Gentle, diffused swarm
	var swarm = Mix.fill(32, { |i|
		var detune = (i-16) * LFNoise1.kr(0.3).range(0.001, 0.008);
		SinOsc.ar(base * (1 + detune)) * LFNoise1.kr(0.15).range(0.02, 0.05)
	});

	// Micro-sound granular cloud
	var grain = GrainFM.ar(4,
		Impulse.kr(LFNoise1.kr(0.2).range(10, 20)),
		LFNoise1.kr(0.3).range(0.1, 0.2),
		base * LFNoise1.kr(0.2).range(0.7, 1.3),
		LFNoise1.kr(0.25).range(1.0, 6.0),
		0.5
	) * 0.4;

	// Spectral comb filtering for soft, metallic sheen
	var spec = CombC.ar(swarm + grain, 0.8,
		{LFNoise1.kr(0.1).exprange(0.008, 0.04)}!8,
		{LFNoise1.kr(0.08).range(2.0, 5.0)}!8
	);

	var sig = sig1 + sig2 + sig3 + swarm + grain + spec.sum;
	sig = SplayAz.ar(8, sig, spread: 1.0, center: 0);

	// Long, chaotic delay matrix
	sig = AllpassC.ar(sig, 1.0,
		{LFNoise1.kr(0.1).exprange(0.05, 0.4)}!8,
		{LFNoise1.kr(0.05).range(2.0, 5.0)}!8
	) * 0.8;

	// Soft, diffused pitch-shifting
	sig = sig + (PitchShift.ar(sig, 0.2, [0.5, 1.5], 0.05, 0.08) * 0.2);

	// PartConv for a lush, organic-sounding reverb
	sig = PartConv.ar(sig, 4096, 1) * 0.6 + (sig * 0.3);

	sig = Compander.ar(sig, sig, 0.5, 1, 0.2);
	sig = Limiter.ar(sig, 0.9);
	sig.sum * 0.4;
}.play;
)






