(
{
	var base = 68 + LFNoise1.kr(0.02!2, 28, 42).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.1).range(5,15), 0, LFNoise1.kr(0.07, 10, 20));
	var fm2 = Pulse.ar(LFNoise0.kr(0.15).range(10,25), 0.5, LFNoise1.kr(0.08, 10, 30));

	var drone = Mix.fill(5, { |i|
		Saw.ar(base * (0.25 + i*0.15) + fm1 + fm2, 0.04)
	});
	var sub = SinOsc.ar(base * 0.2, 0, 0.1);

	var noiseAtmo = GrainSin.ar(3, Impulse.kr(LFNoise1.kr(0.1).range(3,8)), 0.25, LFNoise1.kr(0.15).range(300,1200), LFNoise1.kr(0.08)) * 0.15;

	var sig = drone + sub + noiseAtmo;

	sig = PitchShift.ar(sig, 0.9, [0.95, 1.05], 0.05, 0.2).sum * 0.35;
	sig = FreeVerb2.ar(sig, sig, 0.8, 0.9, 0.4) * 0.5;
	Pan2.ar(sig, LFNoise1.kr(0.03));
}.play;
)
