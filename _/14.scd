// Iteration 1: Softer and smoother
{SinOsc.ar(LFDNoise3.kr(3.14 * 3, 1000, 1000).clip(20, 2000)) * 0.25}.play;