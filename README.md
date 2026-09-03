# 📊 Procurement Spend & Supplier Performance Analysis

## 🎯 Business Question

**Are we getting enough value from our suppliers relative to what we spend with them?**

This project analyzes procurement spend, supplier performance, and payment coverage to identify **supplier risk, spend concentration, and potential process issues**.

---

## ⭐ Highlights

* Designed a **relational data model** across Suppliers, Purchase Orders, and Payments with validated PK/FK relationships.
* Used **data-derived benchmarks** rather than arbitrary thresholds to identify high-spend and below-average suppliers.
* Identified and fixed a **fan-out / row-duplication issue** caused by the 1-to-many Purchase Order → Payments relationship by aggregating each side independently before joining.
* Found that **69% of total spend is concentrated in Professional Services across only 7 suppliers**, highlighting concentration risk.
* Identified **Fisher PLC and Jackson-Yu** as the only suppliers combining high spend with below-average ratings.
* Built a two-page Power BI dashboard centered on a **spend-vs-rating quadrant** to directly support supplier risk assessment.
* Cross-checked key dashboard metrics against SQL results to ensure consistency.

---

## 🛠️ Tools

**Python** · **SQL Server** · **Power BI** · **DAX**

Python was used for synthetic data generation, SQL Server for cleaning, modeling and analysis, and Power BI for visualization and reporting.

---

## 📦 Data

| Table           |  Rows |
| --------------- | ----: |
| Suppliers       |    50 |
| Purchase Orders | 5,000 |
| Payments        | 6,253 |

### 🧹 Data Preparation

The dataset was profiled and cleaned before analysis, including:

* Duplicate supplier IDs
* Inconsistent category text
* Invalid negative delivery values
* Missing supplier ratings

Three suppliers had missing ratings. These were retained as `NULL` and excluded from rating-based analysis rather than imputed, avoiding assumptions that could bias the results.

---

## 🔄 Analytical Process

1. **Profiling** — row counts, duplicates, null audit, and range validation
2. **Cleaning** — deduplication, text standardization, and invalid-value handling
3. **Modeling** — primary/foreign keys and validated relationships
4. **Analysis** — spend, supplier performance, and payment coverage
5. **Visualization** — Power BI dashboard and SQL cross-checking

---

# 🔍 Key Analysis & Results

## 1️⃣ Where Does the Spend Go?

```sql
SELECT
    Product_Category,
    SUM(Total_Cost) AS Total_Spend,
    COUNT(DISTINCT PO_ID) AS Order_Count
FROM purchase_orders_clean
GROUP BY Product_Category
ORDER BY Total_Spend DESC;
```

| Category              |    Spend | % of Total |
| --------------------- | -------: | ---------: |
| Professional Services | $197.02M |    **69%** |
| Technology            |  $30.50M |        11% |
| Marketing             |  $18.46M |         6% |
| Facilities            |  $18.27M |         6% |
| Logistics             |  $14.76M |         5% |
| Office Supplies       |   $5.54M |         2% |

**Total spend: $284.55M across 5,000 purchase orders.**

💡 **Key insight:** 69% of procurement spend is concentrated in one category across only 7 suppliers, creating a clear **supplier concentration risk**.

---

## 2️⃣ Which Suppliers Combine High Spend With Weak Performance?

Benchmarks were derived from the dataset rather than selected arbitrarily:

* Average spend per supplier: **$5.69M**
* Average supplier rating: **4.06**
* Average delivery time: **24 days**

```sql
SELECT
    s.Supplier_Name,
    s.Supplier_Rating,
    SUM(po.Total_Cost) AS Spend
FROM suppliers_clean s
JOIN purchase_orders_clean po
    ON s.Supplier_ID = po.Supplier_ID
WHERE s.Supplier_Rating IS NOT NULL
GROUP BY
    s.Supplier_Name,
    s.Supplier_Rating
HAVING
    SUM(po.Total_Cost) > 5690983.37
    AND s.Supplier_Rating < 4.064948
ORDER BY Spend DESC;
```

