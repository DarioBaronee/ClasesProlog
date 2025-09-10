/* distintos paises */
paisContinente(argentina, americaDelSur).
paisContinente(bolivia, americaDelSur).
paisContinente(brasil, americaDelSur).
paisContinente(chile, americaDelSur).
paisContinente(ecuador, americaDelSur).
paisContinente(alemania, europa).
paisContinente(espania, europa).
paisContinente(francia, europa).
paisContinente(inglaterra, europa).
paisContinente(aral, asia).
paisContinente(china, asia).
paisContinente(gobi, asia).
paisContinente(india, asia).
paisContinente(iran, asia).
/*países importantes*/
paisImportante(argentina).
paisImportante(kamchatka).
paisImportante(alemania).
/*países limítrofes*/
limitrofes([argentina,brasil]).
limitrofes([bolivia,brasil]).
limitrofes([bolivia,argentina]).
limitrofes([argentina,chile]).
limitrofes([espania,francia]).
limitrofes([alemania,francia]).
limitrofes([nepal,india]).
limitrofes([china,india]).
limitrofes([nepal,china]).
limitrofes([afganistan,china]).
limitrofes([iran,afganistan]).
/*distribución en el tablero */
ocupa(argentina, azul, 4).
ocupa(bolivia, rojo, 1).
ocupa(brasil, verde, 4).
ocupa(chile, negro, 3).
ocupa(ecuador, rojo, 2).
ocupa(alemania, azul, 3).
ocupa(espania, azul, 1).
ocupa(francia, azul, 1).
ocupa(inglaterra, azul, 2).
ocupa(aral, negro, 2).
ocupa(china, verde, 1).
ocupa(gobi, verde, 2).
ocupa(india, rojo, 3).
ocupa(iran, verde, 1).
/*continentes*/
continente(americaDelSur).
continente(europa).
continente(asia).
/*objetivos*/
objetivo(rojo, ocuparContinente(asia)).
objetivo(azul, ocuparPaises([argentina, bolivia, francia, inglaterra, china])).
objetivo(verde, destruirJugador(rojo)).
objetivo(negro, ocuparContinente(europa)).
%jugadores
jugador(Jugador) :- 
    distinct(Jugador,(ocupa(_,Jugador,_))).

%1. estaEnContinente/2: Relaciona un jugador y un continente si el jugador ocupa al menos un país en el continente.
estaEnContinente(Jugador,Continente) :-
    ocupa(Pais,Jugador,_),
    paisContinente(Pais,Continente).

%2. cantidadPaises/2: Relaciona a un jugador con la cantidad de países que ocupa.
cantidadPaises(Jugador,CantidadPaises) :-
    objetivo(Jugador,_),
    aggregate_all(count,ocupa(_,Jugador,_),CantidadPaises).

%3. ocupaContinente/2: Relaciona un jugador y un continente si el jugador ocupa totalmente al continente.
ocupaContinente(Jugador,Continente) :-
    objetivo(Jugador,_),
    continente(Continente),
    forall(paisContinente(Pais,Continente),ocupa(Pais,Jugador,_)).

%4. leFaltaMucho/2: Relaciona a un jugador y un continente si al jugador le falta ocupar más de 2 países de dicho continente.
leFaltaMucho(Jugador,Continente) :-
    objetivo(Jugador,_),
    continente(Continente),
    cantidadPaisesContinente(Continente,CantidadPaisesContinente),
    aggregate_all(count,(paisContinente(Pais,Continente),ocupa(Pais,Jugador,_)),CantidadPaisesOcupados),
    CantidadPaisesContinente > CantidadPaisesOcupados + 2.

cantidadPaisesContinente(Continente,CantidadPaises) :-
    continente(Continente),
    aggregate_all(count,paisContinente(_,Continente),CantidadPaises).

%5. sonLimitrofes/2: Relaciona 2 países si son limítrofes.
sonLimitrofes(Pais,OtroPais) :-
    paisContinente(Pais,_),
    paisContinente(OtroPais,_),
    Pais \= OtroPais,
    limitrofes(Limitrofes),
    member(Pais,Limitrofes),
    member(OtroPais,Limitrofes).

%6. esGroso/1: Un jugador es groso si cumple alguna de estas condiciones:
%a. ocupa todos los países importantes,
%b. ocupa más de 10 países
%c. o tiene más de 50 ejercitos.

esGroso(Jugador) :-
    jugador(Jugador),
    forall(paisImportante(Pais),ocupa(Pais,Jugador,_)).

esGroso(Jugador) :-
    jugador(Jugador),
    cantidadPaises(Jugador,CantidadPaises),
    CantidadPaises > 10.

esGroso(Jugador) :-
    jugador(Jugador),
    aggregate_all(sum(Soldados),ocupa(_,Jugador,Soldados),Ejercito),
    Ejercito > 50.

%7. estaEnElHorno/1: un país está en el horno si todos sus países limítrofes están ocupados por el mismo jugador que no es 
%el mismo que ocupa ese país.
estaEnElHorno(Pais) :-
    ocupa(Pais,Jugador,_),
    sonLimitrofes(Pais,PaisVecino),
    ocupa(PaisVecino,OtroJugador,_),            %IMPORTANTE: en forall el universo no debe ser vacio, sino es trivialmente verdadero
    OtroJugador \= Jugador,
    forall(sonLimitrofes(Pais,PaisLimitrofe),ocupa(PaisLimitrofe,OtroJugador,_)).


