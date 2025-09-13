(
{
    // LFOs (Modulation Sources)
    var lfo1 = LFPulse.kr(4, 0, 0.5); // Rhythmic gate
    var lfo2 = LFTri.kr(0.5).range(0.1, 0.5);
    var seq = Stepper.kr(lfo1, 0, 1, 8).round(1.0); // Pitch sequence
    var gate = lfo1; // The LFPulse is now the gate

    // VCOs (Sound Sources)
    var vco1 = Saw.ar(440 + (seq * 100), 0.5); // Pitched based on the sequence
    var vco2 = SinOsc.ar(vco1.freq + 2, 0.3); // Detuned by a fixed amount
    var noise = PinkNoise.ar(0.1);

    // MIXER
    var vcoMix = (vco1 + vco2 + noise) * 0.6;

    // VCF (Filter) - A resonant filter that follows the rhythm
    var vcf = RLPF.ar(
        vcoMix,
        400 + (lfo1.exp * 2000), // Filter frequency jumps with the pulse
        0.5
    );

    // VCA (Amplifier) with a quick, gated envelope
    var env = EnvGen.kr(Env.adsr(0.01, 0.1, 0.8, 0.2, 1, 0, \linear), gate, doneAction: 0);
    var vca = vcf * env;

    // EFFECTS Send - Fast echo and drive
    var delay = CombC.ar(vca, 0.3, 0.15, 2) * 0.7; // Fast slapback delay
    var drive = LPF.ar(vca, 2000) * 2; // Simple overdrive

    // FINAL MIX
    var sig = vca + delay + drive;
    sig = Limiter.ar(sig, 0.9);
    Pan2.ar(sig, 0); // No panning
}.play;
)