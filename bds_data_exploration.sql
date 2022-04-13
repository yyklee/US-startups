-- Data Sets (Two main data sets)
-- 1) bds2019_st_sec (data which includes state * sector)  
-- 2) bds2019_sec_fa ( ... sector * firm age) 

-- View: 
USE yproject;
SELECT *
FROM bds_sec_fa;
SELECT *
FROM bds2019_st_sec;

-- 1 ---
-- Explore Entrepreneurial activity (by using data - 2) 'bds2019_sec_fa' ) 


-- Summary of 2019 firms vs. establishment by sector
SELECT A.year, B.sector, AVG(A.firms), AVG(A.estabs)
FROM bds_sec_fa A
	JOIN sector_codes B
	ON A.sector = B.naics_code
WHERE year = 2019
GROUP BY A.year, A.sector
ORDER BY 3 DESC;


-- Average entry/exit rate by Year and Sector (2015-2019) when firm age >=1
Select A.year, B.sector, 
	   AVG(A.estabs_entry) as tot_entry, 
	   AVG(A.estabs_exit) as tot_exit
FROM bds_sec_fa A
	JOIN sector_codes B
	ON A.sector = B.naics_code
WHERE A.year between 2015 and 2019 and A.fage !="a) 1"
GROUP BY A.year, A.sector
ORDER BY A.year, A.sector;


-- Average number of startups (2015-2019) , startup = firmage < 1
SELECT year, AVG(firms)
FROM bds_sec_fa
WHERE year between 2015 and 2019 AND fage = "a) 0"
GROUP BY year
ORDER BY 1, 2;


-- Average number of startups (2015-2019) , startup = firmage < 1, by sector
SELECT A.year, A.sector, AVG(A.firms)
FROM bds_sec_fa A
	JOIN sector_codes B
	ON A.sector = B.naics_code
WHERE year between 2015 and 2019 AND A.fage = "a) 0"
GROUP BY A.year, A.sector
ORDER BY 2, 1;


-- Average number of firms (2015-2019) by firm age
SELECT year, fage, AVG(firms)
FROM bds_sec_fa
WHERE year between 2015 and 2019 
GROUP BY year, fage
ORDER BY 1, 2;






-- 2 ---
-- Summary of Job Dynamics


-- Job Creation and Destruction Average by sector in 2019

Select A.year, A.sector, 
	   AVG(A.job_creation) as job_creation_avg, 
	   AVG(A.job_destruction) as job_destruction_avg
FROM bds_sec_fa A
	JOIN sector_codes B
	ON A.sector = B.naics_code
WHERE A.year = 2019
GROUP BY A.year, A.sector
ORDER BY A.year, A.sector;

-- Job Creation across 2015-2019 (for startups)


Select A.year, A.sector, 
	   AVG(A.job_creation) as job_creation_avg, 
	   AVG(A.job_destruction) as job_destruction_avg
FROM bds_sec_fa A
	JOIN sector_codes B
	ON A.sector = B.naics_code
WHERE A.fage = "a) 0"
GROUP BY A.year, A.sector
ORDER BY A.year, A.sector;




-- from here --- 

-- 3 ---

-- Average Firm Death by state and year 
Select A.year, A.st, B.geo_name,
	   AVG(A.firmdeath_firms) as firmdeath 
FROM bds_st A
INNER JOIN geo_codes_description B
ON A.st = B.st
GROUP BY A.year, A.st
ORDER BY A.year, A.st;

-- Firm Death in 2019 
SELECT B.geo_name, AVG(A.firmdeath_firms) AS firmdeath19, AVG(A.firmdeath_estabs) AS estdeath19
FROM bds_st A
INNER JOIN geo_codes_description B
ON A.st = B.st
WHERE year = 2019
GROUP BY A.st;



-- 4 -- 
-- by sector
-- Total number of firms and firm entry rate by sector in 2019

--
with cte as (

	select bds.Sector, count( d) as Loans_Approved, sum(d) as Net_Dollars
	from bds
	inner join bds_sector_description as sector
		on left(cast(UNSIGNED main.NAICSCode), 2) = sector.LookupCode
	where year = 2019
	group by bds.Sector
	--order by 3 desc

)bds2019_st_sec_fa


SELECT 
	sector,Loans_Approved,
	SUM(Net_Dollars) OVER(PARTITION BY sector) AS Net_Dollars,
	--SUM(Net_Dollars) OVER() AS Total,
	CAST(1. * Net_Dollars / SUM(Net_Dollars) OVER() AS DECIMAL(5,2)) * 100 AS "Percent by Amount"  
FROM cte  
order by 3 desc;

-- 5 -- 
-- By firm age
-- when firm age < 1 or firm age <5 : focuing on startups. 
-- Total number of firms and firm entry rate by sector in 2019

USE Yproject;

SELECT *
FROM bds2019_sec_fa;


SELECT A.sector, A.YEAR, A.fage, B.sector, AVG(firms), AVG(estabs_entry_rate), AVG(estabs_exit_rate)
FROM bds2019_sec_fa A 
INNER JOIN bds_sector B
ON A.sector = B.naics_code
WHERE fage ="b) 1" 
GROUP BY A.sector, A.year;






-- Average entry rate by State in year 2019
Select A.year, A.st, B.geo_name,
	   AVG(A.estabs_entry) as tot_entry, 
	   AVG(A.estabs_exit) as tot_exit
FROM bds_st A
INNER JOIN geo_codes_description B
ON A.st = B.st
WHERE year = 2019
GROUP BY A.st
ORDER BY 4 DESC; -- TO SEE EXIT : 5

-- > ENTRY TOP3: California, Florida, Texas
-- > ENTRY BOTTOM3: Vermont, Alaska, North Dakota. 
-- > EXIT TOP3: California, Florida, Texas
-- > EXIT BOTTOM3: Vermont, Alaska, North Dakota. 