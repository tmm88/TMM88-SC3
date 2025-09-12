(
// Iteration 1: Chrono-Glitch Cathedral
{
	var numVoices = 32;
	var base = 1800 + LFNoise1.kr(0.1!numVoices, 400, 600).mean;

	// Slower, more melodic FM modulators
	var fm1 = SinOsc.ar(LFNoise0.kr(1).range(200, 800), 0, LFNoise1.kr(0.2, 200, 300));
	var fm2 = LFSaw.ar(LFNoise0.kr(1.5).range(100, 500)) * 200;
	var fm3 = BPF.ar(WhiteNoise.ar(), 1200, 0.5) * LFPulse.kr(5.3, 0, 0.4) * 300;

	// Slower, more dramatic pulse patterns
	var pulseA = LFPulse.kr([5.1, 5.11], 0, LFNoise1.kr(0.1).range(0.2, 0.5));
	var pulseB = LFPulse.kr([3.7, 3.72], 0, LFNoise1.kr(0.2).range(0.3, 0.6)) *
		Demand.kr(Dust.kr(1.5), 0, Dseq([1, 0, 0, 0.7, 0.9, 0], inf));
	var pulseC = LFPulse.kr(9.8, 0, 0.1) * Impulse.kr(0.25);

	// Core signals with deeper modulation
	var sig1 = PMOsc.ar(base + fm1, fm2, LFNoise1.kr(0.05).range(2.0, 8.0)) * pulseA * 0.2;
	var sig2 = Formant.ar(base * 0.5 + fm3, 2000, 500) * pulseB * 0.15;
	var sig3 = Gendy1.ar(8, 8, 1.0, 1.0, base/4, 0.1, 0.5, 0.5) * pulseC * 0.1;

	// Vast, multi-channel swarm
	var swarm = Mix.fill(64, { |i|
		var detune = (i-32) * LFNoise1.kr(0.2).range(0.0005, 0.005);
		SinOsc.ar(base * (1 + detune)) * LFNoise1.kr(0.1).range(0.01, 0.04)
	});

	// Granular cloud with pitch shifting
	var grain = GrainFM.ar(4,
		Impulse.kr(LFNoise1.kr(0.2).range(15, 30)),
		LFNoise1.kr(0.3).range(0.05, 0.15),
		base * LFNoise1.kr(0.15).range(0.5, 1.5),
		LFNoise1.kr(0.2).range(2.0, 10.0),
		0.5
	) * 0.4;

	// Massive spectral delay network
	var spec = CombC.ar(swarm + grain, 0.5,
		{LFNoise1.kr(0.08).exprange(0.002, 0.02)}!8,
		{LFNoise1.kr(0.05).range(5.0, 10.0)}!8
	);

	var sig = sig1 + sig2 + sig3 + swarm + grain + spec.sum;
	sig = SplayAz.ar(8, sig, spread: 2.0, center: 0);

	// Multi-tap allpass network for deep reverb
	var reverb = AllpassC.ar(sig, 1.5, [0.3, 0.5, 0.7, 0.9], [4.0, 5.0, 6.0, 7.0]);
	var reverb2 = AllpassC.ar(reverb, 2.0, [0.4, 0.6, 0.8, 1.0], [5.0, 6.0, 7.0, 8.0]);
	sig = sig * 0.4 + (reverb + reverb2) * 0.6;

	sig = Compander.ar(sig, sig, 0.3, 1, 0.15);
	sig = Limiter.ar(sig, 0.8);
	sig.sum * 0.4;
}.play;
)