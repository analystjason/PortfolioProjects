select *
from PortofolioProject..CovidDeaths
Where continent is not null
order by 3,4

--select *
--from PortofolioProject..covid_vacinnation
--order by 3,4

-- Select Data that we are going to be using

select location,date,total_cases,new_cases,total_deaths,population
from PortofolioProject..CovidDeaths
Where continent is not null
order by 1,2

-- Loooking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
Where location like '%nigeria%'
and continent is not null
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid
select location, date, Population, total_cases, (Total_deaths/Population)*100 as Percentofpopulation
from PortofolioProject..CovidDeaths
--Where location like '%nigeria%'
order by 1,2

--Looking at Counties withHighest Infection Rate Compared to Population
select continent,  Population, MAX(total_cases) as HighestInfectCount, MAX(total_cases/Population)*100 as PercentofPopulationInfected
from PortofolioProject..CovidDeaths
--Where location like '%nigeria%'
Group by continent,population
order by PercentofPopulationInfected desc



-- Showing the counties with the highest death count per population
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortofolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is not null
Group by continent,population
order by TotalDeathCount desc



-- Let's break things down by continent


-- Showing the continent with the highest death count per population
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortofolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is not null
Group by continent
order by TotalDeathCount desc




-- Global Numbers

select sum(new_cases)as total_newcases,sum(cast( new_deaths as int))as total_newdeaths,sum(cast(new_deaths as int))/sum
	(new_cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is not null
--group by date
order by 1,2

select date ,sum(new_cases)as total_newcases,sum(cast( new_deaths as int))as total_newdeaths,sum(cast(new_deaths as int))/sum
	(new_cases)*100 as DeathPercentage

from PortofolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is not null
group by date
order by 1,2

--Looking at Total Population vs Vaccination


select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations ,SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
join PortofolioProject..covid_vacinnation vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--USE CTE
WITH PopvsVac (Continent,location,date,population,new_vaccination,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations ,SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
join PortofolioProject..covid_vacinnation vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select* , (RollingPeopleVaccinated/population)*100
from PopvsVac


-- TEMP TABLE

drop table if exists #PercentPopulationvaccinated
CREATE TABLE #PercentPopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations  numeric,
RollingPeopleVaccinated numeric
)


INSERT INTO  #PercentPopulationvaccinated
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations ,SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
join PortofolioProject..covid_vacinnation vac
	on dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select* , (RollingPeopleVaccinated/population)*100
from #PercentPopulationvaccinated


--Creating View to store data for later visualization


Create View PercenPopulationvaccinated as
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations ,SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
join PortofolioProject..covid_vacinnation vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3


select*
from PercenPopulationvaccinated
