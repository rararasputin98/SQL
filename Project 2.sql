-- Explorotary Data Analysis
select * 
from layoffs_staging2 ;

-- select the company that had the most number of layoffs
select total_laid_off, company
from layoffs_staging2 
order by total_laid_off desc ;

-- select all companies that laid off all it's employees; in other words, companies that went under.
select *
from layoffs_staging2
where percentage_laid_off = 1 ;

-- now organize these companies based on "total laid off" from the highest to lowest 
select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc ;

-- I can use the "order by" on basically any column to obtain whatever info I may require

-- now organize these companies based on "funds raised millions" from the highest to lowest 
select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc ;

-- now organize these companies based on "stage"
select *
from layoffs_staging2
where percentage_laid_off = 1
order by stage ;

-- get the sum of "total laid off" for each company and organize it based on "sum total laid off" highest to lowest 
select sum(total_laid_off), company
from layoffs_staging2
group by company
order by sum(total_laid_off) desc ;

-- select the date range of which all these layovers happened during
select min(date), max(date)
from layoffs_staging2 ;
-- if this doesn't work, try using the back-ticks (`) for the dates

-- organize by "industry"
select sum(total_laid_off), industry
from layoffs_staging2
group by industry
order by sum(total_laid_off) desc ;

-- organize by country
select sum(total_laid_off), country
from layoffs_staging2
group by country
order by sum(total_laid_off) desc ;

-- organize by date

-- year
select sum(total_laid_off), year(date)
from layoffs_staging2
group by year(date)
order by sum(total_laid_off) desc ;

-- month
select sum(total_laid_off), month(date)
from layoffs_staging2
group by month(date)
order by sum(total_laid_off) desc ;

-- All March layoffs
select * 
from layoffs_staging2
where date like "_____03%" ;

-- month & year
select substring(date, 1,7) as date_new, sum(total_laid_off)
from layoffs_staging2
group by date_new
order by date_new asc
;

-- month & year rolling sum
with Rolling_Total as 
(
select substring(date, 1,7) as date_new, sum(total_laid_off) as total_off
from layoffs_staging2
group by date_new
order by date_new asc
)
select date_new, total_off,
sum(total_off) over(order by date_new) as rolling_total
from Rolling_Total
; 

-- organize by stage
select sum(total_laid_off), stage
from layoffs_staging2
group by stage
order by sum(total_laid_off) desc ;

-- Layoffs /year /company
select company, year(date), sum(total_laid_off)
from layoffs_staging2 
group by company, year(date)
order by sum(total_laid_off) desc ; 

-- Ranking the above
with Company_Year (company, years, total_laid_off) as
(
select company, year(date), sum(total_laid_off)
from layoffs_staging2 
group by company, year(date)
), Company_Year_Rank as
(
select *, 
dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null 
)
select *
from Company_Year_Rank
where Ranking <= 5 ;

select *
from layoffs_staging2 ;