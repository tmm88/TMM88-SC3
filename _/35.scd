(
{
	var excite = Dust2.ar(50) * Decay2.kr(0.01, 0.2);
	var reson = Ringz.ar(excite, 200 + (LFDNoise3.kr(2, 1000)), 1);
	Mix(reson!6) * 0.3
}.play;
)
