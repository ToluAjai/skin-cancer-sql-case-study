# Skin Cancer SQL Analytics Project
This repository contains a full SQL analytics project exploring demographic, clinical, environmental, and lifestyle factors associated with skin cancer diagnoses. The project uses various SQL techniques like joins, WINDOW functions, CASE statements and CTEs to produce clean, reproducible insights.

Note: This project uses fully synthetic, non‑identifiable healthcare data created for learning and demonstration purposes. No real patient information is included.

# Objective
To identify key risk factors, diagnosis patterns, body regions affected, liefestyle influneces and opportunities for early detection improvement

# Dataset
Two PostgreSQL tables:
- table1: Patient information
- table2: Lesion information

The tables are connected through the 'patient_id' field
 
# Aspects analysed
Demographics:
- Age-group risk
- Gender distribution
- History of skin cancer
- Malignant diagnoses by body region

Lesions analysis:
- Lesion growth
- Symptom prevalence
- Biopsy counts
- Lesion diameter analysis

Environmental factors:
- Sanition access analysis
- Poor sanitation × severe diagnosis relationship

Lifesytle-related analysis:
- Smoking and drinking prevalence
- Diagnosis patterns among smokers/drinkers
- Risk ratio calculations

# SQL Techniques Used
- Common Table Expressions (CTEs)
- Joins
- CASE statements
- Aggregations
- WINDOW function
- Reusable logic modules

# Key Insights
- Middle‑aged adults and males show the highest diagnosis rates.
- The face is the most affected region across all diagnosis types.
- Actinic keratosis (ACK) is the most common diagnosis among all patients.
- Melanoma (MEL) has the largest average lesion diameter.
- Lifestyle factors (smoking & drinking) significantly increase the likelihood of severe diagnoses.
- Basal Cell Carcinoma (BCC) is the most common diagnosis among smokers and drinkers.
- Poor sanitation does not correlate strongly with severe outcomes.

# Tools Used
- PostgreSQL
- Power BI
- GitHub
