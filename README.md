# SQL---Walmart_Sales_Analysis

📌 Project Overview
This project analyzes Walmart’s transactional sales data using Advanced MySQL. The goal is to solve real business problems and extract insights using structured SQL queries.

🎯 Business Tasks & SQL Solutions:

✅ Task 1: Top Branch by Sales Growth Rate
Use monthly aggregation and growth calculations to find the highest growing branch.

✅ Task 2: Most Profitable Product Line per Branch
Calculate profit = gross income - cost of goods sold and rank product lines by branch.

✅ Task 3: Customer Segmentation by Spending
Use total spending per customer to classify into:

--High Spenders
--Medium Spenders
--Low Spenders

✅ Task 4: Anomaly Detection in Sales
Find sales much higher/lower than the average per product line using STDDEV() and AVG().

✅ Task 5: Most Popular Payment Method by City
Group data by city and payment method, then use COUNT() to find the top one.

✅ Task 6: Monthly Sales Distribution by Gender
Use MONTHNAME() to group and compare male vs. female spending trends.

✅ Task 7: Best Product Line by Customer Type
Compare total sales by customer type (Member vs. Normal) for each product line.

✅ Task 8: Repeat Customers Within 30 Days
Use self-join or window functions to detect customers who made repeat purchases within 30 days.

✅ Task 9: Top 5 Customers by Sales Volume
Aggregate and sort by total sales to get the top 5.

✅ Task 10: Sales Trends by Day of the Week
Use DAYNAME() to analyze which weekdays generate the most revenue.

🛠️ Tools Used
MySQL 8.0+

SQL concepts: JOIN, CTE, Window Functions, GROUP BY, ORDER BY, CASE, IF, RANK(), PARTITION BY

📈 Outcome
Each task returns clear results that answer specific business questions. The SQL logic is optimized for performance and clarity, making the code both readable and scalable.

