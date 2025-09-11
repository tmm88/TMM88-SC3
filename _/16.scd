// Iteration 3: Triggered bursts
(
{
    var trig = Impulse.kr(2); // Trigger a new burst 2 times per second
    var freq = Demand.kr(trig, 0, Dwhite(100.0, 2000.0, inf)); // New random freq on each trigger
    var env = Decay2.kr(trig, 0.01, 0.2); // Percussive envelope
    SinOsc.ar(freq) * env * 0.5;
}.play;
)