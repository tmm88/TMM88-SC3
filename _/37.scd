(
// Massive Iteration 2: Granular texture with envelope and filter
{
	var carrier = 100 + LFDNoise0.kr(4, 2000) * SinOsc.kr(0.1, mul: 0.5); // Modulated carrier
	var mod = LFDNoise1.ar(LFNoise0.kr(0.5, 8, 12), 400, 600);
	var sig = SinOsc.ar(carrier + mod) * LFPulse.kr(8, 0, 0.3);
	var grain = GrainSin.ar(2, Impulse.kr(20), 0.1, carrier + mod, LFNoise2.kr(0.2)) * 0.4; // Granular layer
	sig = sig + grain;
	sig = RLPF.ar(sig, LFNoise1.kr(0.3, 1000, 2000), 0.3); // Low-pass filter
	sig = Pan2.ar(sig, LFNoise2.kr(0.1));
	sig = sig * EnvGen.ar(Env.perc(0.01, 5, 0.2, -4), Dust.kr(0.2)); // Percussive envelope
}.play;
)