(
// Massive Iteration 3: Glitchy swarm & rhythmic granulation
{
	var base = 250 + LFNoise1.kr(0.15!4, 100, 150).mean;
	var fm = SinOsc.ar(LFNoise0.kr(0.3).range(30,120), 0, LFNoise1.kr(0.25, 50, 100));

	// Rhythmic pulse/gate system
	var gateA = PulseDivider.kr(Impulse.kr(12), 3);
	var gateB = PulseDivider.kr(Impulse.kr(10), 4);
	var trig = gateA + gateB;

	// Granular bursts
	var grain = TGrains.ar(2, trig, PinkNoise.ar(0.3), base, LFNoise1.kr(0.2).range(-1,1), 0.1, 0.1, 0.5) * 0.25;

	// Main swarm
	var swarm = Mix.fill(9, { |i| SinOsc.ar(base * (1 + (i-4)*0.004) + fm, 0, 0.08) });

	// Glitch layers
	var glitch = Decimator.ar(Saw.ar(base * 0.33 + fm), 44100/rrand(3,12), 8) * 0.2;

	// Pulse-driven modulation
	var sig1 = swarm * LFPulse.kr(5.5,0,0.5);
	var sig2 = grain * LFPulse.kr(7.2,0,0.4);
	var sig = sig1 + sig2 + glitch;

	// Space & movement
	sig = Pan2.ar(sig, LFNoise2.kr(0.1));
	sig = CombC.ar(sig, 0.25, LFNoise1.kr(0.4,0.05,0.1), 2.5) * 0.7;
	sig = sig + (PitchShift.ar(sig, 0.2, [0.8,1.25,1.6], 0.01, 0.03) * 0.25).sum;

	// Reverb cloud
	sig = FreeVerb2.ar(sig[0], sig[1], 0.9, 0.9, 0.4);
	sig * 0.35;
}.play;
)
