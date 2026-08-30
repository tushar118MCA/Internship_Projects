# 📊 Sales Analytics Project

An end-to-end sales analytics workflow — from raw data cleaning through exploratory data analysis, SQL-based business querying (via a PostgreSQL star schema), and a Power BI-style interactive dashboard.

---

## 📁 Project Structure

```
Sales_Dashboard/
├── Sales_Raw_Data.csv                        # Original, unprocessed sales data (1,000 rows)
├── Sales_Data_Cleaning_Transformation.ipynb  # Notebook: data quality checks, cleaning, feature engineering
├── Sales_Cleaned_Data.csv                    # Cleaned, transformed dataset (992 rows)
├── Data_Dictionary.csv                       # Column-level definitions & business relevance
├── Sales_Exploratory_Data_Analysis__EDA_.ipynb # Notebook: EDA, visualizations, SQL business questions
├── dim_customers.csv                         # Customer dimension table
├── Sales_dashboard_image1.csv                # Image 1
├── Sales_dashboard_image1.csv                # Image 2
├── dim_products.csv                          # Product dimension table
├── fact_orders.csv                           # Orders fact table
├── Sales_Data.sql                            # Standalone SQL queries answering key business questions
├── Sales_Analytics_Dashboard.pbix            # Dashboard
└── README.md                                 # Project documentation (this file)
```

---

## 🧭 Project Workflow

```
Raw Data → Data Cleaning → EDA → Star Schema (PostgreSQL) → SQL Analysis → Dashboard
```

1. **Data Cleaning & Transformation** (`Sales_Data_Cleaning_Transformation.ipynb`)
2. **Exploratory Data Analysis** (`Sales_Exploratory_Data_Analysis__EDA_.ipynb`)
3. **Database Modeling** — cleaned data loaded into PostgreSQL and split into a star schema (`dim_customers`, `dim_products`, `fact_orders`)
4. **Business Question Analysis** via SQL (`Sales_Data.sql`)
5. **Dashboard** — interactive visual summary of KPIs and trends

---

## 🧹 1. Data Cleaning & Transformation

Source: `Sales_Raw_Data.csv` (1,000 rows, 12 columns) → Output: `Sales_Cleaned_Data.csv` (992 rows, 17 columns)

**Steps performed:**
| Step | Description |
|---|---|
| Data Dictionary | Documented each column's type, description, and business relevance → `Data_Dictionary.csv` |
| Missing Values | Checked and quantified nulls across all columns |
| Duplicate Records | Checked full-row duplicates and duplicate `Order_ID`s |
| Format Consistency | Reviewed categorical columns (`Gender`, `City`, `Product`, `Category`) and date formats |
| Remove Duplicates | Dropped duplicate `Order_ID` rows, keeping the first occurrence |
| Handle Missing Values | `Age` filled with median; `City` filled with `"Unknown"` |
| Standardize Dates | Converted `Order_Date` to proper `datetime` (`YYYY-MM-DD`) |
| Standardize Text | Trimmed whitespace and applied title case to text/categorical fields |
| Age Binning | Created `Age_Group` buckets: `18-25`, `26-35`, `36-45`, `46-55`, `56+` |
| Feature Engineering | Derived `Order_Year`, `Order_Month`, `Order_Weekday`, `Order_Quarter` from `Order_Date` |

**Tools:** `pandas`, `numpy`, `matplotlib`, `seaborn`

---

## 🔍 2. Exploratory Data Analysis (EDA)

Source: `Sales_Cleaned_Data.csv`

**Univariate Analysis**
- Summary statistics for numeric fields: `Age`, `Quantity`, `Unit_Price`, `Total_Sales`
- Value counts for categorical fields: `Gender`, `City`, `Product`, `Category`, `Age_Group`
- Histograms (numerical distributions) and bar charts (categorical distributions)

**Multivariate Analysis**
- Correlation heatmap across numeric fields
- Scatter plot: Unit Price vs. Total Sales (colored by Quantity)
- Box plot: Age distribution by Product Category
- Pair plot: numerical relationships segmented by Gender
- Heatmap: Revenue by City × Category

