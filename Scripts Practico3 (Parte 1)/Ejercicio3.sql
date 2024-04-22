-- Primera consulta (Seleccion, proyeccion, outer join)
select alumno.nombre, alumno.apellido, taller.nombre from 
(alumno join realiza on realiza.nro_alumno = alumno.nro_alumno)
left join taller on realiza.codigo_taller = taller.codigo_taller
where sexo = "masculino" && realiza.codigo_taller = 1;

-- Segunda consulta (Union)
select * from (alumno join realiza on alumno.nro_alumno = realiza.nro_alumno) 
join taller on realiza.codigo_taller = taller.codigo_taller
where taller.duracion > 50
union
select * from (alumno join realiza on alumno.nro_alumno = realiza.nro_alumno)
join taller on realiza.codigo_taller = taller.codigo_taller
where taller.duracion < 20
order by dni desc;

-- Tercera consulta (Diferencia)
select * from alumno
except
select * from alumno where sexo = "masculino"
order by apellido asc;