(
{
	var base = 220 + LFDNoise3.kr(3.14 * 5, Line.kr(50, 5000, 90));
	var mod = LFDNoise1.kr(0.25, 200, 400);
	var sig = Mix.fill(16, {
		SinOsc.ar(base + LFNoise2.kr(rrand(0.01, 5), mod, Rand(10, 300)))!2
	});
	sig = sig * 0.05;
	FreeVerb.ar(sig, 0.5, 0.9, 0.3)
}.play;
)
