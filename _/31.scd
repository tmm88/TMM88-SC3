(
{
	var carrier = 100 + LFDNoise0.kr(4, 2000);
	var mod = LFDNoise1.ar(LFNoise0.kr(0.5, 8, 12), 400, 600);
	var sig = SinOsc.ar(carrier + mod) * LFPulse.kr(8, 0, 0.3);
	sig = Pan2.ar(sig, LFNoise2.kr(0.1));
	sig * 0.2
}.play;
)
