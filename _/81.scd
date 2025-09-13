(
{
	var base = 55 + LFNoise1.kr(0.03!2, 20, 30).mean;
	var fm1 = SinOscFB.ar(LFNoise0.kr(0.08).range(5,15), 0.6, LFNoise1.kr(0.1, 20, 40));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.15).range(10,20), 0, LFNoise1.kr(0.12, 10, 20));

	var drone = Mix.fill(3, { |i|
		LFTri.ar(base * (0.25 + i*0.15) + fm1 + fm2, 0.05)
	});
	var sub = SinOsc.ar(base * 0.125, 0, 0.2);

	var noiseAtmo = GrainSin.ar(2, Dust.kr(LFNoise1.kr(0.2).range(1,6)), 0.3, LFNoise1.kr(0.2).range(100,600), 0) * 0.25;

	var sig = drone + sub + noiseAtmo;

	sig = FreeVerb2.ar(sig, sig, 0.6, 0.9, 0.3) * 0.6;
	sig = Compander.ar(sig, sig, 0.32, 1, 0.2);
	Pan2.ar(sig, LFNoise1.kr(0.07));
}.play;
)
