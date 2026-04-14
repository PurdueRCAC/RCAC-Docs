---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
---

# serial_hello.f90

```f90
!  Fortran 90

PROGRAM hello
    CHARACTER(30) name           ! Fortran 90
    CALL getenv("HOST",name)     ! get run-host name
    PRINT *, 'Runhost:', name, '   hello, world'
END PROGRAM hello                ! Fortran 90
```

[Back to the Compiling Serial Programs section](../compile_serial.md)
