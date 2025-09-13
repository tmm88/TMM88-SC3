(
{
    // LFOs (Modulation Sources)
    var lfo1 = LFNoise2.kr(0.1).range(0.9, 1.1); // Pitch LFO
    var lfo2 = LFTri.kr(0.05).range(0.1, 0.5); // Filter LFO
    var lfo3 = LFNoise1.kr(0.2).range(300, 2000); // Filter Freq LFO
    var gate = 1; // Gate is always open for a drone

    // VCOs (Sound Sources)
    var vco1 = Saw.ar(55 * lfo1, 0.3);
    var vco2 = Pulse.ar(55.5 * lfo1, 0.6, 0.2); // Slightly detuned
    var vco3 = Saw.ar(110 * lfo1, 0.1); // Octave up
    var noise = PinkNoise.ar(0.1);

    // MIXER
    var vcoMix = (vco1 + vco2 + vco3 + noise) * 0.4;

    // VCF (Filter)
    var vcf = MoogFF.ar(
        vcoMix,
        lfo3, // Filter Frequency
        LFPulse.kr(0.1).range(1.5, 3.0) // Filter Resonance
    );

    // VCA (Amplifier) with an ASR Envelope
    var env = EnvGen.kr(Env.adsr(4, 1, 0.7, 10, 1, 0, \sine), gate, doneAction: 0);
    var vca = vcf * env;

    // EFFECTS Send
    var delay = CombC.ar(vca, 0.3, 0.25, 3) * 0.4;
    var reverb = GVerb.ar(vca, 100, 10, 0.7, 0.8, 15, drylevel:0) * 0.3;

    // FINAL MIX
    var sig = vca + delay + reverb;
    sig = Limiter.ar(sig, 0.9);
    Pan2.ar(sig, SinOsc.kr(0.03));
}.play;
)