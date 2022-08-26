USE universidad;

-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre 
FROM persona 
WHERE tipo LIKE 'alumno' 
ORDER BY apellido1 ASC, apellido2 ASC, nombre ASC;

-- 2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1, apellido2 
FROM persona 
WHERE tipo LIKE 'alumno' AND telefono IS NULL;

-- 3. Retorna el llistat dels alumnes que van néixer en 1999.
SELECT * 
FROM persona 
WHERE tipo LIKE 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 4. Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
SELECT * 
FROM persona
WHERE tipo LIKE 'profesor' AND telefono IS NULL AND nif LIKE '%K';

-- 5. Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT * 
FROM asignatura 
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- 6. Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT per.apellido1, per.apellido2, per.nombre, dep.nombre as departamento 
FROM persona as per JOIN profesor as prof JOIN departamento as dep
ON prof.id_profesor = per.id AND prof.id_departamento = dep.id
ORDER BY per.apellido1 ASC, per.apellido2 ASC, per.nombre ASC;

-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
SELECT assig.nombre, curso.anyo_inicio, curso.anyo_fin
FROM asignatura as assig JOIN curso_escolar as curso JOIN alumno_se_matricula_asignatura as asma JOIN persona as per
ON asma.id_alumno = per.id AND asma.id_asignatura = assig.id AND asma.id_curso_escolar = curso.id
WHERE per.nif LIKE '26902806M';

-- 8. Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT dep.nombre 
FROM departamento as dep JOIN profesor as prof JOIN asignatura as asig JOIN grado as g
ON prof.id_departamento = dep.id AND asig.id_profesor = prof.id_profesor AND asig.id_grado = g.id
WHERE g.nombre LIKE 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT DISTINCT per.*
FROM alumno_se_matricula_asignatura as asma JOIN persona as per JOIN curso_escolar as curso
ON asma.id_alumno = per.id AND asma.id_curso_escolar = curso.id
WHERE curso.anyo_inicio = 2018 AND curso.anyo_fin = 2019;

-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.

-- 1. Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.

SELECT dep.nombre, profs.apellido1, profs.apellido2, profs.nombre
FROM (SELECT * FROM persona WHERE tipo LIKE 'profesor') as profs 
    LEFT JOIN profesor as prof ON prof.id_profesor = profs.id
    LEFT JOIN departamento as dep ON prof.id_departamento = dep.id
ORDER BY dep.nombre, profs.apellido1, profs.apellido2, profs.nombre;

-- 2. Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT profs.*
FROM (SELECT * FROM persona WHERE tipo LIKE 'profesor') as profs 
    LEFT JOIN profesor as prof ON prof.id_profesor = profs.id
    LEFT JOIN departamento as dep ON prof.id_departamento = dep.id
WHERE dep.nombre IS NULL
ORDER BY dep.nombre, profs.apellido1, profs.apellido2, profs.nombre;

-- 3. Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT dep.*
FROM (SELECT * FROM persona WHERE tipo LIKE 'profesor') as profs 
    RIGHT JOIN profesor as prof ON prof.id_profesor = profs.id
    RIGHT JOIN departamento as dep ON prof.id_departamento = dep.id
WHERE profs.nombre IS NULL;

-- 4. Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT DISTINCT profs.*
FROM (SELECT * FROM persona WHERE tipo LIKE 'profesor') as profs 
    LEFT JOIN asignatura as asig ON profs.id = asig.id_profesor
WHERE asig.id IS NULL;

-- 5. Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT DISTINCT asig.*
FROM asignatura as asig
WHERE asig.id_profesor IS NULL;

-- 6. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT dep.*
FROM departamento as dep 
LEFT JOIN (
    SELECT DISTINCT dep.*
    FROM departamento as dep JOIN profesor as prof JOIN asignatura as asig JOIN alumno_se_matricula_asignatura as asma JOIN curso_escolar
    ON prof.id_departamento = dep.id AND asig.id_profesor = prof.id_profesor AND asma.id_asignatura = asig.id AND asma.id_curso_escolar = curso_escolar.id
    ) as dep_cursats
ON dep.id = dep_cursats.id
WHERE dep_cursats.id IS NULL;

-- Consultes resum:

-- 1. Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(nombre) FROM persona 
WHERE tipo LIKE 'Alumno';

-- 2. Calcula quants alumnes van néixer en 1999.
SELECT COUNT(nombre) 
FROM (
    SELECT * FROM persona 
    WHERE tipo LIKE 'Alumno' 
        AND YEAR(fecha_nacimiento) = 1999
    ) as alumno_99;

-- 3. Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT dep.nombre, COUNT(prof.id_profesor) as `# profesores` 
FROM departamento as dep JOIN profesor as prof
ON dep.id = prof.id_departamento
GROUP BY dep.nombre
ORDER BY `# profesores` DESC;

-- 4. Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT dep.*, COUNT(per.nombre)
FROM departamento as dep 
    LEFT JOIN profesor as prof ON dep.id = prof.id_departamento 
    LEFT JOIN persona as per ON prof.id_profesor = per.id
GROUP BY dep.nombre;

-- 5. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT g.nombre as grado, COUNT(asig.nombre) as `# asignaturas`
FROM grado as g LEFT JOIN asignatura as asig ON asig.id_grado = g.id
GROUP BY g.nombre
ORDER BY `# asignaturas` DESC;

-- 6. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT g.nombre, counts.numero_asigs
FROM grado as g 
    LEFT JOIN (
        SELECT g.id, COUNT(asig.nombre) as numero_asigs
        FROM grado as g 
            LEFT JOIN asignatura as asig ON asig.id_grado = g.id
        GROUP BY g.nombre
        ) as counts 
ON g.id = counts.id
WHERE counts.numero_asigs > 40;

-- 7. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT g.nombre, asig.tipo, SUM(asig.creditos) as `créditos totales`
FROM grado as g LEFT JOIN asignatura as asig
ON g.id = asig.id_grado
GROUP BY g.nombre, asig.tipo;

-- 8. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT curso.anyo_inicio, COUNT(asma.id_alumno) as `# alumnos`
FROM curso_escolar as curso LEFT JOIN alumno_se_matricula_asignatura as asma ON asma.id_curso_escolar = curso.id
GROUP BY curso.anyo_inicio;

-- 9. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT per.id, per.nombre, per.apellido1, per.apellido2, COUNT(asig.nombre) as `# asignaturas`
FROM persona as per LEFT JOIN asignatura as asig ON per.id = asig.id_profesor
GROUP BY per.id
ORDER BY `# asignaturas` DESC;

-- 10. Retorna totes les dades de l'alumne/a més jove.
SELECT * 
FROM persona 
WHERE tipo LIKE 'Alumno' 
    AND YEAR(fecha_nacimiento) = (
        SELECT MAX(YEAR(fecha_nacimiento)) 
        FROM persona 
        WHERE tipo LIKE 'Alumno');
        
-- 11. Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
SELECT per.*
FROM persona as per JOIN profesor as prof JOIN departamento as dep
ON per.id = prof.id_profesor AND dep.id = prof.id_departamento 
LEFT JOIN asignatura as asig ON asig.id_profesor = per.id
WHERE asig.nombre IS NULL;