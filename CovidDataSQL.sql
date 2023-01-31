--Lets create Database
create database CovidData

use CovidData 

select
	* 
From
	CovidData..CovidDeaths
where 
	continent is not null
order by 3,4


select 
	* 
From
	CovidData..CovidVaccination
where 
	continent is not null
order by 3,4 


--Select the data that we are going to use
Select 
	location,date,total_cases,new_cases,total_deaths,population
From
	CovidData..CovidDeaths
Where 
	location= 'India'
order by 1,2;

--Looking at  Date wise Total cases and Total Deaths 

Select 
	location,Date,total_cases,total_deaths,
	concat(round((total_deaths/total_cases)*100,2),'%') as DeathPercentage
From
	CovidData..CovidDeaths
where 
	location='India' 
Order by date;

--Looking at Total cases vs Population
--Shows what percentage of Population got Covid

select 
	location,date,population,total_cases,round((total_cases/population)*100,2) as PercentagePopulationInfected
From
	CovidData..CovidDeaths
where
location like '%India%'
Order by date;

--Looking at countries with highest infection rate compared to population
select
	location,population, max(total_cases) as HighestInfectionCount,max(round((total_cases/population)*100,2)) as PercentPopulationInfected
From
	CovidData..CovidDeaths
Group by location,population
order by PercentPopulationInfected desc

--Showing Countries with Highest death count 
select 
	location,sum(total_deaths) as TotalDeathCount
From
	CovidData..CovidDeaths
where 
	continent is not null
Group by location
order by TotalDeathCount desc

--Lets See Death count by Continent

select 
	continent,sum(total_deaths) as TotalDeathCount
From
	CovidData..CovidDeaths
where 
	continent is not null
Group by continent
order by TotalDeathCount desc

