# Animations
[Back to main index](index.md){ .md-button }

[Previous page](plot_types.md){ .md-button .md-button--primary }

## Introduction
When you have time-varying data, you cannot show that in a static plot, you need to animate it, so that you can see the variance of the data through time. In this section, we will discuss two separate ways to animate time-varying data:

- FuncAnimation
- ArtistAnimation

Which are both intrinsic to MatPlotLib.

The way these scripts work is that we first generate a data set, which is going to be a random walk in two dimensions. We randomly pick an angle and a step length, then we take that step from the previous step. And then we do that process again until we reach our total number of steps.

After the data is generated, we set some initial values for the plot (such as the extent of the data). Then, we generate the plots and save them into a gif file.

## FuncAnimation

The first way to create an animation is using MatPlotLib's `FuncAnimation` function. It is the fastest way to generate plots, but it can also be tricky to work with. And 'fast' here means that the frames are generated quickly, not that it is simple to code out.

It works by having an initial figure created and then a python function defined to update the figure each frame. Since our data is fairly simple, the update function is likewise simple, we change the plotted data to incorporate an additional step every frame. The `interval` option defines the time between frames of the animation in ms. Lastly, we use the `ani.save()` function to save the animation to a file. Here, we specify that we want it as a `.gif` file, but you could also specify different movie types, such as `.mp4`.

!!! note "Additional Import"

    Note that there is an additional import statement at the top of the script, that contains the package necessary to create animations in MatPlotLib: `import matplotlib.animation as animation`

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

num_steps = 100

xs = np.asarray([0])
ys = np.asarray([0])

rng = np.random.default_rng(seed=25)
steps = np.arange(0,num_steps,1)
for step in steps:
    step_angle = 2*np.pi*rng.random()
    step_size = 3*rng.random()
    xs=np.append(xs, xs[-1]+step_size*np.cos(step_angle))
    ys=np.append(ys, ys[-1]+step_size*np.sin(step_angle))

min_x = np.min(xs)
max_x = np.max(xs)
min_y = np.min(ys)
max_y = np.max(ys)

fig, ax = plt.subplots()

line2 = ax.plot(xs[0], ys[0])[0]
ax.set(xlim=[min_x, max_x], ylim=[min_x, max_x])

def update(frame):
    # update the line plot:
    line2.set_xdata(xs[:frame])
    line2.set_ydata(ys[:frame])
    return (line2)


ani = animation.FuncAnimation(fig=fig, func=update, frames=num_steps, interval=50)
ani.save('animated.gif')
```
![A gif of a random walk on loop, generated using FuncAnimation.](/assets/images/workshops/matplotlib/animated.gif "FuncAnimation Gif")

## ArtistAnimation

The second way to create an animation is to use the `ArtistAnimation` function, which takes an array of axes to smash together to form an animation.

In the following script, the imports and data creation are all the same as the previous script. But instead of defining a function to update the figure for us, we simply make a list of the plots we want to have in the animation.

We also add some helper lists, `alphas` and `lws` which set the gradually decreasing transparency and line widths, respectively.

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

num_steps = 100

xs = np.asarray([0])
ys = np.asarray([0])

rng = np.random.default_rng(seed=25)
steps = np.arange(0,num_steps,1)
for step in steps:
    step_angle = 2*np.pi*rng.random()
    step_size = 3*rng.random()
    xs=np.append(xs, xs[-1]+step_size*np.cos(step_angle))
    ys=np.append(ys, ys[-1]+step_size*np.sin(step_angle))

min_x = np.min(xs)
max_x = np.max(xs)
min_y = np.min(ys)
max_y = np.max(ys)

fig, ax = plt.subplots()
ax.set_xlim([min_x,max_x])
ax.set_ylim([min_y,max_y])

alphas=[1]
lws = [2]
dec = 1.05

artists = []
for step in steps:
    alphas.insert(0,alphas[0]/dec)
    lws.insert(0,lws[0]/dec)
    lines = []
    for i in range(step+1):
        line, = ax.plot(xs[i:i+2],ys[i:i+2],'b',alpha=alphas[i],lw=lws[i])
        lines.append(line)
    artists.append(lines)

ani = animation.ArtistAnimation(fig=fig, artists=artists, interval=50)
ani.save('artists.gif')
```
![A gif of a random walk on loop, generated using ArtistAnimation. This one, the previous steps of the random walk gradually get more transparent until you cannot see them anymore.](/assets/images/workshops/matplotlib/artists.gif "ArtistAnimation Gif")


<!---
## FFmpeg

The last way to make animations with MatPlotLib (in this workshop) is to incorporate an external package named FFmpeg. It is an audio and video stream editor, which is versatile and powerful. However in this case, we will use it to convert a series of images into a gif.

The data generation step is still the same, we want the same data as before. But, we have an additional `import` statement at the top, which imports the OS package. This allows us to run programs outside of

```python
import numpy as np
import matplotlib.pyplot as plt
import os

num_steps = 100

xs = np.asarray([0])
ys = np.asarray([0])

rng = np.random.default_rng(seed=25)
steps = np.arange(0,num_steps,1)
for step in steps:
    step_angle = 2*np.pi*rng.random()
    step_size = 3*rng.random()
    xs=np.append(xs, xs[-1]+step_size*np.cos(step_angle))
    ys=np.append(ys, ys[-1]+step_size*np.sin(step_angle))

min_x = np.min(xs)
max_x = np.max(xs)
min_y = np.min(ys)
max_y = np.max(ys)

alphas=[1]
lws = [2]
dec = 1.05

for step in steps[1:]:
    fig, ax = plt.subplots()
    alphas.insert(0,alphas[0]/dec)
    lws.insert(0,lws[0]/dec)
    for i in range(step):
        ax.plot(xs[i:i+2],ys[i:i+2],'b',alpha=alphas[i],lw=lws[i])
    ax.set_xlim([min_x,max_x])
    ax.set_ylim([min_y,max_y])
    plt.savefig('ffmpeg%04d.png' % step)
    plt.close()

os.system('ffmpeg -hide_banner -loglevel panic -y -r 15 -f image2 -i ffmpeg%04d.png -vf "scale=500:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" ffmpeg.gif')
os.system('rm ffmpeg*.png')
```
![A gif of a random walk on loop. This one, the previous steps of the random walk gradually get more transparent until you cannot see them anymore.](/assets/images/workshops/matplotlib/ffmpeg.gif "FFmpeg Gif")
-->

!!! note "Optimization"

    There are ways that you could optimize these plots further, such as not appending to an array, and instead allocating the whole array in memory, then change each individual step. Another thing you could do is generate the plot inside the data generation loop. However, because it is a random walk, we do not know before hand what x- and y-limits should be put, so we generate the data and then the plots.

In the next section we will talk about the Envision Center, RCAC's center for advanced visualization:
[Next Section](env_cent.md){ .md-button .md-button--primary }
