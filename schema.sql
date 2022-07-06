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