---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Cannot use pip after loading ml-toolkit modules


## Question

Pip throws an error after loading the machine learning modules. How can I fix it?

## Answer

Machine learning modules (tensorflow, pytorch, opencv etc.) include a version of `pip` that is newer than the one installed with Anaconda. As a result it will throw an error when you try to use it.

```
$ pip --version
Traceback (most recent call last):
  File "/apps/cent7/anaconda/5.1.0-py36/bin/pip", line 7, in <module>
    from pip import main
ImportError: cannot import name 'main'
```

The preferred way to use `pip` with the machine learning modules is to invoke it via Python as shown below.

```
$ python -m pip --version
```

[**Back to the Software section**](../software.md)
