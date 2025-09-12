// Iteration 3: Add harmonic complexity and spatial effects
(
{
	var base = 60 + LFNoise1.kr(0.03!2, 25, 55).mean;
	var fmMod = LFNoise1.kr(0.05).range(0.8, 1.2);
	var fm1 = SinOsc.ar(LFNoise0.kr(0.15).range(6,50) * fmMod, 0, LFNoise1.kr(0.11, 30, 80));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.18).range(12,60) * fmMod, 0, LFNoise1.kr(0.14, 20, 50));
	var fm3 = SinOsc.ar(LFNoise0.kr(0.09).range(2,25) * fmMod, 0, LFNoise1.kr(0.12, 8, 40));
	var drone = Mix.fill(6, { |i|
		var partialFreq = base * (0.2 + i*0.1) * LFNoise1.kr(0.04).range(0.99, 1.01);
		var fbMod = LFNoise1.kr(0.09).range(0.3, 1.1);
		SinOscFB.ar(partialFreq + fm1 + fm2 + fm3, fbMod,
			LFNoise1.kr(0.07).range(0.02, 0.06))
	});

	// Complex sub with multiple oscillators
	var sub = Mix.ar([
		LFTri.ar(base * 0.2, 0, 0.08),
		SinOsc.ar(base * 0.19, 0, 0.05),
		Pulse.ar(base * 0.21, 0.3, 0.04)
	]) * LFPulse.kr(0.25, 0, 0.8);

	var formants = Mix.fill(5, { |i|
		var formantMod = LFNoise1.kr(0.04*(i+1)).range(0.9, 1.1);
		Formant.ar(drone * 0.1,
			LFNoise1.kr(0.025*(i+1)).range(80,900) * formantMod,
			LFNoise1.kr(0.065*(i+1)).range(30,220) * formantMod,
			LFNoise1.kr(0.095*(i+1)).range(40,400) * formantMod)
	});

	// Multi-layered granular texture
	var noiseAtmo = Mix.ar([
		GrainSin.ar(2, Impulse.kr(LFNoise1.kr(0.25).range(1,20)),
			LFNoise1.kr(0.12).range(0.1, 0.35),
			LFNoise1.kr(0.4).range(80,2500),
			LFNoise1.kr(0.2)) * 0.1,

		GrainFM.ar(2, Dust.kr(8), 0.4,
			LFNoise1.kr(0.3).range(300,1800),
			LFNoise1.kr(0.25).range(100,800),
			LFNoise1.kr(0.15)) * 0.08
	]);

	var sig = drone + sub + formants + noiseAtmo;

	// Advanced signal processing chain
	sig = DFM1.ar(sig, LFNoise1.kr(0.08).range(120, 3000), 0.9, 1, 0) * 0.7;
	sig = PitchShift.ar(sig, 1.0, [0.9, 1.1, 0.93, 1.07, 0.96, 1.04], 0.08, 0.2).sum * 0.18;

	// Complex delay network
	sig = Mix.ar([
		AllpassN.ar(sig, 2.0, [0.2, 0.6, 1.4], 3),
		CombN.ar(sig, 1.5, [0.15, 0.45, 0.9], 6) * 0.3
	]);

	sig = GVerb.ar(sig, 250, 45, 0.95, 0.8, 90, -18, 0.8, 0.9) * 0.35;

	// Multi-band compression
	sig = Compander.ar(sig, sig, 0.18, 1, 0.15, 0.005, 0.08);

	// Advanced stereo imaging with rotating panning
	var panPos = SinOsc.kr(0.02, [0, pi/2]).range(-0.7, 0.7);
	Balance2.ar(sig[0], sig[1], panPos);
}.play;
)

