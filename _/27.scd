(
// metallic pulses with dust bursts
{
	var sig;

	sig = [
		// pulsating brown noise through a slow sine envelope
		BrownNoise.ar(0.3!2) * SinOsc.kr(0.15).range(0.1, 1),

		// dust impulses shaped by a resonant filter
		Resonz.ar(Dust.ar(20) * 5, LFNoise1.kr(0.4).exprange(200, 5000), 0.05),

		// edgy LFD noise with hard clipping
		(LFDNoise0.ar(3.14 * 2) * 2).clip2(0.6)
	];

	Mix(sig) * 0.7;
}.play;
)
