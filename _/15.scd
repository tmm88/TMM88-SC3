// Iteration 2: Stereo width
(
{
    var freq = LFDNoise0.kr([3.14*3, 3.10*3], 1000, 1000).abs; // Different rates for L/R
    SinOsc.ar(freq.clip(20, 5000)) * 0.2; // Auto-panned to left and right
}.play;
)