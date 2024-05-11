CREATE TABLE Personal(
	nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(20) NOT NULL,
    cantidad_peliculas INT NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    CONSTRAINT PK_nombre_p PRIMARY KEY (nombre),
    CONSTRAINT CK_cantidad_pelicula_p CHECK (cantidad_peliculas >= 0),
    CONSTRAINT CK_tipo CHECK (tipo IN ('Protagonista','Reparto','Director'))
);

CREATE TABLE Protagonista(
	nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(20) NOT NULL,
    cantidad_peliculas INT NOT NULL,
    CONSTRAINT PK_nombre_pe PRIMARY KEY (nombre),
    CONSTRAINT CK_cantidad_pelicula_pe CHECK (cantidad_peliculas >= 0)
);

CREATE TABLE Reparto(
	nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(20) NOT NULL,
    cantidad_peliculas INT NOT NULL,
    CONSTRAINT PK_nombre_r PRIMARY KEY (nombre),
    CONSTRAINT CK_cantidad_pelicula_r CHECK (cantidad_peliculas >= 0)
);

CREATE TABLE Director(
	nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(20) NOT NULL,
    cantidad_peliculas INT NOT NULL,
    CONSTRAINT PK_nombre_d PRIMARY KEY (nombre),
    CONSTRAINT CK_cantidad_pelicula_d CHECK (cantidad_peliculas >= 0)
);

CREATE TABLE Pelicula(
	identificador INT NOT NULL,
    titulo_distribucion VARCHAR(50) NOT NULL,
    titulo_original VARCHAR(50) NOT NULL,
    titulo_español VARCHAR(50) NOT NULL,
    genero VARCHAR(20) NOT NULL,
    idioma_original VARCHAR(20) NOT NULL,
    año_produccion INT NOT NULL,
    resumen VARCHAR(1000) NOT NULL,
    fecha_estreno DATE NOT NULL,
    duracion TIME NOT NULL,
    url VARCHAR(100) NOT NULL,
    pais_origen VARCHAR(20) NOT NULL,
    calificacion VARCHAR(20) NOT NULL DEFAULT 'Apta todo público',
    nombre_director VARCHAR(50) NOT NULL,
    CONSTRAINT PK_identificador PRIMARY KEY (identificador),
    CONSTRAINT CK_identificador CHECK (identificador >= 0),
    CONSTRAINT CK_titulo_original CHECK (titulo_original = UPPER(titulo_original)),
    CONSTRAINT CK_año_produccion CHECK (año_produccion >= 0),
    CONSTRAINT FK_nombre_director FOREIGN KEY (nombre_director) REFERENCES Director(nombre),
    CONSTRAINT CK_calificación CHECK (calificacion IN ('+ 13 años', '+ 15 años','+ 18 años'))
);

CREATE TABLE Actuo(
	identificador_pelicula INT NOT NULL,
    nombre_protagonista VARCHAR(50) NOT NULL,
    CONSTRAINT FK_identificador_p_p FOREIGN KEY (identificador_pelicula) REFERENCES Pelicula(identificador),
    CONSTRAINT FK_nombre_protagonista FOREIGN KEY (nombre_protagonista) REFERENCES Protagonista(nombre)
);

CREATE TABLE Participo(
	identificador_pelicula INT NOT NULL,
    nombre_reparto VARCHAR(50) NOT NULL,
    CONSTRAINT FK_identificador_p_r FOREIGN KEY (identificador_pelicula) REFERENCES Pelicula(identificador),
    CONSTRAINT FK_nombre_reparto FOREIGN KEY (nombre_reparto) REFERENCES Reparto(nombre)
);
    
CREATE TABLE Cine(
	nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
	CONSTRAINT PK_nombre_cine PRIMARY KEY (nombre)
);

CREATE TABLE Sala(
	numero INT NOT NULL,
    cantidad_butacas INT NOT NULL,
    nombre_cine VARCHAR(50) NOT NULL,
    CONSTRAINT PK_numero PRIMARY KEY (numero),
    CONSTRAINT CK_numero CHECK (numero >= 0),
    CONSTRAINT FK_nombre_cine_s FOREIGN KEY (nombre_cine) REFERENCES Cine(nombre)
);

