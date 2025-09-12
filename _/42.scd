(
// Iteration 1: Deep Metallic Chimes
{
	var base = 80 + LFNoise1.kr(0.1, 15, 20); // Much lower, slower drift
	var fm = Saw.ar(LFNoise0.kr(0.3, 10, 15)) * 40; // Saw wave FM for metallic edge
	var sig1 = SinOsc.ar(base + fm) * LFPulse.kr(3, 0, 0.5); // Slower pulse
	var sig2 = Saw.ar(base * 1.5 + fm) * LFPulse.kr(5.2, 0, 0.4) * 0.3;
	var sig3 = DPW3Tri.ar(base * 2.01 + fm * 0.5) * LFPulse.kr(4.75, 0, 0.3) * 0.15; // Clean triangle
	var sig = sig1 + sig2 + sig3;
	sig = Pan2.ar(sig, LFNoise1.kr(0.03));
	// A tighter, metallic reverb
	sig = Greyhole.ar(sig, damp: 0.4, size: 0.8, diff: 0.7, feedback: 0.3) * 0.5;
	sig = sig + (PitchShift.ar(sig, 0.2, 1.5, 0.01, 0.01) * 0.3); // Perfect fifth shimmer
	sig = (sig * 1.2).distort * 0.15; // Gentle distortion for metallic body
	sig * 0.5;
}.play;
)