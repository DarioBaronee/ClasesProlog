linea(a,[plazaMayo,peru,lima,congreso,miserere,rioJaneiro,primeraJunta,nazca]).
linea(b,[alem,pellegrini,callao,pueyrredonB,gardel,medrano,malabia,lacroze,losIncas,urquiza]).
linea(c,[retiro,diagNorte,avMayo,independenciaC,plazaC]).
linea(d,[catedral,nueveJulio,medicina,pueyrredonD,plazaItalia,carranza,congresoTucuman]).
linea(e,[bolivar,independenciaE,pichincha,jujuy,boedo,varela,virreyes]).
linea(h,[lasHeras,santaFe,corrientes,once,venezuela,humberto1ro,inclan,caseros]).
combinacion([lima, avMayo]).
combinacion([once, miserere]).
combinacion([pellegrini, diagNorte, nueveJulio]).
combinacion([independenciaC, independenciaE]).
combinacion([jujuy, humberto1ro]).
combinacion([santaFe, pueyrredonD]).
combinacion([corrientes, pueyrredonB]).

/*1. En qué linea está una estación, predicado estaEn/2.*/
/*estaEn(Estacion,Linea):-
    linea(Linea,Estaciones),
    member(Estacion,Estaciones).*/

estaEn(Estacion,Linea) :-
    linea(Linea,Estaciones),
    nth1(_,Estaciones,Estacion).

/*2. dadas dos estaciones de la misma línea, cuántas estaciones hay entre ellas, 
p.ej. entre Perú y Primera Junta hay 5 estaciones. 
Predicado distancia/3 (relaciona las dos estaciones y la distancia).*/

distancia(Estacion,OtraEstacion,Distancia) :- 
    linea(_,Estaciones),
    nth1(PosicionEstacion,Estaciones,Estacion),
    nth1(PosicionOtraEstacion,Estaciones,OtraEstacion),
    Distancia is abs(PosicionEstacion - PosicionOtraEstacion).

/*3. Dadas dos estaciones de distintas líneas, si están a la misma altura (o sea, las dos terceras, las dos quintas, etc.), p.ej. Independencia C y Jujuy que están las dos cuartas. Predicado mismaAltura/2.*/
mismaAltura(Estacion,OtraEstacion) :-
    linea(Linea,Estaciones),
    linea(OtraLinea,EstacionesOtraLinea),
    Linea \= OtraLinea,
    nth1(Altura,Estaciones,Estacion),
    nth1(Altura,EstacionesOtraLinea,OtraEstacion).

/*4. Dadas dos estaciones, si puedo llegar fácil de una a la otra, esto es, si están en la misma línea, o bien puedo llegar con una sola combinación. Predicado viajeFacil/2.*/
viajeFacil(Estacion,OtraEstacion) :-
    linea(_,Estaciones),
    nth1(_,Estaciones,Estacion),
    nth1(_,Estaciones,OtraEstacion).

viajeFacil(Estacion,OtraEstacion) :-
    linea(Linea,EstacionesLinea),
    linea(OtraLinea,EstacionesOtraLinea),
    Linea \= OtraLinea,
    nth1(_,EstacionesLinea,Estacion),
    nth1(_,EstacionesOtraLinea,OtraEstacion),
    combinacion(Combinaciones),
    nth1(_,Combinaciones,EstacionCombinacion),
    nth1(_,Combinaciones,OtraEstacionCombinacion),
    nth1(_,EstacionesLinea,EstacionCombinacion),
    nth1(_,EstacionesOtraLinea,OtraEstacionCombinacion).