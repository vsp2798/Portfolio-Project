/*

Covid 19 Data Exploration using PostgreSQL

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/
--------------------------------------------------------------------------------------------------------------------------------------------------
---- FEW MANDATORY EXPLORATION

SELECT *
FROM VACCINATIONS;


SELECT *
FROM COVIDDEATHS
WHERE CONTINENT IS NOT NULL
ORDER BY 3,4 

SELECT LOCATION1,
	DATE1,
	TOTAL_CASES,
	NEW_CASES,
	TOTAL_DEATHS,
	POPULATION
FROM COVIDDEATHS
WHERE CONTINENT IS NOT NULL
ORDER BY 1,2 

--------------------------------------------------------------------------------------------------------------------------------------------------

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
-- This query says that at the end of October that If you contract covid and live in Canada there is a 1.68 % chance of dying.

SELECT LOCATION1,
	DATE1,
	TOTAL_CASES,
	TOTAL_DEATHS,
	(TOTAL_DEATHS / TOTAL_CASES) * 100 AS DEATHPERCENTAGE
FROM COVIDDEATHS
WHERE LOCATION1 = 'Canada'
ORDER BY 1,
	2 DESC 

--------------------------------------------------------------------------------------------------------------------------------------------------

--This query tells the highest infection count and highest population infected in a country and its says that Montenegro has the highest infected popultation and canada ranks 94TH

SELECT LOCATION1,
	POPULATION,
	MAX(TOTAL_CASES) AS HIGHESTINFECTIONCOUNT,
	MAX((TOTAL_CASES / POPULATION)) * 100 AS PERCENTPOPULATIONINFECTED
FROM COVIDDEATHS
WHERE TOTAL_CASES IS NOT NULL
	AND POPULATION IS NOT NULL
	AND CONTINENT IS NOT NULL
GROUP BY LOCATION1,
	POPULATION
ORDER BY PERCENTPOPULATIONINFECTED DESC 

--------------------------------------------------------------------------------------------------------------------------------------------------

-- Countries with Highest Death Count per Population and it shows that Unites States has highest number of death counts among all countries

SELECT LOCATION1,
	MAX(TOTAL_DEATHS) AS TOTALDEATHCOUNT
FROM COVIDDEATHS
WHERE TOTAL_DEATHS IS NOT NULL AND CONTINENT IS NOT NULL
GROUP BY LOCATION1
ORDER BY TOTALDEATHCOUNT DESC 

--------------------------------------------------------------------------------------------------------------------------------------------------
 
-- GLOBAL NUMBERS AND PERCENTAGES
--- Death percentage till now

SELECT SUM(NEW_CASES) AS TOTAL_CASES,
	SUM(NEW_DEATHS) AS TOTAL_DEATHS,
	SUM(NEW_DEATHS) / SUM(NEW_CASES) * 100 AS DEATHPERCENTAGE
FROM COVIDDEATHS --Where location like '%states%'

WHERE NEW_CASES IS NOT NULL
AND CONTINENT IS NOT NULL 
--Group By date1
ORDER BY 1,2 

--------------------------------------------------------------------------------------------------------------------------------------------------
 
--- This query shows the number of vaccinations increasing each day in a country

SELECT CD.CONTINENT,
	CD.LOCATION1,
	CD.DATE1,
	CD.POPULATION,
	VC.NEW_VACCINATIONS,
	SUM(VC.NEW_VACCINATIONS) OVER (PARTITION BY CD.LOCATION1 ORDER BY CD.LOCATION1,CD.DATE1) AS ROLLINGPEOPLEVACCINATED

FROM COVIDDEATHS CD
JOIN VACCINATIONS VC ON CD.LOCATION1 = VC.LOCATION2
AND CD.DATE1 = VC.DATE2
WHERE CD.CONTINENT IS NOT NULL
ORDER BY 2,3 

--------------------------------------------------------------------------------------------------------------------------------------------------

-- Vaccinations in India till now
-- CTE is used. Also this query finds out that only 70% of population in India has been vaccinated as of Nov 1st 2021
 

WITH POPULATION_VS_VACCINATIONS (CONTINENT,LOCATION1,DATE1,POPULATION,NEW_VACCINATIONS,ROLLINGPEOPLEVACCINATED) AS
	
(
SELECT CD.CONTINENT,
       CD.LOCATION1,
       CD.DATE1,
       CD.POPULATION,
       VC.NEW_VACCINATIONS,
       SUM(VC.NEW_VACCINATIONS) OVER (PARTITION BY CD.LOCATION1 ORDER BY CD.LOCATION1, CD.DATE1) AS ROLLINGPEOPLEVACCINATED

FROM COVIDDEATHS CD
JOIN VACCINATIONS VC ON CD.LOCATION1 = VC.LOCATION2
AND CD.DATE1 = VC.DATE2
WHERE CD.CONTINENT IS NOT NULL
ORDER BY 2,3)

SELECT *,
	(ROLLINGPEOPLEVACCINATED / POPULATION) * 100 AS ROLLINGPEOPLEVACCINETEDPERCENTAGE
FROM POPULATION_VS_VACCINATIONS
WHERE LOCATION1 = 'India' 

--------------------------------------------------------------------------------------------------------------------------------------------------

--- TO CREATE VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW PERCENTPOPULATIONVACCINATED AS
SELECT CD.CONTINENT,
CD.LOCATION1,
CD.DATE1,
CD.POPULATION,
VC.NEW_VACCINATIONS,
SUM(VC.NEW_VACCINATIONS) OVER (PARTITION BY CD.LOCATION1 ORDER BY CD.LOCATION1, CD.DATE1) AS ROLLINGPEOPLEVACCINATED 
FROM COVIDDEATHS CD
JOIN VACCINATIONS VC ON CD.LOCATION1 = VC.LOCATION2
AND CD.DATE1 = VC.DATE2 WHERE CD.CONTINENT IS NOT NULL
ORDER BY 2,3
