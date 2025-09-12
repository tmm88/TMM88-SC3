(
{
	var base = 110 + LFNoise1.kr(0.04!3, 45, 55).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.18).range(30,100), 0, LFNoise1.kr(0.13, 50, 80));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.27).range(60,120), 0, LFNoise1.kr(0.17, 40, 70));
	// Layered drone oscillators
	var drone = Mix.fill(3, { |i| Saw.ar(base * (0.5 + i*0.3) + fm1 + fm2, 0.06) }) +
	           Mix.fill(2, { |i| SinOsc.ar(base * (0.6 + i*0.4) + fm1 + fm2, 0, 0.05) }); // Add SinOsc layer
	var sub = SinOsc.ar(base * 0.5, 0, 0.1); // Sub-oscillator for low-end

	// Formant shaping
	var formants = Mix.fill(3, { |i|
		Formant.ar(drone * 0.25, LFNoise1.kr(0.09*(i+1)).range(350,1000), LFNoise1.kr(0.14*(i+1)).range(90,180), LFNoise1.kr(0.19*(i+1)).range(130,320))
	});

	// Granular noise bed
	var noiseAtmo = GrainSin.ar(2, Impulse.kr(LFNoise1.kr(0.3).range(10,30)), 0.1, LFNoise1.kr(0.4).range(400,2200), LFNoise1.kr(0.2)) * 0.2;

	// Combine
	var sig = drone + sub + formants + noiseAtmo;

	// Spectral processing with longer reverb
	sig = PitchShift.ar(sig, 0.6, [0.92,1.08], 0.04, 0.07).sum * 0.35;
	sig = AllpassN.ar(sig, 0.8, LFNoise1.kr(0.18).range(0.2,0.7), 5);
	sig = GVerb.ar(sig, 120, 16, 0.75, 0.9, 30, -3, 0.6, 0.4) * 0.4;

	sig = Compander.ar(sig, sig, 0.32, 1, 0.28);
	Pan2.ar(sig, LFNoise1.kr(0.08));
}.play;
)