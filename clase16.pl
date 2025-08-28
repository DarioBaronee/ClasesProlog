%Ejercicio 1
progenitor(homero,bart).
progenitor(homero,lisa).
progenitor(homero,maggie).
progenitor(abe,homero).
progenitor(abe, jose).
progenitor(jose,pepe).
progenitor(mona,homero).
progenitor(jaqueline, marge).
progenitor(marge,bart).
progenitor(marge,lisa).
progenitor(marge, maggie).


% Reglas recursivas
ancestro(Padre, Hijo) :- progenitor(Padre, Hijo).
ancestro(Ancestro, Persona) :- 
    progenitor(Ancestro, Descendiente), ancestro(Descendiente, Persona).

% Ejercicio 2
distancia(buenosAires, puertoMadryn, 1300).
distancia(puertoMadryn, puertoDeseado, 732).
distancia(puertoDeseado, rioGallegos, 736).
distancia(puertoDeseado, calafate, 979).
distancia(rioGallegos, calafate, 304).
distancia(calafate, chalten, 213).

% Queremos saber la distancia para ir de una ciudad a otra 
distanciaEntre(Origen, Destino, Distancia) :-
    distancia(Origen, Destino, Distancia).
distanciaEntre(Origen, Destino, Distancia) :-
    distancia(Origen, PuntoIntermedio, DistanciaIntermedia),
    distancia(PuntoIntermedio, Destino, DistanciaRestante),
    Distancia is DistanciaIntermedia + DistanciaRestante.

% Queremos que sea bidireccional
distanciaTotal(Origen,Destino,Distancia) :-
    distanciaEntre(Origen,Destino,Distancia).
distanciaTotal(Origen,Destino,Distancia) :-
    distanciaEntre(Destino,Origen,Distancia).

% Definicion de member 
miembro(Elemento,[Elemento|_]).
miembro(Elemento,[_|Cola]) :-
    miembro(Elemento, Cola).

% Predicado nth1 que relaciona la posicion de un elemento con una lista
indice(1,Elemento,[Elemento|_]).
indice(Posicion,Elemento,[_|Cola]) :-
    indice(PosicionRestante,Elemento,Cola),
    Posicion is PosicionRestante + 1.

/*
% Ejercicio 3: explosion combinatoria
costo(cine,400).
costo(wos,700).
costo(tini,500).
costo(pool,350).
costo(bowling,300).

% Definicion de actividades posibles dentro de un presupuesto
actividadesPosibles(Plata,Actividades) :-
    findall(actividad(Actividad,Costo), (costo(Actividad,Costo), Costo =< Plata), ActividadesPosibles).

combinarActividades(ActividadesPosibles,Actividades), length(Actividades, CantidadActividades), CantidadActividades >=2,
costoTotal(Actividades, Total), Plata >= Total.

costoTotal([],0).
costoTotal([actividad(_, Costo) | Actividades], CostoTotal) :-
    costoTotal(Actividades, CostoRestante),
    CostoTotal is Costo + CostoRestante.


% Caso base
combinarActividades([],[]).
% Recursividad 1
combinarActividades([Actividad | ActividadesPosibles], [Actividad | Actividades]) :-
    combinarActividades(ActividadesPosibles, Actividades).
% Recursividad 2
combinarActividades([_| ActividadesPosibles], Actividades) :-
    combinarActividades(ActividadesPosibles, Actividades).

% combinarActividades([a(cine,400),a(wos,700),a(tini,500)],Actividades)
*/