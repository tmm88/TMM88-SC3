(
{
    var numVoices = 32;
    var duration = 60;
    var masterAmp = 0.04;

    var voices = Mix.fill(numVoices, { |i|
        var freqStart = exprand(200, 8000); // Exponential distribution for better frequency spread
        var freqRatio = rrand(0.25, 4.0); // More dramatic frequency changes
        var freqEnv = XLine.kr(freqStart, freqStart * freqRatio, duration); // Exponential frequency change

        var lfoRate = rrand(0.1, 12);
        var lfoDepth = rrand(0.15, 0.35);
        var ampLFO = SinOsc.kr(lfoRate, i * 0.2, lfoDepth, 0.005);

        var filterFreq = rrand(500, 5000);
        var filteredSaw = LPF.ar(Saw.ar(freqEnv, ampLFO), filterFreq);

        Pan2.ar(filteredSaw, rrand(-1.0, 1.0)); // Stereo panning
    });

    voices * masterAmp;
}.play;
)