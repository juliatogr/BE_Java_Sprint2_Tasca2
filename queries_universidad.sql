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
-- 2. Retorna un llistat amb els professors/es que no estan associats a un departament.
-- 3. Retorna un llistat amb els departaments que no tenen professors/es associats.
-- 4. Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
-- 5. Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
-- 6. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.

-- Consultes resum:

-- 1. Retorna el nombre total d'alumnes que hi ha.
-- 2. Calcula quants alumnes van néixer en 1999.
-- 3. Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
-- 4. Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat.
-- 5. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
-- 6. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
-- 7. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
-- 8. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
-- 9. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
-- 10. Retorna totes les dades de l'alumne/a més jove.
-- 11. Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.