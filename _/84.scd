(
{
	var base = 60 + LFNoise1.kr(0.06!2, 25, 35).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.12).range(5,15), 0, LFNoise1.kr(0.09, 20, 40));
	var fm2 = SinOscFB.ar(LFNoise0.kr(0.2).range(10,40), 0.6, LFNoise1.kr(0.1, 15, 25));

	var drone = Mix.fill(3, { |i|
		PMOsc.ar(base * (0.4 + i*0.2), base*(0.2+i*0.1), 0.3, 0.05)
	});
	var sub = LFTri.ar(base * 0.125, 0, 0.12);

	var noiseAtmo = GrainFM.ar(2, Dust.kr(LFNoise1.kr(0.2).range(3,9)), 0.25, base, base*0.5, 0.2, -1) * 0.2;

	var sig = drone + sub + noiseAtmo;

	sig = PitchShift.ar(sig, 0.85, [0.93, 1.08], 0.1, 0.2).sum * 0.35;
	sig = GVerb.ar(sig, 120, 30, 0.7, 0.8, 60, -7, 0.6, 0.7) * 0.5;
	Pan2.ar(sig, LFNoise1.kr(0.05));
}.play;
)
