(
{
    // LFOs (Modulation Sources) - Stepped and fast for glitch
    var lfo1 = Stepper.kr(4, 0, 1, 12).lag(0.01); // Stepped pitch modulation
    var lfo2 = Dust.kr(4).range(0.1, 0.9); // Fast, random filter cutoff
    var lfo3 = LFDot.kr(8).range(1.0, 2.0); // Random filter Q
    var gate = 1;

    // VCOs (Sound Sources) - Harsh and metallic
    var vco1 = Formant.ar(55, lfo1 * 50, 50, 0.4); // Formant adds a vocal-like texture
    var vco2 = SinOsc.ar(55.5 * lfo1 * 2, 0.5); // Detuned and scaled
    var vco3 = Saw.ar(110, 0.1);
    var noise = WhiteNoise.ar(0.2);

    // MIXER
    var vcoMix = (vco1 * vco2 + vco3 + noise) * 0.5; // Changed to a product for more complex interaction

    // VCF (Filter) - Fast-changing filter with high resonance
    var vcf = Resonz.ar(
        vcoMix,
        lfo2.linexp(0.1, 0.9, 100, 5000), // Exponential filter frequency
        lfo3, // High Q for piercing resonance
        0.5
    );

    // VCA (Amplifier) with a fast, gated envelope
    var env = EnvGen.kr(Env.adsr(0.01, 0.1, 0.5, 0.2, 1, 0, \linear), gate, doneAction: 0);
    var vca = vcf * env;

    // EFFECTS Send - Feedback and bitcrushing
    var delay = CombN.ar(vca, 0.5, 0.3, 5) * 0.6; // Longer delay time
    var bitcrush = Crush.ar(vca, 4, 0.5, 0.5); // Bitcrusher for a digital lo-fi sound

    // FINAL MIX
    var sig = vca + delay + bitcrush;
    sig = Limiter.ar(sig, 0.95);
    Pan2.ar(sig, SinOsc.kr(0.1).range(-1, 1));
}.play;
)