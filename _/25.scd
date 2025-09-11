// Iteration 12: Robust Synthetic Instrument
(
SynthDef(\complexModulator, {
    |out=0, rate=3.0, freqCenter=400, freqRange=800,
     filterMul=1.5, amp=0.3, attack=0.01, release=1.0, gate=1|

    var env = EnvGen.kr(Env.adsr(attack, 0.1, 0.7, release), gate, doneAction: 2);
    var modFreq = LFDNoise3.kr(rate, freqRange, freqCenter).abs;

    // Multi-oscillator source
    var saw = Saw.ar(modFreq * 0.99) * 0.3;
    var pulse = Pulse.ar(modFreq * 1.01, LFDNoise1.kr(0.3).range(0.2, 0.4)) * 0.2;
    var sin = SinOsc.ar(modFreq * 2) * 0.1;

    var snd = Mix.ar([saw, pulse, sin]);

    // Dynamic filter controlled by modulation
    var filterFreq = (modFreq * filterMul).clip(100, 8000);
    snd = MoogFF.ar(snd, filterFreq, LFDNoise2.kr(0.2).range(1.5, 3.0));

    // Stereo enhancement and output
    snd = Splay.ar(snd) * env * amp;
    Out.ar(out, snd);
}).add;
)

(

// Create an instance with custom parameters
x = Synth(\complexModulator, [
    \rate, 4.0,
    \freqCenter, 300,
    \freqRange, 1500,
    \filterMul, 2.0,
    \amp, 0.4
]);
)

// Modify during performance
x.set(\rate, 8.0, \freqRange, 800);