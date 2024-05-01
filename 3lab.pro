database - transport_type
    transport_type(transport, type)
database - route
    route(transport, string)
domains
    station = string
    transport = string
    route_null = string*
    type = symbol
    station_list = station* 
    stringlist=string*

predicates
   %nondeterm transport_type(transport, type)
    %nondeterm route(transport, route_null)
    nondeterm direct_route(station, station)
    nondeterm my_member(station,route_null)
    nondeterm transfer_route(station, station)
    nondeterm common_station(route_null, route_null, station)
    nondeterm find_route(station,station)
    nondeterm repeat
    nondeterm stop_menu(integer)
    nondeterm call(integer)
    nondeterm menu()
    nondeterm show_all_routes()
    nondeterm show_all_transport_types()
    nondeterm add_route(string,string)
    nondeterm add_type(string,string)
    nondeterm split(string, route_null)
    nondeterm route_to_list(string, route_null).

clauses
my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).


% Предикат, который разбивает строку маршрута на список остановок
split(S, [H|T]) :-
  fronttoken(S, H, R),
  !,
  split(R, T).
split(_, []).

route_to_list(RouteString, RouteList) :-
    split(RouteString, RouteList).


% Поиск прямого маршрута
direct_route(Start, End) :- 
    route(Transport, RouteString), % Получаем строку маршрута из базы данных
    transport_type(Transport,Type),
    route_to_list(RouteString, Stations), % Преобразуем строку в список остановок
    my_member(Start, Stations),
    my_member(End, Stations),
    write(Transport),nl,
    write(Type),nl,
    write(Stations),nl,
    fail.
    
direct_route(_, _).

% Поиск маршрута с пересадками
common_station([H|_], List2, H) :- my_member(H, List2), !.
common_station([_|T], List2, CommonStation) :- common_station(T, List2, CommonStation).

transfer_route(Start, End) :-
    route(Transport1, RouteString1),
    route(Transport2, RouteString2),
    route_to_list(RouteString1, Stations1),
    route_to_list(RouteString2, Stations2),
    my_member(Start, Stations1),
    my_member(End, Stations2),
    common_station(Stations1, Stations2, CommonStation),
    not(CommonStation = Start),
    CommonStation <> End,
    write("Route 1: "), write(Transport1), write(" -> Stations: "), write(Stations1), nl,
    write("Route 2: "), write(Transport2), write(" -> Stations: "), write(Stations2), nl,
    write("Common Station: "), write(CommonStation), nl,
    fail.
    
transfer_route(_,_).

% Общий поиск маршрута
find_route(Start, End) :- 
    direct_route(Start, End), !.

find_route(Start, End) :-
    transfer_route(Start, End).
        

repeat.
repeat:-repeat.
stop_menu(0).
stop_menu(_):-fail.

show_all_routes() :-
    write("Routes:"), nl,
    route(Transport, Route_null),
    write(Transport), write(" "), write(Route_null), nl,
    fail.
show_all_routes().

show_all_transport_types() :-
    write("Transport Types:"), nl,
    transport_type(Transport, Type),
    write(Transport), write(" "), write(Type), nl,
    fail.
show_all_transport_types().

add_route(Number, Stations) :-
    assert(route(Number, Stations), route).
    
add_type(Number, Type) :-
    assert(transport_type(Number, Type), transport_type).
    
    
  

call(1):-nl, nl,
    write("Введите номер маршрута:"),readln(Number),nl,
    write("Введите тип транспорта:"),readln(Type),
    add_type(Number,Type), !.
call(2) :-nl, nl,
    write("Введите номер маршрута:"), readln(Number), nl,
        write("Введите остановки через пробел (например, 'ст1 ст2 ст3'): "), readln(Station),
         add_route(Number, Station), !.
call(3):-
    nl, nl,
    write("Введите начальную станцию: "), readln(StartStation), nl,
    write("Введите конечную станцию: "), readln(EndStation), nl,
    find_route(StartStation, X), find_route(X, EndStation).
call(4) :-
    save("C:/Users/konaz/OneDrive/Рабочий стол/route.dba", route),
    save("C:/Users/konaz/OneDrive/Рабочий стол/transport_type.dba", transport_type),
    write("Databases saved!").
call(5) :-
    show_all_routes(),
    show_all_transport_types().   
call(6) :-
    nl, nl,
    write("Введите начальную станцию: "), readln(StartStation), nl,
    write("Введите конечную станцию: "), readln(EndStation), nl,
    find_route(StartStation,EndStation).
call(0):- stop_menu(_).

menu :-repeat,
        write("Выберите действие:"), nl,
        write("1. Добавить тип транспорта"), nl,
        write("2. Добавить маршрут"), nl,
        write("3. Найти маршрут с пересадками"), nl,
        write("4. Сохранить базу данных"), nl,
        write("5. Показать базу данных"), nl,
        write("6. Найти прямой маршрут"), nl,
        write("0. Выход"), nl,
        write("Ваш выбор -> "),
        readint(Choice),
        Choice<7,
        call(Choice),
        readln(_),
        stop_menu(Choice).
        
goal
    consult("C:/Users/konaz/OneDrive/Рабочий стол/route.dba",route),
    consult("C:/Users/konaz/OneDrive/Рабочий стол/transport_type.dba",transport_type),  
    menu.
