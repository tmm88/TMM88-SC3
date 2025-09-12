(
{
	var base = 130 + LFNoise1.kr(0.06!3, 35, 65).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.22).range(25,85), 0, LFNoise1.kr(0.18, 45, 75));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.28).range(45,110), 0, LFNoise1.kr(0.23, 35, 65));
	// Drone oscillators with Pulse waves and detuning
	var drone = Mix.fill(5, { |i| Pulse.ar(base * (0.5 + i*0.25) * LFNoise1.kr(0.05).range(0.98,1.02) + fm1 + fm2, 0.4, 0.09) }); // Pulse with detune

	// Formant shaping
	var formants = Mix.fill(3, { |i|
		Formant.ar(drone * 0.35, LFNoise1.kr(0.11*(i+1)).range(250,900), LFNoise1.kr(0.16*(i+1)).range(70,220), LFNoise1.kr(0.22*(i+1)).range(120,350))
	});

	// Dynamic noise bed with resonant filter
	var noiseAtmo = Resonz.ar(BrownNoise.ar(0.3), LFNoise1.kr(0.5).range(400,3000), 0.15);

	// Combine
	var sig = drone + formants + noiseAtmo;

	// Spectral processing with modulated pitch shift
	sig = PitchShift.ar(sig, 0.45, LFNoise1.kr(0.1).range(0.85,1.15), 0.025, 0.055).sum * 0.38;
	sig = AllpassN.ar(sig, 0.65, LFNoise1.kr(0.22).range(0.12,0.55), 3.5);
	sig = GVerb.ar(sig, 90, 13, 0.65, 0.85, 22, -4, 0.45, 0.25) * 0.48;

	sig = Compander.ar(sig, sig, 0.28, 1, 0.22);
	Pan2.ar(sig, LFNoise1.kr(0.15));
}.play;
)