// Iteration 6: Mouse-controlled instrument
(
{
    var speed = MouseX.kr(0.1, 20, 1); // Control speed with mouse X
    var range = MouseY.kr(20, 5000, 1); // Control range with mouse Y
    var freq = LFDNoise3.kr(speed, range, range/2).abs; // Use mouse values
    SinOsc.ar(freq) * 0.2;
}.play;
)