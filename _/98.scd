(
{
    var numVoices = 16;
    var baseFreq = 55;
    // Create an array of 16 slightly detuned frequencies
    var freqs = ({ baseFreq * LFNoise1.kr(0.05).range(0.995, 1.005) } ! numVoices);
    var lfoDepth = LFNoise1.kr(0.1).range(0.1, 0.5);

    var oscArray = freqs.collect { |freq, i|
        var lfoRate = 0.1 + (i * 0.01); // Slightly different LFO rate for each voice
        var lfo = SinOsc.kr(lfoRate, i * 0.1, lfoDepth, 1);
        var sig = Pulse.ar(freq, LFNoise1.kr(0.1).range(0.3, 0.7), 1/numVoices * lfo);
        Pan2.ar(sig, i.linlin(0, numVoices-1, -0.8, 0.8)) // Spread voices in stereo
    };

    var drone = Mix(oscArray) * 0.4;

    var sig = drone;
    // A phaser to enhance the beating effect
    sig = AllpassN.ar(sig, 0.5, [0.05, 0.051], 4);
    sig = JPverb.ar(sig, 10, 0, 1.0) * 0.4 + sig; // Short, bright reverb
    sig * 0.8;
}.play;
)