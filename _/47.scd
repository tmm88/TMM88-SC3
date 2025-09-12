(
// Iteration 3: Organic Swarm
{
	var base = 300 + LFNoise1.kr(0.1!2, 50, 100).mean;
	// Multiple, slower FM modulators
	var fm1 = SinOsc.ar(LFNoise0.kr(0.5).range(40, 150), 0, LFNoise1.kr(0.3, 100, 150));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.7).range(60, 200), 0, LFNoise1.kr(0.4, 120, 180));

	// Slower, more rhythmic pulses
	var pulseA = LFPulse.kr(4.5, 0, 0.5) * Demand.kr(Dust.kr(0.5), 0, Dseq([1, 0, 1], inf));
	var pulseB = LFPulse.kr(6.1, 0, 0.3) * Demand.kr(Dust.kr(0.7), 0, Dseq([1, 1, 0, 0], inf));
	var pulseC = LFPulse.kr(7.8, 0, 0.2);

	// Core synth layers with more complex modulation
	var sig1 = SinOsc.ar(base + fm1) * pulseA;
	var sig2 = Saw.ar(base * 0.5 + fm2 * 1.5) * pulseB * 0.2;

	// New layers for a more organic feel
	// A detuned swarm of sine waves
	var swarm = SinOsc.ar([base * 1.01, base * 0.99, base * 1.03]) * 0.25;
	// Formant filter on a saw wave to create vowel-like sounds
	var formantSig = Formant.ar(Saw.ar(base * 2.5), 500, LFNoise1.kr(0.1).range(50, 150), LFNoise1.kr(0.12).range(100, 200)) * pulseC * 0.1;

	// Slower noise for atmosphere
	var noiseAtmo = LPF.ar(PinkNoise.ar(), 2000) * LFNoise1.kr(0.2).range(0, 0.1);

	var sig = sig1 + sig2 + swarm + formantSig + noiseAtmo;
	sig = Pan2.ar(sig, LFNoise1.kr(0.3));

	// A lush, long comb delay
	sig = AllpassC.ar(sig, 0.8, [0.2, 0.25], 4) * 0.8;
	// Slower, more subtle pitch shifter
	sig = sig + (PitchShift.ar(sig, 0.5, 1.2, 0.05, 0.05) * 0.4);
	// Reverb for a sense of space
	sig = FreeVerb.ar(sig, 0.8, 0.9, 0.5) * 0.6;
	sig = Compander.ar(sig, sig, 0.4, 1, 0.3);
	sig * 0.4;
}.play;
)






