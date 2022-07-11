/* Database schema to keep the structure of entire database. */

-- Create a table named animals with the specific columns
CREATE TABLE animals (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL
);

-- Add a column species of type string to the animals
ALTER TABLE animals ADD species VARCHAR(70);

-- Create a table named owners with id, full_name, age.
CREATE TABLE owners(
 id INT GENERATED ALWAYS AS IDENTITY,
 full_name VARCHAR(100),
 age INT,
 PRIMARY KEY(id)
);

-- Create a table named species with id, name 
CREATE TABLE species(
 id INT GENERATED ALWAYS AS IDENTITY,
 name VARCHAR(80),
 PRIMARY KEY(id)
);

/*
Modify animals table:
 Remove column species
 Add column species_id which is a foreign key referencing species table
 Add column owner_id which is a foreign key referencing the owners table
*/
ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT
 REFERENCES species(id)
 ON DELETE CASCADE;
 
ALTER TABLE animals ADD COLUMN owner_id INT
 REFERENCES owners(id)
 ON DELETE CASCADE;

 -- Create a table named vets.
CREATE TABLE vets (
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(50),
	age INT,
	date_of_graduation DATE
);

-- Create a "join table" called specializations.
CREATE TABLE specializations (
	vets_id INT NOT NULL,
	species_id INT NOT NULL,
	FOREIGN KEY (vets_id) REFERENCES vets (id) ON UPDATE CASCADE,
	FOREIGN KEY (species_id) REFERENCES species (id) ON UPDATE CASCADE
);

-- Create a "join table" called visits.
CREATE TABLE visits (
    animals_id INT NOT NULL,
    vets_id INT NOT NULL,
    date_of_visit DATE,
    FOREIGN KEY (animals_id) REFERENCES animals(id) ON UPDATE CASCADE,
    FOREIGN KEY (vets_id) REFERENCES vets(id) ON UPDATE CASCADE
);

-- Add an email column to owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);