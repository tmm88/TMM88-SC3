(
// Massive Iteration 5: FM polyrhythms + shimmer
{
	var base = 150 + LFNoise1.kr(0.3, 2500, 300);
	var fm = SinOsc.ar(LFNoise0.kr(0.5, 100, 200), 0, 300);
	var sig1 = SinOsc.ar(base + fm) * LFPulse.kr(6.25, 0, 0.4);
	var sig2 = Saw.ar(base * 0.75 + fm * 0.5) * LFPulse.kr(4.1, 0, 0.5) * 0.25;
	var sig3 = SinOsc.ar(base * 1.33 + fm * 0.3) * LFPulse.kr(5.7, 0, 0.3) * 0.2;
	var sig = sig1 + sig2 + sig3;
	sig = Pan2.ar(sig, LFNoise1.kr(0.05));
	sig = AllpassC.ar(sig, 0.3, {LFNoise1.kr(0.2).exprange(0.02,0.1)}!2, 4) * 0.6;
	sig = sig + (PitchShift.ar(sig, 0.2, 2.0, 0.01, 0.01) * 0.4); // shimmer octave up
	sig = (sig * LFNoise1.kr(0.1, 0.4, 0.6)).softclip * 0.3;
	sig * 0.25;
}.play;
)
