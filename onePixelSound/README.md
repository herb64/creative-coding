# My "One Pixel Sound Cinema" aka "Sound from Outer Space"

This is the new version of the original one pixel cinema from the Futurelearn course.
It uses the originel melbourneCity.jpg and nasaImage.jpg which are provided as course material. See
license in upper directory.

## Basic idea
I was inspired by the sound functions during the course, and found, that there are also functions,
which provide "kind of synthesizer" functionality, instead of only replaying sound files.
This made me come up with the idea to modify the original sketch, showing 10 sample points
as vertical bars on the left to also incorporate some sound.
For each of the sample points, a corresponding Sine Wave Oscillator has been defined, playing
a sine wave sound of a specific frequency and direction.

## Simple rules
The hue value of each sample point defines the frequency of its corresponding oscillator. In addition, 
I decided to introduce a "pan" value depending on the overall brightness of the sampled points.

Thus, dark pixels are "played" on the left, while "bright" ones go to the right. It's important to 
note, that the frequency is NOT dependent on the brightness, but only on the hue value.

Formula behing in current code:
```
    float hueval = (float)hue(pixelColors[i]);
    float brightval = (float)brightness(pixelColors[i]);
    float freq = map(hueval,0.0,255.0,80.0,1500.0);
    float pan = map(brightval,0.0,255.0,-1.0,1.0);
    sine[i].freq(freq);
    sine[i].pan(pan);
```
 
## About interaction

You can use the following keys to interact.

| Key | Function | Remark     |
|------------------------|-------------|-------------|
| 1-0 | Toggle sound for each channel on/off           | 1 = left column, 0 = right column. Inactive tracks are shown in black circles|


