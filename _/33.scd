(
{
	var low = SinOsc.ar(LFDNoise1.kr(0.2, 40, 60), 0, 0.2);
	var hi = SinOsc.ar(5000 + LFDNoise3.kr(20, 2000), 0, 0.05);
	(low + hi) * 0.3!2
}.play;
)
