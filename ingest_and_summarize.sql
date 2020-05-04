DROP TABLE IF EXISTS daily_county_cumulative;
.mode csv
.import "data/us-counties.csv" daily_county_cumulative


-- Lookup table so we can normalize a bit
DROP TABLE IF EXISTS state_county_fips;
CREATE TABLE state_county_fips AS
  SELECT DISTINCT county, state, fips FROM daily_county_cumulative;


-- Lookup table for rolling 7 day week periods
DROP TABLE IF EXISTS weeks;
CREATE TABLE weeks (date date, week date);
with weeks as (select distinct date from daily_county_cumulative t join 
  (select strftime('%w', date(max(date), '-6 day')) as d from daily_county_cumulative) as t
  on strftime('%w', date) = t.d
)
INSERT INTO weeks
select distinct daily_county_cumulative.date, weeks.date as week 
  from weeks join daily_county_cumulative 
    on weeks.date <= daily_county_cumulative.date
    and julianday(weeks.date) >= julianday(daily_county_cumulative.date) - 6;


-- Rollup data by week. Numbers are cumulative, so we can just take the max
DROP TABLE IF EXISTS weekly_county_cumulative;
CREATE TABLE weekly_county_cumulative (week date, fips integer, cases integer, deaths integer);
INSERT INTO weekly_county_cumulative
  select w.week, d.fips, max(d.cases), max(d.deaths)
  FROM daily_county_cumulative d
  JOIN weeks w
  ON d.date = w.date
  GROUP BY 1,2
;

-- Table for new cases by week
DROP TABLE IF EXISTS weekly_county;
CREATE TABLE weekly_county AS
SELECT t1.week, t1.fips, t1.cases - t2.cases as cases, t1.deaths - t2.deaths as deaths
FROM weekly_county_cumulative t1 JOIN weekly_county_cumulative t2 ON
  t1.fips = t2.fips AND date(t1.week, '-7 day') = t2.week;


DROP TABLE IF EXISTS population_estimates_raw;
.import "data/co-est2019-alldata.csv" population_estimates_raw

DROP TABLE IF EXISTS census_populations;
CREATE TABLE census_populations AS SELECT state || county as fips, CENSUS2010POP from population_estimates_raw;
