---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
---

# serial_hello.f

```f
C  Fortran 77

      PROGRAM HELLO
      CHARACTER*30 NAME
*     Get run-host name.
      CALL GETENV("HOST",NAME)
      PRINT *, 'Runhost:', NAME, '   hello, world'
      END
```

[Back to the Compiling Serial Programs section](../compile_serial.md)
