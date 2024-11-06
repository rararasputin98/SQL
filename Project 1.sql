-- Data Cleaning

select *
from layoffs
;

-- 1. remove duplicates: 
-- 2. standardize the data
-- 3. Null values or Blank values
-- 4. remove any columns & rows

-- 1. remove duplicates: 

create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

select *,
row_number() over (
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

with duplicate_cte as
(
select *,
row_number() over (
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

-- now create a "layoffs_staging2" table and delete all the duplicates from that (always make sure the data I'm deleting is saved in a previous table/version - jic I need to access that info)
create table layoffs_staging2
like layoffs_staging;

insert layoffs_staging2
select *
from layoffs_staging;

select *
from layoffs_staging2;

-- now do a "partition by" again to figure out the duplicates
select *,
row_number() over (
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging2;

-- now delete the duplicates from "layoffs_staging2"
delete
from layoffs_staging2
where row_num > 1;

-- 2. standardize the data
select distinct(company)
from layoffs_staging2 ;

-- let's say there were spaces at the front of some company names - I can simply use the "trim" feature to get rid of those blanks 
select distinct(trim(company))
from layoffs_staging2 ;

-- This is just to compare the trim and non-trim 
select company, (trim(company))
from layoffs_staging2 ;

-- just a "distinct" function on the industry column to remove duplicates AND I have used an "order by" to sort all those industries (in this case ascending)
select distinct(industry)
from layoffs_staging2 
order by industry asc ;

-- let's say "crypto" was not duplicated however there are multiple naming conventions (e.g. crypto, Crypto, crypto currency, industry crypto) - now I will use a "like" clause to find out all possible outcomes for anything-crypto on the industry column
select *
from layoffs_staging2 
where industry like "%crypto%" ;

-- now to standardize all of the above varying naming conventions for "crypto"
update layoffs_staging2 
set industry = "Crypto"
where industry like "%crypto%" ;

-- Standardizing the "country" column
select *
from layoffs_staging2;

select distinct country
from layoffs_staging2
order by country asc ;

update layoffs_staging2
set country = "United States"
where country like "%United States%"
;

-- Let's say there's "United States" and "United States." in the country column - following is another way to trim the "." trailing in the duplicate
select distinct country, trim(trailing "." from country)
from layoffs_staging2
order by country asc ;

update layoffs_staging2
set country = trim(trailing "." from country)
where country like "%United States%" ;

-- changing the formats of columns | in this scenario, the "date" column is in text-format. I want to change it to date-format
select `date`
from layoffs_staging2;

select `date`,
str_to_date(`date`, "%m/%d/%Y")
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, "%m/%d/%Y") ; 

alter table layoffs_staging2
modify column `date` date ; 

-- 3. Null values or Blank values
-- To select just "null" values
select *
from layoffs_staging2
where percentage_laid_off is null ;

-- to select "blank" values
select *
from layoffs_staging2
where industry = "" ;

-- select both "null" and "blank" values
select *
from layoffs_staging2
where industry is null
or industry = "" ;

-- Populating "null" or "blank" values
-- I will first populate all "blank" values as "null"
update layoffs_staging2
set industry = "NULL"
where industry = "" ;

-- There was a problem with the data set (in the sense, for some reason, not all records were included when I downloaded the data set). So I'm gonna write the code as Alex wrote it.
-- The following code will make a join on the "company" column as on Alex's data set, there were more than one entry for each company except "Bally's Interactive". So the below code will create a join on the company column and fill out "t1's" null values on the "industry" column
select *
from layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
where t1.industry is null 
and t2.industry is not null ;

select *
from layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
    and t1.location = t2.location
where t1.industry is null 
and t2.industry is not null ;

Update layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
    and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null ;

-- 4. remove any columns & rows
select *
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null ;

-- rows
delete
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null ;

select *
from layoffs_staging2 ;

-- deleting a column: assume there is a column named "row_num" and I want to get rid of it.
alter table layoffs_staging2
drop column row_num ;