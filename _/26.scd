(
// Iterated noisy texture machine
{
	var sig;

	sig = [
		// Wide brown noise bed
		BrownNoise.ar(0.4!2) * LFNoise1.kr(0.1).range(0.2, 1.0),

		// Random crackle impulses
		Dust.ar(ExpRand(10, 40)) * 0.2!2,

		// Gritty LFD noise filtered + limited
		LeakDC.ar(
			Limiter.ar(
				LFDNoise0.ar(3.14 * LFNoise0.kr(0.2).range(1, 5))
			)
		).tanh * 0.6,

		// Iterated layer: resonant bandpass filtering of brown noise
		Resonz.ar(BrownNoise.ar(0.2), LFNoise1.kr(0.3).range(200, 4000), 0.1),

		// Iterated layer: crackle fed through reverb
		FreeVerb.ar(Dust.ar(15) * 0.5, 0.3, 0.8, 0.2)
	];

	Mix(sig) * 0.8; // final mix
}.play;
)
