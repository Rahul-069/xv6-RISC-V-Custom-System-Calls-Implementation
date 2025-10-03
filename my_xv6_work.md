# 🧠 xv6-RISC-V: Custom System Calls Implementation

This project extends the **xv6-riscv** operating system by implementing **three new system calls** and modifying the `fork` mechanism to support **argument passing**.  
It demonstrates how to modify xv6's kernel, add new system calls, and test them using user-space programs.

---

## 📋 Overview

The following system calls were added:

| System Call     | Description |
|------------------|-------------|
| `forkwitharg`     | Creates a new process (like `fork`) but allows passing arguments from parent to child. |
| `getforkarg`      | Retrieves the argument passed using `forkwitharg`. |
| `getppid`         | Returns the parent process ID of the calling process. |

---

## ⚙️ Modified Files and Changes

| **File** | **Change Description** |
|----------|--------------------------|
| `kernel/proc.c` | Implemented logic for `forkwitharg` and updated the fork system call to handle argument passing. |
| `kernel/sysproc.c` | Added `sys_forkwitharg`, `sys_getforkarg`, and `sys_getppid` system call handler functions. |
| `kernel/proc.h` | Added a new field `fork_arg` to the `struct proc`. Declared prototypes for new system calls. |
| `kernel/syscall.h` | Added new syscall identifiers (`SYS_forkwitharg`, `SYS_getforkarg`, `SYS_getppid`). |
| `kernel/syscall.c` | Linked the new system calls in the system call table. |
| `kernel/defs.h` | Declared prototypes for the new system calls for kernel-wide use. |
| `user/user.h` | Declared the new system calls for user-space programs. |
| `user/usys.pl` | Added entries for `forkwitharg`, `getforkarg`, and `getppid` to generate syscall stubs. |
| `user/fork.c` | Added a user program demonstrating the use of the new system calls. |
| `user/Makefile` | Included `fork.c` in the list of user programs to compile. |

---

## 🧠 Implementation Details

### 🧩 1. Adding System Call Identifiers
In `kernel/syscall.h`:
```c
#define SYS_forkwitharg  22
#define SYS_getforkarg   23
#define SYS_getppid      24
```

### 🧩 2. Declaring Prototypes

In `kernel/defs.h` and `kernel/proc.h`:

```c
int forkwitharg(int arg);
int getforkarg(void);
int getppid(void);
```

Also added `int fork_arg;` inside `struct proc` in `kernel/proc.h`.

### 🧩 3. Implementing Kernel Logic

In `kernel/proc.c`:

Implemented `forkwitharg()` to:
- Allocate a new process.
- Copy the parent's memory.
- Store the argument in the child's `p->fork_arg`.

In `kernel/sysproc.c`:

Added `sys_forkwitharg()`, `sys_getforkarg()`, and `sys_getppid()` as syscall handlers.

In `kernel/syscall.c`:

Added to the syscall table:

```c
[SYS_forkwitharg] sys_forkwitharg,
[SYS_getforkarg] sys_getforkarg,
[SYS_getppid] sys_getppid,
```

### 🧩 4. User-Space Integration

In `user/user.h`:

```c
int forkwitharg(int arg);
int getforkarg(void);
int getppid(void);
```

In `user/usys.pl`:

```perl
entry("forkwitharg");
entry("getforkarg");
entry("getppid");
```

### 🧩 5. Test Program

Created `user/fork.c`:

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
    int arg = 42;
    int pid = forkwitharg(arg);

    if (pid == 0) {
        printf("Child received arg: %d\n", getforkarg());
        printf("Parent PID: %d\n", getppid());
    } else {
        printf("Parent created child with PID %d and passed arg %d\n", pid, arg);
    }

    exit(0);
}
```

### 🧩 6. Build Integration

Added to `user/Makefile`:

```makefile
UPROGS += _fork
```

---

## 🧪 How to Build and Run

### 🔧 Build
```bash
make clean
make
```

### ▶️ Run
```bash
make qemu
```

Once inside xv6 shell:

```bash
fork
```

---

## 🧾 Expected Output

```
Parent created child with PID 5 and passed arg 42
Child received arg: 42
Parent PID: 1
```

---

## 🧰 Tools Used

- xv6-riscv (MIT OS educational project)
- RISC-V GCC toolchain
- QEMU RISC-V emulator

---

## 🧠 Learning Outcomes

- Understanding of xv6 system call flow.
- Experience with kernel-user communication.
- Implementing process-related syscalls.
- Extending xv6 kernel safely with new features.

---

## 📚 References

- [MIT 6.S081 xv6-riscv GitHub](https://github.com/mit-pdos/xv6-riscv)
- [xv6 Book (RISC-V)](https://pdos.csail.mit.edu/6.828/2023/xv6/book-riscv-rev3.pdf)
