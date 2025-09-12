(
// Massive Iteration 4: Granular/ring mod chaos
{
	var carrier = 200 + LFDNoise3.kr(0.3, 3000, 500);
	var mod = LFNoise1.kr(0.7, 1000, 200);
	var grain = GrainSin.ar(2, Impulse.kr(LFNoise0.kr(0.4, 8, 12)), 0.05, carrier + mod, -1, 0.3);
	var ring = SinOsc.ar(carrier * LFNoise1.kr(0.2, 4, 1)) * grain;
	var sig1 = ring * LFPulse.kr(7, 0, 0.4);
	var sig2 = Saw.ar(carrier * 0.25 + mod * 0.2) * LFPulse.kr(9.7, 0, 0.35) * 0.2;
	var sig3 = Pulse.ar(carrier * 0.125 + mod * 0.1) * LFNoise0.kr(2).exprange(0.1,0.5);
	var sig = sig1 + sig2 + sig3;
	sig = Pan2.ar(sig, LFNoise1.kr(0.07));
	sig = CombL.ar(sig, 0.3, LFNoise1.kr(0.2, 0.1, 0.15), 3) * 0.6;
	sig = (sig * LFNoise2.kr(0.15, 0.7, 0.5)).tanh * 0.25;
	sig * 0.25;
}.play;
)
