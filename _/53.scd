(
// Massive Iteration 4: Dark drone swarm & formant sculpting
{
	var base = 120 + LFNoise1.kr(0.05!3, 40, 60).mean;
	var fm1 = SinOsc.ar(LFNoise0.kr(0.2).range(20,80), 0, LFNoise1.kr(0.15, 40, 70));
	var fm2 = SinOsc.ar(LFNoise0.kr(0.3).range(50,100), 0, LFNoise1.kr(0.2, 30, 60));
	// Drone oscillators
	var drone = Mix.fill(5, { |i| Saw.ar(base * (0.5 + i*0.25) + fm1 + fm2, 0.08) });

	// Formant shaping
	var formants = Mix.fill(3, { |i|
		Formant.ar(drone * 0.3, LFNoise1.kr(0.1*(i+1)).range(300,800), LFNoise1.kr(0.15*(i+1)).range(80,200), LFNoise1.kr(0.2*(i+1)).range(150,300))
	});

	// Noise bed
	var noiseAtmo = BPF.ar(BrownNoise.ar(0.2), LFNoise1.kr(0.3).range(300,2000), 0.2);

	// Combine
	var sig = drone + formants + noiseAtmo;

	// Spectral delay/reverb combo
	sig = PitchShift.ar(sig, 0.4, [0.95,1.05], 0.02, 0.05).sum * 0.4;
	sig = AllpassN.ar(sig, 0.6, LFNoise1.kr(0.2).range(0.1,0.5), 3);
	sig = GVerb.ar(sig, 80, 12, 0.7, 0.8, 20, -5, 0.5, 0.3) * 0.5;

	sig = Compander.ar(sig, sig, 0.3, 1, 0.25);
	Pan2.ar(sig, LFNoise1.kr(0.1));
}.play;
)
