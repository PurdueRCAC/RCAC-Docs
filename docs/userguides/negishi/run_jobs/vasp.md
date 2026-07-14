---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---


# VASP

The Vienna Ab initio Simulation Package (VASP) is a computer program for atomic scale materials modelling, e.g. electronic structure calculations and quantum-mechanical molecular dynamics, from first principles.

## VASP License

The VASP team allows only registered users who have purchased their own license to use the software and access is only given to the VASP release which is covered by the license of the respective research group. For those who are interested to use VASP on Negishi, please [contact support](/contact) to request access and provide your email address associated with your license for our verification. Once confirmed, the approved users will be given access to the `vasp5` or/and `vasp6` unix groups.

Prospective users can use the command below to check their unix groups on the system.

```
$ id $USER
```

If you are interested to purchase and get a VASP license, please visit [VASP](http://vasp.at) website for more information.

## VASP 5 and VASP 6 Installations

Negishi provides **VASP 5.4.4.pl2** and **VASP 6.4.1** installations and modulefiles with our default environment compiler `gcc/12.2.0` and mpi library `openmpi/4.1.4`. Note that only license-approved users can load the VASP modulefile as below.

You can use the VASP 5.4.4.pl2 module by:

```
$ module load vasp/5.4.4.pl2
```

You can use the VASP 6.4.1 module by:

```
$ module load vasp/6.4.1
```

Once a VASP module is loaded, you can choose one of the VASP executables to run your code: `vasp_std`, `vasp_gam`, and `vasp_ncl`.

The VASP pseudopotential files are not provided on Negishi, you may need to bring your own POTCAR files.

## Build your own VASP 5 and VASP 6

If you would like to use your own VASP on Negishi, please follow the instructions for [Installing VASP.6.X.X](https://www.vasp.at/wiki/index.php/Installing_VASP.6.X.X) and [Installing VASP.5.X.X](https://www.vasp.at/wiki/index.php/Installing_VASP.5.X.X).

In the following sections, we provide some instructions about how to install VASP 5 and VASP 6 as well as bash job submit script on Negishi:

* [VASP Job Submit Script](vasp/vasp-job-submit-script.md)
* [Build your own VASP 5](vasp/build-your-own-vasp-5.md)
* [Build your own VASP 6](vasp/build-your-own-vasp-6.md)

[**Back to the Running Jobs section**](index.md)
