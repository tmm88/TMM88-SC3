(
{
	var base = 65 + LFNoise1.kr(0.04!2, 30, 45).mean;
	var fm1 = Saw.ar(LFNoise0.kr(0.1).range(5,20), LFNoise1.kr(0.1, 20, 40));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.15).range(20,50), 0, LFNoise1.kr(0.08, 10, 30));

	var drone = Mix.fill(4, { |i|
		Formant.ar(base * (0.4 + i*0.25) + fm1, base*0.5, base*1.5, 0.05)
	});
	var sub = SinOscFB.ar(base * 0.125, 0.7, 0.15);

	var noiseAtmo = PinkNoise.ar(0.15) * LFNoise1.kr(0.3).range(0.1,0.6);

	var sig = drone + sub + noiseAtmo;

	sig = CombN.ar(sig, 0.5, LFNoise1.kr(0.05).range(0.1,0.4), 6) + sig;
	sig = GVerb.ar(sig, 250, 60, 0.9, 0.8, 90, -10, 0.5, 0.8) * 0.4;
	Pan2.ar(sig, LFNoise1.kr(0.02));
}.play;
)