CREATE TABLE Funcion(
	codigo INT NOT NULL,
    fecha DATE NOT NULL,
    hora_comienzo TIME NOT NULL,
    numero_sala INT NOT NULL,
    CONSTRAINT PK_codigo PRIMARY KEY (codigo),
    CONSTRAINT CK_codigo CHECK (codigo >= 0),
    CONSTRAINT FK_numero FOREIGN KEY (numero_sala) REFERENCES Sala(numero)
);

CREATE TABLE Exhibe(
	identificador_pelicula INT NOT NULL,
    codigo_funcion INT NOT NULL,
    CONSTRAINT FK_identificador_p_e FOREIGN KEY  (identificador_pelicula) REFERENCES Pelicula(identificador),
    CONSTRAINT FK_codigo_funcion_e FOREIGN KEY (codigo_funcion) REFERENCES Funcion(codigo)
);

INSERT INTO Pelicula (identificador, titulo_distribucion, titulo_original, titulo_español, genero, idioma_original, año_produccion, resumen, fecha_estreno, duracion, url, pais_origen, calificacion, nombre_director) VALUES
(1, 'The Fast and The Furious', 'THE FAST AND THE FURIOUS', 'Rápido y Furioso', 'Acción', 'Inglés', 2001, 'Un policía encubierto se infiltra en una subcultura del inframundo de corredores callejeros de Los Ángeles que buscan reventar una red de secuestros, y pronto comienza a cuestionar sus lealtades.', '2001-06-22', '01:47:00', 'http://www.rapidosyfuriosos.com.ar/franchise.php?id=4', 'Estados Unidos', '+ 13 años', 'Justin Lin'),
(2, '2 Fast 2 Furious', '2 FAST 2 FURIOUS', 'Más Rápidos Más Furiosos', 'Acción', 'Inglés', '2003', 'Cuando el ex policía, Brian O`Conner, es capturado en Miami por su antiguo socio, Bilkins, lo reclutan para acabar con un narcotraficante llamado Carter Verone. O`Connor acepta ayudarlos en los términos de crear su propio equipo. Decide formar equipo con su amigo de la infancia, Roman Pearce.', '2003-06-06', '01:47:00', 'http://www.rapidosyfuriosos.com.ar/franchise.php?id=4', 'Estados Unidos', '+ 13 años', 'Justin Lin'),
(3, 'The Fast and the Furious: Tokyo Drift', 'THE FAST AND THE FURIOUS: TOKYO DRIFT', 'Rápido y furioso: Reto Tokio', 'Acción', 'Inglés', 2006, 'Sean es un chico que no se adapta a ningún grupo, su única conexión con el mundo son las carreras ilegales, lo que lo ha convertido en el perseguido número uno por la policía. Cuando lo amenazan de cárcel, lo mandan a Japón con su padre. Estando en este país es atraído por el último reto automovilístico que desafía la gravedad: las carreras drift, una mezcla peligrosa de alta velocidad en pistas con curvas muy cerradas y en zigzag. Estas carreras lo llevan a involucrase con la mafia japonesa, el hampa de Tokio y a jugarse la vida.', '2006-06-16', '01:44:00', 'http://www.rapidosyfuriosos.com.ar/franchise.php?id=4', 'Estados Unidos', '+ 13 años', 'Justin Lin'),
(4, 'Fast & Furious', 'FAST & FURIOUS', 'Rápidos y Furiosos', 'Acción', 'Inglés', '2009', 'Un asesinato obliga a Don Toretto, un ex convicto huido, y al agente Brian O`Conner a volver a Los Ángeles. donde su pelea se reaviva. Pero al tener que enfrentarse a un enemigo común, se ven obligados a formar una alianza incierta si quieren conseguir desbaratar sus planes.', '2009-04-03', '01:47:00', 'http://www.rapidosyfuriosos.com.ar/franchise.php?id=4', 'Estados Unidos', '+ 13 años', 'Justin Lin'),
(5, 'Fast Five', 'FAST FIVE', 'Rápidos y Furiosos 5in Control', 'Acción', 'Inglés', 2011, 'Luke Hobbs, un duro agente federal acostumbrado a dar caza a todos sus objetivos, debe confiar en su instinto para atraparles y que nadie más se le adelante. De esta forma, él y su equipo se embarcarán en un veloz viaje sin tregua para frenar a los protagonistas de la saga.', '2011-04-29', '02:11:00', 'https://www.imdb.com/title/tt1596343/', 'Estados Unidos', '+ 15 años', 'Justin Lin'),
(6, 'Fast & Furious 6', 'FAST & FURIOUS 6', 'Rápido y Furioso 6', 'Acción', 'Inglés', 2013, 'Desde que Dom y Brian destruyeron el imperio de un mafioso y se hicieron con cien millones de dólares, se encuentran en paradero desconocido; no pueden regresar a casa porque la ley los persigue. Entretanto, Hobbs ha seguido la pista por una docena de países a una banda de letales conductores mercenarios, cuyo cerebro cuenta con la inestimable ayuda de la sexy Letty, un viejo amor de Dom que éste daba por muerta. La única forma de detenerlos es enfrentarse a ellos en las calles, así que Hobbs le pide a Dom que reúna a su equipo en Londres. ¿Qué obtendrán a cambio? Un indulto para que todos puedan volver a casa con sus familias.', '2013-05-24', '02:10:00', 'https://www.imdb.com/title/tt1905041/', 'Estados Unidos', '+ 15 años', 'Justin Lin'),
(7, 'Furious 7', 'FURIOUS 7', 'Rápidos y Furiosos 7', 'Acción', 'Inglés', 2015, 'Luego de haber derrotado al terrorista Owen Shaw, Dominic Toretto y sus amigos creían haber dejado la vida ruda atrás. Sin embargo, Deckard Shaw, el hermano de Owen, aparece de pronto para cobrar venganza. Su intención es eliminar al clan que exterminó a su hermano, uno por uno. ', '2015-04-03', '02:20:00', 'https://www.imdb.com/title/tt2820852/', 'Estados Unidos', '+ 15 años', 'James Wan');

