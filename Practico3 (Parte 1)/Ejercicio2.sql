show tables;

-- Ejercicio 1
select * from competencia where categoria > 2;

-- Ejercicio 2
select nombre_club, club.nro_club, competencia.categoria from 
(club join participacion on club.nro_club = participacion.nro_club) 
join competencia on competencia.nro_competencia = participacion.nro_competencia 
where competencia.categoria > 2 order by nombre_club asc;

-- Ejercicio 3
select nombre_club from (club join participacion on club.nro_club = participacion.nro_club)
join competencia on competencia.nro_competencia = participacion.nro_competencia
where competencia.categoria = 2 order by nombre_club asc;