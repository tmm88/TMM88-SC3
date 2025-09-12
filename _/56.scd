(
// Iteration 3: Bio-Mechanical Respiration
{
	var numVoices = 6;
	var breathRate = LFNoise1.kr(0.1).range(0.1, 0.4);
	var base = 180 + LFNoise1.kr(0.2!numVoices, 40, 60).mean;

	// Organic FM modulators with breath-like contours
	var fm1 = SinOsc.ar(LFNoise0.kr(breathRate).range(0.5, 3.0), 0,
		LFNoise1.kr(breathRate, 30, 40) * LFPulse.kr(breathRate, 0, 0.8));
	var fm2 = LFTri.ar(LFNoise0.kr(breathRate*1.3).range(0.3, 1.2), 0,
		LFNoise1.kr(breathRate*0.8, 20, 25));
	var fm3 = BrownNoise.ar() * LFPulse.kr(breathRate*0.7, 0, 0.6) * 15;

	// Biological rhythm patterns
	var pulseA = LFPulse.kr(1.618, 0, LFNoise1.kr(0.08).range(0.4, 0.7)); // Golden ratio
	var pulseB = LFPulse.kr(2.718, 0.3, LFNoise1.kr(0.1).range(0.3, 0.6)); // Euler's number
	var pulseC = LFPulse.kr(3.142, 0.6, LFNoise1.kr(0.12).range(0.2, 0.5)); // Pi

	// Organic core signals
	var sig1 = Formant.ar(base + fm1,
		LFNoise1.kr(0.2).range(300, 800),
		LFNoise1.kr(0.15).range(100, 300)
	) * pulseA * 0.3;

	var sig2 = Resonz.ar(
		PinkNoise.ar(),
		base * 2.5 + fm2,
		LFNoise1.kr(0.25).range(0.05, 0.2)
	) * pulseB * 0.4;

	var sig3 = MoogFF.ar(
		Saw.ar(base * 0.67 + fm3),
		LFNoise1.kr(0.3).exprange(200, 2000),
		LFNoise1.kr(0.2).range(2.0, 3.5)
	) * pulseC * 0.2;

	// Living swarm with vowel-like qualities
	var swarm = Mix.fill(9, { |i|
		var formantFreq = Select.kr(i % 3, [[600, 1400], [800, 1150], [400, 1700]]);
		Formant.ar(
			base * (1 + (i-4.5)*0.002),
			formantFreq[0] + LFNoise1.kr(0.1, 50),
			formantFreq[1] + LFNoise1.kr(0.1, 100),
			0.05
		)
	});

	// Organic grain source (breath-like)
	var grain = GrainSin.ar(2,
		Dust.kr(LFNoise1.kr(0.2).range(5, 15)),
		LFNoise1.kr(0.3).range(0.05, 0.2),
		base * LFNoise1.kr(0.4).range(0.9, 1.1),
		PinkNoise.ar(0.2),
		LFNoise1.kr(0.2)
	) * 0.25;

	// Morphing spectral filter
	var spec = MMorph.ar(swarm + grain,
		LFNoise1.kr(0.1).range(0.0, 1.0),
		\formant, \reson
	) * 0.3;

	var sig = sig1 + sig2 + sig3 + swarm + grain + spec;
	sig = Pan2.ar(sig, LFNoise1.kr(0.2));

	// Breathing delay
	sig = AllpassN.ar(sig, 1.0,
		LFNoise1.kr(breathRate).range(0.1, 0.4),
		LFNoise1.kr(breathRate*0.5).range(2.0, 4.0)
	) * 0.7;

	// Subtle pitch shifting for chorusing effect
	sig = sig + (PitchShift.ar(sig, 0.2, [1.01, 0.99], 0.0, 0.01) * 0.3).sum;

	// Warm, natural reverb
	sig = JPverb.ar(sig, 3.0, 0.7, 2.0, damp: 0.4, earlyref: 0.6) * 0.5;

	sig = Compander.ar(sig, sig, 0.4, 1, 0.3, 0.02, 0.1);
	sig * 0.5;
}.play;
)