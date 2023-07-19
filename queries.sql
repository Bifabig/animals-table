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

-- What animals belong to Melody Pond?
SELECT name, full_name
FROM animals
JOIN owners
ON animals.owner_id = owners.id AND animals.owner_id = 4;

-- List of all animals that are pokemon (their type is Pokemon)

SELECT animals.name, species.name
FROM animals
JOIN species
ON animals.species_id = species.id AND animals.species_id = 1;

-- List all owners and their animals, remember to include those that don't own any animal.

SELECT name, full_name
FROM animals
FULL JOIN owners
ON animals.owner_id = owners.id;

-- How many animals are there per species?
SELECT animals.species_id, species.name as species_name, COUNT(animals.species_id) as num_animals
FROM animals
JOIN species
ON animals.species_id = species.id
GROUP BY animals.species_id, species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name, owners.full_name
FROM animals
INNER JOIN owners
ON animals.owner_id = 2 AND owners.id = 2
INNER JOIN species
ON animals.species_id = 2 AND species.id = 2;

-- List all animals owned by Dean Winchester that haven't tried to escape.

SELECT animals.name, owners.full_name
FROM animals
INNER JOIN owners
ON animals.owner_id = 5 AND owners.id = 5 AND animals.escape_attempts = 0;

-- Who owns the most animals?

SELECT COUNT(animals.owner_id) as num_animals, owners.full_name
FROM animals
JOIN owners
ON animals.owner_id = owners.id
GROUP BY owners.full_name
ORDER BY num_animals DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT date_of_visit, vets.name as vet_name, animals.name as animal_name
FROM visits
JOIN vets
ON visits.vets_id = 1 AND vets.id = 1
JOIN animals
ON visits.animals_id = animals.id
GROUP BY visits.date_of_visit, vet_name, animal_name
ORDER BY date_of_visit DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(animals_id) as animal_count, vets_id, vets.name as vet_name
FROM visits
JOIN vets
ON visits.vets_id = 3 AND vets.id = 3
GROUP BY vets_id, vet_name;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name as vet_name, species.name as speciality
FROM specializations
FULL JOIN vets
ON specializations.vets_id = vets.id
FULL JOIN species
ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name as animal_name, vets.name as vet_name, date_of_visit
FROM visits
JOIN animals
ON visits.animals_id = animals.id
JOIN vets
ON visits.vets_id = vets.id AND vets.id = 3
GROUP BY animal_name, vet_name, date_of_visit
HAVING date_of_visit BETWEEN DATE '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT COUNT(animals.id) as most_visit, animals.name as animal_name
FROM visits
JOIN animals
ON visits.animals_id = animals.id
GROUP BY animal_name
ORDER BY most_visit DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT animals_id, animals.name as animal_name, vets_id, vets.name as vet_name, date_of_visit
FROM visits
JOIN vets
ON visits.vets_id = 2 AND visits.vets_id = vets.id
JOIN animals
ON animals.id = visits.animals_id
ORDER BY date_of_visit ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.

SELECT animals_id, animals.name as animal_name, vets_id, vets.name as vet_name, date_of_visit
FROM visits
JOIN vets
ON visits.vets_id = vets.id
JOIN animals
ON animals.id = visits.animals_id
ORDER BY date_of_visit DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?

SELECT COUNT(date_of_visit) as num_visits, visits.vets_id, specializations.species_id as speciality
FROM specializations
RIGHT JOIN visits
ON specializations.vets_id = visits.vets_id
WHERE specializations.vets_id IS NULL
GROUP BY visits.vets_id, speciality;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.

SELECT date_of_visit, visits.vets_id, vets.name, animals.species_id, species.name as species_name
FROM visits
JOIN animals
ON visits.animals_id = animals.id AND visits.vets_id = 2
JOIN vets
ON vets.id = visits.vets_id
JOIN species
ON species.id = animals.species_id
WHERE animals.species_id = 2;