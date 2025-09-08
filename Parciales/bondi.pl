/*Base de conocimientos:
Tenemos como punto de partida un predicado recorrido/3 que relaciona una línea con la información de su recorrido, especificando el área por la que pasa y la calle que atraviesa.
*/

% Recorridos en GBA:
recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247, gba(sur), onsari).
recorrido(60, gba(norte), maipu).
recorrido(152, gba(norte), olivos).

% Recorridos en CABA:
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).

/*
1. Saber si dos líneas pueden combinarse, que se cumple cuando su recorrido pasa por una misma calle dentro de la misma zona.
2. Conocer cuál es la jurisdicción de una línea, que puede ser o bien nacional, que se cumple cuando la misma cruza la General Paz,  o bien provincial, cuando no la cruza. 
Cuando la jurisdicción es provincial nos interesa conocer de qué provincia se trata, si es de buenosAires (cualquier parte de GBA se considera de esta provincia) o si es de caba.
Se considera que una línea cruza la General Paz cuando parte de su recorrido pasa por una calle de CABA y otra parte por una calle del Gran Buenos Aires (sin importar de qué zona se trate).
3. Saber cuál es la calle más transitada de una zona, que es por la que pasen mayor cantidad de líneas.
*/

puedenCombinarse(Linea,OtraLinea) :-
    recorrido(Linea,Zona,Calle),
    recorrido(OtraLinea,Zona,Calle),
Linea \= OtraLinea.

jurisdiccion(Linea,nacional) :- distinct(Linea,(
    recorrido(Linea,gba(_),_),
    recorrido(Linea,caba,_))).

jurisdiccion(Linea,provincial) :-
    recorrido(Linea,_,_),
    not(jurisdiccion(Linea,nacional)).

calleMasTransitada(Zona,Calle) :- distinct(Zona,(
    recorrido(_,Zona,Calle),
    aggregate_all(count, recorrido(Linea,Zona,Calle), CantLineasCalle),
    not((
        recorrido(_,Zona,OtraCalle),
        aggregate_all(count, recorrido(Linea,Zona,OtraCalle), CantLineasOtraCalle),
        CantLineasOtraCalle > CantLineasCalle
    )))).
    
calleDeTransbordos(Zona,Calle) :- distinct(Zona,(
    recorrido(_,Zona,Calle),
    aggregate_all(count,(recorrido(Linea,Zona,Calle),jurisdiccion(Linea,nacional)),CantLineas),
CantLineas >= 3)).

%costo normal jurisdiccion naciona
costoNormal(Linea,500) :-
    jurisdiccion(Linea,nacional).

%costo normal en caba
costoNormal(Linea,350) :-
    recorrido(Linea,caba,_).

%costo normal en gba
costoNormal(Linea,Costo) :- 
    recorrido(Linea,gba(_),_),
    aggregate_all(count, distinct(Calle, recorrido(Linea,gba(_),Calle)), CantidadCalles),
    plus(Linea,Plus),
    Costo is 25 * CantidadCalles + Plus.

plus(Linea,50) :- recorreZonasGbaDiferentes(Linea).
plus(Linea, 0) :- not(recorreZonasGbaDiferentes(Linea)).

recorreZonasGbaDiferentes(Linea) :- distinct(Linea,(
    recorrido(Linea,gba(ZonaGba),_),
    recorrido(Linea,gba(OtraZonaGba),_),
    ZonaGba \= OtraZonaGba)).

%beneficio(persona,linea,valorBonificado)
beneficio(estudiantil,_,50).
beneficio(personalCasasParticulares(Zona),Linea,0) :-
    recorrido(Linea,Zona,_).
beneficio(jubilado,Linea,ValorBonificado) :-
    costoNormal(Linea,CostoNormal),
    ValorBonificado is CostoNormal /2.

beneficiario(pepito,personalCasasParticulares(gba(oeste))).
beneficiario(juanita,estudiantil).
beneficiario(marta,jubilado).
beneficiario(marta,personalCasasParticulares(gba(sur))).
beneficiario(marta,personalCasasParticulares(caba)).

valorBoleto(Persona,Linea,Valor) :- distinct(Linea,(
    recorrido(Linea,_,_),
    beneficiario(Persona,Beneficio), 
    beneficio(Beneficio,Linea,Valor),
    not((
        beneficiario(Persona,OtroBeneficio), 
        beneficio(OtroBeneficio,Linea,OtroValor),
        OtroValor < Valor)))).