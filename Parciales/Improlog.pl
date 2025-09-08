integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

tieneBuenaBase(Grupo) :-
    integrante(Grupo,Musico,InstrumentoArmonico),
    integrante(Grupo,OtroMusico,InstrumentoRitmico),
    instrumento(InstrumentoArmonico,armonico),
    instrumento(InstrumentoRitmico,ritmico),
    Musico \= OtroMusico.

seDestaca(Persona,Grupo) :- distinct(Grupo,(
    integrante(Grupo,Persona,_),
    nivelQueTiene(Persona,_,NivelPersona),
    not((
        integrante(Grupo,OtraPersona,_),
        OtraPersona \= Persona,
        nivelQueTiene(OtraPersona,_,NivelOtraPersona),
        NivelPersona < NivelOtraPersona +1)))).

grupo(vientosDelEste,bigband).
grupo(sophieTrio,formacion([contrabajo,guitarra,violin])).
grupo(jazzmin,formacion([bateria,bajo,guitarra,violin])).
/*
hayCupo(Instrumento,Grupo) :-
    instrumento(Instrumento,_),
    grupo(Grupo,bigband),
    (instrumento(Instrumento,melodico(viento)) ;(   
        member(Instrumento,[bateria,bajo,piano]),
        not(integrante(Grupo,_,Instrumento))
    )).

hayCupo(Instrumento,Grupo) :-
    instrumento(Instrumento,_),
    not(integrante(Grupo,_,Instrumento)),
    grupo(Grupo,formacion(Instrumentos)),
    member(Instrumento,Instrumentos).
*/

%Excepcion con melodicos de viento en bigbands
hayCupo(Instrumento,Grupo) :-
    instrumento(Instrumento,_),
    grupo(Grupo,bigband),
    instrumento(Instrumento,melodico(viento)).

%Regla general
hayCupo(Instrumento,Grupo) :-
    instrumento(Instrumento,_),
    not(integrante(Grupo,_,Instrumento)),
    grupo(Grupo,TipoGrupo),
    sirvePara(Instrumento,TipoGrupo).

sirvePara(Instrumento,bigband) :-
    member(Instrumento,[bateria,bajo,piano]).

sirvePara(Instrumento,formacion(Instrumentos)) :-
    member(Instrumento,Instrumentos).