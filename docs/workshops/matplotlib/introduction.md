# Getting Started with Python and MatPlotLib
[Back to main index](index.md)

## Introduction

Let's say you have some data that you have generated, whether it is from an experiment or a simulation, and you want to visualize it. How would you go about that? You could probably piece together an image pixel by pixel to create something, but that sounds like a lot of work. Thankfully, most of that work has been done for you. There's a python package called 'MatPlotLib' that lays down the groundwork to generate stunning graphics, and even animations.

Python is a programming language this is quick to learn and easy to use. Its use in scientific computing has been expanding rapidly. It has many packages that you can install and use, such as MatPlotLib. But there are a plethora of other packages available including ones doing machine learning, quantum computing, and many more!

## Packages

In this series of workshops, we will focus on the MatPlotLib package and its uses. It was based off of MATLAB's plotting system, but implemented in a more intuitive way. There are a couple of other packages we will use along the way:

- **OS**: This one is used rarely, it interfaces with your operating system to perform some simple tasks
- **NumPy**: A C-based numeric library to perform quick mathematical operations
- **Bokeh**: Used only in our interactive plotting session, it creates plots that can be served on the web
- **ffmpeg** (external): In one example of creating animated figures, we use the external (non-Python) ffmpeg package, which deals with creating and editing videos through the command line

## Installation

If you do not have python already installed on your computer, please download it here: [Download Python](https://www.python.org/downloads/). Once python is downloaded and installed, please open a terminal (or PowerShell if you are on Windows) and run:
```
python --version
```
To ensure it is installed correctly.

After installing python and checking that it's installed, we need to install MatPlotLib. There are better ways to do this (such as if you are using one of RCAC's clusters), but for now we will do the simple but wrong way. In a terminal, please run the command:
```
pip install matplotlib
```
This will go through and install the MatPlotLib package as well as any dependencies it has (which includes NumPy).

## Writing Python Code

There are two main ways to write code in Python:

- Interactively
- Scripting

In this workshop, we will write scripts and run those scripts. The script is essentially a list of commands you want the computer to run. You could do the same thing interactively and write the program line-by-line every time, but scripts introduce reproducibility to your workflow.

[Next Section](first_script.md)
