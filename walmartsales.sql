-- Q1 Identifying the Top Branch by Sales Growth Rate 
WITH Monthly_Sales AS (
  SELECT 
    Branch,
    DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS YearMonth,
    SUM(Total) AS Monthly_Total
  FROM walmart_sales
  GROUP BY Branch, YearMonth
),

Sales_With_Growth AS (
  SELECT 
    curr.Branch,
    curr.YearMonth,
    curr.Monthly_Total,
    prev.Monthly_Total AS Prev_Month_Total,
    ROUND(
      IFNULL(
        ((curr.Monthly_Total - prev.Monthly_Total) / prev.Monthly_Total) * 100, 
        NULL
      ), 2
    ) AS Growth_Rate
  FROM Monthly_Sales curr
  LEFT JOIN Monthly_Sales prev
    ON curr.Branch = prev.Branch
    AND DATE_FORMAT(
      DATE_SUB(STR_TO_DATE(CONCAT(curr.YearMonth, '-01'), '%Y-%m-%d'), INTERVAL 1 MONTH),
      '%Y-%m'
    ) = prev.YearMonth
)

SELECT 
  Branch,
  ROUND(AVG(Growth_Rate), 2) AS Avg_Monthly_Growth_Rate
FROM Sales_With_Growth
WHERE Prev_Month_Total IS NOT NULL
GROUP BY Branch
ORDER BY Avg_Monthly_Growth_Rate DESC
LIMIT 1;

-- Q2  Finding the Most Profitable Product Line for Each Branch
SELECT 
    result.Branch,
    result.`Product line`,
    result.Total_Profit
FROM (
    SELECT 
        Branch,
        `Product line`,
        ROUND(SUM(`gross income`), 2) AS Total_Profit,
        RANK() OVER (PARTITION BY Branch ORDER BY SUM(`gross income`) DESC) AS rnk
    FROM walmart_sales
    GROUP BY Branch, `Product line`
) AS result
WHERE result.rnk = 1;

-- Q3 Analyzing Customer Segmentation Based on Spending 
WITH customer_totals AS (
    SELECT 
        `Customer ID`, 
        SUM(Total) AS total_spent
    FROM walmart_sales
    GROUP BY `Customer ID`
),
ranked_customers AS (
    SELECT 
        `Customer ID`,
        total_spent,
        ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS row_num,
        COUNT(*) OVER () AS total_customers
    FROM customer_totals
)

SELECT 
    `Customer ID`,
    ROUND(total_spent, 2) AS Total_Spent,
    CASE
        WHEN row_num <= total_customers * 0.25 THEN 'High Spender'
        WHEN row_num <= total_customers * 0.75 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS Spending_Tier
FROM ranked_customers
ORDER BY Total_Spent DESC;

-- Q4 Detecting Anomalies in Sales Transactions 
WITH product_stats AS (
    SELECT 
        `Product line`,
        AVG(Total) AS avg_total,
        STDDEV(Total) AS std_total
    FROM walmart_sales
    GROUP BY `Product line`
)
SELECT 
    ws.`Invoice ID`,
    ws.`Product line`,
    ws.Total,
    ps.avg_total,
    ps.std_total,
    CASE 
        WHEN ws.Total > ps.avg_total + 2 * ps.std_total THEN 'High Anomaly'
        WHEN ws.Total < ps.avg_total - 2 * ps.std_total THEN 'Low Anomaly'
        ELSE 'Normal'
    END AS Anomaly_Type
FROM walmart_sales ws
JOIN product_stats ps
    ON ws.`Product line` = ps.`Product line`
WHERE 
    ws.Total > ps.avg_total + 2 * ps.std_total
    OR ws.Total < ps.avg_total - 2 * ps.std_total;
    
-- Q5 Most Popular Payment Method by City
WITH ranked_payments AS (
    SELECT 
        City,
        Payment,
        COUNT(*) AS Payment_Count,
        RANK() OVER (PARTITION BY City ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart_sales
    GROUP BY City, Payment
)
SELECT 
    City,
    Payment AS Most_Popular_Method,
    Payment_Count
FROM ranked_payments
WHERE rnk = 1;

-- Q6 Monthly Sales Distribution by Gender
SELECT 
    DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS YearMonth,
    Gender,
    ROUND(SUM(Total), 2) AS Total_Sales
FROM walmart_sales
GROUP BY YearMonth, Gender
ORDER BY YearMonth, Gender;

-- Q7 Best Product Line by Customer Type
WITH product_sales AS (
    SELECT 
        `Customer type`,
        `Product line`,
        ROUND(SUM(Total), 2) AS Total_Sales,
        RANK() OVER (PARTITION BY `Customer type` ORDER BY SUM(Total) DESC) AS rnk
    FROM walmart_sales
    GROUP BY `Customer type`, `Product line`
)
SELECT 
    `Customer type`,
    `Product line` AS Best_Product_Line,
    Total_Sales
FROM product_sales
WHERE rnk = 1;

-- Q8 Identifying Repeat Customers
WITH formatted_dates AS (
    SELECT 
        `Customer ID`,
        STR_TO_DATE(Date, '%d-%m-%Y') AS order_date
    FROM walmart_sales
),
repeat_check AS (
    SELECT 
        a.`Customer ID`,
        a.order_date AS first_purchase,
        b.order_date AS repeat_purchase,
        DATEDIFF(b.order_date, a.order_date) AS days_diff
    FROM formatted_dates a
    JOIN formatted_dates b
        ON a.`Customer ID` = b.`Customer ID`
        AND b.order_date > a.order_date
        AND DATEDIFF(b.order_date, a.order_date) <= 30
)
SELECT DISTINCT `Customer ID`
FROM repeat_check
ORDER BY `Customer ID`;

-- Q9 Finding Top 5 Customers by Sales Volume
SELECT 
    `Customer ID`,
    ROUND(SUM(Total), 2) AS Total_Revenue
FROM walmart_sales
GROUP BY `Customer ID`
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Q10 Analyzing Sales Trends by Day of the Week
SELECT 
    DAYNAME(STR_TO_DATE(Date, '%d-%m-%Y')) AS Day_of_Week,
    ROUND(SUM(Total), 2) AS Total_Sales
FROM walmart_sales
GROUP BY Day_of_Week
ORDER BY Total_Sales DESC;

 