/*
Covid 19 Data Exploration 
 Skills Used: Joins, CTE's, Temp Table, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
 
 */
 
 Select *
 from portfolioproject.coviddeaths1
 where continent is not null
 order by 3,4
 
 
 -- Select Data that we are going to be starting with
 
 Select location, date, total_cases, new_cases, total_deaths, population
 from portfolioproject.coviddeaths1
 where continent is not null 
 order by 1,2
 
 -- Total Cases vs Total Deaths
 -- Shows likelihood of dying if you contract covid in your country
 
 Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 from portfolioproject.coviddeaths1
 where location like '%states%'
 and continent is not null
 order by 1,2

-- Total Cases vs Population 
-- Shows what percentage of population infected with Covid

Select location,date, population, total_cases, (total_cases/population)*100 as PopulationPercentageInfected
from portfolioproject.coviddeaths1
order by 1,2

-- Countries with Highest Infection Rate Compared to Population

Select location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from portfolioproject.coviddeaths1
group by location, population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from portfolioproject.coviddeaths1
where continent is not null 
group by Location
order by TotalDeathCount desc

-- BREAKING DOWN THINGS BY CONTINENT

-- Showing Continents with the highest death count per population
-- SQL using INT
Select Continent, 
MAX(CAST(Total_deaths as INT)) as TotalDeathCount
from portfolioproject.coviddeaths1
where continent is not null
group by Continent
order by TotalDeathCount desc


-- MySQL using INT as SIGNED/UNSIGNED
Select Continent, 
MAX(CAST(Total_deaths as signed)) as TotalDeathCount
from portfolioproject.coviddeaths1
where continent is not null
group by Continent
order by TotalDeathCount desc


 -- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as signed)) as total_deaths, 
SUM(cast(new_deaths as signed))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject.CovidDeaths1
where continent is not null 
order by 1,2




-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
SUM(CAST(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject.CovidDeaths1 deacoviddeaths1
Join PortfolioProject.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.CovidDeaths1 dea
Join PortfolioProject.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.CovidDeaths1 dea
Join PortfolioProject.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.CovidDeaths dea
Join PortfolioProject.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 






-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as signed)) as TotalDeathCount
From portfolioproject.coviddeaths1
Where continent is not null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



----
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolioproject.coviddeaths1
Group by Location, Population, date
order by PercentPopulationInfected desc
