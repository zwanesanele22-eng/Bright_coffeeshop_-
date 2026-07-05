Bright Coffee Shop Sales Analysis

This project presents a comprehensive sales analysis of historical transactional data from Bright Coffee Shop. It was designed to provide business insights for a newly appointed CEO with the goal of improving revenue performance and optimizing product strategy.

Objective:

To use data analytics and visualization to answer the following key business questions:
Which products generate the most revenue?
What time of day does the store perform best?
What are the sales trends across products and time intervals?
What actionable recommendations can be made to improve sales performance?
Tools Used

Coding Platforms: SQL, Databricks
Data Visualization: Microsoft Excel (Pivot Tables, Charts, Slicers)
Presentation & Planning: Microsoft PowerPoint, Miro

Project Tasks

Task 1: Planning & Architecture

Developed a data flow and ETL architecture diagram using Miro, outlining:


Where the data originates (store transaction records)
How it is processed (ETL pipeline)
Where it is stored and cleaned (Databricks)
How it is analyzed and presented (Excel, PowerPoint)


Outlined core KPIs and insights to guide the analysis process, including revenue by product category and time interval, high- and low-performing products, and total revenue calculations.

Task 2: Data Processing in Databricks

Transformed raw Excel data to CSV, loaded into Databricks, and performed key cleaning and transformation steps:


Standardized price formatting (converted comma-decimal entries, e.g. '3,1' to 3.1)
Created time_bucket to group transactions into time-of-day intervals (Morning, Afternoon, Evening)
Computed total_amount = unit_price * transaction_qty per transaction
Created spend_bucket (Cheap Spend, Low Spend, Moderate Spend, Expensive Spend) using a CASE statement based on transaction value
Created order_size_category (Personal order, Small group order, Bulk order) to classify transactions by order size
Engineered supporting date fields: day_name, month_name, day_type (Weekday/Weekend), month_period (Early/Mid/Late month)


Task 3: Data Analysis in Excel

Created pivot tables and dashboards showing:


Revenue by product category and product type
Top 10 and bottom 10 best- and worst-selling products
Peak sales time intervals and day-of-week patterns
Revenue by store location (Astoria, Hell's Kitchen, Lower Manhattan)
Monthly revenue trends by category, order size, and spend bucket
Average order value trend over time


Interactive slicers were added to filter dashboards by product category, day type, month, and store location.

Task 4: Executive Presentation
Delivered a data-driven story for the CEO, including:

Key takeaways backed by visuals (Pareto charts, combo charts, trend lines)
Outliers and risks to monitor (e.g. underused premium spend tier, flat average order value)
Recommendations for sales growth
Next steps including automation and multi-location tracking


Key Recommendations

Launch marketing campaigns during low-sales time slots (afternoons, weekends)
Increase inventory and promotion of best-selling items
Promote underperforming products with special offers or bundling
Introduce group and bulk-order incentives to grow an underused order segment
Track average order value monthly as an early indicator of growth quality


Next Steps
Automate daily sales reporting
Track sales performance across multiple store locations
Implement a loyalty program based on peak customer time slots


Repository Contents

Miro Plan/Diagram — data flow and architecture planning
Processed Dataset (Excel) — cleaned data with pivot tables and charts
PowerPoint Presentation — executive presentation for the CEO
SQL file — Databricks SQL code used for data cleaning and transformation
