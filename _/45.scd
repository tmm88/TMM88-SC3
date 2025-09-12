(
// Iteration 1: The Whispering Machine
{
	var base = 250 + LFNoise1.kr(0.5!2, 100, 300).mean; // Slower, more subtle stereo detune
	var fm = SinOsc.ar(LFNoise0.kr(0.8).range(50, 200), 0, LFNoise1.kr(0.2, 150, 200));

	// Use dust to trigger more varied, rapid-fire glitches
	var pulseA = LFPulse.kr(8.1, 0, 0.2) * Demand.kr(Dust.kr(1.5), 0, Dseq([1, 0, 1, 0, 0, 1], inf));
	var pulseB = LFPulse.kr(6.3, 0, 0.4) * Demand.kr(Dust.kr(2), 0, Dseq([1, 1, 0, 1, 0, 0], inf));
	var pulseC = LFPulse.kr(9.5, 0, 0.1);

	// Core synth layers
	var sig1 = SinOsc.ar(base + fm) * pulseA;
	var sig2 = Saw.ar(base * 0.75 + fm * 1.5) * pulseB * 0.3;

	// New layers for depth and texture
	// A more resonant, modulated filter sweep
	var sweepFilt = RHPF.ar(LFPulse.ar(LFNoise1.kr(0.1).range(5, 15)), LFNoise1.kr(0.05).exprange(400, 4000), 0.05);
	// Filtered noise with rhythmic gating
	var noiseGated = BPF.ar(PinkNoise.ar(), 1200 + LFNoise1.kr(0.5).range(-500, 500), 0.5) * LFPulse.kr(LFNoise1.kr(0.3).range(1, 4), 0, 0.5) * 0.2;

	// Granular texture with random pitch
	var grains = GrainSin.ar(1!2, LFTri.kr(0.08).range(1, 3), 0.1, LFTri.kr(0.12).exprange(100, 300), 0, LFNoise2.kr(3!2));
	var grainsSig = RLPF.ar(grains, 800 + LFNoise1.kr(0.1).range(-200, 200), 0.2) * 0.2;

	var sig = sig1 + sig2 + sweepFilt + noiseGated + grainsSig;
	sig = Pan2.ar(sig, LFNoise1.kr(0.2));

	// Longer, more chaotic comb delay
	sig = AllpassC.ar(sig, 0.5, [0.1, 0.15], 4) * 0.5;
	// Glitchy pitch shifter for metallic shimmers
	sig = sig + (PitchShift.ar(sig, 0.1, 1.5, 0.05, 0.05) * 0.6);
	sig = Compander.ar(sig, sig, 0.4, 1, 0.3);
	sig * 0.4;
}.play;
)
