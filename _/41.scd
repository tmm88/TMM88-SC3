(
// Massive Iteration 6: Noise sculpting glitch
{
	var base = 80 + LFNoise0.kr(0.6, 1800, 400);
	var noiseLayer = RHPF.ar(WhiteNoise.ar(0.4), base * LFNoise1.kr(0.4,0.5,1), 0.2);
	var sig1 = SinOsc.ar(base + noiseLayer) * LFPulse.kr(11.3, 0, 0.25);
	var sig2 = Pulse.ar(base * 0.42 + noiseLayer) * LFNoise0.kr(4).range(0.1,0.5);
	var sig3 = Saw.ar(base * 0.18) * LFNoise1.kr(3).exprange(0.05,0.3);
	var sig = sig1 + sig2 + sig3;
	sig = Pan2.ar(sig, LFNoise1.kr(0.08));
	sig = CombC.ar(sig, 0.25, LFNoise1.kr(0.3, 0.08, 0.1), 2.5) * 0.7;
	sig = Decimator.ar(sig, 44100/rrand(2,16), 8) * 0.5; // glitch crush
	sig = (sig * LFNoise2.kr(0.12, 0.6, 0.5)).wrap2(0.7);
	sig * 0.25;
}.play;
)
