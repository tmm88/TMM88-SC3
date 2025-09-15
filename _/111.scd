(
{
	var base = 50 + LFNoise1.kr(0.05!2, 50, 60).mean; // Deepened base freq, broader noise for evolving foundation
	var fmDepth1 = LFNoise1.kr(0.09, 70, 100); // Amplified FM depths for intensified modulation
	var fmDepth2 = LFNoise1.kr(0.11, 50, 70);
	var fmDepth3 = LFNoise1.kr(0.08, 30, 50);
	var fmDepth4 = LFNoise1.kr(0.14, 20, 40);
	var fmDepth5 = LFNoise1.kr(0.1, 15, 30);
	var fmDepth6 = LFNoise1.kr(0.07, 10, 20); // Added sixth FM for layered complexity

	var fm1 = SinOsc.ar(LFNoise0.kr(0.1).range(6, 25), 0, fmDepth1);
	var fm2 = SinOsc.ar(LFNoise0.kr(0.12).range(10, 35), 0, fmDepth2);
	var fm3 = SinOsc.ar(LFNoise0.kr(0.09).range(2.5, 15), 0, fmDepth3);
	var fm4 = Saw.ar(LFNoise0.kr(0.15).range(1, 10), fmDepth4);
	var fm5 = LFTri.ar(LFNoise0.kr(0.11).range(4, 20), 0, fmDepth5);
	var fm6 = Pulse.ar(LFNoise0.kr(0.08).range(3, 18), LFNoise1.kr(0.2).range(0.2, 0.8), fmDepth6); // Pulse FM for rhythmic modulation

	var drone = Mix.fill(10, { |i| // Increased to 10 partials for ultra-rich spectrum
		var freqMult = 0.15 + i * 0.08; // Narrower spacing for thicker texture
		var fb = LFNoise1.kr(0.07 + i*0.02).range(0.2, 1.2); // Broader feedback for diversity
		var amp = LFNoise1.kr(0.06 + i*0.015).range(0.015, 0.15) * (1 - (i/10)**1.2); // Exponential falloff
		var phase = LFNoise1.kr(0.04).range(0, pi); // Per-partial phase variation
		SinOscFB.ar(base * freqMult + fm1 + fm2 + fm3 + fm4 + fm5 + fm6, fb, amp, phase)
	});

	var sub = LFTri.ar(base * 0.1 + SinOsc.kr(0.01, 0, 1.2), 0, 0.2) +
	           SinOsc.ar(base * 0.3 + SinOsc.kr(0.015, 0, 2), 0, 0.15) +
	           LFPulse.ar(base * 0.25 + SinOsc.kr(0.02, 0, 1), 0, LFNoise1.kr(0.1).range(0.3, 0.6), 0.12) +
	           LFSaw.ar(base * 0.2 + SinOsc.kr(0.025, 0, 0.5), 0, 0.08); // Added saw sub for edge

	var formants = Mix.fill(9, { |i| // Increased to 9 formants for intricate vocal-esque filtering
		var mod = drone * (0.06 + i*0.03);
		var freq = LFNoise1.kr(0.02*(i+1)).range(60 + i*70, 1000 + i*140);
		var bw = LFNoise1.kr(0.05*(i+1)).range(20 + i*20, 250 + i*30);
		var amp = LFNoise1.kr(0.08*(i+1)).range(50 + i*20, 450 + i*50) * (1 - (i/9));
		Formant.ar(mod, freq, bw, amp)
	}) * 0.6;

	var noiseAtmo = GrainSin.ar(2,
		Impulse.kr(LFNoise1.kr(0.16).range(10, 30)),
		LFNoise1.kr(0.3).range(0.05, 0.3),
		LFNoise1.kr(0.35).range(80, 3500),
		LFNoise1.kr(0.14).range(-1, 1)) * 0.3;

	var windNoise = BrownNoise.ar(0.2) * LFNoise2.kr(0.03).range(0.4, 1.0);
	var pulseLayer = Pulse.ar(LFNoise0.kr(0.2).range(20, 60), LFNoise1.kr(0.3).range(0.1, 0.9), 0.12);
	var crackleLayer = Crackle.ar(LFNoise1.kr(0.06).range(1.4, 2.0), 0.07);
	var hissLayer = WhiteNoise.ar(0.05) * LFNoise2.kr(0.04).range(0.1, 0.5); // Added hiss for high-end atmosphere

	var sig = drone + sub + formants + noiseAtmo + windNoise + pulseLayer + crackleLayer + hissLayer;

	// Sophisticated pitch shifting with dynamic ratios
	var shiftRatios = [0.88, 1.09, 0.91, 1.12, 0.94, 1.06, 0.97, 1.03, 1.0, 0.99];
	sig = PitchShift.ar(sig, 0.1, shiftRatios, 0.03, 0.06).sum * 0.15;
	sig = sig + PitchShift.ar(sig, 0.2, [1.2, 0.8, 1.25, 0.75], 0.06, 0.1) * 0.1;
	sig = sig + PitchShift.ar(sig, 0.3, [0.7, 1.3], LFNoise1.kr(0.05).range(0.05, 0.09), 0.15) * 0.08; // Dynamic dispersion

	// Complex delay network with feedback
	sig = AllpassC.ar(sig, 0.7, LFNoise1.kr(0.08).range(0.1, 0.6), 6, 0.5) +
	      AllpassC.ar(sig, 0.9, LFNoise1.kr(0.1).range(0.2, 0.8), 9, 0.6) +
	      AllpassC.ar(sig, 1.2, LFNoise1.kr(0.12).range(0.3, 1.0), 12, 0.7) +
	      AllpassN.ar(sig, 2.0, LFNoise1.kr(0.06).range(0.6, 1.5), 18);

	// Layered reverb system
	sig = GVerb.ar(sig, 350, 50, 0.7, 0.75, 100, -6, 0.4, 0.5) * 0.3;
	sig = FreeVerb2.ar(sig[0], sig[1], 0.7, 0.8, 0.5) * 0.2;
	sig = JPverb.ar(sig, 6, 0.15, 5, modDepth: 0.6) * 0.15;
	sig = Greyhole.ar(sig, delayTime: 2, damp: 0.5, size: 3, diff: 0.8, fb: 0.7) * 0.1; // Added Greyhole for granular reverb

	// Refined dynamics processing
	sig = Compander.ar(sig, sig, 0.2, 1, 0.08, 0.005, 0.03);
	sig = SoftClipAmp.ar(sig, 0.6);
	sig = Limiter.ar(sig, 0.98);

	// Immersive stereo manipulation
	var pan = LFNoise1.kr(0.02).range(-0.7, 0.7);
	sig = Splay.ar(sig, spread: 1.0, level: 1, center: pan);
	sig = Rotate2.ar(sig[0], sig[1], LFNoise1.kr(0.025).range(-0.4, 0.4));
	sig = MidSide.ar(sig, midGain: 1.1, sideGain: 1.3); // Enhanced mid-side processing for width
	Balance2.ar(sig[0], sig[1], LFNoise1.kr(0.045).range(-0.3, 0.3));
}.play;
)