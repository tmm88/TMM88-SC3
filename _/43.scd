(
// Iteration 2: Glitching Digital Forest
{
	var base = 250 + LFNoise1.kr(1!2, 500, 600).mean; // Stereo detuning on base freq
	var fm = SinOsc.ar(LFNoise0.kr(2).range(80, 300), 0, LFNoise1.kr(0.4, 200, 250));
	// Use Dust to trigger glitchy pulses
	var pulse1 = LFPulse.kr(7.25, 0, 0.3) * Demand.kr(Dust.kr(0.8), 0, Dseq([1, 0, 0, 1, 0, 1], inf));
	var pulse2 = LFPulse.kr(5.1, 0, 0.6) * Demand.kr(Dust.kr(1.2), 0, Dseq([1, 1, 0], inf));
	var pulse3 = LFPulse.kr(8.7, 0, 0.2);

	var sig1 = SinOsc.ar(base + fm) * pulse1;
	var sig2 = Saw.ar(base * 0.5 + fm * 1.2) * pulse2 * 0.2;
	// Add some filtered noise for texture
	var sig3 = PinkNoise.ar() * pulse3 * 0.15;
	var sig4 = RLPF.ar(Saw.ar(base * 3 + fm), LFNoise1.kr(0.2).exprange(300, 2000), 0.1) * pulse3 * 0.1;

	var sig = sig1 + sig2 + sig3 + sig4;
	sig = Pan2.ar(sig, LFNoise1.kr(0.1));
	// A comb delay for a "cybernetic" feel
	sig = AllpassC.ar(sig, 0.2, [0.05, 0.051], 2) * 0.6;
	sig = sig + (PitchShift.ar(sig, 0.1, 2.0, 0.02, 0.02) * 0.5); // Glitchier shimmer
	sig = Compander.ar(sig, sig, 0.4, 1, 0.3); // Tight compression to control spikes
	sig * 0.4;
}.play;
)