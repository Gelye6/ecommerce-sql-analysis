Ecommerce Business Data Analysis (SQL)
Project Overview
This project involves a comprehensive SQL-based analysis of an Ecommerce database. The objective was to extract actionable business insights regarding sales performance, customer purchasing behavior, and operational efficiency. The analysis covers a range of SQL techniques, from foundational joins and aggregations to advanced analytical methods.

Objectives
-  Revenue Analysis: Identify high-value employees and top-spending customers.
- Time-Series Trends: Track monthly sales patterns to identify peak periods in 1997.
- Fulfillment Tracking: Calculate average order processing times based on shifting annual business rules.
- Advanced Ranking: Implement leaderboards and statistical rankings for products and staff performance.

Technical Skills Demonstrated
- Multi-Table Joins: Connecting Orders, Employees, Customers, Products, and Categories to build a complete data picture.
- Conditional Logic: Utilizing CASE statements to calculate fulfillment metrics based on specific order years.
- Window Functions: Using RANK(), PARTITION BY, and PERCENT_RANK() to categorize and rank data without collapsing rows.
- Aggregations & Filtering: Applying SUM, AVG, COUNT, and the HAVING clause to filter grouped data.
- Subqueries: Nesting queries to isolate the "Most Valuable Product" within each specific category.

Key Insights
- Sales Leaderboard: Successfully ranked employees by total revenue, providing a clear view of top sales performers.
Customer Loyalty: Identified the top 5 customers contributing the most to the company's bottom line.
- Inventory Health: Isolated "one-hit wonder" products that have been sold but never reordered, highlighting potential areas for inventory review.
- Regional Performance: Analyzed sales distribution across different countries and product categories.

Project Structure
- Query solution.sql: The full SQL script containing all 15 research queries.
- MySQL_Project_Report.pdf: The final comprehensive report containing the business logic, the SQL code, and screenshots of the query results.
