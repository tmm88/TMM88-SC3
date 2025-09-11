(
{
    var numVoices = 32;
    var duration = 60;
    var masterAmp = 0.06;

    Mix.fill(numVoices, { |i|
        var freqStart = rrand(1000, 8000);
        var freqEnd = freqStart * rrand(0.5, 2.0); // More interesting frequency evolution
        var lfoRate = rrand(0.125, 8);
        var lfoDepth = rrand(0.2, 0.4);

        var freqEnv = Line.kr(freqStart, freqEnd, duration);
        var ampLFO = SinOsc.kr(lfoRate, i * 0.1, lfoDepth, 0.01);

        Saw.ar(freqEnv, ampLFO) * masterAmp;
    });
}.play;
)