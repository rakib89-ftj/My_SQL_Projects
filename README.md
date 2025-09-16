CREATE TABLE insurance (
    age INTEGER,
    sex VARCHAR(10),
    bmi DECIMAL(5,2),
    children INTEGER,
    smoker VARCHAR(3),
    region VARCHAR(20),
    charges DECIMAL(10,4)
);

SELECT * FROM insurance

--1. Write a SQL query to select all columns for patients who are female, smokers, and have charges greater than $10,000.

SELECT * FROM insurance
WHERE
	sex= 'female'
	and smoker= 'yes'
	and charges>10000
order  by charges DESC;

-- 2. Write a SQL query to find the age and charges for all patients in the 'northwest' region, ordered by age in descending order.

SELECT
	age,
	charges
FROM insurance
WHERE 
	region='northwest'
ORDER by age DESC

--3. Write a SQL query to calculate the average bmi for smokers and non-smokers. What is the difference in average bmi between the two groups?

SELECT * FROM insurance

SELECT
	smoker,
	ROUND(avg(bmi),2) as avg_bmi,
	(select round(avg(bmi),2) FROM insurance where smoker='yes')-(select round(avg(bmi),2) FROM insurance where smoker='no')
FROM insurance
GROUP by smoker

--4.Write a SQL query to determine the total number of patients and the average insurance charge for each region. The output should include the region, number_of_patients, and average_charge.

SELECT
	count(*) as total_number_of_patients,
	round(avg(charges),2) as avg_charges
from insurance
GROUP by region
order by avg_charges DESC

-- 5.Write a SQL query to identify the region with the highest average insurance charge for patients with 2 or more children.
SELECT 
    region,
    ROUND(AVG(charges), 2) as average_charge,
    COUNT(*) as patient_count
FROM insurance
WHERE children >= 2
GROUP BY region
ORDER BY average_charge DESC;

--6.Write a SQL query to find all patients who have insurance charges that are higher than the average charge for their respective region.

SELECT * from insurance

SELECT i.*
from insurance i
INNER join(
SELECT
	region,
	avg(charges) as region_avg_charge
from insurance
GROUP by region
) r on i.region = r.region
WHERE i.charges > r.region_avg_charge
order by i.region, i.charges DESC

--  7.Using a Common Table Expression (CTE), first, calculate the average bmi for each number of children (0, 1, 2, etc.). Then, join this back to the original table to show each patient's bmi alongside the average bmi for their number of children.

SELECT * from insurance

WITH avg_bmi_by_children AS (
    SELECT 
        children,
        ROUND(AVG(bmi), 2) as avg_bmi_for_children_count
    FROM insurance
    GROUP BY children
)
SELECT 
    i.*,
    ab.avg_bmi_for_children_count,
    ROUND(i.bmi - ab.avg_bmi_for_children_count, 2) as bmi_difference_from_avg
FROM insurance i
INNER JOIN avg_bmi_by_children ab ON i.children = ab.children
ORDER BY i.children, i.bmi DESC;

--8.Write a SQL query to rank patients within each region based on their charges in descending order, without skipping ranks for ties. Also, include the patient's age and sex.

SELECT * from insurance

SELECT 
    region,
    age,
    sex,
    charges,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY charges DESC) as charge_rank
FROM insurance
ORDER BY region, charge_rank, charges DESC;
