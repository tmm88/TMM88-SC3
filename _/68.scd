// Iteration 2: Add rhythmic elements and more complex filtering
(
{
	var base = 62 + LFNoise1.kr(0.025!2, 30, 50).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.12).range(8,45), 0, LFNoise1.kr(0.09, 35, 75));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.15).range(15,55), 0, LFNoise1.kr(0.13, 25, 45));
	var fm3 = SinOsc.ar(LFNoise0.kr(0.07).range(3,20), 0, LFNoise1.kr(0.1, 10, 35));
	var drone = Mix.fill(5, { |i|
		var detune = LFNoise1.kr(0.03).range(0.98, 1.02);
		SinOscFB.ar(base * (0.25 + i*0.12) * detune + fm1 + fm2 + fm3,
			LFNoise1.kr(0.08).range(0.4, 1.0),
			LFNoise1.kr(0.06).range(0.03, 0.07))
	});

	// Pulsing sub with rhythm
	var subRhythm = LFPulse.kr(0.5, 0, 0.7);
	var sub = LFTri.ar(base * 0.22 + SinOsc.kr(0.04, 0, 0.8), 0, 0.1) * subRhythm;

	var formants = Mix.fill(4, { |i|
		Formant.ar(drone * 0.12,
			LFNoise1.kr(0.03*(i+1)).range(100,800),
			LFNoise1.kr(0.07*(i+1)).range(40,200),
			LFNoise1.kr(0.1*(i+1)).range(60,350))
	});

	// More complex granular texture
	var noiseAtmo = Mix.ar(
		GrainSin.ar(2,
			Impulse.kr(LFNoise1.kr(0.2).range(2,18)),
			LFNoise1.kr(0.1).range(0.15, 0.3),
			LFNoise1.kr(0.35).range(100,2200),
			LFNoise1.kr(0.18)) * 0.12
	);

	var sig = drone + sub + formants + noiseAtmo;

	// Spectral enhancement
	sig = BPF.ar(sig, LFNoise1.kr(0.1).range(80, 2000), 0.8);
	sig = PitchShift.ar(sig, 0.9, [0.92, 1.04, 0.95, 1.08], 0.07, 0.15).sum * 0.22;

	// Multi-tap delay for more depth
	sig = AllpassN.ar(sig, 1.8, [0.3, 0.7, 1.1], 4).mean;
	sig = GVerb.ar(sig, 220, 40, 0.9, 0.85, 80, -15, 0.75, 0.85) * 0.4;

	// Dynamic processing with sidechain
	var compCtrl = Amplitude.kr(sig, 0.01, 0.1);
	sig = Compander.ar(sig, compCtrl, 0.2, 1, 0.18, 0.01, 0.1);

	// Stereo imaging with more movement
	Balance2.ar(sig[0], sig[1], LFNoise1.kr(0.06));
}.play;
)