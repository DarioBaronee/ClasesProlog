%Turf
/*
Punto 1: Pasos al costado (2 puntos)
Les jockeys son personas que montan el caballo en la carrera: 
tenemos a Valdivieso, que mide 155 cms y pesa 52 kilos, 
Leguisamo, que mide 161 cms y pesa 49 kilos, 
Lezcano, que mide 149 cms y pesa 50 kilos, 
Baratucci, que mide 153 cms y pesa 55 kilos, 
Falero, que mide 157 cms y pesa 52 kilos.
*/
jockey(valdivieso,155,52).
jockey(leguizamo,161,49).
jockey(lezcano,149,50).
jockey(baratucci,153,55).
jockey(falero,157,52).

/*
También tenemos a los caballos: Botafogo, Old Man, Enérgica, Mat Boy y Yatasto, entre otros. 
Cada caballo tiene sus preferencias:
a Botafogo le gusta que le jockey pese menos de 52 kilos o que sea Baratucci
a Old Man le gusta que le jockey sea alguna persona de muchas letras (más de 7), existe el predicado atom_length/2
a Enérgica le gustan todes les jockeys que no le gusten a Botafogo
a Mat Boy le gusta les jockeys que midan mas de 170 cms
a Yatasto no le gusta ningún jockey
*/
caballo(botafogo).
caballo(yatasto).
caballo(old_man).
caballo(energica).
caballo(mat_boy).

prefiere(botafogo,Jockey) :- 
    jockey(Jockey,_,Peso), Peso < 52.
prefiere(botafogo,baratucci).
prefiere(old_man,Jockey) :- jockey(Jockey,_,_),
    atom_length(Jockey,CantidadLetras), CantidadLetras > 7.
prefiere(energica,Jockey) :- jockey(Jockey,_,_),
    not(prefiere(botafogo,Jockey)).
prefiere(mat_boy,Jockey) :- jockey(Jockey,Altura,_), Altura > 170.
%prefiere(yatasto,_) :- false. % No es necesario modelarlo. 
% Por principio de universo cerrado lo que no esta en la base de conocimiento se presume falso.

/*
También sabemos el Stud o la caballeriza al que representa cada jockey
Valdivieso y Falero son del stud El Tute
Lezcano representa a Las Hormigas
Baratucci y Leguisamo representan a El Charabón
*/

caballeriza(valdivieso, elTute).
caballeriza(falero, elTute).
caballeriza(lezcano, lasHormigas).
caballeriza(baratucci, elCharabon).
caballeriza(leguizamo, elCharabon).

/*
Por otra parte, sabemos que Botafogo ganó el Gran Premio Nacional y el Gran Premio República, 
Old Man ganó el Gran Premio República y el Campeonato Palermo de Oro y Enérgica y Yatasto no ganaron ningún campeonato. 
Mat Boy ganó el Gran Premio Criadores.
Modelar estos hechos en la base de conocimientos e indicar en caso de ser necesario si algún concepto interviene a la hora 
de hacer dicho diseño justificando su decisión.
*/

gano(botafogo,gran_premio_nacional).
gano(botafogo,gran_premio_republica).
gano(old_man,gran_premio_republica).
gano(mat_boy,gran_premio_criadores).
%energica y yatasto no ganaron ningun campeonato, no es necesario modelarlo.

/*Punto 2: Para mí, para vos (2 puntos)
Queremos saber quiénes son los caballos que prefieren a más de un jockey. 
Ej: Botafogo, Old Man y Enérgica son caballos que cumplen esta condición según la base de conocimiento planteada. 
El predicado debe ser inversible.*/
/*
prefierenAMasDeUnJockey(Caballo) :- 
    caballo(Caballo),
    findall(Jockey, prefiere(Caballo,Jockey), Jockeys),
    length(Jockeys,Cantidad),
    Cantidad > 1.
*/

% code smells (kent beck), no es necesario usar un acumulador
% findall se ata mucho al paradigma imperativo, no se recomienda su uso en prolog para esta situacion.
prefierenAMasDeUnJockey(Caballo) :- 
    distinct(Caballo,(prefiere(Caballo,Jockey), prefiere(Caballo,OtroJockey), Jockey \= OtroJockey)).
%  No es necesario ligar el caballo, ya que prefiere/2 lo hace.

% Punto 3: No se llama Amor (2 puntos)
% Queremos saber quiénes son los caballos que no prefieren a ningún jockey de una caballeriza. El predicado debe ser inversible. 
% Ej: Botafogo aborrece a El Tute (porque no prefiere a Valdivieso ni a Falero), Old Man aborrece a Las Hormigas y Mat Boy 
% aborrece a todos los studs, entre otros ejemplos.

% Opcion 1: usar el forall
noPrefierenANinguno(Caballo,Caballeriza) :- 
    distinct(Caballeriza, caballeriza(_,Caballeriza)),
    distinct(caballo(Caballo)), 
    forall(caballeriza(Jockey,Caballeriza), not(prefiere(Caballo,Jockey))).

% Opcion 2: usar negacion existencial
noPrefierenANinguno(Caballo,Caballeriza) :- 
    distinct(caballo(Caballo)), distinct(caballeriza(_,Caballeriza)),
    not((caballeriza(Jockey,Caballeriza), prefiere(Caballo,Jockey))).

/*
Punto 4: Piolines (2 puntos)
Queremos saber quiénes son les jockeys "piolines", que son las personas preferidas por todos los caballos que ganaron un premio 
importante. El Gran Premio Nacional y el Gran Premio República son premios importantes.
Por ejemplo, Leguisamo y Baratucci son piolines, no así Lezcano que es preferida por Botafogo pero no por Old Man. 
El predicado debe ser inversible.
*/

piolin(Jockey) :- 
    jockey(Jockey,_,_),
    forall(ganoPremioImportante(Caballo), prefiere(Caballo,Jockey)).

ganoPremioImportante(Caballo) :- gano(Caballo,Premio),
    premioImportante(Premio).

premioImportante(gran_premio_nacional).
premioImportante(gran_premio_republica).

/*Punto 5: El jugador (2 puntos)
Existen apuestas
a ganador por un caballo => gana si el caballo resulta ganador
a segundo por un caballo => gana si el caballo sale primero o segundo
exacta => apuesta por dos caballos, y gana si el primer caballo sale primero y el segundo caballo sale segundo
imperfecta => apuesta por dos caballos y gana si los caballos terminan primero y segundo sin importar el orden

Queremos saber, dada una apuesta y el resultado de una carrera de caballos si la apuesta resultó ganadora. 
No es necesario que el predicado sea inversible.
*/

