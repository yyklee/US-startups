
-- View: 
USE yproject;
SELECT *
FROM sec_fa;
SELECT *
FROM st_sec;
SELECT *
FROM st_fa;


-- 1 ---
-- startups across states (fage < 1) in 1978 - 2019 
SELECT st_name, year, avg(firms)
FROM st_fa
WHERE fage = 'a) 0'
GROUP BY st_name, year
ORDER BY 3 DESC, 2 DESC
; 

-- startups across states (fage < 1) in 2019 
SELECT st_name, avg(firms)
FROM st_fa
WHERE fage = 'a) 0' and year = 2019
GROUP BY st_name
ORDER BY 2 DESC
; 


-- 2 ---
-- California vs. Vermont
SELECT firms, sector_name
FROM st_sec 
WHERE year = 2019 and st_name = "Vermont"
GROUP BY sector_name
ORDER BY 1 DESC
;
SELECT firms, sector_name
FROM st_sec 
WHERE year = 2019 and st_name = "California"
GROUP BY sector_name
ORDER BY 1 DESC
;


-- 3 -- 
-- startup sectors in us economy whole
-- Average number of startups by sector (2015-2019) , startup = firmage < 1
SELECT sector, sector_name, AVG(firms)
FROM sec_fa
WHERE year between 2015 and 2019 and fage = 'a) 0'
GROUP BY sector
ORDER BY sector;


-- 4 --
-- Job creation and destruction by fage
Select fage, 
	   AVG(job_creation) as job_creation_avg, 
	   AVG(job_destruction) as job_destruction_avg
FROM sec_fa
GROUP BY fage
ORDER BY 2 DESC;

-- Job Creation and Destruction Average by sector in 2019

Select year, sector, 
	   AVG(job_creation) as job_creation_avg, 
	   AVG(job_destruction) as job_destruction_avg
FROM sec_fa
WHERE year = 2019
GROUP BY fage
ORDER BY year, sector;


-- 5--
-- Average number of firms (2015-2019) by firm age
SELECT year, fage, AVG(firms)
FROM sec_fa
WHERE year between 2015 and 2019 
GROUP BY year, fage
ORDER BY 1, 2;


-- Extra: Explore Entrepreneurial activity & Firm Deaths
-- Average entry rate by State in year 2019
Select year, st, st_name,
	   AVG(estabs_entry) as tot_entry, 
	   AVG(estabs_exit) as tot_exit
FROM st_sec
WHERE year = 2019
GROUP BY st
ORDER BY 4 DESC; 

-- Summary of 2019 firms vs. establishment by sector
SELECT sector, sector_name, AVG(estabs), AVG(firms)
FROM st_sec
WHERE year = 2019
GROUP BY sector
ORDER BY 4 DESC; 


-- Firm Death by state and year 
Select year, st_name,
	   AVG(firmdeath_firms) as firmdeath 
FROM st_sec
WHERE year > 2000
GROUP BY year, st
ORDER BY year, st;

-- Firm Death in 2019 
Select year, st_name,
	   AVG(firmdeath_firms) as firmdeath 
FROM st_sec
WHERE year = 2019
GROUP BY year, st
ORDER BY year, st;






