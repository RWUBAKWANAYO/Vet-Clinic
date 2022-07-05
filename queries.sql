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
