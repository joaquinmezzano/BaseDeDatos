CREATE TABLE Personal(
	nombre VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(20) NOT NULL,
    cantidad_peliculas INT NOT NULL,
    CONSTRAINT PK_nombre_p PRIMARY KEY (nombre),
    CONSTRAINT CK_cantidad_pelicula_p CHECK (cantidad_peliculas >= 0)
);

CREATE TABLE Director(
	nombre_director VARCHAR(50),
    CONSTRAINT PK_nombre_director FOREIGN KEY (nombre_director) REFERENCES Personal(nombre) ON DELETE SET NULL
);

CREATE TABLE Protagonista(
	nombre_protagonista VARCHAR(50),
    CONSTRAINT PK_nombre_p FOREIGN KEY (nombre_protagonista) REFERENCES Personal(nombre) ON DELETE SET NULL
);

CREATE TABLE Reparto(
	nombre_reparto VARCHAR(50),
    CONSTRAINT PK_nombre_r FOREIGN KEY (nombre_reparto) REFERENCES Personal(nombre) ON DELETE SET NULL
);

CREATE TABLE Pelicula(
	id_pelicula INT NOT NULL,
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
    calificacion VARCHAR(20) NOT NULL DEFAULT 'Apta todo público',
    nombre_d VARCHAR(50) NOT NULL,
    CONSTRAINT PK_identificador PRIMARY KEY (id_pelicula),
    CONSTRAINT UK_fecha_estreno UNIQUE KEY (fecha_estreno),
    CONSTRAINT CK_identificador CHECK (id_pelicula >= 0),
    CONSTRAINT CK_año_produccion CHECK (año_produccion >= 0),
    CONSTRAINT FK_nombre_d FOREIGN KEY (nombre_d) REFERENCES Director(nombre_director),
    CONSTRAINT CK_calificación CHECK (calificacion IN ('+ 13 años', '+ 15 años','+ 18 años'))
);

DELIMITER $$

CREATE TRIGGER after_insert_pelicula
BEFORE INSERT ON Pelicula
FOR EACH ROW
BEGIN
	SET NEW.titulo_original = UPPER(NEW.titulo_original);
END $$

DELIMITER ;

CREATE TABLE MPelicula(
	id_pelicula INT,
    paises_origen VARCHAR(20),
    CONSTRAINT FK_id_pel FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula) ON DELETE CASCADE
);

CREATE TABLE Actuo(
	ident_pelicula INT,
    nombre_p VARCHAR(50),
    CONSTRAINT FK_identificador_p_p FOREIGN KEY (ident_pelicula) REFERENCES Pelicula(id_pelicula) ON DELETE CASCADE,
    CONSTRAINT FK_nombre_p FOREIGN KEY (nombre_p) REFERENCES Protagonista(nombre_protagonista)
);

CREATE TABLE Participo(
	ident_pelicula INT NOT NULL,
    nombre_r VARCHAR(50) NOT NULL,
    CONSTRAINT FK_identificador_p_r FOREIGN KEY (ident_pelicula) REFERENCES Pelicula(id_pelicula) ON DELETE CASCADE,
    CONSTRAINT FK_nombre_r FOREIGN KEY (nombre_r) REFERENCES Reparto(nombre_reparto)
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
    CONSTRAINT FK_nombre_cine_s FOREIGN KEY (nombre_cine) REFERENCES Cine(nombre) ON DELETE CASCADE
);

CREATE TABLE Funcion(
	codigo INT NOT NULL,
    fecha DATE NOT NULL,
    hora_comienzo TIME NOT NULL,
    numero_sala INT,
    id_peli INT,
    CONSTRAINT PK_codigo PRIMARY KEY (codigo),
    CONSTRAINT CK_codigo CHECK (codigo >= 0),
    CONSTRAINT FK_numero FOREIGN KEY (numero_sala) REFERENCES Sala(numero),
    CONSTRAINT FK_id_peli FOREIGN KEY (id_peli) REFERENCES Pelicula(id_pelicula)
);

CREATE TABLE Auditoria (
	id_peli INT,
    titulo_distribucion VARCHAR(50),
    fecha_estreno_anterior DATE,
    fecha_estreno_nueva DATE,
    fecha_modificacion DATETIME,
    CONSTRAINT FK_id_p FOREIGN KEY (id_peli) REFERENCES Pelicula(id_pelicula)
);

DELIMITER $$

CREATE TRIGGER after_update_fecha
AFTER UPDATE ON Pelicula
FOR EACH ROW
BEGIN
	IF (NEW.fecha_estreno <> OLD.fecha_estreno) THEN
		INSERT INTO Auditoria(id_peli, titulo_distribucion, fecha_estreno_anterior, fecha_estreno_nueva, fecha_modificacion)
        VALUES (NEW.id_pelicula, NEW.titulo_distribucion, OLD.fecha_estreno, NEW.fecha_estreno, now());
	END IF;
END $$

DELIMITER ;