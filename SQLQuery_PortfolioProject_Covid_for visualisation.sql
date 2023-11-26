
Queries used for Tableau Project


-- 1. 

SELECT
  SUM(d.new_cases) AS total_cases
 ,SUM(cast(d.new_deaths AS INT)) AS total_deaths
 ,SUM(cast(d.new_deaths AS int))/SUM(New_Cases)*100 AS DeathPercentage

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE d.continent IS NOT NULL

ORDER BY 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent

SELECT
 location
 ,SUM(cast(new_deaths AS INT)) AS TotalDeathCount

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE 
d.continent IS NOT NULL
AND d.location NOT IN ('World', 'European Union', 'International')

GROUP BY d.location
ORDER BY TotalDeathCount DESC


-- 3.

SELECT
 d.location
,d.population
,MAX(d.total_cases) AS HighestInfectionCount
,MAX((d.total_cases/d.population)*100) AS PersentPopulationInfected

FROM PortfolioProject.dbo.CovidDeaths AS d

GROUP BY
 d.location
,d.population

ORDER BY PersentPopulationInfected DESC



-- 4.
SELECT
 d.location
,d.population
,date
,MAX(d.total_cases) AS HighestInfectionCount
,MAX((d.total_cases/d.population)*100) AS PersentPopulationInfected

FROM PortfolioProject.dbo.CovidDeaths AS d

GROUP BY
 d.location
,d.population
,d.date

ORDER BY PersentPopulationInfected DESC
