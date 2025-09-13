(
{
	var base = 85 + LFNoise1.kr(0.04!2, 30, 50).mean;
	var fm1 = LFPulse.ar(LFNoise0.kr(0.2).range(20,80), 0, 0.3, LFNoise1.kr(0.1, 30, 60));
	var fm2 = Saw.ar(LFNoise0.kr(0.25).range(40,120), LFNoise1.kr(0.2, 15, 25));

	var drone = Mix.fill(5, { |i|
		SinOsc.ar(base * (0.5 + i*0.2) + fm1 + fm2, 0, 0.04)
	});
	var sub = LFPulse.ar(base * 0.2, 0, 0.4, 0.1);

	var noiseAtmo = LFNoise2.ar(LFNoise1.kr(0.3).range(200,2000)) * 0.18;

	var sig = drone + sub + noiseAtmo;

	sig = PitchShift.ar(sig, 0.7, [0.94, 1.06], 0.1, 0.3).sum * 0.4;
	sig = GVerb.ar(sig, 150, 20, 0.7, 0.6, 40, -5, 0.4, 0.5) * 0.45;
	Pan2.ar(sig, LFNoise1.kr(0.04));
}.play;
)
