/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL,
);

ALTER TABLE animals
ADD species VARCHAR(100);

-- OWNERS TABLE
CREATE TABLE owners (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    age INT,
);

-- SPECIES TABLE
CREATE TABLE species (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
);

-- REMOVE SPECIES COLUMN FROM ANIMALS TABLE
ALTER TABLE animals
DROP COLUMN species;

-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals
ADD species_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_species
FOREIGN KEY (species_id)
REFERENCES species (id); 

-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals
ADD owner_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_owners
FOREIGN KEY (owner_id)
REFERENCES owners (id); 

-- Create a table named vets
CREATE TABLE vets (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    date_of_graduation DATE NOT NULL
);

-- Create a table specializations
CREATE TABLE specializations (
    species_id INT,
    vets_id INT
);

ALTER TABLE specializations
ADD CONSTRAINT fk_species
FOREIGN KEY (species_id)
REFERENCES species (id);


ALTER TABLE specializations
ADD CONSTRAINT fk_vets
FOREIGN KEY (vets_id)
REFERENCES vets (id); 

-- Create a table specializations
CREATE TABLE visits (
    animals_id INT,
    vets_id INT
);

ALTER TABLE visits
ADD date_of_visit DATE NOT NULL;

ALTER TABLE visits
ADD CONSTRAINT fk_animals
FOREIGN KEY (animals_id)
REFERENCES animals (id);


ALTER TABLE visits
ADD CONSTRAINT fk_vets
FOREIGN KEY (vets_id)
REFERENCES vets (id); 

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- Index for animals_id column on visits table
CREATE INDEX animals_id_asc ON visits(animals_id ASC);

-- Index for vets_id column on visits table
CREATE INDEX vets_id_asc ON visits(vets_id ASC);

-- Index for email column on owners table
CREATE INDEX owners_email_desc ON owners(email DESC);