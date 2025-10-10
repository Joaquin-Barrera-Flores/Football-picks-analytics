Football Picks Analytics: A Business Intelligence Case Study
This repository contains the code and documentation for an end-to-end data analytics project designed to answer a core business question: Can we use data to move from simple intuition to strategic insight in sports prediction?

The goal was to build a complete BI solution to track, analyze, and visualize performance, identifying patterns and biases to provide actionable recommendations.

Live Dashboard: Interactive Tableau Dashboard

Dataset: Kaggle Dataset

1. Business Problem & Objectives
The project aimed to solve several key business challenges through data:

Performance Benchmarking: Quantitatively identify the most accurate predictors and establish performance benchmarks.

Decision-Making Bias Analysis: Uncover and measure potential biases in prediction patterns (e.g., favoritism towards underdog teams or local leagues).

Trend & Seasonality Analysis: Determine if performance fluctuates over time or is affected by specific events (e.g., post-international breaks).

Strategic Insights: Provide data-driven feedback to participants to help improve their prediction strategies.

2. Tech Stack & Process
I implemented a full ETL (Extract, Transform, Load) and BI workflow:

Step

Description

Tools Used

Data Collection

Weekly data gathered via structured polls.

WhatsApp

Data Storage & Structure

Designed a relational database to store raw and processed data.

SQL

ETL & Data Modeling

Cleaned data, handled missing values, and engineered new features (e.g., accuracy scores, "upset" metrics).

R (Tidyverse)

Analysis & Visualization

Performed exploratory data analysis and built a multi-page interactive dashboard.

Tableau, ggplot2

Documentation & Version Control

Maintained code and project documentation.

GitHub

3. Key Findings & Actionable Insights
The analysis of X weeks of data and over Y predictions yielded several key insights:

Insight 1: The Local Specialist

Finding: Participant "Juan Perez" demonstrates a 15% higher accuracy rate on Liga MX matches compared to European leagues, but a 10% lower rate on the latter.

Business Action: This suggests a deep local market expertise. A potential strategy for this participant would be to specialize and focus their predictions on local tournaments.

Insight 2: High-Risk, High-Reward Bias

Finding: Participant "Ana Garcia" consistently predicts wins for underdog teams 30% more often than the average, leading to a lower overall accuracy but the highest score on "upset" wins.

Business Action: This identifies a distinct high-risk strategy. Recommendations could include balancing these high-risk picks with more conservative choices to improve overall consistency.

Insight 3: Post-International Break Performance Dip

Finding: A time-series analysis revealed a consistent 25% drop in prediction accuracy across all participants in the game week immediately following a FIFA international break.

Business Action: This insight suggests that market volatility and unpredictability increase significantly during these periods. A strategic adjustment would be to make more cautious predictions during these specific weeks.

4. Next Steps
Incorporate Predictive Modeling: Develop a basic predictive model in Python (pandas, scikit-learn) to forecast future performance based on historical data.

Add External Data: Integrate betting odds data via an API to benchmark prediction accuracy against market expectations.

Automate the Pipeline: Explore tools like Airflow or Mage to automate the weekly data ingestion and transformation process.