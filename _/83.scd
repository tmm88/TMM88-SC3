(
{
	var base = 72 + LFNoise1.kr(0.02!2, 40, 50).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.1).range(5,25), 0, LFNoise1.kr(0.05, 10, 20));
	var fm2 = SinOscFB.ar(LFNoise0.kr(0.15).range(20,40), 0.8, LFNoise1.kr(0.08, 20, 30));

	var drone = Mix.fill(4, { |i|
		VarSaw.ar(base * (0.3 + i*0.1) + fm1 + fm2, 0, 0.5, 0.05)
	});
	var sub = SinOsc.ar(base * 0.33, 0, 0.1);

	var noiseAtmo = BrownNoise.ar(0.15) * EnvGen.kr(Env.perc(0.1, 3), Impulse.kr(0.3));

	var sig = drone + sub + noiseAtmo;

	sig = JPverb.ar(sig, 18, 5, 0.7, 0.8) * 0.6;
	Pan2.ar(sig, LFNoise1.kr(0.02));
}.play;
)
