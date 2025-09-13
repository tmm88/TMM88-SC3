(
{
    // LFOs (Modulation Sources)
    var lfo1 = LFPulse.kr(0.01).range(0.01, 0.5); // Grain size
    var lfo2 = LFNoise2.kr(10).range(1, 100); // Grain density
    var gate = 1;

    // Granular Source
    // Load a sample buffer for granular synthesis
    var buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

    // Granular Synthesis
    var grain = GrainBuf.ar(
        numChannels: 2,
        trigger: Dust.kr(lfo2), // Density of grains
        dur: lfo1, // Grain duration
        bufnum: buf,
        pos: LFTri.kr(0.05).range(0, 1), // Sweeping through the buffer
        rate: 1, // Normal speed
        interp: 4
    );

    // MIXER
    var vcoMix = grain * 0.8;

    // VCF (Filter)
    var vcf = ResonZ.ar(vcoMix, 3000, 100); // A high-resonance filter to ring

    // VCA (Amplifier)
    var env = EnvGen.kr(Env.adsr(4, 1, 0.7, 10, 1, 0, \sine), gate, doneAction: 0);
    var vca = vcf * env;

    // EFFECTS Send
    var delay = CombN.ar(vca, 0.5, 0.2, 3) * 0.4;
    var reverb = FreeVerb.ar(vca, 0.5, 0.9, 0.8) * 0.5;

    // FINAL MIX
    var sig = vca + delay + reverb;
    sig = Limiter.ar(sig, 0.95);
    Pan2.ar(sig, 0);
}.play;
)