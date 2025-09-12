(
// Iteration 2: The Singularity Engine
{
	var numVoices = 24;
	var base = 2500 + LFNoise1.kr(0.5!numVoices, 800, 1200).mean;

	// Harsh, high-frequency FM modulators
	var fm1 = SinOsc.ar(LFNoise0.kr(5).range(1000, 4000), 0, LFNoise1.kr(0.8, 500, 800));
	var fm2 = LFPulse.ar(LFNoise0.kr(6).range(1200, 2500), 0, LFNoise1.kr(0.5).range(0.1, 0.8)) * 500;
	var fm3 = PinkNoise.ar() * LFPulse.kr(10.2, 0, 0.2) * 800;

	// Rapid, percussive pulse patterns
	var pulseA = LFPulse.kr([25.3, 25.32], 0, 0.1) * Impulse.kr(20);
	var pulseB = LFPulse.kr([30.7, 30.73], 0, 0.15) *
		Demand.kr(Dust.kr(5), 0, Dseq([1, 0, 1], inf));
	var pulseC = Impulse.kr(8);

	// Core signals with added distortion
	var sig1 = PMOsc.ar(base + fm1, fm2, LFNoise1.kr(0.2).range(3.0, 10.0));
	var sig1_dist = Distort.ar(sig1) * pulseA * 0.3;
	var sig2 = Formant.ar(base * 0.9 + fm3, 5000, 1000);
	var sig2_dist = Limiter.ar(sig2, 0.5) * pulseB * 0.2;
	var sig3 = Gendy1.ar(4, 4, 1.0, 1.0, base/1.5, 0.2, 0.8, 0.8) * 0.2 * pulseC;

	// Chaotic, detuned swarm with aggressive filtering
	var swarm = Mix.fill(32, { |i|
		var detune = (i-16) * LFNoise1.kr(1).range(0.002, 0.02);
		BPF.ar(SinOsc.ar(base * (1 + detune)), 5000 + LFNoise1.kr(2).range(-2000, 2000), 0.2) * LFNoise1.kr(0.5).range(0.01, 0.03)
	});

	// Grain cloud with a high feedback comb filter
	var grain = GrainFM.ar(2,
		Impulse.kr(LFNoise1.kr(1).range(50, 100)),
		LFNoise1.kr(0.5).range(0.01, 0.05),
		base * LFNoise1.kr(0.5).range(0.5, 2.0),
		LFNoise1.kr(0.7).range(4.0, 12.0),
		0.5
	);
	var grain_spec = CombL.ar(grain, 0.05, [0.001, 0.0011], 10.0) * 0.3;

	var sig = sig1_dist + sig2_dist + sig3 + swarm + grain_spec;
	sig = Splay.ar(sig, spread: 1.0, level: 0.8);

	// Fast, aggressive delay
	sig = AllpassC.ar(sig, 0.2, [0.01, 0.02], 1.5);
	// Multi-octave pitch shifting for extreme artifacts
	sig = sig + (PitchShift.ar(sig, 0.01, [0.125, 2.0, 4.0], 0.01, 0.02) * [0.5, 0.3, 0.1]).sum;

	// Heavy compression and limiting
	sig = Compander.ar(sig, sig, 0.1, 1, 0.05, 0.001, 0.01);
	sig = Limiter.ar(sig, 0.6);
	sig.sum * 0.4;
}.play;
)