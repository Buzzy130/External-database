database
language(string)
database - mydatabase
knows(string,string)
predicates
nondeterm menu()
nondeterm add_lang(integer,string)
nondeterm repeat
nondeterm stop_menu(integer)
nondeterm call(integer)
nondeterm show_all()
clauses
language("�����������").
language("��������").
language("��������").
language("����������").
language("����������").
add_lang(I,Name):-language(X), write("Do you know ",X," language?"),
 nl, write("(yes or no): "),readln(Answer), Answer="yes",
 retractall(knows(Name,X)),
 assert(knows(Name,X),mydatabase),
 I=I-1, I<>0, fail.
repeat.
repeat:-repeat.
stop_menu(0).
stop_menu(_):-fail.

show_all():- knows(Name,Language), write(Name," ",Language).
call(1):- consult("C:\Users\konaz\OneDrive\������� ����\mydatabase.dba",mydatabase), write("Database was loaded!").
call(2):- nl, nl, write("Enter your name: "), readln(Name),
 nl, add_lang(5,Name).
call(3):- nl, nl, write("Please, enter name you want to delete: "), readln(Name),
 retractall(knows(Name,_)), nl,
 write("All information about ",Name," was deleted!").
call(4):- save("C:\Users\konaz\OneDrive\������� ����\mydatabase.dba",mydatabase), write("Database saved!").
call(5):- show_all().
call(0):- stop_menu(_).
menu():-repeat,
write("�������� ��������:"),
nl, write("1. ��������� ���� ������"),
nl, write("2. �������� ������"),
nl, write("3. ������� ������"),
nl, write("4. ��������� ���� ������"),
nl, write("5. �������� ���� ������"),
nl, write("0. �����"),
nl, write("��� ����� -> "),
readint(X),
X<6,
call(X),
readln(_),
stop_menu(X).
goal
menu. 