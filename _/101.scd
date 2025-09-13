(
{
    // LFOs (Modulation Sources) - Slow and gentle for a dreamy feel
    var lfo1 = LFTri.kr(0.03).range(0.99, 1.01); // Very subtle pitch drift
    var lfo2 = SinOsc.kr(0.02).range(0.1, 0.3); // Slow filter modulation
    var lfo3 = LFNoise0.kr(0.1).range(0.5, 1.0); // Random resonance changes
    var gate = 1;

    // VCOs (Sound Sources) - Multiple detuned sines
    var vco1 = SinOsc.ar(110 * lfo1, 0.5);
    var vco2 = SinOsc.ar(110.1 * lfo1, 0.4); // Detuned
    var vco3 = SinOsc.ar(109.8 * lfo1, 0.3); // Detuned the other way

    // MIXER
    var vcoMix = (vco1 + vco2 + vco3) * 0.7;

    // VCF (Filter) - Gentle, resonant low-pass filter
    var vcf = LPF.ar(
        vcoMix,
        3000 * lfo2, // Slowly sweeping filter
    );
    vcf = OnePole.ar(vcf, 0.9); // Adds a subtle low-pass to smooth things out

    // VCA (Amplifier) with a long attack and release
    var env = EnvGen.kr(Env.adsr(8, 2, 0.8, 15, 1, 0, \sine), gate, doneAction: 0);
    var vca = vcf * env;

    // EFFECTS Send - Huge reverb and chorus
    var chorus = JPverb.ar(vca, 0.5, 0.8, 0.5); // Rich chorus for stereo width
    var reverb = FreeVerb.ar(vca + chorus, mix: 0.9, room: 0.9, damp: 0.5); // Large, long reverb

    // FINAL MIX
    var sig = vca + reverb;
    sig = Limiter.ar(sig, 0.9);
    Pan2.ar(sig, LFTri.kr(0.01)); // Very slow panning for a wide stereo image
}.play;
)