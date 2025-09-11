(
{
    var freqs, sound;
    // Use LFDNoise1 for smoother frequency modulation
    sound = Mix.fill(6, { 
        var detune = LFNoise1.ar(0.1).range(-5, 5); // Subtle detuning for richness
		freqs = LFDNoise1.kr(3.14 * 2).range(30, 2000); // Slower rate, wider range
		GVerb.ar(
            Saw.ar(freqs + detune), // Apply detuning to base frequencies
            roomsize: 50,       // Larger room for ambient feel
            revtime: 3,         // Moderate reverb decay
            damping: 0.6,       // Slightly dampened for clarity
            drylevel: 0.8,      // Balance dry signal
            mul: 0.1            // Control reverb intensity
        )
    }) * 0.6;              // Slightly higher amplitude for presence
    [sound, sound]          // Stereo output
}.play;
)