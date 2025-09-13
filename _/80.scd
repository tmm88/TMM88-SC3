(
{
	var base = 70 + LFNoise1.kr(0.05!2, 25, 35).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.15).range(15,60), 0, LFNoise1.kr(0.12, 30, 60));
	var fm2 = LFPulse.ar(LFNoise0.kr(0.2).range(10,30), 0, 0.4, LFNoise1.kr(0.1, 10, 20));

	var drone = Mix.fill(4, { |i|
		Blip.ar(base * (0.6 + i*0.25) + fm1 + fm2, 5, 0.05)
	});
	var sub = SinOsc.ar(base * 0.5, 0, 0.12);

	var noiseAtmo = Crackle.ar(LFNoise1.kr(0.2).range(1.2,2.0)) * 0.15;

	var sig = drone + sub + noiseAtmo;

	sig = PitchShift.ar(sig, 0.9, [0.97, 1.02], 0.1, 0.2).sum * 0.35;
	sig = JPverb.ar(sig, 12, 4, 0.8, 0.7) * 0.5;
	sig = Compander.ar(sig, sig, 0.3, 1, 0.25);
	Pan2.ar(sig, LFNoise1.kr(0.05));
}.play;
)
