(
{
	var base = 100 + LFNoise1.kr(0.07!3, 50, 70).mean; // Lower base freq, more variation
	var fm1 = SinOsc.ar(LFNoise0.kr(0.25).range(15,90), 0, LFNoise1.kr(0.2, 50, 80));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.35).range(40,120), 0, LFNoise1.kr(0.25, 40, 70));
	// Drone oscillators
	var drone = Mix.fill(6, { |i| Saw.ar(base * (0.4 + i*0.2) + fm1 + fm2, 0.07) }); // More oscillators, lower amplitude

	// Formant shaping with wider range
	var formants = Mix.fill(4, { |i|
		Formant.ar(drone * 0.4, LFNoise1.kr(0.12*(i+1)).range(200,1200), LFNoise1.kr(0.18*(i+1)).range(60,250), LFNoise1.kr(0.25*(i+1)).range(100,400))
	});

	// Noise bed with dynamic filtering
	var noiseAtmo = BPF.ar(BrownNoise.ar(0.25), LFNoise1.kr(0.4).range(200,2500), 0.25);

	// Combine with tremolo
	var sig = drone + formants + noiseAtmo;
	sig = sig * SinOsc.kr(LFNoise1.kr(0.1).range(0.3,0.8)).range(0.6,1); // Subtle tremolo

	// Spectral processing
	sig = PitchShift.ar(sig, 0.5, [0.9,1.1], 0.03, 0.06).sum * 0.35;
	sig = AllpassN.ar(sig, 0.7, LFNoise1.kr(0.25).range(0.15,0.6), 4);
	sig = GVerb.ar(sig, 100, 14, 0.6, 0.9, 25, -6, 0.4, 0.2) * 0.45;

	sig = Compander.ar(sig, sig, 0.25, 1, 0.2);
	Pan2.ar(sig, LFNoise1.kr(0.12));
}.play;
)