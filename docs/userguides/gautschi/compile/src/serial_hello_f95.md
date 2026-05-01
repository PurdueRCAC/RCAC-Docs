---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
---

# serial_hello.f95

```f95
!  Fortran 95

PROGRAM hello
    CHARACTER(30) name
    INTEGER, PARAMETER :: high=8
    REAL (KIND=high) x           ! Fortran 95
    CALL getenv("HOST",name)     ! get run-host name
    PRINT *, 'Runhost:', name, '   hello, world'
END PROGRAM hello
```

[Back to the Compiling Serial Programs section](../compile_serial.md)
