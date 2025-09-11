(
// evolving drone with layered dust
{
	var sig;

	sig = [
		// low drone filtered
		Resonz.ar(BrownNoise.ar(0.2), LFNoise1.kr(0.05).range(50, 200), 0.2),

		// airy brown noise with tremolo
		BrownNoise.ar(0.15!2) * LFNoise1.kr(0.1).range(0.2, 0.8),

		// dusty crackle cloud in stereo
		Pan2.ar(Dust2.ar(10) * 0.4, LFNoise1.kr(0.5))
	];

	FreeVerb.ar(Mix(sig), 0.5, 0.9, 0.3) * 0.8;
}.play;
)
