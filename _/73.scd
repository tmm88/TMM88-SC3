(
{
	var base = 65 + LFNoise1.kr(0.02!2, 35, 45).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.1).range(10,40), 0, LFNoise1.kr(0.08, 40, 70));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.12).range(20,50), 0, LFNoise1.kr(0.11, 20, 40));

	var drone = Mix.fill(3, { |i|
		SinOscFB.ar(base * (0.4 + i*0.2) + fm1 + fm2, 0.7, 0.06)
	});
	var sub = LFTri.ar(base * 0.25, 0, 0.15);

	var formants = Mix.fill(2, { |i|
		Formant.ar(drone * 0.2, LFNoise1.kr(0.05*(i+1)).range(300,1000), LFNoise1.kr(0.09*(i+1)).range(80,200), LFNoise1.kr(0.13*(i+1)).range(150,300)) // Higher formant range
	});

	var noiseAtmo = GrainSin.ar(1, Impulse.kr(LFNoise1.kr(0.15).range(8,20)), 0.2, LFNoise1.kr(0.25).range(200,1800), LFNoise1.kr(0.12)) * 0.18; // Faster grains

	var sig = drone + sub + formants + noiseAtmo;

	sig = PitchShift.ar(sig, 0.8, [0.96, 1.05], 0.05, 0.1).sum * 0.3;
	sig = AllpassN.ar(sig, 1.2, LFNoise1.kr(0.1).range(0.4,1.0), 8);
	sig = GVerb.ar(sig, 180, 30, 0.8, 0.95, 60, -9, 0.6, 0.7) * 0.5;

	sig = Compander.ar(sig, sig, 0.28, 1, 0.22);
	Pan2.ar(sig, LFNoise1.kr(0.03));
}.play;
)