---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
---

# serial_hello.cpp

```cpp
//  C++

#include <iostream>
#include <unistd.h>

using namespace std;

int main () {
    int len=30;
    char name[30];
    gethostname(name,len);     // get run-host name
    cout << "Runhost:" << name << "   hello, world\n" << endl;
    return 0;
}
```

[Back to the Compiling Serial Programs section](../compile_serial.md)
