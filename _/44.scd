(
// Iteration 3: Ethereal Pad Swell
{
	var lfoRate = 0.05;
	// Slow, smooth sweeps for the base
	var base = LFTri.kr(lfoRate/4).range(110, 130) + LFNoise1.kr(lfoRate, 4, 2);
	// Smooth, slow FM for gentle movement
	var fm = SinOsc.ar(LFTri.kr(lfoRate/2).range(0.1, 0.5), 0, LFTri.kr(lfoRate/3).range(5, 20));

	// Use slow, overlapping LFPulses for a continuous pad feel
	var env1 = LFPulse.kr(0.5, 0, 0.99, 1, 0.1); // Almost always on
	var env2 = LFPulse.kr(0.33, 0.3, 0.99, 1, 0.1);
	var env3 = LFPulse.kr(0.4, 0.6, 0.99, 1, 0.1);

	var sig1 = SinOsc.ar(base + fm, 0.5) * env1 * 0.3;
	var sig2 = SinOsc.ar(base * 1.498 + (fm*1.1), 0.5) * env2 * 0.3; // Perfect fifth
	var sig3 = SinOsc.ar(base * 2.0 + (fm*0.8), 0.5) * env3 * 0.2; // Octave

	// Mix to stereo and add a rich, long reverb
	var sig = Splay.ar([sig1, sig2, sig3], 0.7);
	sig = JPverb.ar(sig, 5.0, 0.9, 4.0, damp: 0.7) * 0.4;
	// Subtle downward shimmer mixed in
	sig = sig + (PitchShift.ar(sig, 0.4, 0.5, 0.0, 0.01) * 0.15);
	// Use a low-pass filter to soften the sound
	sig = LPF.ar(sig, LFTri.kr(lfoRate/5).range(800, 4000));
	sig * 0.7;
}.play;
)