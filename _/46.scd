(
// Iteration 2: Corrupted Circuitry
{
	var base = 150 + LFNoise1.kr(0.2!2, 100, 200).mean;
	// Faster, more erratic FM
	var fm = SinOsc.ar(LFNoise0.kr(4).range(100, 500), 0, LFNoise1.kr(1, 300, 400));

	// Aggressive, percussive pulses with high density
	var pulse1 = LFPulse.kr(10.5, 0, 0.15) * Demand.kr(Dust.kr(3), 0, Dseq([1, 0, 0, 1], inf));
	var pulse2 = LFPulse.kr(15.2, 0, 0.2) * Demand.kr(Dust.kr(5), 0, Dseq([1, 1, 0], inf));
	var pulse3 = LFPulse.kr(20, 0, 0.1);

	// Core synth layers with added distortion and ring modulation
	var sig1 = SinOsc.ar(base + fm) * pulse1;
	// Ring modulation for metallic clang
	var ringMod = RingMod.ar(Saw.ar(base * 2.5), SinOsc.ar(base * 3)) * pulse2 * 0.2;
	// Distorted saw wave
	var sawDist = OverlapTexture.ar(1, 0.5, { Saw.ar(440 * LFDust.kr(8).range(1, 3)) * 0.2; }) * pulse3;
	var sawDistSig = LeakDC.ar(sawDist);

	// New layers for harshness and digital artifacts
	// Noise bursts gated by high-frequency pulses
	var noiseGate = PinkNoise.ar() * LFPulse.ar(LFNoise1.kr(5).range(20, 50), 0, 0.2);
	// Bit-crushing on a resonant saw wave
	var crushSig = Crush.ar(Saw.ar(base * 3 + fm), LFNoise1.kr(1).range(2, 8), LFNoise1.kr(1.5).range(0, 0.5)) * 0.2;

	var sig = sig1 + ringMod + sawDistSig + noiseGate + crushSig;
	sig = Pan2.ar(sig, LFNoise1.kr(0.5));

	// Short, choppy allpass
	sig = AllpassC.ar(sig, 0.05, [0.01, 0.02], 2) * 0.6;
	// More aggressive pitch shifter for wild artifacts
	sig = sig + (PitchShift.ar(sig, 0.05, 3.0, 0.05, 0.05) * 0.8);
	sig = Compander.ar(sig, sig, 0.4, 1, 0.3);
	sig = LPF.ar(sig, 10000);
	sig * 0.4;
}.play;
)
