# Forbidden syscalls
##### By Harrys Kedjnane

## Introduction

For security reasons, OpenBSD forbids syscalls from happening anywhere other than allowed callers such as the standard C library. For example, if we write our own assembly code and try to call a syscall such as ```write```, our compiled binary throws an error. On the other hand, if we create the same program in C using the standard library, our program functions correctly and the call to ```write``` works as expected.

## Goal

We would like to disable this feature by patching the OpenBSD kernel's source code.

## Approach

In order to implement this change, it is first necessary to figure out which part of the source code is responsible for blocking direct syscalls.
In order to do that, I decided to test the behaviour by directly calling a syscall in Assembly code. I wrote a simple Hello World program in C using the standard library and another implementation in x86_64 assembly code producing a direct system call.
As expected, the C version correctly prints out our string while the call to the ```write``` syscall in the assembly version is blocked and generates an error message that reads, among other things, ```bogus syscall```.

This error message is very useful as it will allow me to search the source code for mentions of it and hopefully find where the blocking is handled.
One obstacle I faced doing this is that the latest version of the source code did not contain this error message anymore. Luckily, all I had to do was revet to an older commit.

After ```grep```'ing through the source code looking for a ```bogus syscall``` mention I was able to trace the error back to the ```sys/sys/syscall_mi.h``` file. And indeed, in the ```mi_syscall``` function, the following check was made before printing this error:
```PC must be in un-writeable permitted text (sigtramp, libc, ld.so)```
This check is not present in the latest version of the source code, however it is replaced by a call to a function called ```pin_check``` where a comment reads:
```Check if a system call is entered from precisely correct location```

This seems to describe the behaviour we want to disable. Looking at the function, it checks that the address space from which the syscall originates corresponds to known regions of memory that are authorized to call syscalls.
In order to disable this check, I commented out the call to this function in the ```mi_syscall``` function. Now direct syscalls should no longer cause an error and should be allowed through by the kernel.

## Testing

Checking if our changes actually worked took some work. Since this change required us to modify the source code of the kernel, the only way to check our work is to build and run the patched kernel. Following the steps we saw in class, I compiled the kernel with the modifications we made, installed it and rebooted. 

Once this is done, all we have to do is run our binary compiled from assembly. This time, instead of generating an error, the call is made properly and prints out ```Hello World!``` like we wanted.

## Conclusion

We managed to disable the check on direct syscall in the OpenBSD kernel. To do so, we used the error message generated when direct syscalls occur to find which part of the source code handles this check. We then commented out the associated code and rebuilt our kernel. 

Now, we can run a binary compiled from assembly where our direct syscall occurs. The call now goes through correctly and works similarly to calls made through the C standard library.
