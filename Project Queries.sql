-- Task 1: Patient Demographic Risk Analysis
-- Goal: Understand which demographic groups are most affected by skin cancer conditions.

-- Which age group has the highest number of skin cancer diagnoses?
WITH age_groups AS (
    SELECT 
        t1.patient_id,
        CASE
            WHEN age <= 17 THEN 'Children or Adolescents'
            WHEN age <= 34 THEN 'Young Adults'
            WHEN age <= 49 THEN 'Early Middle Aged'
            WHEN age <= 64 THEN 'Middle-Aged'
            WHEN age <= 79 THEN 'Older Adults'
            ELSE 'Very Old Adults'
        END AS age_group
    FROM table1 t1
)
SELECT 
    age_group,
    COUNT(*) AS number_of_diagnoses
FROM age_groups
JOIN table2 USING (patient_id)
GROUP BY age_group
ORDER BY number_of_diagnoses DESC; -- Middle-aged people have the highest

-- How many patients have a previous history of skin cancer?
SELECT COUNT(*) AS total_skin_cancer_patients
FROM table1
WHERE skin_cancer_history = true -- 224 patients have a history of skin cancer

-- What is the distribution of diagnoses between male and female patients?
SELECT 
    gender,
    COUNT(*) AS gender_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM table1
GROUP BY gender; -- 726 Males, 362 Females

-- Which body regions record the highest number of patients with malignant diagnoses?
SELECT region, COUNT(diagnostic) AS malignant_cases
FROM table2
WHERE diagnostic IN ('MEL', 'SCC', 'BCC') -- I have classed malignant diagnoses as MEL, SCC, BCC
GROUP BY 1
ORDER BY COUNT(diagnostic) DESC; -- The face experiences the highest number of malignant diagnoses


-- Task 2: Lesion Growth & Diagnosis Analysis
-- Goal: Analyse lesion characteristics and identify indicators of dangerous skin conditions.

-- Which diagnosis category appears most frequently?
SELECT diagnostic, COUNT(diagnostic) AS number_of_diagnoses
FROM table2
GROUP BY 1
ORDER BY number_of_diagnoses DESC; -- (ACK) actinic keratosis appears the most

-- How many lesions were reported as growing?
SELECT COUNT(*) AS lesions_that_grew
FROM table2
WHERE grew = true; -- 510 lesions

-- Which symptoms are most commonly associated with lesions?
SELECT 'Itching' AS Symptoms, SUM(CASE WHEN itch = true THEN 1 ELSE 0 END) AS frequency
FROM table2

UNION ALL

SELECT 'Growing', SUM(CASE WHEN grew = true THEN 1 ELSE 0 END)
FROM table2

UNION ALL

SELECT 'Pain', SUM(CASE WHEN hurt = true THEN 1 ELSE 0 END)
FROM table2

UNION ALL

SELECT 'Changed', SUM(CASE WHEN changed = true THEN 1 ELSE 0 END)
FROM table2

UNION ALL

SELECT 'Bleeding', SUM(CASE WHEN bleed = true THEN 1 ELSE 0 END)
FROM table2

UNION ALL

SELECT 'Elevation', SUM(CASE WHEN elevation = true THEN 1 ELSE 0 END)
FROM table2
ORDER BY frequency DESC; -- Most patients experience itching, elevation, and lesion growth

-- How many lesions were biopsied before diagnosis confirmation?
SELECT COUNT(*) AS no_of_biopsies
FROM table2
WHERE biopsed = true; -- 458 lesions

-- Which diagnosis type has the highest average lesion diameter?
SELECT diagnostic, AVG(diameter_1 + diameter_2) :: decimal(10,2) AS average_diameter
FROM table2
GROUP BY 1
ORDER BY average_diameter DESC; -- MEL (Melanoma) has the highest average lesion diameter



--Task 3: Environmental Condition Analysis
--Goal: Understand how environmental conditions influence diagnosis patterns.

-- Which body region has the highest number of diagnosed cases?
SELECT region, COUNT(*) AS total_diagnoses
FROM table2
GROUP BY 1
ORDER BY total_diagnoses DESC; -- The face has the overall highest diagnosed cases

-- How many patients lack access to piped water?
SELECT COUNT(patient_id) AS patients_with_no_piped_water
FROM table1
WHERE has_piped_water = false -- 782 patients had no access to piped water

-- How many patients do not have access to sewage systems?
SELECT COUNT(patient_id) AS patients_with_no_sewage_system
FROM table1
WHERE has_sewage_system = false -- 815 patients had no sewage system

-- No access to either of the two
SELECT COUNT(patient_id) AS patients_with_no_sewage_system
FROM table1
WHERE has_sewage_system = false AND has_piped_water = false

-- Which body regions report the highest number of biopsied lesions?
SELECT region, COUNT(*) AS no_of_biopsies
FROM table2
WHERE biopsed = true
GROUP BY 1
ORDER BY no_of_biopsies DESC; -- The face again

-- Is there a relationship between poor sanitation access and severe diagnosis outcomes?
-- Severe diagnoses include MEL, SCC, and BCC

/*SELECT COUNT(diagnostic) AS number_of_malignant_diagnoses
FROM table2
WHERE diagnostic IN ('MEL', 'SCC', 'BCC') -- 346*/

SELECT 
    poor_sanitation,
    severe_diagnosis,
    COUNT(*) AS number_of_cases
