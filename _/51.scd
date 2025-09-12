(
// Massive Iteration 2: Dense swarm clouds & spectral shaping
{
	var base = 200 + LFNoise1.kr(0.1!5, 80, 200).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.4).range(50, 200), 0, LFNoise1.kr(0.2, 80, 140));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.6).range(30, 150), 0, LFNoise1.kr(0.3, 120, 200));
	var fm3 = SinOsc.ar(LFNoise0.kr(0.5).range(40, 120), 0, LFNoise1.kr(0.25, 60, 90));

	// Polyrhythmic pulse ensemble
	var pulseA = LFPulse.kr(5.2, 0, 0.4) * Demand.kr(Dust.kr(0.6), 0, Dseq([1,0.5,1,0], inf));
	var pulseB = LFPulse.kr(3.7, 0, 0.3) * Demand.kr(Dust.kr(0.4), 0, Dseq([1,0,1,1], inf));

	// Core modulated signals
	var sig1 = SinOsc.ar(base + fm1 + fm2) * pulseA;
	var sig2 = Saw.ar(base * 0.67 + fm3) * pulseB * 0.2;

	// Expanded swarm with 7 detuned oscillators
	var swarm = Mix.fill(7, { |i| SinOsc.ar(base * (1 + (i-3)*0.003)) * 0.1 });

	// Grain clouds
	var grain = GrainIn.ar(2, Impulse.kr(12), 0.1, PinkNoise.ar(0.3), -1) * 0.25;

	// Spectral sculpting with resonant filter banks
	var spec = BPF.ar(swarm + grain, [500,1200,2500,4000], 0.2).sum * 0.3;

	var sig = sig1 + sig2 + swarm + grain + spec;
	sig = Pan2.ar(sig, LFNoise1.kr(0.25));

	// Complex delay network
	sig = CombN.ar(sig, 0.5, LFNoise1.kr(0.15).range(0.05,0.4), 3) * 0.8;

	// Pitch layering with fifths & octaves
	sig = sig + (PitchShift.ar(sig, 0.3, [1.5, 2.0], 0.01, 0.03) * 0.25).sum;

	// Reverb wash
	sig = GVerb.ar(sig, 50, 8, 0.6, 0.7, 15, -3, 0.5, 0.3) * 0.4;

	sig = Compander.ar(sig, sig, 0.35, 1, 0.25);
	sig * 0.4;
}.play;
)
