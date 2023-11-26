-- Exproting the data
SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3,4

SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
ORDER BY 3,4



-- Looking at Total Cases vs Total Deaths
SELECT
 d.location
,d.date
,d.new_cases
,d.total_cases
,d.total_deaths
,d.population

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE d.continent IS NOT NULL

ORDER BY 1,2



-- Looking at Total Cases vs Total Deaths in Russia
SELECT
 d.location
,d.date
,d.total_cases
,d.total_deaths
,(d.total_deaths/d.total_cases)*100 AS DeathPercentage

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE 
d.location = 'Russia'
AND d.continent IS NOT NULL

ORDER BY 1,2



-- Showing likelihood of dying of Covid if you contract Covid in Russia
SELECT
 d.location
,d.date
,d.total_cases
,d.total_deaths
,(d.total_deaths/d.total_cases)*100 AS DeathPercentage

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE 
d.location = 'Russia'
AND d.continent IS NOT NULL

ORDER BY 1,2



-- Looking at Total Cases vs Population
-- Shows what percentage of population in Russia got Covid
SELECT
 d.location
,d.date
,d.population
,d.total_cases
,(d.total_cases/d.population)*100 AS PersentPopulationInfected

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE 
d.location = 'Russia'
AND d.continent IS NOT NULL

ORDER BY 1,2



-- Looking at Countries with the Highest Infection Rate compared to Population
SELECT
 d.location
,d.population
,MAX(d.total_cases) AS HighestInfectionCount
,MAX((d.total_cases/d.population)*100) AS PersentPopulationInfected

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE d.continent IS NOT NULL

GROUP BY
 d.location
,d.population

ORDER BY PersentPopulationInfected DESC



-- Looking at Countries with the Highest Death Count
SELECT
 d.location
,MAX(cast(d.total_deaths AS int)) AS TotalDeathCount

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE d.continent IS NOT NULL

GROUP BY d.location

ORDER BY TotalDeathCount DESC


-- Looking at the Death Count By Continent
SELECT
 d.location
,MAX(cast(d.total_deaths AS int)) AS TotalDeathCount

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE d.continent IS NULL

GROUP BY d.location

ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS
SELECT
 SUM(d.new_cases) AS TotalCases
,SUM(cast(d.new_deaths as INT)) AS TotalDeaths
,SUM(cast(d.new_deaths as INT))/SUM(d.new_cases) *100 AS DeathPercentage

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE d.continent IS NOT NULL

ORDER BY 1,2



-- Looking at Total Population vs Vaccinations (using CTE)
WITH PopvsVac (Cotntinent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS (
SELECT
 d.continent
,d.location
,d.date
,d.population
,v.new_vaccinations
,SUM(CONVERT(INT,v.new_vaccinations)) OVER (Partition by d.location Order By d.location, d.date) AS RollingPeopleVaccinated

FROM
PortfolioProject.dbo.CovidDeaths AS d
JOIN PortfolioProject.dbo.CovidVaccinations AS v 
	ON d.location = v.location
	AND d.date = v.date

WHERE d.continent IS NOT NULL
)

SELECT * , (RollingPeopleVaccinated/Population)*100 AS PercentagePeopleVaccinated
FROM PopvsVac 



-- Looking at Total Population vs Vaccinations (using Temp Table)
DROP table if exists #PercentPopulationVaccinated
CREATE table #PercentPopulationVaccinated
(
 Continent nvarchar(255)
,Location nvarchar(255)
,Date datetime
,Population numeric
,New_vaccinations numeric
, RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated

SELECT
 d.continent
,d.location
,d.date
,d.population
,v.new_vaccinations
,SUM(CONVERT(INT,v.new_vaccinations)) OVER (Partition by d.location Order By d.location, d.date) AS RollingPeopleVaccinated

FROM
PortfolioProject.dbo.CovidDeaths AS d
JOIN PortfolioProject.dbo.CovidVaccinations AS v 
	ON d.location = v.location
	AND d.date = v.date

WHERE d.continent IS NOT NULL

SELECT * , (RollingPeopleVaccinated/Population)*100 AS PercentagePeopleVaccinated
FROM #PercentPopulationVaccinated



-- Creating View to store data for later visualizations - Total Population vs Vaccinations
CREATE View PercentPopulationVaccinated AS
SELECT
 d.continent
,d.location
,d.date
,d.population
,v.new_vaccinations
,SUM(CONVERT(INT,v.new_vaccinations)) OVER (Partition by d.location Order By d.location, d.date) AS RollingPeopleVaccinated

FROM
PortfolioProject.dbo.CovidDeaths AS d
JOIN PortfolioProject.dbo.CovidVaccinations AS v 
	ON d.location = v.location
	AND d.date = v.date

WHERE d.continent IS NOT NULL


SELECT *
FROM PercentPopulationVaccinated


-- Creating View to store data for later visualizations - Death Count By Continent
CREATE View DeathCountByContinent AS
SELECT
 d.location
,MAX(cast(d.total_deaths AS int)) AS TotalDeathCount

FROM PortfolioProject.dbo.CovidDeaths AS d

WHERE d.continent IS NULL

GROUP BY d.location