**Database Integration**
- Cleaned data loaded into a local **PostgreSQL** database (`sales_Analytics`) via `SQLAlchemy` / `psycopg2`
- Data split into a **star schema**:
  - `dim_customers` — Customer_ID, Customer_Name, Age, Age_Group, Gender, City
  - `dim_products` — Product_ID, Product, Category
  - `fact_orders` — Order_ID, Customer_ID, Product_ID, Order_Date, Order_Year/Quarter, Quantity, Unit_Price, Total_Sales

**Tools:** `pandas`, `numpy`, `matplotlib`, `seaborn`, `psycopg2`, `sqlalchemy`

---

## 🗄️ 3. Data Model (Star Schema)

| Table | Grain | Key Columns |
|---|---|---|
| `dim_customers` | 1 row per customer | `Customer_ID` (PK), Customer_Name, Age, Age_Group, Gender, City |
| `dim_products` | 1 row per product | `Product_ID` (PK), Product, Category |
| `fact_orders` | 1 row per order | `Order_ID`, `Customer_ID` (FK), `Product_ID` (FK), Order_Date, Order_Year, Order_Quarter, Quantity, Unit_Price, Total_Sales |

**Products covered:** Rice (Grocery), Book (Education), Mobile (Electronics), Laptop (Electronics), Shoes (Fashion), Chair (Furniture)

**Cities covered:** Bengaluru, Delhi, Gaya, Hyderabad, Kolkata, Mumbai, Patna, Pune (+ Unknown)

---

## ❓ 4. Business Questions Answered (SQL)

Defined in `Sales_Data.sql` and executed against the star schema:

1. **Top 5 products by total revenue** — units sold, order count, and revenue by product/category
2. **Monthly/quarterly trend across the year** — order count, total revenue, average order value
3. **Revenue by city** — which city generates the highest revenue and average order value
4. **Top 10 customers by total spend**
5. **Revenue and order count by category and gender**
6. **Revenue by age group within category**, for customers older than 30

---

## 📈 5. Dashboard

The dashboard summarizes the full dataset with filters for **Category, Product, City, Age Group, and Gender**, and includes:

- Page 1 
![Sales Dashboard](https://github.com/tushar118MCA/Internship_Projects/blob/821e22ed10e42151f610fbb201453683b23da2ce/Sales_Dashboard/Sales_dashboard_page1.png)

- Page 2
![Sales Dashboard](https://github.com/tushar118MCA/Internship_Projects/blob/821e22ed10e42151f610fbb201453683b23da2ce/Sales_Dashboard/Sales_dashboard_page2.png)


**Key Metrics**
- Total Revenue: **138.10M**
- Average Revenue per Customer: **146.76K**
- Churn Rate: **49.63%**
- Top Product Revenue: **18.32M**
- Average Units per Order: **5.44**
- Retention Rate: **5.31%**

---

## 🛠️ Tech Stack

| Layer | Tools |
|---|---|
| Data Cleaning & EDA | Python (`pandas`, `numpy`, `matplotlib`, `seaborn`) |
| Database | PostgreSQL |
| DB Connectivity | `SQLAlchemy`, `psycopg2` |
| Analysis | SQL |
| Visualization / Dashboard | BI dashboard tool (Power BI / Tableau-style) |
| Environment | Jupyter Notebook |

---

## 🚀 How to Reproduce

1. **Clean the data**
   ```bash
   jupyter notebook Sales_Data_Cleaning_Transformation.ipynb
   ```
   Produces `Sales_Cleaned_Data.csv` and `Data_Dictionary.csv`.

2. **Run the EDA & load to PostgreSQL**
   ```bash
   jupyter notebook Sales_Exploratory_Data_Analysis__EDA_.ipynb
   ```
   Update the connection string to match your local PostgreSQL instance:
   ```python
   engine = create_engine("postgresql+psycopg2://<user>:<password>@localhost:5432/<database>")
   ```

3. **Run business-question queries**
   ```bash
   psql -d sales_Analytics -f Sales_Data.sql
   ```

4. **Explore the dashboard** using the cleaned data / star schema tables as the data source.

---

