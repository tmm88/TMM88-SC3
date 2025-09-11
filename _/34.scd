(
{
	var mod = SinOsc.ar(LFDNoise0.kr(0.5, 200, 400));
	var carrier = SinOsc.ar(200 + (mod * LFDNoise1.kr(0.2, 1000)), 0, 0.1);
	var swarm = Mix.fill(8, { carrier * LFNoise1.kr(rrand(0.1, 2)) });
	swarm * 0.15 ! 2
}.play;
)
