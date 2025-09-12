(
// Massive Iteration 1: Multi-layered with reverb and frequency modulation
{
	var carrier = 100 + LFDNoise0.kr(LFNoise1.kr(0.2, 4, 6), 2000);
	var mod = LFDNoise1.ar(LFNoise0.kr(0.5, 8, 12), 400, 600);
	var mod2 = SinOsc.ar(LFNoise0.kr(0.3, 200, 300)) * 200; // Additional modulator
	var sig = SinOsc.ar(carrier + mod + mod2) * LFPulse.kr(8, 0, 0.3);
	sig = sig + (SinOsc.ar(carrier * 1.5 + mod) * LFPulse.kr(6, 0, 0.2) * 0.3); // Second layer
	sig = Pan2.ar(sig, LFNoise2.kr(0.1));
	sig = FreeVerb.ar(sig, mix: 0.4, room: 0.8, damp: 0.5); // Add reverb
	sig = sig * 0.2;
}.play;
)