| Supplier   |  Spend | Rating |
| ---------- | -----: | -----: |
| Fisher PLC | $26.9M |   3.40 |
| Jackson-Yu | $25.8M |   3.50 |

**Only 2 of 50 suppliers** combine above-average spend with below-average ratings.

These suppliers represent the clearest candidates for **pricing, service-level, and contract-performance review**.

---

## 3️⃣ Payment Coverage & the SQL Bug Fix

An initial payment-coverage query produced inflated spend because the Purchase Order → Payments relationship is **1-to-many**.

The issue was identified and corrected by aggregating spend and payments independently before joining:

```sql
WITH SupplierSpend AS (
    SELECT
        Supplier_ID,
        SUM(Total_Cost) AS Spend
    FROM purchase_orders_clean
    GROUP BY Supplier_ID
),
SupplierPaid AS (
    SELECT
        po.Supplier_ID,
        SUM(p.Payment_Amount) AS Paid
    FROM purchase_orders_clean po
    JOIN payments_clean p
        ON po.PO_ID = p.PO_ID
    GROUP BY po.Supplier_ID
)
SELECT
    s.Supplier_Name,
    ss.Spend,
    sp.Paid,
    sp.Paid * 100.0 / ss.Spend AS Coverage_Pct
FROM suppliers_clean s
JOIN SupplierSpend ss
    ON s.Supplier_ID = ss.Supplier_ID
JOIN SupplierPaid sp
    ON s.Supplier_ID = sp.Supplier_ID
ORDER BY Coverage_Pct ASC;
```

### Result

| Metric                       |            Result |
| ---------------------------- | ----------------: |
| Payment coverage range       | **76.6% – 99.9%** |
| Suppliers below 70% coverage |             **0** |
| Fisher PLC coverage          |         **83.2%** |
| Jackson-Yu coverage          |         **88.4%** |

💡 No supplier is simultaneously weak across **spend, rating, and payment coverage**.

This shows that the identified issues are **distributed across different suppliers rather than concentrated in one supplier**.

---

## 4️⃣ What's the Outstanding Balance?

Of the 5,000 purchase orders:

* **4,438 (89%)** have an actual payment greater than $0.
* **562 orders** have no recorded payment greater than $0.
* These orders represent **$32.49M** in outstanding order value.
* **531 payment entries** contain a $0 amount.

⚠️ The zero-value entries suggest a **potential payment-logging/process gap**, rather than simply missing payment records.

---

# 📈 Power BI Dashboard

## Procurement Overview

Overview of total spend, monthly trends, category concentration, and payment status.

![Procurement Overview Dashboard](Screenshots/Procurement%20Overview%20dashboard%20.png)

---

## Supplier Performance

Supplier-level analysis highlighting high-spend and below-average-performing suppliers through the spend-vs-rating quadrant.

![Supplier Performance Dashboard](Screenshots/Supplier%20Performance%20dashboard%20.png)

🎯 The **spend-vs-rating quadrant** is the core analytical visual, allowing decision-makers to quickly identify suppliers with high financial exposure and weaker performance.

---

# 💡 Key Findings

### 💰 Spend Concentration

**69% of total spend** is concentrated in Professional Services across only 7 suppliers.

### ⚠️ Supplier Performance

**Fisher PLC and Jackson-Yu** are the only suppliers combining high spend with below-average ratings.

### 📋 Contract Review

**Martinez-Jacobs** has the highest rating in the dataset (4.80) despite an expired contract. This is a **contract-management issue rather than a performance concern** and warrants review before renewal.

### 💳 Payment Process

**$32.49M** in orders have no recorded payment greater than $0, with 531 zero-value payment entries indicating a potential payment-logging gap.

---

# 📌 Recommendations

1. **Review pricing and performance terms** with Fisher PLC and Jackson-Yu given their high financial exposure and below-average ratings.
2. **Review Martinez-Jacobs' expired contract** before renewal, given its strong supplier performance.
3. **Investigate zero-value payment entries** with Finance to determine whether they reflect a system or process issue.
4. **Diversify Professional Services suppliers** to reduce dependency on a small supplier base.
