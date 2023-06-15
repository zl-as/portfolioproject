/*1.Find the Average age of employees in each department and gender group*/

SELECT gender, department, avg(age)as Average_Age 
FROM employee1 
GROUP by gender, department;
---------------------------------------------------------------------------------------------------------------------------------

/*2.List the top 3 departments with the highest average training scores.( round average scores up to two decima places if needed)*/
select department, round(avg(avg_training_score),2) as avg_training_score
from employee1
group by department
order by avg_training_score desc
limit 3;
 -------------------------------------------------------------------------------------------------------------------------------
 
 /*3. Find the percentage of employees who have won awards in each region.(round percentage up to two decimal places if needed).*/

select region, round(count(*) *100 /(select sum(awards_won) from employee1),2) as award_percentage
from employee1
where awards_won !=0
group by region;

-------------------------------------------------------------------------------------------------------------------------------
/*4.Show the number of employees who have met more than 80% of KPI for each recruitment channel and education level*/

select recruitment_channel, education, count(*) as employee_count 
from employee1 
where KPIs_met_more_than_80 =1 
group by recruitment_channel,education;

---------------------------------------------------------------------------------------------------------------------------------

/*5.Find the average length of service for employees in each department, considering only employees with previous year ratings greater than or equal to 4. (Round average length up to two decimal places if needed)*/

select department, round(avg(length_of_service),2) as average_length_of_service
from employee1
where previous_year_rating >= 4
group by department;

-----------------------------------------------------------------------------------------------------------------------------
/*6. List top 5 region with the highest average previous year ratings. (Round average ratings up to two decimal places if needed)*/

select region, round(avg(previous_year_rating),2) as average_previous_year_rating
from employee1
group by region
order by average_previous_year_rating  desc
limit 5;

-----------------------------------------------------------------------------------------------------------------------
/*7.List the departments with more than 100 employees having length of service greater  than 5 years.*/

select department, employee_count from
(
    select count(employee_id) as employee_count, department from employee1 where length_of_service >5
    group by department) L
where employee_count > 100;

----------------------------------------------------------------------------------------------------------------------------
/*8. Show the average length of service for employees who have attended more than 3 trainings, grouped by department and gender. (Round average up to two decimal places if needed)*/
select department, gender, round(avg(length_of_service),2)
from employee1
where no_of_trainings >3
group by department , gender;

-----------------------------------------------------------------------------------------------------------------------------
/*9. Find the percentage of female employees who have won award , per department.*/
/* Also show the number of female employees who won awards and total female employees. (Round percentage up to two decimal places if needed)*/

select department,
   count(*) as total_female_employees,
   count(case when awards_won>=1 Then 1 end) as female_award_winners,
   round((count(case when awards_won>=1 Then 1 end)*100.0 )/nullif(count(*),0),2) as percentage_femalewinners
from employee1
where gender="f"
group by department;

-------------------------------------------------------------------------------------------------

/*10. Calculate the percentage of employees per department who have a length of service between 5 and 10 years.*/
/*(Round percentage up to two decimal places if needed)*/

SELECT department, 
       ROUND(COUNT(CASE WHEN length_of_service BETWEEN 5 AND 10 THEN 1 END) / COUNT(*) * 100, 2) AS percentage 
FROM employee1
GROUP BY department;

---------------------------------------------------------------------------------------------------------------------------
/*11. Find the top 3 regions with the highest number of employees who have met more than 80% of their KPI’s */
/* and received at least one award, grouped by department and   region*/

select department, region,
       count(employee_id) as employee_count
from employee1 
where KPIs_met_more_than_80 = 1 and awards_won >0 
group by department, region
having (count(employee_id) > 0)
order by employee_count desc
limit 3;

-------------------------------------------------------------------------------------------------------------------------
/*12.Calculate the average length of service for employees per education level and gender, considering only those employees who have completed more than 2 trainings*/ 
/*and have an average training score greater than 75*/
/* ( Round average length up to two decimal places if needed)*/

select education, gender,
     round(avg(length_of_service),2) as avg_length_of_service
from employee1 
where no_of_trainings > 2 and avg_training_score > 75
group by education, gender;

-----------------------------------------------------------------------------------------------------------------------------

/*13. For each department and recruitment channel, find the total number of employees who have met more than 80% of their KPIs,
have a previous_year_rating of 5, and have a length of service greater than 10 years.*/

SELECT 
    department, 
    recruitment_channel, 
    COUNT(employee_id) AS total_employee_count 
FROM 
    employee1 
WHERE 
    KPIs_met_more_than_80 = 1 
    AND previous_year_rating = 5 
    AND length_of_service > 10 
GROUP BY 
    department, recruitment_channel;

------------------------------------------------------------------------------------------------------------------------

/*14. Calculate the percentage of employees in each department who have received awards, have a previous_year_rating of 4 or 5, 
and an average training score above 70, grouped by department and gender ( Round percentage up to two decimal places if needed)*/

SELECT 
    department, 
    gender, 
    ROUND((COUNT(CASE WHEN awards_won = 1 AND previous_year_rating IN (4,5) AND avg_training_score > 70 THEN 1 END) / COUNT(*)) * 100, 2) AS percentage_award_winners
FROM 
    employee1
GROUP BY 
    department, gender;
    
---------------------------------------------------------------------------------------------------------------------------------

/*15. List the top 5 recruitment channels with the highest average length of service for employees who have met more than 80% of their KPIs,
 have a previous_year_rating of 5, and an age between 25 and 45 years, grouped by department and recruitment channel. 
 ( Round average length up to two decimal places if needed).*/

SELECT 
    recruitment_channel, 
    department, 
    ROUND(AVG(length_of_service), 2) AS avg_length_of_service
FROM 
    employee1
WHERE 
    KPIs_met_more_than_80 = 1 AND previous_year_rating = 5 AND age BETWEEN 25 AND 45
GROUP BY 
    recruitment_channel, department
ORDER BY 
    avg_length_of_service DESC
LIMIT 5;




    









