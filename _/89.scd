(
{
    var tempo = 1.5;
    var base = 65 + LFNoise1.kr(0.1!2, 10).mean;
    var pulse = LFPulse.kr(tempo, 0, 0.4) * LFPulse.kr(tempo*3, 0, 0.2); // Rhythmic gate
    var fm = Pulse.ar(LFNoise1.kr(0.2).range(80, 200), 0.5, 15);

    var drone = Mix.fill(3, { |i|
        var saw = Saw.ar(base * (i+1) * [1, 1.01] + fm, pulse * 0.1);
        RLPF.ar(saw, LFNoise1.kr(0.1).range(200, 1200), 0.3)
    });

    var sub = Pulse.ar(base * 0.25, 0.8, pulse * 0.2);

    var sig = drone + sub;
    // Phaser and Flanger for movement
    sig = AllpassN.ar(sig, 0.5, SinOsc.kr(0.08, [0, pi]).range(0.01, 0.1), 4) * 0.3 + sig;
    sig = MoogFF.ar(sig, pulse.range(300, 2000) + 300, 2.5);
    sig = Compander.ar(sig, sig, 0.5, 1, 1/4);
    Pan2.ar(sig, SinOsc.kr(0.05));
}.play;
)