(
// Massive Iteration 3: Chaotic spectral swarm with glitch bursts
{
	var base = 200 + LFNoise1.kr(0.08!2, 80, 120).mean + SinOsc.kr(0.03, mul: 30); // slower wobble
	var fm1 = SinOsc.ar(LFNoise0.kr(0.4).range(60, 180), 0, LFNoise1.kr(0.25, 150, 220));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.6).range(100, 220), 0, LFNoise1.kr(0.3, 100, 170));

	// Polyrhythmic envelopes (less regular, glitchier)
	var envA = Decay2.kr(Impulse.kr(3.2), 0.02, 0.3) * Demand.kr(Dust.kr(0.4), 0, Dseq([1, 0, 1, 1, 0], inf));
	var envB = Decay2.kr(Impulse.kr(5.5), 0.05, 0.2) * Demand.kr(Dust.kr(0.8), 0, Dseq([1, 1, 0, 1, 0, 0], inf));
	var envC = Decay2.kr(Impulse.kr(7.1), 0.01, 0.4) * Demand.kr(Dust.kr(0.6), 0, Dseq([0, 1, 0, 1], inf));

	// Core oscillators
	var sig1 = SinOsc.ar(base + fm1) * envA;
	var sig2 = Saw.ar(base * 0.66 + fm2) * envB * 0.3;
	var sig3 = Pulse.ar(base * 1.25, LFNoise1.kr(0.2).range(0.1, 0.6)) * envC * 0.25;

	// Ring modulated and frequency-shifted layers
	var ring = sig1 * SinOsc.ar(base * 0.9) * 0.4;
	var fshift = FreqShift.ar(sig2, LFNoise1.kr(0.3).range(-200, 200)) * 0.35;

	// Swarm (detuned granular effect)
	var swarm = Mix.fill(7, { |i|
		SinOsc.ar(base * (1 + LFNoise1.kr(0.1).range(-0.03, 0.03) + (i * 0.002))) * 0.08
	});

	// Noisy textures
	var noiseAtmo = BPF.ar(WhiteNoise.ar(0.3), LFNoise1.kr(0.2).range(200, 8000), 0.3) * LFNoise1.kr(0.25).range(0, 0.1);
	var crackle = Crackle.ar(LFNoise1.kr(0.05).range(1.4, 1.9)) * 0.15;

	// Sum
	var sig = sig1 + sig2 + sig3 + ring + fshift + swarm + noiseAtmo + crackle;

	// Stereo motion
	sig = Pan2.ar(sig, LFNoise1.kr(0.15));

	// Delay & glitch space
	sig = CombC.ar(sig, 0.6, LFNoise1.kr(0.1!2).range(0.05, 0.25), 4) * 0.7;
	sig = AllpassN.ar(sig, 0.5, {Rand(0.01, 0.2)}!2, 3) * 0.8;

	// Distortion chain
	sig = (sig * LFNoise1.kr(0.1, 0.6, 1)).tanh * 0.7;
	sig = sig + (PitchShift.ar(sig, 0.25, [0.85, 1.35], 0.1, 0.2) * 0.25).sum;

	// Long reverb wash
	sig = GVerb.ar(sig, 100, 8, 0.6, 0.7, 15, 0.5, 0.3, 0.7) * 0.5;

	// Master comp
	sig = Compander.ar(sig, sig, 0.5, 1, 0.3);
	sig * 0.4;
}.play;
)
