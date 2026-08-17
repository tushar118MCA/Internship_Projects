SELECT * FROM public.sales

-- 1. What are the top 5 products by total revenue 

SELECT
    p."Product",
    p."Category",
    COUNT(*)                                AS "Num_Orders",
    SUM(f."Quantity")                       AS "Total_Units_Sold",
    ROUND(SUM(f."Total_Sales")::numeric, 2) AS "Total_Revenue"
FROM fact_orders f
JOIN dim_products p ON f."Product_ID" = p."Product_ID"
GROUP BY p."Product", p."Category"
ORDER BY "Total_Revenue" DESC
LIMIT 5;

-- 2. What is the Monthly trend across the year 

SELECT
    "Order_Year",
    "Order_Quarter",
    COUNT(*)                                AS "Num_Orders",
    ROUND(SUM("Total_Sales")::numeric, 2)   AS "Total_Revenue",
    ROUND(AVG("Total_Sales")::numeric, 2)   AS "Avg_Order_Value"
FROM fact_orders
GROUP BY "Order_Year", "Order_Quarter"
ORDER BY "Order_Quarter"

-- 3. Which city generates the highest total revenue, and what's the average value per city 

SELECT
    c."City",
    COUNT(*)                                AS "Num_Orders",
    ROUND(SUM(f."Total_Sales")::numeric, 2) AS "Total_Revenue",
    ROUND(AVG(f."Total_Sales")::numeric, 2) AS "Avg_Order_Value"
FROM fact_orders f
JOIN dim_customers c ON f."Customer_ID" = c."Customer_ID"
GROUP BY c."City"
ORDER BY "Total_Revenue" DESC;


-- 4. Who are the top 10 customers By Total Spend 

SELECT
    c."Customer_ID",
    c."Customer_Name",
    c."City",
    c."Age_Group",
    COUNT(*)                                AS "Num_Orders",
    ROUND(SUM(f."Total_Sales")::numeric, 2) AS "Total_Spend"
FROM fact_orders f
JOIN dim_customers c ON f."Customer_ID" = c."Customer_ID"
GROUP BY c."Customer_ID", c."Customer_Name", c."City", c."Age_Group"
ORDER BY "Total_Spend" DESC
LIMIT 10;

-- 5. What is revenue and order count by category and gender

SELECT
    p."Category",
    c."Gender",
    COUNT(*)                                AS "Num_Orders",
    ROUND(SUM(f."Total_Sales")::numeric, 2) AS "Total_Revenue"
FROM fact_orders f
JOIN dim_products  p ON f."Product_ID"  = p."Product_ID"
JOIN dim_customers c ON f."Customer_ID" = c."Customer_ID"
GROUP BY p."Category", c."Gender"
ORDER BY p."Category", c."Gender";

-- 6. What is Revenue by Age group within each category, for customers older than 30

SELECT
    p."Category",
    c."Age_Group",
    COUNT(*)                                AS "Num_Orders",
    ROUND(SUM(f."Total_Sales")::numeric, 2) AS "Total_Revenue"
FROM fact_orders f
JOIN dim_products  p ON f."Product_ID"  = p."Product_ID"
JOIN dim_customers c ON f."Customer_ID" = c."Customer_ID"
WHERE c."Age" > 30
GROUP BY p."Category", c."Age_Group"
ORDER BY p."Category", "Total_Revenue" DESC;
