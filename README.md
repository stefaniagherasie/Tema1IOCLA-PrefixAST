# Tema1IOCLA-PrefixAST
[Tema1 Introducere in Organizarea Calculatoarelor si Limbaj de Asamblare (2019-2020, seria CB)]

Tema presupune presupune parcurgerea unui arbore de tip AST care contine scrierea
unei expresii care trebuie evaluata.

#### IMPLEMENTARE
Expresia este citită și transformată în arbore de către functia ```getAST()``` si se retine
la adresa lui root.
Se retine in ebx nodul root al arborelui si se apeleaza functia    ```calcul_expresie```
care implementeaza parcurgerea arborelui si calcularea rezultatului.

Functia ```atoi``` este folosita la conversia din string in numar intreg, valorile in
arbore fiind retinute sub forma de sir. Functia ia pe rand fiecare caracter si il
converteste in cifra(prin scaderea cu 48 conform codului ASCII) dupa care formeaza
in eax rezultatul. Daca numarul e negativ, se retine in variabila ```semn``` acest 
lucru si se ignora la calcul primul caracter(care este '-'). La sfarsit se trece
rezultatul la negativ.
<br>
Functia ```calcul_expresie``` este o functie recursiva care porneste de la nodul
curent si merge pe fii din stanga si din dreapta pana ajunge la frunze.

- Labelul ```stanga``` se apeleaza daca exista fiu in stanga, punandu-se pe stiva 
valoarea convertita ce se afla in nodul din stanga. Tot aici se apeleaza si labelul 
```dreapta``` care procedeaza la fel, doar ca pentru subarborele drept. Ambele 
contin apelarea recursiva a functiei ```calcul_expresie``` pentru a parcurge tot
arborele. Parcurgerea se face Radacina-Stanga-Dreapta.

- Labelul ```conversie_sir``` converteste sirul afla la nodul curent in numar intreg.

- Labelul ```expresie``` testeaza ce fel de operatie trebuie efectuata prin evaluarea
continutului nodului parinte pentru nivelul curent. Apoi se apeleaza operatia
corespunzatoare: adunare, scadere, inmultire sau impartire. Acestea scot din stiva
valoarea din stanga si din dreapta si efectueaza calculul.

Dupa ce se termina functia de calcul al expresiei, se afiseaza rezultatul stocat 
in eax. Eliberarea memoriei este realizata de functia ```freeAST()```.
