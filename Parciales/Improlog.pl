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

%Punto 1
buenaBase(Grupo) :-
    integrante(Grupo,Persona,InstrumentoArmonico),
    integrante(Grupo,OtraPersona,InstrumentoRitmico),
    Persona \= OtraPersona,
    instrumento(InstrumentoArmonico,armonico),
    instrumento(InstrumentoRitmico,ritmico).

%Punto 2
seDestaca(Persona,Grupo) :- distinct(Grupo,(
    integrante(Grupo,Persona,_),
    nivelQueTiene(Persona,_,NivelPersona),
    not((
        integrante(Grupo,OtraPersona,_),
        OtraPersona \= Persona,
        nivelQueTiene(OtraPersona,_,NivelOtraPersona),
        NivelPersona < NivelOtraPersona +1)))).

%Punto 3
grupo(vientosDelEste,bigband).
grupo(sophieTrio,formacion([contrabajo,guitarra,violin])).
grupo(jazzmin,formacion([bateria,bajo,guitarra,violin])).
grupo(estudio1,ensamble(3)).    %Agregado punto 8

%Excepcion: no hay limite de cupos para melodicos de viento en una bigband
hayCupo(Instrumento,Grupo) :-
    instrumento(Instrumento,_),
    grupo(Grupo,bigband),
    instrumento(Instrumento,melodico(viento)).

%Regla general: no debe haber otro integrante que toque ese instrumento, y debe servir para el grupo
hayCupo(Instrumento,Grupo) :-
    instrumento(Instrumento,_),
    not(integrante(Grupo,_,Instrumento)),
    grupo(Grupo,TipoGrupo),
    sirvePara(Instrumento,TipoGrupo).

%Insturmentos que sirven en una bigband (ademas de los melodicos de viento)
sirvePara(Instrumento,bigband) :-
    member(Instrumento,[bateria,bajo,piano]).

%Instrumentos que sirven para una formacion
sirvePara(Instrumento,formacion(Instrumentos)) :-
    member(Instrumento,Instrumentos).

%Instrumentos que sirven para un ensamble (agregado punto 8)
sirvePara(_,ensamble(_)).

%Punto 5
puedeIncorporarse(Persona,Instrumento,Grupo) :-
    not(integrante(Grupo,Persona,_)),       %la persona no es integrante del grupo
    hayCupo(Instrumento,Grupo),             %hay cupo para ese instrumento
    grupo(Grupo,TipoGrupo),
    nivelQueTiene(Persona,Instrumento,Nivel),
    nivelRequerido(TipoGrupo,NivelRequerido),        %cumple con el nivel minimo requerido
    Nivel >= NivelRequerido.

nivelRequerido(bigband, 1).

nivelRequerido(formacion(Instrumentos), Nivel) :-
    length(Instrumentos,CantidadInstrumentos),
    Nivel is 7 - CantidadInstrumentos.

nivelRequerido(ensamble(Nivel), Nivel).     %agregado punto 8

%Punto 6
quedoEnBanda(Persona) :- distinct(Persona,(
    nivelQueTiene(Persona,_,_),     %la persona existe
    not(integrante(_,Persona,_)),   %no es integrante de ningun grupo
    not(puedeIncorporarse(Persona,_,_)))).

%Punto 7
puedeTocar(Grupo) :-
    grupo(Grupo,bigband),
    buenaBase(Grupo),
    aggregate_all(count, (integrante(Grupo,_,Instrumento),instrumento(Instrumento,melodico(viento))), CantidadInstrumentosDeViento),
    CantidadInstrumentosDeViento >= 5.

puedeTocar(Grupo) :-
    grupo(Grupo,formacion(Instrumentos)),
    forall(member(Instrumento,Instrumentos),integrante(Grupo,_,Instrumento)).

puedeTocar(Grupo) :-
    grupo(Grupo,ensamble(_)),
    buenaBase(Grupo),
    integrante(Grupo,_,Instrumento),
    instrumento(Instrumento,melodico(_)).

/*8. Finalmente queremos incorporar a nuestra base de conocimientos grupos de otro tipo de los que ya tenemos: los ensambles. 
Para cada ensamble deberá informarse cuál es el nivel mínimo que tiene que tener una persona con su instrumento para poder incorporarse al grupo correspondiente. 
Además sabemos que para los ensambles cualquier instrumento sirve, y para que puedan tocar hace falta una buena base y al menos alguna persona que toque un instrumento melódico 
sin importar de qué tipo. Agregar a la base de conocimientos al grupo estudio1 que es un ensamble que requiere tener un nivel con el instrumento de al menos 3 para poder incorporarse, 
y adaptar la lógica desarrollada en los puntos anteriores para que funcionen correctamente con los ensambles*/




