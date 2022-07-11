/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon
SELECT * FROM animals WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered = true;

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/*
 update the animals table by setting the species column to unspecified.
 Verify that change was made.
 roll back the change.
 Verify that change was made.
*/
BEGIN;
UPDATE animals SET species = 'unspecified'; 
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

/* 
setting the species column to digimon for all animals that have a name ending in mon.
setting the species column to pokemon for all animals that don't have species already set.
Commit the transaction
Verify that change was made and persists after commit.
*/
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT * FROM animals;

/*
delete all records in the animals table.
roll back the transaction.
verify if all records in the animals table still exists.
*/
BEGIN;
DELETE FROM animals;
ROLLBACK
SELECT * FROM animals;

/*
Delete all animals born after Jan 1st, 2022.
Create a savepoint for the transaction.
Update all animals' weight to be their weight multiplied by -1.
Rollback to the savepoint
Update all animals' weights that are negative to be their weight multiplied by -1.
Commit transaction
*/
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT update_weight;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO update_weight;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

/*
number of animals are there
number of animals have never tried to escape
average weight of animals
Who escapes the most, neutered or not neutered animals
minimum and maximum weight of each type of animal
average number of escape attempts per animal type of those born between 1990 and 2000?
*/
SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY (neutered);
SELECT species, MIN(weight_kg), MAX(weight_kg)FROM animals GROUP BY(species);
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY(species);

/*
Write queries (using JOIN ) to answer the following questions:
 animals belong to Melody Pond
 List of all animals that are pokemon (their type is Pokemon).
 List all owners and their animals, remember to include those that don't own any animal.
 How many animals are there per species?
 List all Digimon owned by Jennifer Orwell.
 List all animals owned by Dean Winchester that haven't tried to escape.
 Who owns the most animals?
*/
SELECT animals.* FROM animals
 JOIN owners ON animals.owner_id = owners.id
 WHERE owners.full_name = 'Melody Pond';

SELECT animals.* FROM animals
 JOIN species ON animals.species_id = species.id
 WHERE species.name = 'Pokemon';

SELECT owners.full_name,animals.name FROM owners
 LEFT JOIN animals ON owners.id = animals.owner_id;

SELECT species.name, COUNT(*) FROM animals
 JOIN species ON animals.species_id = species.id
 GROUP BY species.name;

SELECT animals.* FROM animals
 JOIN owners ON animals.owner_id = owners.id
 JOIN species ON animals.species_id = species.id
 WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';
 
SELECT animals.* FROM animals
 JOIN owners ON animals.owner_id = owners.id
 WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

SELECT owners.full_name,COUNT(*) FROM owners 
 JOIN animals ON owners.id = animals.owner_id
 GROUP BY owners.full_name
 ORDER BY count DESC LIMIT 1;

/*
Write queries to answer the following:
 last animal seen by William Tatcher
 How many different animals did Stephanie Mendez see?
 List all vets and their specialties, including vets with no specialties.
 List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
 What animal has the most visits to vets?.
 Who was Maisy Smith's first visit?.
 Details for most recent visit: animal information, vet information, and date of visit.
 How many visits were with a vet that did not specialize in that animal's species?.
 What specialty should Maisy Smith consider getting? Look for the species she gets the most.
*/
SELECT animals.name, visits.date_of_visit from animals
JOIN visits ON visits.animals_id = animals.id
JOIN vets ON vets.id =visits.vets_id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.date_of_visit DESC LIMIT 1;
-------------------------------------------------
SELECT COUNT(*) FROM animals
JOIN visits ON visits.animals_id = animals.id
JOIN vets ON vets.id = visits.vets_id
WHERE vets.name = 'Stephanie Mendez';
-------------------------------------------------
SELECT vets.name, species.name FROM vets
FULL JOIN specializations ON specializations.vets_id = vets.id
FULL JOIN species ON species.id = specializations.species_id;
-------------------------------------------------
SELECT animals.name, visits.date_of_visit FROM animals
 JOIN visits ON visits.animals_id = animals.id
 JOIN vets ON vets.id = visits.vets_id
 WHERE vets.name = 'Stephanie Mendez' AND
 (visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30');
-------------------------------------------------
SELECT animals.name, COUNT(animals.name) FROM animals
 JOIN visits ON visits.animals_id = animals.id
 GROUP BY animals.name
 ORDER BY count DESC LIMIT 1;
-------------------------------------------------
SELECT animals.name, visits.date_of_visit FROM animals
JOIN visits ON visits.animals_id = animals.id
JOIN vets ON vets.id = visits.vets_id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_of_visit ASC LIMIT 1;
-------------------------------------------------
SELECT animals.*, vets.*,visits.date_of_visit FROM animals
JOIN visits ON visits.animals_id = animals.id
JOIN vets ON vets.id = visits.vets_id
ORDER BY visits.date_of_visit DESC;
-------------------------------------------------
SELECT vets.name AS "non-specialize vet", COUNT(vets.name) AS "number of visit" FROM vets
FULL JOIN specializations ON specializations.vets_id = vets.id
FULL JOIN visits ON visits.vets_id = vets.id
WHERE specializations.vets_id IS NULL
GROUP BY vets.name;
-------------------------------------------------
SELECT species.name "species she gets the most", COUNT(*) FROM animals
JOIN visits ON visits.animals_id = animals.id
JOIN vets ON vets.id = visits.vets_id
JOIN species ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name 
ORDER BY count DESC LIMIT 1;

-----------------------------------------------
/*
Find a way to decrease the execution time of the first query.
Use EXPLAIN ANALYZE to check what is happening.
*/

CREATE INDEX visits_animals_id_asc ON visits(animals_id ASC);
explain analyze SELECT COUNT(*) FROM visits where animals_id = 4;

-----------------------------------------------
/*
Find a way to improve execution time of the other two queries.
Use EXPLAIN ANALYZE to check what is happening.
*/
CREATE INDEX visits_vets_id_asc ON visits(vets_id DESC);
explain analyze SELECT * FROM visits where vets_id = 2;

CREATE INDEX owners_email_asc ON owners(email ASC);
explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';
