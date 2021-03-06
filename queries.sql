SELECT *
  FROM animals
  WHERE name LIKE '%mon';

 SELECT name
  FROM animals
  WHERE date_of_birth 
  BETWEEN '1-1-2016' 
  AND '12-31-2019';

  SELECT name
  FROM animals
  WHERE neutered = TRUE
  AND escape_attempts < 3;

  SELECT date_of_birth
  FROM animals
  WHERE name = 'Agumon'
  OR name = 'Pikachu';

  SELECT name, escape_attempts
  FROM animals
  WHERE weight_kg > 10.5;

  SELECT *
  FROM animals
  WHERE neutered = TRUE;

  SELECT *
  FROM animals
  WHERE NOT name = 'Gabumon';

  SELECT *
  FROM animals
  WHERE weight_kg
  BETWEEN 10.4 
  AND 17.3;

/* update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that species columns went back to the state before tranasction. */
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT species from animals
ROLLBACK;
SELECT species from animals

/* Update the animals table by setting the species column to digimon for all animals that have a name ending in mon or pokemon the others */
BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
COMMIT;
SELECT species from animals

/* delete all records in the animals table, then roll back the transaction */
BEGIN;
DELETE FROM animals
ROLLBACK;


/* Delete all animals born after Jan 1st, 2022.
Create a savepoint for the transaction.
Update all animals' weight to be their weight multiplied by -1.
Rollback to the savepoint
Update all animals' weights that are negative to be their weight multiplied by -1.
Commit transaction */
BEGIN;

DELETE FROM animals
WHERE date_of_birth > 'jan/01/2022';

SAVEPOINT save1;

UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO save1;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

SELECT * FROM animals;

COMMIT; 

/* Total animals */
SELECT COUNT (*)
FROM animals;

/* Total animals that never tried to escpaed */
SELECT COUNT (*)
FROM animals
WHERE escape_attempts = 0;

/* Avarage weight of animals */
SELECT AVG(weight_kg) FROM animals; 

/* Total escape attempts by neutered */
SELECT neutered, SUM (escape_attempts)
FROM animals
GROUP BY neutered;

/* MAX and MIN weight by species */
SELECT species, MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species; 

/* AVG escape attempts between dates */
SELECT species, AVG(escape_attempts)
FROM animals
WHERE date_of_birth BETWEEN 'jan/01/1990' AND 'DEC/31/2000'
GROUP BY species; 

SELECT 
    animals.name,
    owners.full_name 
    FROM animals
    JOIN owners ON owners.id = animals.owner_id
    where owners.full_name = 'Melody Pond';

    /* All animals w/ type pokemon */
    SELECT 
    animals.name,
    species.name
    FROM animals
    JOIN species ON species.id = animals.species_id 
    where species.name = 'Pokemon';

    /* All owners even without animals */
    SELECT 
    owners.full_name,
    animals.name

    FROM owners
    left JOIN animals 
    ON animals.owner_id = owners.id

    /* Number of animals per species */
    SELECT 
    species.name,
    count(animals)
    FROM animals
    JOIN species 
    ON animals.species_id = species.id
    group by species.name;

    /* All Digimons owned by jennifer orwell */
    SELECT 
    animals.name,
    species.name,
    owners.full_name
    FROM animals
    JOIN owners
    ON owners.id = animals.owner_id
    join species
    on species.id = animals.species_id
    where species.name = 'Digimon' and owners.full_name = 'Jennifer Orwell'


    /* All Animals owned by dean winchester that havent tried to escape */
    SELECT 
    animals.name,
    animals.escape_attempts ,
    owners.full_name
    FROM animals
    JOIN owners
    ON owners.id = animals.owner_id
    where owners.full_name = 'Dean Winchester' and escape_attempts = 0;

    /* Person who owns most animals */
    SELECT 
    count(owners.full_name),
    owners.full_name
    FROM owners
    JOIN animals
    ON owners.id = animals.owner_id
    group by owners.full_name 
    order by count(*) desc limit 1;

/* Last animal seen by william */
 SELECT visits.date, animals.name, vets."name"
 FROM visits
 JOIN animals  ON visits.animal_id = animals.id 
 JOIN vets ON vets.id = visits.vet_id 
 where vets."name" = 'William Tatcher'
 order by visits."date" desc limit 1; 

 /* different animal that stephanie mendez sees */
 SELECT count(distinct animal_id), vets."name"
 FROM visits 
 JOIN animals ON visits.animal_id = animals.id 
 JOIN vets ON visits.vet_id = vets.id 
 where vets."name" = 'Stephanie Mendez'
 group by vets."name";

 /* All vets and their specialtities (Even the ones with no one)*/
 SELECT vets."name", species."name" 
 FROM vets
 left JOIN specializations on specializations.vet_id = vets.id 
 left join species on specializations.species_id = species.id ;

 /* Visits to stephanie between april 1st and august 30th */
 SELECT visits.date, animals.name, vets.name
 FROM visits
 JOIN animals ON visits.animal_id = animals.id 
 JOIN vets ON visits.vet_id = vets.id
 where vets."name" = 'Stephanie Mendez' and visits."date" between 'apr-01-2020' and 'aug-30-2020';

 /* What animals has the most visits to vets*/
 SELECT max(visitCount.count), visitCount.name

 FROM (
    SELECT COUNT(visits."date"), animals."name" 
    FROM visits
    JOIN animals ON visits.animal_id = animals.id
    GROUP BY animals."name"
 ) AS visitCount

 GROUP BY visitCount.name, visitCount.count
 ORDER BY visitCount.count DESC LIMIT 1;

 /* Mary's first animal visit */
 SELECT visits.date, animals.name, vets."name"
 FROM visits
 JOIN animals ON visits.animal_id = animals.id 
 JOIN vets ON visits.vet_id = vets.id
 where vets."name" = 'Maisy Smith'
 order by visits."date" asc limit 1;

 /* Details on most recent animal visit */
 SELECT visits, animals, vets
 FROM visits
 JOIN animals ON visits.animal_id = animals.id 
 JOIN vets ON visits.vet_id = vets.id
 order by visits."date" desc limit 1;

 /* Visits that were treated by non specialist */
 SELECT count(*) 
 FROM vets 
 JOIN visits ON vets.id = visits.vet_id
 LEFT JOIN specializations ON vets.id = specializations.vet_id 
 LEFT JOIN animals ON visits.animal_id = animals.id 
 WHERE specializations.species_id != animals.species_id;

 /* What speciality maisy gets the most */
 SELECT COUNT(visits.animal_id), species."name"
 FROM visits
 JOIN animals on visits.animal_id = animals.id 
 JOIN species on animals.species_id = species.id
 JOIN vets on visits.vet_id = vets.id
 WHERE vets."name" = 'Maisy Smith'
 GROUP BY  species."name"
 ORDER BY COUNT(visits.animal_id ) DESC LIMIT 1;