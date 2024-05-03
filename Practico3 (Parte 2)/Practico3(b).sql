-- EJERCICIO 1 (A)
create table Articulo (
	nro_art integer not null primary key,
	descripcion varchar(100), 
	precio float, 
	cantidad int, 
	stock_min int, 
	stock_max int, 
	mes_ult_mov int, 
	fecha_vto date,
	constraint control_stock check (stock_min < stock_max), 
	constraint control_precio_min check (precio > 0), 
	constraint control_precio_max check (precio < 999999));
    
-- EJERCICIO 1 (B)
create table personas (
	dni int not null primary key,
	nombre varchar(45),
	edad int,
	municipio varchar(45),
	constraint fkmunicipio foreign key (municipio) references municipios(municipio),
	constraint dni_post check (dni > 0),
	constraint edad_max check (edad < 21)
);

create table contagios (
	dni int,
	cepa varchar(45),
	constraint fkdni foreign key (dni) references personas(dni)
);

create table vacunados (
	dni int,
	cod_vacuna int,
	constraint fk_dni foreign key (dni) references personas(dni),
	constraint fkcod_vacuna foreign key (cod_vacuna) references vacunas(cod_vacuna)
);

create table municipios (
	municipio varchar(45) not null primary key,
	provincia varchar(45)
);

create table vacuna_options (
	id int auto_increment primary key,
	nombre_vacuna varchar(30) unique
);

insert into vacuna_options (nombre_vacuna) values
('COVID-19'), 
('FIEBRE AMARILLA'), 
('DENGUE'), 
('BCG');

create table vacunas (
	cod_vacuna int not null primary key,
	nombre_vacuna varchar(30),
    constraint fk_vacuna_options foreign key (nombre_vacuna) references vacuna_options(nombre_vacuna)
);

-- EJERCICIO 2 Y 3
insert into municipios values ('Rio Cuarto', 'Cordoba'),
	('Merlo', 'Buenos Aires'),
	('Sampacho', 'Cordoba');

insert into personas values (46827301, 'Joaquin', 18, 'Rio Cuarto'),
	(43027192, 'Rocio', 19, 'Merlo'),
	(41829633, 'Jose', 15, 'Sampacho');

select * from municipios order by municipio asc;
select * from personas order by dni asc;

-- EJERCICIO 4
alter table vacunados drop constraint fk_dni;
alter table vacunados add constraint fk_dni foreign key (dni) references personas(dni) on delete no action;

INSERT INTO vacunas (cod_vacuna, nombre_vacuna)
SELECT 
    vacuna_options.id,
    vacuna_options.nombre_vacuna
FROM 
    vacuna_options;
    
INSERT INTO vacunados (dni, cod_vacuna)
VALUES 
    (46827301, (SELECT cod_vacuna FROM vacunas WHERE nombre_vacuna = 'DENGUE')),
    (43027192, (SELECT cod_vacuna FROM vacunas WHERE nombre_vacuna = 'FIEBRE AMARILLA')),
    (41829633, (SELECT cod_vacuna FROM vacunas WHERE nombre_vacuna = 'COVID19'));

delete from vacunas where cod_vacuna='0';

-- EJERCICIO 5
-- a)
select cod_vacuna, count(cod_vacuna) as contador from vacunados group by cod_vacuna;

-- b)
select distinct personas.nombre, vacunados.dni, cod_vacuna, count(vacunados.cod_vacuna)
as cantidad
from vacunados join personas on personas.dni = vacunados.dni
group by cod_vacuna, vacunados.dni
order by cantidad desc
limit 1;

-- c)
select distinct personas.nombre, vacunados.dni, cod_vacuna, count(vacunados.cod_vacuna)
as cantidad
from vacunados join personas on personas.dni = vacunados.dni
group by cod_vacuna, vacunados.dni;

-- EJERCICIO 6
-- a)
delimiter $$
create trigger trigger_insert_art
before insert on Articulo
for each row
begin
	set new.descripcion = upper (new.descripcion);
end
$$
delimiter;

-- b
CREATE TABLE auditoriaArticulo (
    num_art INTEGER NOT NULL PRIMARY KEY,
    movimiento INT,
    fecha_actualizacion DATE,
    CONSTRAINT fknum FOREIGN KEY (num_art) REFERENCES Articulo(nro_art)
);

delimiter //
create trigger new_trigger_modification
after update on Articulo
for each row
-- 'update' se utiliza para modificar los registros existentes en una tabla por lo tanto
-- 'AFTER UPDATE' se ejecutara despues de que se haya actualizado la fila en la tabla
-- permitiendo acceder a los valores actualizados
begin
	declare movi int;
    set movi = new.cantidad - old.cantidad;
    insert into auditoriaArticulo (num_art, movimiento, fecha_actualizacion)
    values (new.nro_art, movi, now());
end //
delimiter;