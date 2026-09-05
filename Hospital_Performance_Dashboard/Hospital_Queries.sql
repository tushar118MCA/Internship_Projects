SELECT * FROM public.visits
SELECT * FROM public.patients
SELECT * FROM public.doctors

-- 1. What are the 5 most common diagnoses across all visits 

SELECT "Diagnosis" , COUNT(*) AS number_of_cases
FROM visits
GROUP BY "Diagnosis"
ORDER BY number_of_cases DESC
LIMIT 5;

-- 2. Which visits involved Critical-severity patients 

SELECT "Visit_ID", "Patient_ID", "Department", "Diagnosis", "Treatment_Cost_USD", "Outcome"
FROM visits
WHERE "Severity_Level" = 'Critical'
LIMIT 10;

-- 3. Which department handles the most visits

select "Department",count (*) as Most_Visits
from visits 
group by "Department"
Order by Most_Visits DESC;


-- 4. Which department has the highest average treatment cost

Select "Department",AVG("Treatment_Cost_USD") AS Average_Cost
from visits
group by "Department"
Order by Average_Cost DESC;


-- 5. Which patient age group costs the most, on average, to treat

select p."Age_Group", AVG(v."Treatment_Cost_USD") as Avg_Cost_USD,Count(*) as visits
from visits v 
join patients p on v."Patient_ID" = p."Patient_ID"
group by "Age_Group"
order by Avg_Cost_USD DESC;

-- 6 Who are the 5 busiest doctors by number of patients treated?

select "Doctor_ID","Total_Patients_Treated","Avg_Treatment_Cost_USD","Readmission_Rate_Pct"
from doctors
order by "Total_Patients_Treated" DESC
LIMIT 5;

-- 7. Which patients are older than the hospital's average patient age

select "Patient_ID", "Age", "Gender", "Age_Group"
FROM patients
WHERE "Age" > (SELECT AVG("Age") FROM patients)
ORDER BY "Age" DESC
LIMIT 10;


-- 8. Which departments cost more than the hospital-wide average to treat in

SELECT "Department", AVG("Treatment_Cost_USD") AS avg_cost_usd
FROM visits
GROUP BY "Department"
HAVING AVG("Treatment_Cost_USD") > (SELECT AVG("Treatment_Cost_USD") FROM visits)
ORDER BY avg_cost_usd DESC;


-- 9. What was the single most expensive visit in each department

SELECT "Department", "Visit_ID", "Treatment_Cost_USD", rnk
FROM (
    SELECT "Department", "Visit_ID", "Treatment_Cost_USD",
           RANK() OVER (PARTITION BY "Department" ORDER BY "Treatment_Cost_USD" DESC) AS rnk
    FROM visits
) ranked
WHERE rnk = 1


-- 10. What is the complete record (patient + doctor + visit) for one specific patient

SELECT p."Patient_ID", p."Age", p."Gender", v."Department", v."Diagnosis", v."Doctor_ID",
       d."Total_Patients_Treated" AS doctor_total_patients, v."Treatment_Cost_USD", v."Outcome"
FROM visits v
JOIN patients p ON v."Patient_ID" = p."Patient_ID"
JOIN doctors d ON v."Doctor_ID" = d."Doctor_ID"
WHERE p."Patient_ID" = (SELECT "Patient_ID" FROM patients LIMIT 1);


-- 11. How many visits fall into Low/Medium/High cost tiers, and what's the average cost per tier

SELECT
    CASE
        WHEN "Treatment_Cost_USD" < 1000 THEN 'Low (<$1000)'
        WHEN "Treatment_Cost_USD" BETWEEN 1000 AND 5000 THEN 'Medium ($1000-$5000)'
        ELSE 'High (>$5000)'
    END AS cost_tier,
    COUNT(*) AS num_visits,
    AVG("Treatment_Cost_USD") AS avg_cost
FROM visits
GROUP BY cost_tier
ORDER BY avg_cost;


-- 12. Which insurance type has the highest readmission rate

SELECT "Insurance_Type",
       COUNT(*) AS total_visits,
       100.0 * SUM("Readmission_Flag") / COUNT(*) AS readmission_rate_pct
FROM visits
GROUP BY "Insurance_Type"
ORDER BY readmission_rate_pct DESC;


-- 13. What are the 5 most common diagnoses across all visits

SELECT "Diagnosis", COUNT(*) AS num_cases
FROM visits
GROUP BY "Diagnosis"
ORDER BY num_cases DESC
LIMIT 5;

-- 14. Which doctors have an above-average readmission rate


SELECT d."Doctor_ID", d."Readmission_Rate_Pct"
FROM doctors d, (SELECT AVG("Readmission_Rate_Pct") AS avg_rate FROM doctors) t
WHERE d."Readmission_Rate_Pct" > t.avg_rate
ORDER BY d."Readmission_Rate_Pct" DESC
LIMIT 10;