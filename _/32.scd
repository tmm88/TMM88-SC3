(
{
	var freqs = Array.fill(24, { 200 + LFDNoise3.kr(rrand(0.1, 4), 2000) });
	var sig = Mix(SinOsc.ar(freqs, 0, 0.05));
	sig = CombC.ar(sig, 0.25, LFNoise1.kr(0.1, 0.2, 0.21), 10);
	sig = LeakDC.ar(sig);
	sig * 0.3 !2
}.play;
)
