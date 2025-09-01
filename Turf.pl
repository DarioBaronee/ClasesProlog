/*
Punto 1: Pasos al costado (2 puntos)
Les jockeys son personas que montan el caballo en la carrera: tenemos a Valdivieso, que mide 155 cms y pesa 52 kilos, Leguisamo, que mide 161 cms y pesa 49 kilos, Lezcano, que mide 149 cms y pesa 50 kilos, Baratucci, que mide 153 cms y pesa 55 kilos, Falero, que mide 157 cms y pesa 52 kilos.
También tenemos a los caballos: Botafogo, Old Man, Enérgica, Mat Boy y Yatasto, entre otros. Cada caballo tiene sus preferencias:
● a Botafogo le gusta que el jockey pese menos de 52 kilos o que sea Baratucci
● a Old Man le gusta que el jockey sea alguna persona de muchas letras (más de 7), existe el predicado atom_length/2
● a Enérgica le gustan todes les jockeys que no le gusten a Botafogo
● a Mat Boy le gusta les jockeys que midan mas de 170 cms
● a Yatasto no le gusta ningún jockey

También sabemos el Stud o la caballeriza al que representa cada jockey
● Valdivieso y Falero son del stud El Tute
● Lezcano representa a Las Hormigas
● Y Baratucci y Leguisamo a El Charabón
Por otra parte, sabemos que Botafogo ganó el Gran Premio Nacional y el Gran Premio República, Old Man ganó el Gran Premio República y el Campeonato Palermo de Oro y Enérgica y Yatasto 
no ganaron ningún campeonato. Mat Boy ganó el Gran Premio Criadores.
Modelar estos hechos en la base de conocimientos e indicar en caso de ser necesario si algún concepto interviene a la hora de hacer dicho diseño justifi cando su decisión.
*/

% jockey(nombre, altura, peso)
jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

caballo(botafogo).
caballo(old_man).
caballo(energica).
caballo(mat_boy).
caballo(yatasto).

% prefiere(caballo,nombreJockey)
prefiere(botafogo,Jockey) :- 
    jockey(Jockey,_,Peso), Peso < 52.
prefiere(botafogo, baratucci).
prefiere(old_man,Jockey) :- 
    jockey(Jockey,_,_), 
    atom_length(Jockey,CantidadLetras), 
    CantidadLetras > 7.
prefiere(energica,Jockey) :- 
    jockey(Jockey,_,_), 
    not(prefiere(botafogo,Jockey)).
prefiere(mat_boy,Jockey) :- 
    jockey(Jockey,Altura,_), Altura > 170.

% stud(jockey,nombreStud)
stud(valdivieso,elTute).
stud(falero,elTute).
stud(lezcano,lasHormigas).
stud(baratucci,elCharabon).
stud(leguisamo,elCharabon).

%gano(caballo,premio)
gano(botafogo,gran_premio_nacional).
gano(botafogo,gran_premio_republica).
gano(old_man,gran_premio_republica).
gano(old_man,campeonato_palermo_de_oro).
gano(mat_boy,gran_premio_criadores).

/*
Punto 2: Para mí, para vos (2 puntos)
Queremos saber quiénes son los caballos que prefieren a más de un jockey. Ej: Botafogo, Old Man y Enérgica son caballos que cumplen esta condición según la base de conocimiento planteada. 
El predicado debe ser inversible.
*/

prefiereAMasDeUnJockey(Caballo) :-
    distinct(Caballo,(
    prefiere(Caballo,Jockey),
    prefiere(Caballo,OtroJockey),
    Jockey \= OtroJockey
    )).

/*
Punto 3: No se llama Amor (2 puntos)
Queremos saber quiénes son los caballos que no prefieren a ningún jockey de una caballeriza. 
El predicado debe ser inversible. Ej: Botafogo aborrece a El Tute (porque no prefiere a Valdivieso ni a Falero), 
Old Man aborrece a Las Hormigas y Mat Boy aborrece a todos los studs, entre otros ejemplos.
*/

aborrece(Caballo,Stud) :-
    caballo(Caballo),   %Unifico Caballo
    distinct(Stud,(
        stud(_,Stud),   %Unifico Stud
        forall(
            stud(Jockey,Stud),
            not(prefiere(Caballo,Jockey))
        )
    )).

% noPrefiere es igual a aborrece pero usando la negacion existencial
noPrefiere(Caballo,Stud) :-
    caballo(Caballo),
    distinct(Stud, (
        stud(_,Stud),
        not((stud(Jockey,Stud),prefiere(Caballo,Jockey))))).

/*
Punto 4: Piolines (2 puntos)
Queremos saber quiénes son les jockeys "piolines", que son las personas preferidas por
todos los caballos que ganaron un premio importante. El Gran Premio Nacional y el Gran
Premio República son premios importantes.
Por ejemplo, Leguisamo y Baratucci son piolines, no así Lezcano que es preferida por
Botafogo pero no por Old Man. El predicado debe ser inversible.
*/

premioImportante(gran_premio_nacional).
premioImportante(gran_premio_republica).

ganoPremioImportante(Caballo) :-
    gano(Caballo,PremioImportante),premioImportante(PremioImportante).

