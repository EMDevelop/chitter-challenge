ALTER TABLE users ADD COLUMN salt TEXT;
ALTER TABLE users 
ALTER COLUMN password SET DATA TYPE TEXT;
