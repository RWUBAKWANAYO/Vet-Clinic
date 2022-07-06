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