piolin(Jockey) :-
    jockey(Jockey,_,_),
    forall(ganoPremioImportante(Caballo), prefiere(Caballo,Jockey)).

/*
Punto 5: El jugador (2 puntos)
Existen apuestas
● a ganador por un caballo => gana si el caballo resulta ganador
● a segundo por un caballo => gana si el caballo sale primero o segundo
● exacta => apuesta por dos caballos, y gana si el primer caballo sale primero y el
segundo caballo sale segundo
● imperfecta => apuesta por dos caballos y gana si los caballos terminan primero y
segundo sin importar el orden
Queremos saber, dada una apuesta y el resultado de una carrera de caballos si la apuesta
resultó ganadora. No es necesario que el predicado sea inversible.
*/

%apuesta(Caballo,ResultadoCarrera,ResultadoApuesta)

% A ganador
apuesta(Caballo,[Caballo|_],ganador).

% A segundo (1.º o 2.º puesto)
apuesta(Caballo,[Caballo|_],segundo).          % si sale primero
apuesta(Caballo,[_,Caballo|_],segundo).        % si sale segundo

% Exacta
apuesta(caballos(Primer,Segundo),[Primer,Segundo|_],exacta).

% Imperfecta (1.º y 2.º en cualquier orden)
apuesta(caballos(Primer,Segundo),[Primer,Segundo|_],imperfecta).
apuesta(caballos(Primer,Segundo),[Segundo,Primer|_],imperfecta).

% ?- apuesta(botafogo, [botafogo, old_man, mat_boy, energica, yatasto], Resultado).
% ?- apuesta(old_man, [botafogo, old_man, mat_boy, energica, yatasto], Resultado).
% ?- apuesta(caballos(botafogo,old_man), [botafogo, old_man, mat_boy, energica, yatasto], Resultado).
% ?- apuesta(caballos(old_man, botafogo), [botafogo, old_man, mat_boy, energica, yatasto], Resultado).
% ?- apuesta(yatasto, [botafogo, old_man, mat_boy, energica, yatasto], Resultado).

%Otra forma mejorada

salioPrimero(Caballo,[Caballo|_]).
salioSegundo(Caballo,[_,Caballo|_]).

%ganaApuesta(Apuesta,ResultadoCarrera)
ganaApuesta(ganador(Caballo),Resultado) :- salioPrimero(Caballo,Resultado).
ganaApuesta(segundo(Caballo),Resultado) :- salioPrimero(Caballo,Resultado) ; salioSegundo(Caballo,Resultado).
ganaApuesta(exacto(Primero,Segundo),Resultado) :- salioPrimero(Primero,Resultado), salioSegundo(Segundo,Resultado).
ganaApuesta(imperfecto(Primero,Segundo), Resultado) :- 
    salioPrimero(Primero,Resultado), salioSegundo(Segundo,Resultado) ;
    salioPrimero(Segundo,Resultado), salioSegundo(Primero,Resultado).

% ganaApuesta(exacto(botafogo,old_man),[botafogo, old_man, mat_boy, energica, yatasto]).
% ganaApuesta(imperfecto(botafogo,old_man),[botafogo, old_man, mat_boy, energica, yatasto]).
% ganaApuesta(imperfecto(old_man, botafogo),[botafogo, old_man, mat_boy, energica, yatasto]).

/*
Punto 6: Los colores (2 puntos)
Sabiendo que cada caballo tiene un color de crin:
● Botafogo es tordo (negro)
● Old Man es alazán (marrón)
● Enérgica es ratonero (gris y negro)
● Mat Boy es palomino (marrón y blanco)
● Yatasto es pinto (blanco y marrón)
Queremos saber qué caballos podría comprar una persona que tiene preferencia por
caballos de un color específico. Tiene que poder comprar por lo menos un caballo para que
la solución sea válida. Ojo: no perder información que se da en el enunciado.
Por ejemplo: una persona que quiere comprar caballos marrones podría comprar a Old Man,
Mat Boy y Yatasto. O a Old Man y Mat Boy. O a Old Man y Yatasto. O a Old Man. O a Mat
Boy y Yatasto. O a Mat Boy. O a Yatasto.
*/

crin(botafogo, tordo).
crin(oldMan, alazan).
crin(energica, ratonero).
crin(matBoy, palomino).
crin(yatasto, pinto).

color(tordo, negro).
color(alazan, marron).
color(ratonero, gris).
color(ratonero, negro).
color(palomino, marron).
color(palomino, blanco).
color(pinto, blanco).
color(pinto, marron).

comprarPorColor(Color,Caballos) :-
    findall(Caballo,(crin(Caballo,Crin),color(Crin,Color)),CaballosPosibles),
    combinar(CaballosPosibles,Caballos),
    Caballos \= [].

%caso base
combinar([],[]).

%caso recursivo 1: agrego caballo
combinar([Caballo|CaballosPosibles],[Caballo|Caballos]) :-
    combinar(CaballosPosibles,Caballos).

%caso recursivo 2: ignoro caballo
combinar([_|CaballosPosibles],Caballos) :-
    combinar(CaballosPosibles,Caballos).