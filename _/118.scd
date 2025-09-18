(
{
	var modFreq = LFNoise2.kr(0.2).range(1, 8) * 50; // wandering modulator frequency
	var modIndex = LFNoise1.kr(0.1).range(20, 80);   // dynamic index
	var carriers = [60, 62, 90];                     // 3 detuned carriers

	var fm = carriers.collect { |cfreq|
		var mod = SinOsc.ar(modFreq, 0, modIndex);
		SinOsc.ar(cfreq + mod, 0, 0.1)
	};

	var drone = Mix(fm);
	var sub   = SinOsc.ar(30, 0, 0.1);

	var sig = drone + sub;
	sig = RLPF.ar(sig, LFNoise1.kr(0.1).range(300, 1500), 0.3);
	sig = (sig * 5).tanh * 0.3;
	sig = FreeVerb.ar(sig, 0.4, 0.6, 0.3);

	Splay.ar(sig, 0.5);
}.play;


{
	var modFreq  = LFNoise2.kr(0.2).range(1, 6) * 50; // slow-moving modulator
	var modIndex = LFNoise1.kr(0.1).range(10, 60);    // index drift
	var carrier  = 70;                                // single carrier

	var mod  = SinOsc.ar(modFreq, 0, modIndex);
	var tone = SinOsc.ar(carrier + mod, 0, 0.2);
	var sub  = SinOsc.ar(30, 0, 0.1);

	var sig = tone + sub;
	sig = RLPF.ar(sig, LFNoise1.kr(0.1).range(200, 1200), 0.3);
	sig = (sig * 4).tanh * 0.3;
	sig = FreeVerb.ar(sig, 0.3, 0.6, 0.3);

	sig ! 2 // stereo
}.play;


{
	var mod = SinOsc.ar(40, 0, 50);        // simple modulator
	var tone = SinOsc.ar(100 + mod, 0, 0.2);
	var sig = RLPF.ar(tone, 800, 0.3);
	sig = FreeVerb.ar(sig, 0.3, 0.6, 0.2);
	sig ! 2
}.play;
)
