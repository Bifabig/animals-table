/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon';
SELECT * from animals WHERE date_of_birth BETWEEN DATE '2016-01-01' AND '2019-01-01';
SELECT * from animals WHERE neutered = true AND  escape_attempts < 3;
SELECT name, date_of_birth from animals WHERE name IN  ('Agumon','Pikachu');
SELECT name, escape_attempts from animals WHERE weight_kg BETWEEN '10.4' AND '17.3';
SELECT * from animals WHERE neutered = true;
SELECT * from animals WHERE name !='Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

-- transactions
-- update species column to unspecified and rollback.
BEGIN;

UPDATE animals
SET species = 'unspecified';

ROLLBACK;

-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

-- Commit the transaction.
COMMIT;

-- Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
BEGIN;

DELETE FROM animals;

ROLLBACK;

-- Delete all animals born after Jan 1st, 2022.
BEGIN;

DELETE FROM animals
WHERE date_of_birth > DATE '2022-01-01';

-- Create a savepoint for the transaction.
SAVEPOINT before_weight_update;

-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals
SET weight_kg = weight_kg * -1;

-- Rollback to the savepoint
ROLLBACK TO before_weight_update;

-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

-- How many animals are there?
SELECT COUNT(id)
FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(id)
FROM animals
WHERE escape_attempts = 0;

-- What is the average weight of animals?

SELECT AVG(weight_kg)
FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) as escape_attempts
FROM animals
GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) as MIN_weight_kg, MAX(weight_kg) as MAX_weight_kg
FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, date_of_birth, AVG(escape_attempts) as avg_escape_attempts
FROM animals
GROUP BY species, date_of_birth
HAVING date_of_birth BETWEEN DATE '1990-01-01' AND '2000-01-01';