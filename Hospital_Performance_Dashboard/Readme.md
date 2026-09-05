# 🏥 Hospital Performance & Patient Outcome Analytics Project

An end-to-end hospital analytics workflow — from raw data cleaning through exploratory data analysis, star-schema data modeling, DAX-based business querying, and two purpose-built Power BI dashboards covering both **operational performance** and **clinical patient outcomes**.

---

## 📁 Project Structure

```
Hospital_Performance_Dashboard/
├── doctors.csv                                    # Physician dimension table (500 rows)
├── patients.csv                                    # Patient dimension table (18,655 rows)
├── visits.csv                                      # Visit fact table (18,655 rows)
├── Data_Dictionary.csv                             # Column-level definitions & business relevance
├── Hospital_Data_Cleaning_Transformation.ipynb     # Notebook: data quality checks, cleaning, feature engineering
├── Hospital_Exploratory_Data_Analysis__EDA_.ipynb  # Notebook: EDA, visualizations, KPI derivation
├── Hospital_Performance_Dashboard.pbix             # Power BI file
├── Hospital_Performance_Patient_Outcome_Theme.json # Custom Power BI theme
├── Hospital_dashboard_image1.png                   # Screenshot
├── Hospital_dashboard_image2.png                   # Screenshot
└── README.md                                       # Project documentation (this file)
```

---

## 🧭 Project Workflow

```
Raw Data → Data Cleaning → EDA → Star Schema (Data Model) → DAX Analysis → Dashboard
```

1. **Data Cleaning & Transformation** (`Hospital_Data_Cleaning_Transformation.ipynb`)
2. **Exploratory Data Analysis** (`Hospital_Exploratory_Data_Analysis__EDA_.ipynb`)
3. **Data Modeling** — cleaned data structured into a star schema (`patients`, `doctors`, `visits`)
4. **Business Question Answerd**
5. **Dashboard** — Interactive dashboards

---

## 🧹 1. Data Cleaning & Transformation

Source: `doctors.csv` (500 rows), `patients.csv` (18,655 rows), `visits.csv` (18,655 rows, 17 columns)

**Steps performed:**
| Step | Description |
|---|---|
| Data Dictionary | Documented each column's type, description, and business relevance → `Data_Dictionary.csv` |
| Missing Values | Checked and quantified nulls across all columns in all three files — **none found** |
| Duplicate Records | Checked for duplicate `Visit_ID`, `Patient_ID`, and `Doctor_ID` — **none found** |
| Referential Integrity | Verified every `Patient_ID` / `Doctor_ID` in `visits.csv` resolves to a valid row in `patients.csv` / `doctors.csv` |
| Format Consistency | Reviewed categorical columns (`Department`, `Diagnosis`, `Severity_Level`, `Outcome`, `Insurance_Type`, `Gender`) for consistent spelling/casing and a fixed, valid category set |
| Data Type Validation | Confirmed numeric fields (`Treatment_Cost_USD`, `Length_of_Stay_Days`, `Wait_Time_Minutes`, `Age`) were stored as proper numeric types, not strings |
| Grain Check | Confirmed 1 row per visit in the fact table and 1 row per patient/physician in the dimension tables |
| Age Binning | Verified `Age_Group` buckets: `Child (0-12)`, `Teen (13-18)`, `Young Adult (19-35)`, `Adult (36-50)`, `Senior (51-65)`, `Elderly (65+)` |
| Stay Binning | Verified `Stay_Category` buckets: `Same day`, `Short (2-3d)`, `Medium (4-7d)`, `Long (8-14d)`, `Extended (15d+)` |
| Wait Time Binning | Verified `Wait_Time_Bucket` buckets: `<30 min`, `30-60 min`, `1-2 hr`, `2-3 hr`, `3-5 hr` |
| Derived Field Check | Confirmed `Cost_Per_Day_USD` = `Treatment_Cost_USD` / `Length_of_Stay_Days` holds consistently across rows |

**Result:** No rows were dropped or imputed — the source data arrived pre-cleaned and passed all quality checks as-is. `Sales_Cleaned_Data`-style output was not required; `visits.csv`, `patients.csv`, and `doctors.csv` were used directly as the modeling layer.

**Tools:** `pandas`, `numpy`

---

## 🔍 2. Exploratory Data Analysis (EDA)

Source: `doctors.csv`, `patients.csv`, `visits.csv`

**Univariate Analysis**
- Summary statistics for numeric fields: `Age`, `Treatment_Cost_USD`, `Length_of_Stay_Days`, `Wait_Time_Minutes`, `Severity_Score`
- Value counts for categorical fields: `Department`, `Diagnosis`, `Severity_Level`, `Outcome`, `Insurance_Type`, `Gender`, `Age_Group`
- Distribution charts: severity mix (pie), outcome mix (donut), wait-time bucket distribution (bar), stay-category distribution (donut)

**Multivariate Analysis**
- Bar charts: visit volume, average cost, average length of stay, and readmission rate — each broken out **by department**
- Stacked column charts: outcome broken out **by severity level**, and outcome broken out **by gender**
- Line chart: average cost, average wait time, and readmission rate trended **across age group**
- Matrix / heatmap: visit count by **Department × Severity Level**, to spot where the sickest patients concentrate
- Bubble chart: physician-level **cost vs. readmission rate**, sized by caseload, to spot cost/quality outliers
- Bar charts: top diagnoses by volume, top diagnoses by recovery rate, top departments by cost efficiency (cost per recovered patient), top physicians by recovery rate and by lowest readmission rate (minimum 20-case threshold)

