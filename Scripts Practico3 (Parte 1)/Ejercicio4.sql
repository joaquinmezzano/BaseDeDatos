-- Ejercicio 1
select nro_competidor, pais, anio, nombre, competidor.cod_deporte from competidor join deporte 
on competidor.cod_deporte = deporte.cod_deporte where denominacion = "FUTBOL";

-- Ejercicio 2
select distinct pais from competidor
except
select distinct pais from medalla;