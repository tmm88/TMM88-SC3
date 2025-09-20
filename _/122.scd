(
// Massive Iteration 3: Enhanced swarm density, formant filtering, and rhythmic gating
{
	var base = 200 + LFNoise1.kr(0.1!5, 80, 200).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.4).range(50, 200), 0, LFNoise1.kr(0.2, 80, 140));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.6).range(30, 150), 0, LFNoise1.kr(0.3, 120, 200));
	var fm3 = SinOsc.ar(LFNoise0.kr(0.5).range(40, 120), 0, LFNoise1.kr(0.25, 60, 90));

	// Polyrhythmic pulse ensemble with added complexity
	var pulseA = LFPulse.kr(5.2, 0, 0.4) * Demand.kr(Dust.kr(0.6), 0, Dseq([1, 0.5, 1, 0, 0.8], inf));
	var pulseB = LFPulse.kr(3.7, 0, 0.3) * Demand.kr(Dust.kr(0.4), 0, Dseq([1, 0, 1, 1, 0.7], inf));
	var pulseC = LFPulse.kr(7.1, 0, 0.2) * Demand.kr(Dust.kr(0.5), 0, Dseq([0, 1, 0.3, 1], inf));

	// Core modulated signals
	var sig1 = SinOsc.ar(base + fm1 + fm2) * pulseA;
	var sig2 = Saw.ar(base * 0.67 + fm3) * pulseB * 0.2;

	// Expanded swarm with 10 detuned oscillators for denser texture
	var swarm = Mix.fill(10, { |i| SinOsc.ar(base * (1 + (i-5)*0.0025)) * 0.08 });

	// Grain clouds with dynamic density
	var grain = GrainIn.ar(2, Impulse.kr(LFNoise1.kr(0.2).range(10, 15)), 0.1, PinkNoise.ar(0.3), -1) * 0.25;

	// Spectral sculpting with resonant filter banks and modulated formant filter
	var spec = BPF.ar(swarm + grain, [500, 1200, 2500, 4000], 0.2).sum * 0.3;
	var formant = Formlet.ar(swarm, LFNoise1.kr(0.1).range(400, 1600), 0.1, 0.2) * 0.2;

	// Combine signals
	var sig = sig1 + sig2 + swarm + grain + spec + formant;
	sig = Pan2.ar(sig, LFNoise1.kr(0.25));

	// Rhythmic gating for texture
	var gate = LFPulse.kr(LFNoise1.kr(0.3).range(2, 8), 0, 0.5);
	sig = sig * gate * 0.9 + (sig * 0.1); // Blend gated and ungated signal

	// Complex delay network with modulated delay time
	sig = CombN.ar(sig, 0.5, LFNoise1.kr(0.15).range(0.05, 0.4), 3) * 0.8;

	// Pitch layering with fifths, octaves, and subtle third
	sig = sig + (PitchShift.ar(sig, 0.3, [1.5, 2.0, 1.33], 0.01, 0.03) * 0.2).sum;

	// Reverb wash with slightly larger room
	sig = GVerb.ar(sig, 60, 8, 0.6, 0.7, 15, -3, 0.5, 0.3) * 0.4;

	// Dynamic compression
	sig = Compander.ar(sig, sig, 0.35, 1, 0.25);
	sig * 0.4;
}.play;
)