INSERT INTO Personal (nombre, nacionalidad, cantidad_peliculas, tipo) VALUES
('Vin Diesel', 'Estadounidense', 5, 'Protagonista'),
('Paul Walker', 'Estadounidense', 6, 'Protagonista'),
('Tyrese Gibson', 'Estadounidense', 5, 'Reparto'),
('Jordana Brewster', 'Panameño', 5, 'Reparto'),
('Justin Lin', 'Tailandes', 3, 'Director'),
('James Wan', 'Malayo', 1, 'Director');

INSERT INTO Cine (nombre, direccion, telefono) VALUES
('Cine del Paseo', 'Sobremonte 80, Río Cuarto, Córdoba', '03584621235'),
('Cine Hoyts Patio Olmos', 'Vélez Sarsfield 361, Córdoba', '03514238408');

DELIMITER $$

CREATE TRIGGER insertar_personal
AFTER INSERT ON Personal
FOR EACH ROW
BEGIN
	IF (NEW.tipo = 'Director') THEN
		INSERT INTO Director (nombre, nacionalidad, cantidad_peliculas) VALUES (NEW.nombre, NEW.nacionalidad, NEW.cantidad_peliculas);
	ELSEIF (NEW.tipo = 'Protagonista') THEN
		INSERT INTO Protagonista (nombre, nacionalidad, cantidad_peliculas) VALUES (NEW.nombre, NEW.nacionalidad, NEW.cantidad_peliculas);
    ELSEIF (NEW.tipo = 'Reparto') THEN
		INSERT INTO Reparto (nombre, nacionalidad, cantidad_peliculas) VALUES (NEW.nombre, NEW.nacionalidad, NEW.cantidad_peliculas);
    END IF;
END $$

DELIMITER ;

select * from Protagonista;
select * from Director;
select * from Reparto;