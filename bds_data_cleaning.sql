###Business Dynamics: Data Cleaning###

-- 1. Changing 'bds_geo' to match STATE-ID-CODE. 

-- 'bds_geo' contains: geo_id(ex. 0400000US01) | geo_name(ex. Alabama)
USE yproject;

SELECT *, length(geo_id)
FROM bds_geo
GROUP BY geo_id;

-- create table 'geo_codes' : geo_name(ex. Alabama) | st (ex. 01) <-- from geo_id (ex. 0400000US01)

CREATE TABLE geo_codes AS 
	(SELECT 
		geo_name,
		RIGHT(geo_id, 2) as st -- last two numbers = state code
		FROM bds_geo
		WHERE LENGTH(geo_id) > 9 -- exclude Country level data 
		GROUP BY geo_id
    );
    
SELECT *
FROM
geo_codes;


-- 2. Changing 'bds_naics' (sector data) to match STATE-ID-CODE. 

-- 'bds_naics' contains: naics_code(ex. 11) | sector (ex. Agriculture, fishing,...)

SELECT *
FROM bds_naics;

-- Possible to match with main data 

CREATE TABLE sector_codes
AS (SELECT naics_code, sector 
	  FROM bds_naics
      GROUP BY sector
); 

SELECT * FROM sector_codes;


-- Just in case; changing naics_code with hyphen (ex. 31-33) to separate values (31 /32 /33)

CREATE TABLE bds_sector_sep
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


-- 3. bds2019_sec_fa -> get 2015 - 2019 dataset 

CREATE TABLE bds_sec_fage(
SELECT *
FROM bds2019_sec_fa
WHERE YEAR BETWEEN 2015 AND 2019);

SELECT * FROM bds_sec_fage ;

-- Delete Unused Columns

Select *
From bds_sec_fage; 

ALTER TABLE bds_sec_fage  DROP COLUMN job_creation_births,  
						DROP COLUMN job_creation_continuers,         
                        DROP COLUMN job_creation_rate_births,         
                        DROP COLUMN job_destruction_deaths,         
                        DROP COLUMN reallocation_rate,        
                        DROP COLUMN firmdeath_emp,        
                        DROP COLUMN firmdeath_estabs,
                        DROP COLUMN denom;



--
CREATE TABLE bds19_sec_fage AS 
  (
	Select year, 
           sector
           fage, 
           IF(CAST(firms AS UNSIGNED) = 0, NULL, CAST(firms AS UNSIGNED)) as firms,
           IF(CAST(estabs AS UNSIGNED) = 0, NULL, CAST(estabs AS UNSIGNED)) as estabs,
		   IF(CAST(emp AS UNSIGNED) = 0, NULL, CAST(emp AS UNSIGNED)) as emp,
		   IF(CAST(estabs_entry AS UNSIGNED) = 0, NULL, CAST(estabs_entry AS UNSIGNED)) as estabs_entry,
           IF(CAST(estabs_entry_rate AS UNSIGNED) = 0, NULL, CAST(estabs_entry_rate AS UNSIGNED)) as estabs_entry_rate,
           IF(CAST(estabs_exit AS UNSIGNED) = 0, NULL, CAST(estabs_exit AS UNSIGNED)) as estabs_exit,
           IF(CAST(estabs_exit_rate AS UNSIGNED) = 0, NULL, CAST(estabs_exit_rate AS UNSIGNED)) as estabs_exit_rate,
           IF(CAST(job_creation AS UNSIGNED) = 0, NULL, CAST(job_creation AS UNSIGNED)) as job_creation,
           IF(CAST(job_destruction AS UNSIGNED) = 0, NULL, CAST(job_destruction AS UNSIGNED)) as job_destruction
FROM bds_sec_fa

);
Select *
From bds_sec_fage_R;

create table cte
(
Select year, 
           sector,
           fage, 
           IF(CAST(firms AS UNSIGNED) = 0, NULL, firms) as firms 
           from bds_sec_Fa
);
Select *
From cte;

 -- ALTER TABLE bds_sec_fa   
				MODIFY firms INT,          
                MODIFY estabs INT,         
                MODIFY emp INT,         
                MODIFY estabs_entry INT,         
                MODIFY estabs_entry_rate INT,         
                MODIFY estabs_exit INT,         
                MODIFY estabs_exit_rate INT,         
                MODIFY job_creation INT,         
                MODIFY job_destruction INT;

SHOW COLUMNS FROM bds_sec_fa; 



       