(
// Massive Iteration 1: Enhanced swarm with granular synthesis and dynamic filtering
{
	var base = 300 + LFNoise1.kr(0.1!3, 50, 100).mean; // Expanded base frequency modulation
	var fm1 = SinOsc.ar(LFNoise0.kr(0.5).range(40, 150), 0, LFNoise1.kr(0.3, 100, 150));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.7).range(60, 200), 0, LFNoise1.kr(0.4, 120, 180));
	var fm3 = SinOsc.ar(LFNoise0.kr(0.6).range(30, 100), 0, LFNoise1.kr(0.2, 80, 120)); // Additional modulator

	// Polyrhythmic pulses with more variation
	var pulseA = LFPulse.kr(4.5, 0, 0.5) * Demand.kr(Dust.kr(0.5), 0, Dseq([1, 0, 1, 0.5], inf));
	var pulseB = LFPulse.kr(6.1, 0, 0.3) * Demand.kr(Dust.kr(0.7), 0, Dseq([1, 1, 0, 0, 1], inf));
	var pulseC = LFPulse.kr(7.8, 0, 0.2) * Demand.kr(Dust.kr(0.6), 0, Dseq([0, 1, 0, 1], inf));

	// Core synth layers with richer modulation
	var sig1 = SinOsc.ar(base + fm1 + fm3) * pulseA;
	var sig2 = Saw.ar(base * 0.5 + fm2 * 1.5) * pulseB * 0.2;

	// Expanded swarm with detuned oscillators
	var swarm = SinOsc.ar([base * 1.01, base * 0.99, base * 1.03, base * 1.02, base * 0.98]) * 0.2;
	// Granular layer for texture
	var grain = GrainSin.ar(2, Impulse.kr(15), 0.15, base + fm1, LFNoise2.kr(0.2)) * 0.3;
	// Enhanced formant with dynamic modulation
	var formantSig = Formant.ar(Saw.ar(base * 2.5), LFNoise1.kr(0.2).range(400, 600), LFNoise1.kr(0.1).range(50, 150), LFNoise1.kr(0.12).range(100, 200)) * pulseC * 0.15;

	// Atmospheric noise with dynamic filtering
	var noiseAtmo = LPF.ar(PinkNoise.ar(), LFNoise1.kr(0.3).range(1500, 2500)) * LFNoise1.kr(0.2).range(0, 0.15);

	var sig = sig1 + sig2 + swarm + grain + formantSig + noiseAtmo;
	sig = Pan2.ar(sig, LFNoise1.kr(0.3));

	// Dynamic comb delay with modulation
	sig = AllpassC.ar(sig, 0.8, LFNoise1.kr(0.2, 0.05, 0.25), 4) * 0.8;
	// Pitch shifting with multiple ratios
	sig = sig + (PitchShift.ar(sig, 0.5, [1.2, 1.3], 0.05, 0.05) * 0.3).sum;
	// Lush reverb with larger room
	sig = FreeVerb.ar(sig, 0.85, 0.95, 0.4) * 0.6;
	sig = Compander.ar(sig, sig, 0.4, 1, 0.3);
	sig * 0.35;
}.play;
)