(
// broken texture machine
{
	var sig;

	sig = [
		// broken LFD chaos
		LeakDC.ar(LFDNoise0.ar(3.14 * LFNoise1.kr(2).range(1, 8))) * 0.5,

		// glitchy dust impulses gated by LFNoise0
		Dust.ar(30) * LFNoise0.kr(8).range(0, 1) * 0.3!2,

		// brown noise stabs modulated by sine
		BrownNoise.ar(0.25!2) * SinOsc.kr(1.5).range(0, 1)
	];

	CombN.ar(Mix(sig), 0.3, {Rand(0.05, 0.2)}.dup, 2) * 0.8;
}.play;
)