**Key EDA Findings**
- Gynecology, Dermatology, and Neurology are the highest-volume departments; Oncology and Cardiology run the highest average cost per visit.
- Critical-severity cases skew heavily toward "Transferred" and "Deceased" outcomes compared to Low/Medium severity.
- Diabetes and Pneumonia post the highest recovery rates among major diagnoses; Asthma and Heart Disease trail slightly.
- Neurology, Oncology, and ICU are the most cost-efficient departments per recovered patient, despite Oncology's high raw average cost.
- A small group of physicians combine high recovery rates (85%+) with low readmission rates — worth studying as best-practice benchmarks.

**Tools:** `pandas`, `numpy`, `matplotlib`/`seaborn`-style charting (mirrored in Power BI/Chart.js for the final dashboards)

---

## 🗄️ 3. Data Modeling (Star Schema)

| Table | Grain | Key Columns |
|---|---|---|
| `patients` | 1 row per patient | `Patient_ID` (PK), Age, Gender, Age_Group |
| `doctors` | 1 row per physician | `Doctor_ID` (PK), Total_Patients_Treated, Departments_Covered, Avg_Treatment_Cost_USD, Avg_Length_of_Stay_Days, Readmission_Rate_Pct |
| `visits` | 1 row per patient visit | `Visit_ID` (PK), `Patient_ID` (FK), `Doctor_ID` (FK), Department, Diagnosis, Severity_Level, Severity_Score, Length_of_Stay_Days, Stay_Category, Wait_Time_Minutes, Wait_Time_Bucket, Insurance_Type, Treatment_Cost_USD, Cost_Per_Day_USD, Readmission_Flag, Readmitted, Outcome |

```
patients (1) ──< visits >── (1) doctors
   Patient_ID              Doctor_ID
```

**Departments covered:** Cardiology, Dermatology, Emergency, General Surgery, Gynecology, ICU, Neurology, Oncology, Orthopedics, Pediatrics

**Diagnoses covered:** Asthma, Cancer, Diabetes, Fracture, Heart Disease, Hypertension, Infection, Kidney Disease, Pneumonia, Stroke

`patients` and `doctors` act as dimension tables; `visits` is the fact table, joined to both on `Patient_ID` and `Doctor_ID` respectively — loaded directly into Power BI's model view with these relationships defined.

---

## ❓ 4. Business Questions Answered (DAX)

1. **Top 5 departments by patient volume** — visit count, average cost, and readmission rate by department
2. **Recovery, mortality, and readmission rate trends** — overall and sliced by department, diagnosis, severity, and physician
3. **Top diagnoses by volume and by recovery rate** — which conditions are most common vs. which respond best to treatment
4. **Top 10 physicians by caseload, recovery rate, and readmission rate** (minimum 20-case threshold to avoid small-sample distortion)
5. **Cost efficiency by department** — average cost per recovered patient, to separate "expensive" from "inefficient"
6. **Outcome breakdown by severity and gender**, for quality and equity review

**Core measures:**
```dax
Recovery Rate = 
DIVIDE(CALCULATE(COUNTROWS(visits), visits[Outcome] = "Recovered"), COUNTROWS(visits), 0)

Mortality Rate = 
DIVIDE(CALCULATE(COUNTROWS(visits), visits[Outcome] = "Deceased"), COUNTROWS(visits), 0)


Total Patients = DISTINCTCOUNT(patients[Patient_ID])
```

---

## 📈 5. Dashboard

The dashboards summarize the full dataset with filters for **Department, Diagnosis, Insurance_Type, Age_Group, and Gender**, split across pages

- Page 1 

![Hospital Performance Dashboard](https://github.com/tushar118MCA/Internship_Projects/blob/1edfe192074229154845adf72bfb509ed3717e7c/Hospital_Performance_Dashboard/Hospital_Dashboard_Image1.png)

- Page 2 

![Hospital Performance Dashboard](https://github.com/tushar118MCA/Internship_Projects/blob/1edfe192074229154845adf72bfb509ed3717e7c/Hospital_Performance_Dashboard/Hospital_Dashboard_Image2.png)

**Key Metrics**
- Total Revenue: **$92M**
- Average Cost per Visit: **$4.92K**
- Average Length of Stay: **5.39 days**
- Average Wait Time: **151.55 min**
- Recovery Rate: **68.64%**
- Mortality Rate: **2.49%**


---

## 🛠️ Tech Stack

| Layer | Tools |
|---|---|
| Data Cleaning & EDA | Python (`pandas`, `numpy`, `matplotlib`, `seaborn`) |
| Data Modeling & Measures | Power BI, DAX |
| Theming | Custom Power BI theme (JSON) |
| Visualization / Dashboard | Power BI (native)|
| Environment | Jupyter Notebook, Power BI Desktop |

---

## 🚀 How to Reproduce

1. **Review the cleaning checks**
   ```bash
   jupyter notebook Hospital_Data_Cleaning_Transformation.ipynb
   ```
   Confirms `doctors.csv`, `patients.csv`, `visits.csv` are null-free, duplicate-free, and referentially consistent — no output file is produced since no rows required alteration.

2. **Run the EDA**
   ```bash
   jupyter notebook Hospital_Exploratory_Data_Analysis__EDA_.ipynb
   ```
   Reproduces the univariate/multivariate charts and the KPI values referenced above.

3. **Load the data model**
   Open `Hospital_Performance_Dashboard.pbix` in Power BI Desktop, and point the data source to `doctors.csv`, `patients.csv`, and `visits.csv`.

4. **Apply the theme**
   ```
   View → Themes → Browse for themes → Hospital_Performance_Patient_Outcome_Theme.json
   ```
---
