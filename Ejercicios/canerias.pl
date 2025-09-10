%codo(color)
%canio(color,longitud)
%canilla(tipo,color,ancho)

pieza(codo(rojo)).
pieza(canio(rojo,3)).
pieza(canilla(triangular,rojo,4)).

precio(codo(_),5).
precio(canio(_,Longitud),Precio) :- 
    Precio is 3 * Longitud.
precio(canilla(triangular,_,_),20).
precio(canilla(Tipo,_,Ancho),Precio) :-
    Tipo \= triangular,
    (Ancho =< 5 -> Precio is 12 ; Precio is 15).

%Caso base
precioCanieria([],0).
%Caso recursivo
precioCanieria([Pieza|Canieria],Precio) :-
    precio(Pieza,PrecioPieza),
    precioCanieria(Canieria,PrecioCanieriaRestante),
    Precio is PrecioPieza + PrecioCanieriaRestante.

%precioCanieria([codo(rojo),canio(rojo,3),canilla(triangular,rojo,4)],Precio).

precioCanieria2(Canieria,PrecioTotal) :-
    aggregate_all(sum(Precio), (member(Pieza,Canieria),precio(Pieza,Precio)), PrecioTotal).

