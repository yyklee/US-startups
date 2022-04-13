###Business Dynamics: Data Cleaning###

-- 1. Changing 'bds_geo' to match STATE-ID-CODE. 

-- 'bds_geo' contains: geo_id(ex. 0400000US01) | geo_name(ex. Alabama)
USE yproject;

SELECT *, length(geo_id)
FROM bds_geo
GROUP BY geo_id;

-- create table 'geo_codes' : geo_name(ex. Alabama) | st (ex. 01) <-- from geo_id (ex. 0400000US01)
DROP TABLE IF EXISTS geo_codes;

CREATE TABLE geo_codes AS 
	(SELECT 
		geo_name as st_name,
		RIGHT(geo_id, 2) as st_id -- last two numbers = state code
		FROM bds_geo
		WHERE LENGTH(geo_id) > 9 -- exclude Country level data 
		GROUP BY geo_id
    );
    
SELECT *
FROM
geo_codes;


-- 2. Changing 'bds_naics' (sector data) to match naics_sector_code 

-- 'bds_naics' contains: naics_code(ex. 11) | sector (ex. Agriculture, fishing,...)

SELECT *
FROM bds_naics;

-- Possible to match with main data 
DROP TABLE IF EXISTS sector_codes;
CREATE TABLE sector_codes
AS (SELECT naics_code as sector_id, sector as sector_name
	  FROM bds_naics
      GROUP BY sector
); 

SELECT * FROM sector_codes;


-- Just in case; changing naics_code with hyphen (ex. 31-33) to separate values (31 /32 /33)

CREATE VIEW bds_sector_sep
AS (SELECT sector,
		  if(naics_code like '%-%', substring(naics_code, 1, 2 ), naics_code) sector_code
	  FROM bds_naics
      GROUP BY sector
); 

insert into bds_sector_sep
values 
  ('Manufacturing', 32), 
  ('Manufacturing', 33), 
  ('Retail Trade', 45),
  ('Transportation and Warehousing', 49); 

SELECT *
FROM bds_sector_sep;



-- 3. Joining : 
-- (1) bds2019_sec_fa + sector_codes
DROP table if exists sec_fa;
CREATE TABLE sec_fa AS (
SELECT *
FROM bds2019_sec_fa A
JOIN sector_codes B
ON A.sector = B.sector_id
);

SELECT *
FROM sec_fa;

-- (2) bds2019_st_sec + sector_codes + geo_codes 
DROP table if exists st_sec;
CREATE TABLE st_sec AS (
SELECT *
FROM bds2019_st_sec A
JOIN geo_codes B
ON A.st = B.st_id
JOIN sector_codes C
ON A.sector = C.sector_id
);

SELECT *
FROM st_sec;

-- (3) bds2019_st_fa + geo_codes 
DROP table if exists st_fa;
CREATE TABLE st_fa AS (
SELECT *
FROM bds2019_st_fa A
JOIN geo_codes B
ON A.st = B.st_id
);

SELECT *
FROM st_fa;


## -->  3 datasets: st_fa / st_sec / sec_fa



-- 4 Remove unnecessary columns

Select *
From st_sec, sec_fa; 

ALTER TABLE bds_sec_fage  DROP COLUMN job_creation_births,  
						DROP COLUMN job_creation_continuers,         
                        DROP COLUMN job_creation_rate_births,         
                        DROP COLUMN job_destruction_deaths,         
                        DROP COLUMN reallocation_rate,        
                        DROP COLUMN firmdeath_emp,        
                        DROP COLUMN firmdeath_estabs,
                        DROP COLUMN denom;




-- 5 change to integer 

-- CREATE TABLE bds19_sec_fage AS 
--   (
-- 	Select year, 
--            sector
--            fage, 
--            IF(CAST(firms AS UNSIGNED) = 0, NULL, CAST(firms AS UNSIGNED)) as firms,
--            IF(CAST(estabs AS UNSIGNED) = 0, NULL, CAST(estabs AS UNSIGNED)) as estabs,
-- 		   IF(CAST(emp AS UNSIGNED) = 0, NULL, CAST(emp AS UNSIGNED)) as emp,
-- 		   IF(CAST(estabs_entry AS UNSIGNED) = 0, NULL, CAST(estabs_entry AS UNSIGNED)) as estabs_entry,
--            IF(CAST(estabs_entry_rate AS UNSIGNED) = 0, NULL, CAST(estabs_entry_rate AS UNSIGNED)) as estabs_entry_rate,
--            IF(CAST(estabs_exit AS UNSIGNED) = 0, NULL, CAST(estabs_exit AS UNSIGNED)) as estabs_exit,
--            IF(CAST(estabs_exit_rate AS UNSIGNED) = 0, NULL, CAST(estabs_exit_rate AS UNSIGNED)) as estabs_exit_rate,
--            IF(CAST(job_creation AS UNSIGNED) = 0, NULL, CAST(job_creation AS UNSIGNED)) as job_creation,
--            IF(CAST(job_destruction AS UNSIGNED) = 0, NULL, CAST(job_destruction AS UNSIGNED)) as job_destruction
-- FROM bds_sec_fa

-- );
-- Select *
-- From bds_sec_fage_R;

-- create table cte
-- (
-- Select year, 
--            sector,
--            fage, 
--            IF(CAST(firms AS UNSIGNED) = 0, NULL, firms) as firms 
--            from bds_sec_Fa
-- );
-- Select *
-- From cte;

--  -- ALTER TABLE bds_sec_fa   
-- 				MODIFY firms INT,          
--                 MODIFY estabs INT,         
--                 MODIFY emp INT,         
--                 MODIFY estabs_entry INT,         
--                 MODIFY estabs_entry_rate INT,         
--                 MODIFY estabs_exit INT,         
--                 MODIFY estabs_exit_rate INT,         
--                 MODIFY job_creation INT,         
--                 MODIFY job_destruction INT;

-- SHOW COLUMNS FROM bds_sec_fa; 


