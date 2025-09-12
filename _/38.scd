(
// Massive Iteration 3: Polyrhythmic layers with delay and distortion
{
	var carrier = 100 + LFDNoise0.kr(LFNoise0.kr(0.4, 3, 5), 2000);
	var mod = LFDNoise1.ar(LFNoise0.kr(0.5, 8, 12), 400, 600);
	var sig1 = SinOsc.ar(carrier + mod) * LFPulse.kr(8, 0, 0.3); // Main signal
	var sig2 = Saw.ar((carrier + mod) * 0.5) * LFPulse.kr(5.33, 0, 0.4) * 0.25; // Polyrhythmic layer
	var sig3 = Pulse.ar((carrier + mod) * 0.33) * LFPulse.kr(3, 0, 0.2) * 0.2; // Additional layer
	var sig = sig1 + sig2 + sig3;
	sig = Pan2.ar(sig, LFNoise2.kr(0.1));
	sig = CombC.ar(sig, 0.2, LFNoise1.kr(0.2, 0.05, 0.1), 2) * 0.7; // Delay effect
	sig = (sig * LFNoise1.kr(0.1, 0.5, 1)).distort * 0.3; // Distortion
	sig * 0.2;
}.play;
)