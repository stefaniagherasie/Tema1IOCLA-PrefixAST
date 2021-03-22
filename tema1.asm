%include "/home/student/IOCLA/checker/includes/io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
    semn: resd 1        ;pentru a vedea daca numarul e negativ

section .text


global atoi

atoi:
    push ebp
    mov ebp, esp
    mov ebx, [ebp + 8]  ;sirul care trebuie convertit
    
    mov eax, 0          ;stocheaza in eax rezultatul
    mov edx, 0
    mov [semn], edx     ;foloseste [semn] pt a vedea daca
                        ;numarul e negativ
    jmp bucla_atoi
    
bucla_atoi:
    movzx ecx, byte[ebx] ;primul caracter din ebx 
    
    cmp ecx, 0           ;a ajuns la sfarsitul sirului
    je iesire_atoi

    cmp ecx, '-'         ;testeaza daca e negativ
    je numar_negativ
    
    mov ecx, 10     
    mul ecx              ;inmulteste eax cu 10
    
    movzx ecx, byte[ebx]
    sub ecx, 48          ;conversie in numar intreg
    add eax, ecx         ;adunare la eax
    
    inc ebx              ;se trece la urmatorul caracter din ebx
    jmp bucla_atoi

iesire_atoi:
    mov edx, -1
    cmp [semn], edx      ;daca numarul e negativ, se schimba semnul
    je conversie_semn
    leave
    ret

conversie_semn:
    mov edx, -1
    imul eax, edx
    leave
    ret
    
numar_negativ:   
    mov edx, -1
    mov [semn], edx      ;[semn] se face -1; numar negativ
    inc ebx              ;se trece la urmatorul caracter din ebx
    jmp bucla_atoi
    
    
    
global calcul_expresie

calcul_expresie:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]   ;in eax se tine nodul curent
      
    mov ebx, [eax + 4]   ;se testeaza existenta fiului stang
    cmp ebx, 0
    jne stanga
    
    cmp ebx, 0           ;se converteste sirul in numar
    je conversie_sir
      
    jmp iesire 
      
conversie_sir:
    mov eax, [ebp + 8]
    mov ebx, [eax]
    
    push ebx
    call atoi            ;conversie
    pop ebx
    
    jmp iesire

stanga:
    mov eax, [ebp + 8]
    mov eax, [eax + 4]   ;fiul din stanga
    mov ebx, eax
    
    push ebx
    call calcul_expresie ;se apeleaza recursiv functia
    pop ebx
    
    push eax             ;se pune pe stiva numarul din fiul stang   

    jmp dreapta          ;se trece la fiul din dreapta   

dreapta:
    mov eax, [ebp + 8]
    mov eax, [eax + 8]   ;fiul din dreapta
    mov ebx, eax
    
    push ebx
    call calcul_expresie ;se apeleaza recursiv functia
    pop ebx
    
    push eax             ;se pune pe stiva numarul din fiul drept
       
    jmp expresie         ;se calculeaza expresia pt. nivelul curent

expresie:
    mov eax, [ebp + 8]
    mov eax, [eax]
    mov ebx, [eax]

    mov edx, '+'         ;adunare
    cmp ebx, edx
    je adunare
    
    mov edx, '-'         ;scadere   
    cmp ebx, edx
    je scadere
 
    mov edx, '*'         ;inmultire
    cmp ebx, edx        
    je inmultire

    mov edx, '/'         ;impartire
    cmp ebx, edx
    je impartire

adunare:
    pop edx              ;se scoate de pe stiva numarul din dreapta   
    pop eax              ;se scoate de pe stiva numarul din stanga

    add eax, edx         ;adunarea   
    jmp iesire
    
scadere:
    pop edx              ;se scoate de pe stiva numarul din dreapta   
    pop eax              ;se scoate de pe stiva numarul din stanga   

    cmp eax, edx         ;descazutul e mai mic decat scazatorul
    jl scadere_negativa
    
    sub eax, edx         ;scaderea       
    jmp iesire
scadere_negativa:
    sub eax, edx
    neg eax
    mov edx, -1
    
    imul eax, edx
    jmp iesire
    
inmultire:
    pop edx             ;se scoate de pe stiva numarul din dreapta   
    pop eax             ;se scoate de pe stiva numarul din stanga 

    imul edx            ;inmultirea    
    jmp iesire
    
impartire:
    pop ecx             ;se scoate de pe stiva numarul din dreapta   
    pop eax             ;se scoate de pe stiva numarul din stanga

    xor edx, edx
    cdq
    idiv ecx            ;impartirea
    jmp iesire
    
iesire:                 ;iesire din functie
    leave
    ret
    
    
global main
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:
    
    mov eax, [root]
    mov ebx, eax
    
    push ebx
    call calcul_expresie        ;se apeleaza functia pentru calculul expresiei                            ;
    pop ebx

    PRINT_DEC 4, eax            ;printare rezultat
      
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret