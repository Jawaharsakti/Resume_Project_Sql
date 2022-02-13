
--Death percentage if infected with covid in india during Third_wave
select continent, location, date, total_deaths, total_cases, round(((total_deaths/total_cases)*100),2) as death_percentage_if_infected_in_Third_wave
from dbo.covid_deaths
where location = 'India'
and date between '2022-01-01' and '2022-02-04' 


--Possibility of death by covid-19 during third wave in india
select continent, location, date, population, total_cases, round(((total_deaths/population)*100),3) as covid_death_by_population_in_Third_wave
from dbo.covid_deaths
where location = 'India'
and date between '2022-01-01' and '2022-02-04'

--possibilty of contracting covid 19 in each country 
select location, population, max(total_cases) as Maximum_infected_count , max(round(((total_cases/population)*100),3)) as Possibility_of_contracting_covid19_in_each_country
from dbo.covid_deaths
group by location, population
order by Possibility_of_contracting_covid19_in_each_country desc

-- maximum death count by country
select location, max(cast(total_deaths as int)) as maximum_death_count
from dbo.covid_deaths
where continent is not null
group by location
order by 2 desc

--Worldwide Total death percentage due to covid
select sum(new_cases) as Total_case,sum(cast (new_deaths as int)) as Total_deaths, round((sum(cast(new_deaths as int))/max(ISNULL(total_cases, 0))*100),2) as death_percentage
 from dbo.covid_deaths
 where location = 'world'

--Worldwide Total death percentage due to covid each day
 select date, sum(new_cases) as Total_case,sum(cast (new_deaths as int)) as Total_deaths, round((sum(cast(new_deaths as int))/max(ISNULL(total_cases, 0))*100),2) as death_percentage
 from dbo.covid_deaths
 where location = 'world'
 group by date

 --percentage of vaccination
 select d.location, d.date,d.population, v.people_fully_vaccinated, round((v.people_fully_vaccinated/d.population)*100,3) as percentage_of_vaccination
 from dbo.covid_deaths d
 join dbo.covid_vaccinations v
 on d.location = v.location
 and d.date = v.date
 where d.continent is not null
 order by 1,2,3

 --percentage of people with boosters injected
 select d.location, d.date, v.total_boosters, d.population, round((v.total_boosters/d.population)*100,2) as booster_percentage
  from dbo.covid_deaths d
 join dbo.covid_vaccinations v
 on d.location = v.location
 and d.date = v.date
 where d.continent is not null
 order by 1,2,3


 --rolling total of new vaccinations in each country
 With cte_total_doses_each_day (location,date,population,new_vaccinations,total_vaccinations_each_day) 
 as (
 select d.location,d.date, d.population, v.new_vaccinations , sum(convert(bigint,new_vaccinations)) over (partition by d.location order by d.location
 , d.date) as total_doses_each_day
 from dbo.covid_deaths d
 join dbo.covid_vaccinations v
 on d.location = v.location
 and d.date = v.date
 where d.continent is not null
     )
select *, (total_vaccinations_each_day/population) as percentage_of_doses_by_population from cte_total_doses_each_day


--latest total_cases_per_million
 select location,total_cases_per_million 
 from dbo.Covid_deaths 
 where date = ( select max(date) from dbo.Covid_deaths)
 order by 1
 --three months before
 select location,total_cases_per_million 
 from dbo.Covid_deaths 
 where date = ( select dateadd(month,-3,max(date)) from dbo.Covid_deaths)
 order by 1
 --one year before
 select location,total_cases_per_million 
 from dbo.Covid_deaths 
 where date = ( select dateadd(YEAR,-1,max(date)) from dbo.Covid_deaths)
 order by 1

 --creating index
 create index vaccination_index on dbo.covid_vaccinations (location, people_fully_vaccinated_per_hundred)
 select * from vaccination_index
 --Creating views
 create view death_percentage_if_infected_in_Third_wave as
select continent, location, date, total_deaths, total_cases, round(((total_deaths/total_cases)*100),2) as death_percentage_if_infected_in_Third_wave
from dbo.covid_deaths
where location = 'India'
and date between '2022-01-01' and '2022-02-04' 

create view covid_death_by_population_in_Third_wave as
select continent, location, date, population, total_cases, round(((total_deaths/population)*100),3) as covid_death_by_population_in_Third_wave
from dbo.covid_deaths
where location = 'India'
and date between '2022-01-01' and '2022-02-04'


select * from dbo.Covid_deaths
select * from dbo.covid_vaccinations