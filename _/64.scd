(
{
	var base = 90 + LFNoise1.kr(0.03!4, 60, 80).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.15).range(20,80), 0, LFNoise1.kr(0.12, 60, 90));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.25).range(40,100), 0, LFNoise1.kr(0.2, 30, 60));

	var drone = Mix.fill(5, { |i|
		LFSaw.ar(base * (0.7 + i*0.25) + fm1 + fm2, 0, 0.05)
	});
	var sub = SinOsc.ar(base * 0.33, 0, 0.12);

	var formants = Mix.fill(4, { |i|
		Formant.ar(drone * 0.18, LFNoise1.kr(0.07*(i+1)).range(200,1200), LFNoise1.kr(0.1*(i+1)).range(80,220), LFNoise1.kr(0.16*(i+1)).range(100,400))
	});

	var noiseAtmo = GrainSin.ar(2, Dust.kr(LFNoise1.kr(0.2).range(5,18)), 0.12, LFNoise1.kr(0.35).range(300,2500), LFNoise1.kr(0.25)) * 0.25;

	var sig = drone + sub + formants + noiseAtmo;

	sig = PitchShift.ar(sig, 0.7, [0.88, 1.14], 0.06, 0.09).sum * 0.35;
	sig = CombN.ar(sig, 1.0, LFNoise1.kr(0.15).range(0.3,0.9), 6);
	sig = GVerb.ar(sig, 150, 20, 0.7, 0.85, 40, -6, 0.7, 0.5) * 0.38;

	sig = Compander.ar(sig, sig, 0.3, 1, 0.25);
	Pan2.ar(sig, LFNoise1.kr(0.05));
}.play;
)
