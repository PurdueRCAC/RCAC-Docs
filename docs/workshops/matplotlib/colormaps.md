# Colormaps
[Back to main index](index.md){ .md-button }

[Previous page](plot_types.md){ .md-button .md-button--primary }

Up until now, we have used the default colors for our 2D plots. However, MatPlotLib provides many different pre-baked colormaps for us to use. These are essentially color gradients that have been created to map our data to colors.

## Named Colormaps

MatPlotLib has a total of 86 named color maps ready to use. They are separated into four overarching categories:

> Sequential: change in lightness and often saturation of color incrementally, often using a single hue; should be used for representing information that has ordering.

> Diverging: change in lightness and possibly saturation of two different colors that meet in the middle at an unsaturated color; should be used when the information being plotted has a critical middle value, such as topography or when the data deviates around zero.

> Cyclic: change in lightness of two different colors that meet in the middle and beginning/end at an unsaturated color; should be used for values that wrap around at the endpoints, such as phase angle, wind direction, or time of day.

> Qualitative: often are miscellaneous colors; should be used to represent information which does not have ordering or relationships.

These categories are taken from the [MatPlotLib website](https://matplotlib.org/stable/users/explain/colors/colormaps.html).

MatPlotLib has a great writeup about the different features of the different color maps here: [MatPlotLib Color Maps](https://matplotlib.org/stable/users/explain/colors/colormaps.html)

They also go into depth about the lightness of the colormaps as well as what each colormap looks like in greyscale.

## Using Colormaps

Using colormaps is quite simple: add the `cmap='CMAP_NAME'` option to the plotting function you are using and MatPlotLib will handle the rest.

In the following script, we use four different colormaps with the same `contourf` function on the same data. The invocation stays mostly the same, it just changes the `cmap` option on each one. We also use a new function, `fig.suptitle()`, which puts a title at the top of the figure, instead of on top of a specific set of axes. The `y` option (`y=0.94`) helps position the overall title so that there is not as much space around it as if we left that option off.

```python
import matplotlib.pyplot as plt
import numpy as np

bound = 5

X, Y = np.meshgrid(np.linspace(-bound, bound, 10*bound), np.linspace(-bound, bound, 10*bound))
Z = X + Y**2 + np.sin(X*Y) + 1/X

levels = np.linspace(Z.min(),Z.max(),10)

fig, ((ax_tl,ax_tr),(ax_bl,ax_br)) = plt.subplots(2,2)

fig.suptitle('Colormaps', fontweight='bold', y=0.94)

cfax_tl = ax_tl.contourf(X,Y,Z, levels=levels)
fig.colorbar(cfax_tl)
ax_tl.set_title('Default/Viridis')

cfax_tr = ax_tr.contourf(X,Y,Z, levels=levels, cmap='magma')
fig.colorbar(cfax_tr)
ax_tr.set_title('Magma')

cfax_bl = ax_bl.contourf(X,Y,Z, levels=levels, cmap='Greens')
fig.colorbar(cfax_bl)
ax_bl.set_title('Greens')

cfax_br = ax_br.contourf(X,Y,Z, levels=levels, cmap='seismic')
fig.colorbar(cfax_br)
ax_br.set_title('Seismic')

plt.show()
```
![An image showing four filled contour plots, each with different colors for their levels. The top left is the default colormap: viridis. The top right uses the magma colormap, which ranges from black to white through oranges and reds. The bottom left uses the greens colormap, which goes from white to dark green. The bottom right uses the seismic colormap, which starts at blue, then goes to white, and ends up red.](./_static/Colormaps.png "Filled Contour Plots Showing Colormaps")

## Colormap Scales

What if you had some non-linear scale you wanted to show of data, or data that has a large span? MatPlotLib allows you to change the scale, or normalization of the colormap. In the following script, we show three types of color normalizations:

- **Linear**
- **Logarithmic**
- **Centered**

**Linear** is the default and linearly increases from your data's minimum to its maximum. **Logarithmic** uses a linear scale through powers of 10 to place more emphasis on smaller data values. **Centered** puts the center of the scale at 0 and essentially maps the data to go from the largest absolute value of your data down to the negative largest absolute value.

To implement these scales, we need to import one more package: `matplotlib.colors` at the top of our script, and we will nickname it: `colors`. Then in the plotting invocation, we can use the `norm=NORMALIZATION` option to specify the normalization of the data. Here we use the `ax.imshow()` function to plot the data, with a specified `extent=[left,right,bottom,top]` to constrain the span of the data. We use two different functions: one that is strictly positive (for the top two plots) and one that spans positive and negative (for the bottom two plots). The strictly positive one is necessary because the logarithmic norm fails if there are negative values in the data. There is an option for a two-sided logarithmic norm that uses a logarithmic scale for both sides of zero. Details of that normalization can be found [**here**](https://matplotlib.org/stable/users/explain/colors/colormapnorms.html#symmetric-logarithmic).

```python
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.colors as colors

bound = 5

X, Y = np.meshgrid(np.linspace(-bound, bound, 10*bound), np.linspace(-bound, bound, 10*bound))
LOG = np.abs(20*X-10*np.sin(Y))+X**2+np.log(Y**2+5)

Z1 = np.exp(-X**2 - Y**2)
Z2 = np.exp(-(X - 1)**2 - (Y - 1)**2)
CEN = (0.9*Z1 - 0.5*Z2) * 2

fig, ((ax_tl,ax_tr),(ax_bl,ax_br)) = plt.subplots(2,2,figsize=(10,8))

fig.suptitle('Color Scales', fontweight='bold', y=0.94)

cfax_tl = ax_tl.imshow(LOG, extent=[-bound,bound,-bound,bound],origin='lower')
fig.colorbar(cfax_tl)
ax_tl.set_title('Linear')

cfax_tr = ax_tr.imshow(LOG, extent=[-bound,bound,-bound,bound], norm=colors.LogNorm(), origin='lower')
fig.colorbar(cfax_tr)
ax_tr.set_title('Logarithmic')

cfax_bl = ax_bl.imshow(CEN, extent=[-bound,bound,-bound,bound],origin='lower',cmap='seismic')
fig.colorbar(cfax_bl)
ax_bl.set_title('Linear')

cfax_br = ax_br.imshow(CEN, extent=[-bound,bound,-bound,bound], norm=colors.CenteredNorm(), origin='lower', cmap='seismic')
fig.colorbar(cfax_br)
ax_br.set_title('Centered')

plt.show()
```

![An image showing four filled contour plots, each with different normalizations for their colors. The top two plots have the default colormap: viridis (blue, green, and yellow). The top left uses a linear scale for coloring, where the top right uses a logarithmic scale. The bottom two plots use the seismic colormap, which is blue, then white, then red. The bottom left plot is mostly blue and uses a standard linear map. The bottom right plot is mostly white as it uses a centered scaling, which goes around 0.](./_static/Color_scales.png "Heat Maps Showing Color Scales")

In the next section, we will discuss how to make a time-series of plots into an animation, such as a gif.

[Next section](animations.md){ .md-button .md-button--primary }
