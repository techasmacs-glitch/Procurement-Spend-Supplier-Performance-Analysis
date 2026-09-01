# 🏢 Procurement Spend & Supplier Performance Analysis

## 📌 Business Problem
> **Are we getting enough value from our suppliers relative to what we spend with them?**

Management needs to understand whether high procurement spend is justified by strong supplier performance, or if certain suppliers require review.

---

## 🛠️ Tools Used
- **Python** – Synthetic data generation (`pandas`, `numpy`)
- **SQL Server** – Data profiling, cleaning, modeling, and analysis
- **Power BI** – Interactive dashboard and visualization
- **GitHub** – Version control and project documentation

---

## 📊 Data Overview

### Data Generation (Python)
The dataset was generated using **Python** (`pandas` and `numpy`) to simulate real-world procurement data, including:

- **Suppliers** – Name, category, region, rating, contract status
- **Purchase Orders** – Product, quantity, price, order date, delivery days
- **Payments** – Amount, date, status

The data was intentionally designed with **realistic data quality issues** (missing values, duplicates, typos, invalid entries) to mimic actual organizational data.

### Datasets
| Table | Description | Rows (Raw) | Rows (Clean) |
|-------|-------------|------------|--------------|
| `suppliers_messy` | Raw supplier master data | 52 | 50 |
| `purchase_orders_messy` | Raw purchase transactions | 5,003 | 5,000 |
| `payments_messy` | Raw payment records | 6,256 | 6,253 |

### Data Quality Issues Identified & Resolved
| Issue | Discovery | Action Taken |
|-------|-----------|--------------|
| Duplicate Suppliers | `SUP-005`, `SUP-013` appeared twice | Removed using `SELECT DISTINCT` |
| Missing Supplier Ratings | 3 suppliers had `NULL` rating | Investigated and imputed with category average |
| Invalid Delivery Days | `-5` days recorded | Replaced with `NULL` and excluded from analysis |
| Inconsistent Categories | "Electronics" vs "ELECTRONICS" | Standardized using `UPPER()` and `TRIM()` |
| Missing Payment Status | 3 records with `NULL` status | Set to `Pending` |
| Overpayments | 3 cases due to duplicates | Resolved after removing duplicates |

---

## 🔍 SQL Process

### 1. Data Profiling (`01_Data_Profiling.sql`)
- Checked total row counts
- Identified duplicates and missing values
- Validated data types and ranges
- Analyzed categorical distributions

### 2. Data Cleaning (`02_Data_Cleaning.sql`)
- Removed exact duplicates using `SELECT DISTINCT`
- Handled missing ratings
- Standardized text fields
- Converted data types for consistency

### 3. Data Modeling (`08-10_Data_Modeling_*.sql`)
- Created Primary Keys on all tables
- Established Foreign Key relationships
- Validated referential integrity

### 4. Procurement Overview (`11_Procurement_Overview.sql`)
- Total spend: **$284.55M**
- Total orders: **5,000**
- Spend by department and category
- Payment vs outstanding analysis

### 5. Supplier Analysis (`13_Supplier_Analysis.sql`)
- **Top 7 suppliers** account for **$197M** (69% of total spend)
- **Fisher PLC**: $26.94M spend | 3.40 rating | 67.75% coverage
- **Jackson-Yu**: $25.83M spend | 3.50 rating | 70.14% coverage
- **Martinez-Jacobs**: $27.07M spend | 25-day delivery | Expired contract

### 6. Payment Analysis (`14_Payment_Analysis.sql`)
- Total paid: **$252.06M**
- Outstanding: **$32.49M** (562 unpaid orders)
- Payment coverage ranges from **58.59%** to **81.86%**

---

## 📊 Dashboard

### Page 1: Executive Overview
- **KPIs**: Total Orders, Purchase Cost, Paid Amount, Outstanding, Payment Rate
- **Trend**: Purchase Cost over time
- **Category Analysis**: Spend by Product Category
- **Payment Status**: Paid vs Pending distribution
- **Slicers**: Order Date, Product Category, Order Status

### Page 2: Supplier Performance
- **KPIs**: Total Suppliers, Active Suppliers, Average Rating
- **Spend vs Rating Matrix**: Scatter plot with 4 quadrants
- **Top 10 Suppliers**: By spend
- **Supplier Summary Table**: Supplier name, spend, and rating
- **Slicers**: Region, Supplier Category, Contract Status

---

## 🔍 Key Insights

1. **High spend does NOT always mean high performance**  
   - **Fisher PLC** ($26.94M, rating 3.40) and **Jackson-Yu** ($25.83M, rating 3.50) are high-spend suppliers with below-average ratings.

2. **Supplier risk is not concentrated in one supplier**  
   - **Martinez-Jacobs** ($27.07M, rating 4.80) has an expired contract and slow delivery (25 days).
   - **Colon, Camacho and Williams** ($6.40M) has an expired contract and missing rating.

3. **Professional Services dominates spending**  
   - 69% of total spend ($197M) goes to Professional Services.

4. **Outstanding payments require attention**  
   - $32.49M outstanding across 562 unpaid orders (11.24% of total orders).

---

## 💡 Recommendations

1. **Review Fisher PLC and Jackson-Yu**  
   - Investigate performance issues and renegotiate contracts.

2. **Renew Martinez-Jacobs' contract**  
   - Address delivery delays despite strong rating.

3. **Follow up on outstanding payments**  
   - Improve cash flow visibility and payment reconciliation.

4. **Diversify Professional Services suppliers**  
   - Reduce dependency on a single category.

---

## 📁 Project Structure
