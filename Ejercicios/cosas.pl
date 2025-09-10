/*Cosas y Paises
Se organiza un juego que consiste en ir buscando distintos objetos por el mundo. 
Cada participante está en un determinado nivel, cada nivel implica ciertas tareas, cada tarea consiste en buscar un objeto en una ciudad.
Representamos las tareas como functores buscar(Cosa,Ciudad), y definimos el predicado tarea/2 de esta forma:*/
tarea(basico,buscar(libro,jartum)).
tarea(basico,buscar(arbol,patras)).
tarea(basico,buscar(roca,telaviv)).
tarea(intermedio,buscar(arbol,sofia)).
tarea(intermedio,buscar(arbol,bucarest)).
tarea(avanzado,buscar(perro,bari)).
tarea(avanzado,buscar(flor,belgrado)).
/*O sea, si estoy en el nivel básico, mis tareas posibles son buscar un libro en Jartum, un árbol en Patras o una roca en Tel Aviv.
Para definir en qué nivel está cada participante se define el predicado nivelActual/2, de esta forma:*/
nivelActual(pepe,basico).
nivelActual(lucy,intermedio).
nivelActual(juancho,avanzado).
/*También vamos a necesitar saber qué idioma se habla en cada ciudad, qué idiomas habla cada persona, y el capital actual de cada persona. 
 Esto lo representamos con los predicados idioma/2, habla/2 y capital/2:*/
idioma(alejandria,arabe).
idioma(jartum,arabe).
idioma(patras,griego).
idioma(telaviv,hebreo).
idioma(sofia,bulgaro).
idioma(bari,italiano).
idioma(bucarest,rumano).
idioma(belgrado,serbio).
habla(pepe,bulgaro).
habla(pepe,griego).
habla(pepe,italiano).
habla(juancho,arabe).
habla(juancho,griego).
habla(juancho,hebreo).
habla(lucy,griego).
capital(pepe,1200).
capital(lucy,3000).
capital(juancho,500).

%1. destinoPosible/2 e idiomaUtil/2. 
%destinoPosible/2 relaciona personas con ciudades; una ciudad es destino posible para un nivel si alguna tarea que tiene que hacer 
%la persona (dado su nivel) se lleva a cabo en la ciudad. 
%P.ej. los destinos posibles para Pepe son: Jartum, Patras y Tel Aviv. 
%idiomaUtil/2 relaciona niveles con idiomas: un idioma es útil para un nivel si en alguno de los
%destinos posibles para el nivel se habla el idioma. P.ej. los idiomas útiles para Pepe son: árabe, griego y hebreo.
destinoPosible(Persona,Ciudad) :-
    nivelActual(Persona,Nivel),
    tarea(Nivel,buscar(_,Ciudad)).

idiomaUtil(Nivel,Idioma) :-
    tarea(Nivel,buscar(_,Ciudad)),
    idioma(Ciudad,Idioma).

%2. excelenteCompaniero/2, que relaciona dos participantes. P2 es un excelente compañero para P1 si habla los idiomas de todos los 
%destinos posibles del nivel donde está P1. P.ej. Juancho es un excelente compañero para Pepe, porque habla todos los idiomas de los 
%destinos posibles para el nivel de Pepe. Asegurar que el predicado sea inversible para los dos parámetros.
excelenteCompaniero(Participante,Companiero) :-
    nivelActual(Participante,Nivel),
    habla(Companiero,_),
    forall(idiomaUtil(Nivel,Idioma),habla(Companiero,Idioma)).

%3. interesante/1: un nivel es interesante si se cumple alguna de estas condiciones
%a. todas las cosas posibles para buscar en ese nivel están vivas (las cosas vivas en el ejemplo son: árbol, perro y flor)
%b. en alguno de los destinos posibles para el nivel se habla italiano.
%c. la suma del capital de los participantes de ese nivel es mayor a 10000.
%Asegurar que el predicado sea inversible.

%Condicion A
interesante(Nivel) :-
    tarea(Nivel,_),                    
    forall(tarea(Nivel,buscar(Cosa,_)),estaViva(Cosa)).

%Condicion B
interesante(Nivel) :-
    tarea(Nivel,_),                     
    idiomaUtil(Nivel,italiano).

%Condicion C
interesante(Nivel) :-
    tarea(Nivel,_), 
    aggregate_all(sum(Capital),(nivelActual(Persona,Nivel),capital(Persona,Capital)),CapitalTotal),
    CapitalTotal > 10000.

estaViva(arbol).
estaViva(perro).
estaViva(flor).

%4. complicado/1: un participante está complicado si: no habla ninguno de los idiomas de los destinos posibles para su nivel actual; 
%está en un nivel distinto de básico y su capital es menor a 1500, o está en el nivel básico y su capital es menor a 500.
/*complicado(Participante) :-
    nivelActual(Participante,Nivel),
    forall(idiomaUtil(Nivel,Idioma),not(habla(Participante,Idioma))).*/

complicado(Participante) :-
    nivelActual(Participante,Nivel),
    not((idiomaUtil(Nivel,Idioma),habla(Participante,Idioma))).

complicado(Participante) :-
    nivelActual(Participante,_),            %Importante: instanciar la variable antes de evaluar el not, sino no funciona
    not(nivelActual(Participante,basico)),
    capital(Participante,Capital),
    Capital < 1500.

complicado(Participante) :-        
    nivelActual(Participante,basico),
    capital(Participante,Capital),
    Capital < 500.

%5. homogeneo/1: un nivel es homogéneo si en todas las opciones la cosa a buscar es la misma. 
%En el ejemplo, el nivel intermedio es homogéneo, porque en las dos opciones el objeto a buscar es un árbol. 
%Asegurar que el predicado sea inversible. Ayuda: hay que saber de alguna forma si una lista tiene un único elemento, 
%p.ej. la lista [3,3,3,3] tiene un único elemento (el 3) mientras que la lista [2,1,2,4] no. 
%Tal vez convenga definir un predicado aparte para este problema.

unicoElemento(Lista) :-
    member(Elemento,Lista),
    not((member(OtroElemento,Lista),Elemento \= OtroElemento)).

homogeneo(Nivel) :- distinct(Nivel,(
    tarea(Nivel,_),
    findall(Cosa,tarea(Nivel,buscar(Cosa,_)),Cosas),
    unicoElemento(Cosas))).

%6. poliglota/1: una persona es políglota si habla al menos tres idiomas. 
%En general: es válido agregar los predicados necesarios para poder garantizar inversibilidad o auxiliares para resolver cada ítem, 
%y usar en un ítem los predicados definidos para resolver ítems anteriores.

poliglota(Persona) :-
    nivelActual(Persona,_),
    aggregate_all(count,habla(Persona,_),CantidadIdiomas),
    CantidadIdiomas >= 3.