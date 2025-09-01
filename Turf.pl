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
El predicado debe ser inversible. Ej: Botafogo aborrece a El Tute (porque no prefiere a Valdivieso ni a Falero), Old Man aborrece a Las Hormigas y 
Mat Boy aborrece a todos los studs, entre otros ejemplos.
*/

aborrece(Caballo,Stud) :-
    caballo(Caballo),
    distinct(Caballo,(
        stud(Jockey,Stud),
        forall(
            stud(Jockey,Stud),
            not(prefiere(Caballo,Jockey))
        )
    )).
