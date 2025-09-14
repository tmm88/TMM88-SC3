(
{
    // Primary trigger with LFO-modulated rate
    var rate = SinOsc.kr(0.2).range(1, 7); // Faster LFO, 1-7 Hz
    var trig = Impulse.kr(rate);
    
    // Secondary trigger for syncopated bursts
    var trig2 = Impulse.kr(rate * 0.5); // Half-rate syncopation
    
    // Polyphonic frequency arrays for layered bursts
    var freqs = Array.fill(3, { Demand.kr(trig, 0, Dwhite(100.0, 2000.0, inf)) }); // 3 voices
    var freqs2 = Array.fill(2, { Demand.kr(trig2, 0, Dwhite(50.0, 500.0, inf)) }); // Low voices
    
    // Sequenced amplitude and resonance patterns
    var ampSeq = Demand.kr(trig, 0, Dseq([0.6, 0.3, 0.8, 0.2], inf));
    var resSeq = Demand.kr(trig, 0, Dseq([0.1, 0.3, 0.2, 0.4], inf)); // Filter resonance
    
    // Envelopes for primary and secondary triggers
    var env = Decay2.kr(trig, 0.008, TExpRand.kr(0.08, 0.4, trig));
    var env2 = Decay2.kr(trig2, 0.01, TExpRand.kr(0.05, 0.25, trig2));
    
    // Polyphonic oscillator mix with vibrato
    var sig = Mix(
        freqs.collect { |freq, i|
            var vib = SinOsc.kr(5 + (i * 0.5)).range(0.98, 1.02); // Randomized vibrato
            SinOsc.ar(freq * vib) * (0.4 / (i + 1)) + Saw.ar(freq * vib) * (0.2 / (i + 1))
        }
    );
    var lowSig = Mix(
        freqs2.collect { |freq| Pulse.ar(freq) * 0.15 }
    );
    sig = sig + (lowSig * env2);
    
    // Noise layer for texture
    var noise = PinkNoise.ar() * env2 * 0.08;
    sig = sig + noise;
    
    // Modulated resonant filter
    var filtFreq = freqs[0] * 2 * SinOsc.kr(0.25).range(0.5, 1.6);
    var filt = RLPF.ar(sig, filtFreq, resSeq);
    sig = (sig * 0.3) + (filt * 0.7);
    
    // Modulated distortion
    var dist = sig.distort * SinOsc.kr(0.1).range(0.1, 0.5);
    sig = (sig * 0.6) + (dist * 0.4);
    
    // Apply envelopes and amplitude sequence
    sig = sig * env * ampSeq * 0.5;
    
    // Randomized delay effect
    var delayTime = Demand.kr(trig, 0, Dwhite(0.1, 0.4, inf));
    var delay = CombC.ar(sig, 0.5, delayTime, 0.5) * 0.3;
    sig = sig + delay;
    
    // Reverb for spatial depth
    sig = FreeVerb.ar(sig, mix: 0.35, room: 0.7, damp: 0.5);
    
    // Stereo panning with randomized width
    var pan = SinOsc.kr(0.4).range(-0.8, 0.8) * Demand.kr(trig, 0, Dwhite(0.4, 1.0, inf));
    Pan2.ar(sig, pan);
}.play;
)