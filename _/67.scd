// Iteration 1: Add more modulation and stereo spread
(
{
	var base = 65 + LFNoise1.kr(0.02!2, 35, 45).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.1).range(10,40), 0, LFNoise1.kr(0.08, 40, 70));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.12).range(20,50), 0, LFNoise1.kr(0.11, 20, 40));
	var fm3 = SinOsc.ar(LFNoise0.kr(0.08).range(5,25), 0, LFNoise1.kr(0.09, 15, 30));
	var drone = Mix.fill(4, { |i| // Increased to 4 partials
		SinOscFB.ar(base * (0.3 + i*0.15) + fm1 + fm2 + fm3,
			LFNoise1.kr(0.07).range(0.5, 0.9),
			LFNoise1.kr(0.05).range(0.04, 0.08))
	});

	var sub = LFTri.ar(base * 0.25 + SinOsc.kr(0.03, 0, 0.5), 0, 0.12);

	var formants = Mix.fill(3, { |i| // Increased to 3 formants
		Formant.ar(drone * 0.15,
			LFNoise1.kr(0.04*(i+1)).range(120,700),
			LFNoise1.kr(0.08*(i+1)).range(50,180),
			LFNoise1.kr(0.11*(i+1)).range(80,300))
	});

	var noiseAtmo = GrainSin.ar(2, // Stereo grains
		Impulse.kr(LFNoise1.kr(0.15).range(3,15)),
		0.25,
		LFNoise1.kr(0.3).range(150,2000),
		LFNoise1.kr(0.15)) * 0.15;

	var sig = drone + sub + formants + noiseAtmo;

	// Enhanced stereo processing
	sig = PitchShift.ar(sig, 0.8, [0.94, 1.03, 0.97, 1.06], 0.06, 0.12).sum * 0.25;
	sig = AllpassN.ar(sig, 1.5, LFNoise1.kr(0.12).range(0.3,1.2), 10);
	sig = GVerb.ar(sig, 200, 35, 0.85, 0.9, 70, -12, 0.7, 0.8) * 0.45;

	sig = Compander.ar(sig, sig, 0.25, 1, 0.2);
	Balance2.ar(sig[0], sig[1], LFNoise1.kr(0.04));
}.play;
)

