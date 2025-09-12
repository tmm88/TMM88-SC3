(
// Iteration 1: Tectonic Plate Shift
{
	var numVoices = 8;
	var lfoRate = 0.05;
	var base = 30 + LFNoise1.kr(lfoRate!numVoices, 10, 15).mean; // Sub-bass territory

	// Massive, slow FM modulators
	var fm1 = SinOsc.ar(LFNoise0.kr(lfoRate/2).range(0.1, 0.5), 0, LFNoise1.kr(lfoRate, 8, 12));
	var fm2 = Saw.ar(LFNoise0.kr(lfoRate/3).range(0.05, 0.2)) * 20;
	var fm3 = LFTri.ar(LFNoise0.kr(lfoRate/4).range(0.03, 0.1), 0, 15);

	// Polyrhythmic pulse ensemble for sub-harmonics
	var pulseA = LFPulse.kr(0.33, 0, LFNoise1.kr(0.1).range(0.7, 0.9));
	var pulseB = LFPulse.kr(0.5, 0.2, LFNoise1.kr(0.08).range(0.4, 0.8));
	var pulseC = LFPulse.kr(0.75, 0.6, LFNoise1.kr(0.12).range(0.3, 0.6));

	// Core modulated signals - using filtered noise and sines for texture
	var sig1 = SinOsc.ar(base + fm1) * pulseA * 0.4;
	var sig2 = RLPF.ar(BrownNoise.ar(), base * 4 + fm2, 0.05) * pulseB * 0.15;
	var sig3 = SinOsc.ar(base * 0.5 + fm3) * pulseC * 0.3;

	// Infrasonic swarm (heavily filtered)
	var swarm = LPF.ar(
		Mix.fill(12, { |i|
			SinOsc.ar(base * (1 + (i-6)*0.001) + LFNoise1.kr(0.05, 0.5)) * 0.07
		}),
		120
	);

	// Geological grain clouds (very slow, large grains)
	var grain = GrainIn.ar(2, Dust.kr(0.8), LFNoise1.kr(0.1).range(0.5, 2.0),
		BrownNoise.ar(0.4), -1, pan: LFNoise1.kr(0.2)) * 0.2;

	// Resonant filter banks for earth-like resonances
	var spec = BRF.ar(swarm + grain, [45, 90, 180, 360], 0.8).sum * 0.4;

	var sig = sig1 + sig2 + sig3 + swarm + grain + spec;
	sig = Pan2.ar(sig, LFNoise1.kr(0.1));

	// Massive delay network for cavernous spaces
	sig = AllpassL.ar(sig, 4.0, LFNoise1.kr(0.05).range(0.8, 3.5), 8) * 0.7;

	// Sub-harmonic enhancement rather than pitch shifting
	sig = sig + (LeakDC.ar(sig * 1.5).distort * 0.2);

	// Cathedral-scale reverb
	sig = GVerb.ar(sig, 300, 16, 0.9, 0.8, 45, -15, 0.7, 0.5) * 0.3;

	sig = Compander.ar(sig, sig, 0.4, 1, 0.2, 0.01, 0.1);
	sig * 0.6;
}.play;
)