FROM (
    SELECT 
        t1.patient_id,
        CASE 
            WHEN has_piped_water = false AND has_sewage_system = false THEN 1
            ELSE 0
        END AS poor_sanitation,
        CASE 
            WHEN diagnostic IN ('MEL', 'SCC', 'BCC') THEN 1
            ELSE 0
        END AS severe_diagnosis
    FROM table1 t1
    JOIN table2 t2
        ON t1.patient_id = t2.patient_id
) AS combined
GROUP BY poor_sanitation, severe_diagnosis
ORDER BY poor_sanitation, severe_diagnosis; /* Out of the 1088 patients, only 142(17%) had severe diagnoses and poor sanitation conditions.
Based on these numbers, poor sanitation is not associated with more severe skin cancer. */


-- Task 4: Lifestyle & Behavioral Risk Analysis
-- Goal: To understand how lifestyle choices contribute to cancer conditions

-- How many patients smoke, drink and do both?
SELECT 
    COUNT(*) FILTER (WHERE smoke = true) AS smokers,
    COUNT(*) FILTER (WHERE drink = true) AS drinkers,
    COUNT(*) FILTER (WHERE smoke = true AND drink = true) AS both
FROM table1;

-- Most common diagnosis?
CREATE TEMP TABLE lifestyle AS (
    SELECT 
        t1.patient_id,
        smoke,
        drink,
        t2.diagnostic
    FROM table1 t1
    JOIN table2 t2 USING (patient_id)
);
-- Among smokers
SELECT diagnostic, COUNT(*) AS cases
FROM lifestyle
WHERE smoke = TRUE
GROUP BY diagnostic
ORDER BY cases DESC; -- According to the dataset, the most common diagnosis among smokers is BCC (basal cell carcinoma)

-- Among drinkers
SELECT diagnostic, COUNT(*) AS cases
FROM lifestyle
WHERE drink = TRUE
GROUP BY diagnostic
ORDER BY cases DESC; -- BCC

-- Among both drinkers and smokers
SELECT diagnostic, COUNT(*) AS cases
FROM lifestyle
WHERE smoke = TRUE AND drink = true
GROUP BY diagnostic
ORDER BY cases DESC; -- BCC

-- What percentage of smokers also consume alcohol?
SELECT 
    COUNT(*) FILTER (WHERE smoke = TRUE) AS smokers,
    COUNT(*) FILTER (WHERE smoke = TRUE AND drink = TRUE) AS smokers_who_drink,
    ROUND(
        COUNT(*) FILTER (WHERE smoke = TRUE AND drink = TRUE) * 100.0
        / NULLIF(COUNT(*) FILTER (WHERE smoke = TRUE), 0), 
    2) AS pct_smokers_who_drink
FROM table1;

-- Are patients who both smoke and drink more likely to develop malignant conditions?
SELECT 
COUNT(*) AS smokers_and_drinkers_with_malignant_conditions 
FROM 
(SELECT newtable.patients_who_smoke_and_drink, COUNT(CASE WHEN diagnostic IN ('MEL', 'SCC', 'BCC') THEN 1 END ) AS has_malignant_condition
FROM (SELECT patient_id AS patients_who_smoke_and_drink
FROM table1
WHERE smoke = true AND drink = true) AS newtable -- A total of 28 patients smoke and drink
JOIN table2
ON newtable.patients_who_smoke_and_drink= table2.patient_id
GROUP BY newtable.patients_who_smoke_and_drink
HAVING COUNT(CASE WHEN diagnostic IN ('MEL', 'SCC', 'BCC') THEN 1 END )= 1)
/*23 of the 28 patients (82%) have developed a malignant condition
Based on those numbers, it seems likely that patients who both smoke and drink are likely to develop malignant conditions*/


-- Which lifestyle factor has the strongest relationship with severe diagnosis outcomes?
-- Severe outcomes have been classified as MEL, SCC, and BCC
SELECT smoke,
       COUNT(*) AS total,
       COUNT(CASE WHEN diagnostic IN ('MEL','SCC','BCC') THEN 1 END) AS severe
FROM table1
JOIN table2 USING (patient_id)
GROUP BY smoke;
/* To find out the relationship between smoking and severe diagnosis, I did a Risk Ratio analysis.
Smokers with severe diagnosis: 47/62 = 0.758
Non-smokers with severe diagnosis: 299/1026 = 0.291
Risk ratio = 0.758 / 0.291 = 2.60
Therefore, from this analysis, Smokers are 2.6× more likely to develop a severe diagnosis than non‑smokers. */
SELECT drink,
       COUNT(*) AS total,
       COUNT(CASE WHEN diagnostic IN ('MEL','SCC','BCC') THEN 1 END) AS severe
FROM table1
JOIN table2 USING (patient_id)
GROUP BY drink;
/* To find out the relationship between smoking and severe diagnosis, I did a Risk Ratio analysis.
Drinkers with severe diagnosis: 98/138 = 0.710
Non-drinkers with severe diagnosis: 248/950 = 0.261
Risk ratio = 0.710 / 0.261 = 2.72
Therefore, from this analysis, Drinkers are 2.72× more likely to develop a severe diagnosis than non‑drinkers. */

-- Overall, from this dataset, Drinking has a slightly stronger relationship with severe diagnosis outcomes than smoking in your dataset.

