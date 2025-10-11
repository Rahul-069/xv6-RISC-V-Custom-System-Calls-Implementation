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
| `kernel/syscall.h` | Added new syscall identifiers (`SYS_forkwitharg`, `SYS_getforkarg`, `SYS_getppid`). |
| `kernel/proc.h` | Added a new field `fork_arg` to the `struct proc`. |
| `kernel/proc.c` | Implemented logic for `forkwitharg` to handle argument passing during process creation. |
| `kernel/sysproc.c` | Added `sys_forkwitharg`, `sys_getforkarg`, and `sys_getppid` system call handler functions. |
| `kernel/defs.h` | Declared prototypes for the new system calls for kernel-wide use. |
| `kernel/syscall.c` | Linked the new system calls in the system call table. |
| `user/user.h` | Declared the new system calls for user-space programs. |
| `user/usys.pl` | Added entries for `forkwitharg`, `getforkarg`, and `getppid` to generate syscall stubs. |
| `user/fork.c` | Created a user program demonstrating the use of the new system calls. |
| `user/Makefile` | Added the user program `_fork` to the list of programs to compile. |

---

## 🔧 Step-by-Step Implementation Guide

### Step 1: Define System Call Numbers

**File:** `kernel/syscall.h`

Add unique identifiers for the new system calls at the end of the system call definitions.

```c
// System call numbers
#define SYS_forkwitharg 23
#define SYS_getforkarg 24
#define SYS_getppid 25
```

---

### Step 2: Add Fork Argument Field to Process Structure

**File:** `kernel/proc.h`

Modify the `struct proc` to include a field for storing the fork argument. Add this field inside the structure definition.

```c
struct proc {
  // ... existing fields ...
  int fork_arg;              // Argument passed via forkwitharg
  // ... existing fields ...
};
```

---

### Step 3: Implement Core Fork Logic with Argument

**File:** `kernel/proc.c`

Implement the `forkwitharg()` function that creates a new process and passes an integer argument to it. This function is similar to the standard `fork()` but stores the argument in the child's process structure.

```c
int
forkwitharg(int value)
{
    int i, pid;
    struct proc *np;
    struct proc *p = myproc();
    
    // Allocate process
    if((np = allocproc()) == 0){
        return -1;
    }
    
    // Save the argument in new process
    np->fork_arg = value;
    
    // Copy user memory from parent to child
    if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
        freeproc(np);
        release(&np->lock);
        return -1;
    }
    np->sz = p->sz;
    
    // Copy saved user registers
    *(np->trapframe) = *(p->trapframe);
    
    // Return value for child
    np->trapframe->a0 = 0;
    
    // Increment reference counts on open file descriptors
    for(i = 0; i < NOFILE; i++)
        if(p->ofile[i])
            np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
    
    safestrcpy(np->name, p->name, sizeof(p->name));
    
    pid = np->pid;
    
    release(&np->lock);
    
    acquire(&wait_lock);
    np->parent = p;
    release(&wait_lock);
    
    acquire(&np->lock);
    np->state = RUNNABLE;
    release(&np->lock);
    
    return pid;
}
```

---

### Step 4: Add System Call Handler Functions

**File:** `kernel/sysproc.c`

Create wrapper functions that handle the system calls from user space. These functions extract arguments and call the appropriate kernel functions.

```c
uint64
sys_forkwitharg(void)
{
    int arg;
    
    // Get the argument passed from user space
    argint(0, &arg);
    
    return forkwitharg(arg);
}

int
sys_getforkarg(void)
{
    struct proc *p = myproc();
    return p->fork_arg;
}

uint64 
sys_getppid(void)
{
    struct proc *p = myproc();
    if(p->parent) 
        return p->parent->pid;
    return -1;
}
```

---

### Step 5: Declare Kernel Function Prototypes

**File:** `kernel/defs.h`

Add function prototypes to make them accessible throughout the kernel.

```c
// proc.c
int             forkwitharg(int);
uint64          sys_getppid(void);
```

---

### Step 6: Register System Calls in Syscall Table

**File:** `kernel/syscall.c`

First, declare external references to the system call handlers:

```c
// Prototypes for the functions that handle system calls.
extern uint64 sys_forkwitharg(void);
extern uint64 sys_getforkarg(void);
extern uint64 sys_getppid(void);
```

Then, add them to the system call dispatch table:

```c
// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64 (*syscalls[])(void) = {
  // ... existing syscalls ...
  [SYS_forkwitharg] sys_forkwitharg,
  [SYS_getforkarg] sys_getforkarg,
  [SYS_getppid] sys_getppid,
};
```

---

### Step 7: Declare User-Space Function Prototypes

**File:** `user/user.h`

Make the system calls available to user programs by declaring their prototypes.

```c
int forkwitharg(int);
int getforkarg(void);
uint64 getppid(void);
```

---

### Step 8: Generate System Call Stubs

**File:** `user/usys.pl`

Add entries to automatically generate assembly stubs that transition from user space to kernel space.

```perl
entry("forkwitharg");
entry("getforkarg");
entry("getppid");
```

---

### Step 9: Create Test User Program

**File:** `user/fork.c`

Create a new user program that demonstrates all three system calls with user input.

```c
#include "kernel/types.h"
#include "user/user.h"

int custom_atoi(const char *str) {
    int result = 0;
    int sign = 1;
    
    // Check for negative sign
    if (*str == '-') {
        sign = -1;
        str++;
    }
    
    // Convert characters to integer
    while (*str >= '0' && *str <= '9') {
        result = result * 10 + (*str - '0');
        str++;
    }
    
    return sign * result;
}

int
main(int argc, char *argv[])
{
    int pid;
    char buffer[10];
    int n;
    
    printf("Enter a number to pass to child : ");
    n = read(0, buffer, sizeof(buffer));
    
    if(n < 0) {
        printf("Error reading input\n");
        exit(0);
    }
    
    buffer[n-1] = '\0';
    int arg = custom_atoi(buffer);
    
    pid = forkwitharg(arg);
    
    if(pid < 0) {
        printf("forkwitharg failed\n");
        exit(1);
    }
    
    if(pid == 0) {
        // Child process
        printf("Child process created with argument: %d\n", getforkarg());
        printf("Child Pid : %u, Parent Pid : %lu\n", getpid(), getppid());
    } else {
        // Parent process
        wait(0);
        printf("In parent process\n");
        printf("Parent Pid : %u, Parent's Parent Pid : %lu\n", getpid(), getppid());
    }
    
    exit(0);
}
```

---

### Step 10: Update User Program Makefile

**File:** `user/Makefile`

Add the new user program to the build system so it gets compiled with xv6.

```makefile
UPROGS=\
	$U/_cat\
	$U/_echo\
	$U/_fork\
	# ... other programs ...
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
Enter a number to pass to child : 42
Child process created with argument: 42
Child Pid : 4, Parent Pid : 3
In parent process
Parent Pid : 3, Parent's Parent Pid : 1
```

---

## 🧰 Tools Used

- xv6-riscv (MIT OS educational project)
- RISC-V GCC toolchain
- QEMU RISC-V emulator

---

## 🧠 Learning Outcomes

- Understanding of xv6 system call flow from user space to kernel space
- Experience with kernel-user communication and argument passing
- Implementing process-related syscalls with proper synchronization
- Extending xv6 kernel safely with new features
- Process creation and parent-child relationship management

---

## 📚 References

- [MIT 6.S081 xv6-riscv GitHub](https://github.com/mit-pdos/xv6-riscv)
- [xv6 Book (RISC-V)](https://pdos.csail.mit.edu/6.828/2023/xv6/book-riscv-rev3.pdf)
