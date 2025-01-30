create database telecom;
use telecom;
show tables;
select * from telecom_dataset;

-- 1. Find the number of consumers
select count(customerid)as total_consumers from telecom_dataset;
-- There are 7043 customers in this dataset.

-- 2. Find duplicate rows

select customerid,count(*)as total from telecom_dataset group by customerid having count(*)>1;
-- As is possible see there are not duplicate rows in this dataset.


-- 3 What is the number and proportion of customers who have churned? 
select count(case when customer_status='churned' then 1 end)as total_churned ,
round(count(case when customer_status='churned' then 1 end)/count(*)*100,2)as proportion from telecom_dataset;
-- The churn rate of 26.54% indicates that a significant number of customers have opted to acquire services from other companies. This is a significant figure as it represents a quarter of the total customer base.  

--  What is the proportion rate of customers?
select count(case when customer_status='Churned' then 1 end)as churned_customer,
count(case when customer_status='Joined' then 1 end)as Joined_customer,
count(case when customer_status='Stayed' then 1 end)as Stayed_customer,
round(count(case when customer_status='Churned' then 1 end)/count(*)*100,2 )as churned_percentage_customers,
round(count(case when customer_status='Joined' then 1 end)/count(*)*100,2 )as joined_percentage_customers,
round(count(case when customer_status='Stayed' then 1 end)/count(*)*100,2 )as stayed_percentage_customers
from telecom_dataset ;



-- What is the average age of the customers that joined, stayed and churned? 
select round(avg(case when customer_status='churned' then age end),2)as average_churned_age,
round(avg(case when customer_status='stayed' then age end),2)as average_stayed_age,
round(avg(case when customer_status='joined' then age end),2)as average_joined_age
from telecom_dataset;
-- The average ages of consumers across the three customer statuses are within the 40s, yet it is noticeable that newcomers to the company are younger, while older users tend to leave. This trend could prompt the company to consider specific retention strategies aimed at older customers. Such strategies could include offering loyalty benefits, customizing service packages to fit their usage patterns, or providing personalized customer service support tailored to the preferences of the older demographic.

-- What is the gender’s proportion churned? 
select gender,count(gender)as total_churned_customer ,
count(*)/(select count(*) from telecom_dataset where customer_status='churned')*100 as proportion_churned
from telecom_dataset where customer_status='churned' group by gender;
-- As we can observe that the proportion of churned customers is fairly similar across genders, with males at 49.76% and females at 50.24%. This indicates that gender does not significantly influence the churn rate. Therefore, we cannot consider gender as a decisive factor in customer retention strategies based on this data alone.

-- The state civil of customers has correlation with churned?

select married ,count(*)as total,
round(count(*)/(select count(*) from telecom_dataset where customer_status='churned')*100,2)as proprtion from telecom_dataset 
where customer_status='churned' group by married;  
-- The data reveals a significant difference in churn rates based on marital status: unmarried customers are more likely to churn at 64.21% compared to 35.79% for married customers. This suggests that marital status is a strong indicator of customer retention. To leverage this insight, companies should craft targeted engagement strategies. For unmarried customers, focus on individualized incentives and community features, while for married ones, emphasize family plans and stability.

-- Does the fact that the customer has a child correlate with “Churned”?
select customer_status,number_of_dependents,count(8)as total from telecom_dataset group by 1,2;

--  The average of referrals has correlation with customers’s status?
select customer_status,round(avg(number_of_referrals),2) from telecom_dataset group by 1;
-- Is possible analyse that maintaining high satisfaction among current customers could be key to generating new leads through referrals. Furthermore, it could be beneficial to investigate the reasons behind the low referral rate among churned customers to understand better why they left and how to prevent future churn.


-- What is the better offer for each customer’s status?
select customer_status,offer,count(offer)as total from telecom_dataset group by 1,2 order by 1,2 desc;
-- Here it’s important to note that the majority of customers who churned were associated with Offer E, which is also the only offer available to new customers who have joined. This suggests that Offer E, being exclusive to new consumers, may need to be reviewed in terms of its benefits. On the other hand, the predominant plan among customers who stayed is Offer B. Therefore, the company should analyze the features of Offer B compared to Offer E and consider enhancing the latter offer with some of the advantages of Offer B.

-- What is the average of tenure in months for each customer’s status?
select customer_status,avg(tenure_in_months)as average_tenure from telecom_dataset group by 1; 
-- The average tenure in months suggests that customers classified as “Churned” are more likely to switch companies after completing one year, given that the average tenure is around 18 months. Therefore, the company could consider introducing new offers for these customers after they complete one year to encourage them to stay.


--  What is the average monthly long distance charge for each customer’s status?
select customer_status ,round(avg(avg_monthly_long_distance_charges),2)as avg_monthly_long_distance_charge from telecom_dataset group by 1; 
-- Regarding the average monthly long-distance charges, it is not possible to draw any conclusions, as the average charge can be considered the same across all categories.


-- Total of multiple lines for each customer’s status

select customer_status,multiple_lines ,count(internet_service)as total  from telecom_dataset where internet_service is not null  group by 1,2;
-- Regarding the total of multiple lines for each customer’s status,it is not possible to draw any conclusions, as the total of multiples lines is balanced for all classes.

-- Total of internet service for each customer’s status

with count as(select customer_status,internet_service,count(*)as total from telecom_dataset where internet_service is not null  group by 1,2),
perstatus as (select customer_status,sum(total)as status_total from count group by 1)
select count.customer_status,internet_service,status_total ,round(total/status_total*100 ,2)as percentage from count join perstatus on count.customer_status=perstatus.customer_status;
--  With respect to the total number of “Churned” consumers with internet service, it is interesting to note that a large portion of them subscribed to the internet service. Therefore, the company should analyze the benefits of their plan to determine if improvements are needed to make it more competitive in the market. Perhaps this segment of consumers is switching to another company because they find the service better elsewhere.



-- Main internet type for each customer’s status -- 

select customer_status,internet_type,count(internet_type)as total from telecom_dataset where Internet_Type is not null group by 1,2 order by total desc;
-- Regarding this analysis, it is not possible to conclude anything definitive since the primary type of internet service for both the “Stayed” and “Churned” categories is the same. Therefore, it would be prudent to focus on other features to address this issue.


-- . What is the average of tenure in months for each customer’s status?
select customer_status,round(avg(tenure_in_months),2)as total from telecom_dataset group by 1;
--  The average tenure in months suggests that customers classified as “Churned” are more likely to switch companies after completing one year, given that the average tenure is around 18 months. Therefore, the company could consider introducing new offers for these customers after they complete one year to encourage them to stay.

--  What is the average monthly long distance charge for each customer’s status?
select  customer_status,round(avg(Avg_Monthly_Long_Distance_Charges),2)as total from telecom_dataset group by 1;
-- Regarding the average monthly long-distance charges, it is not possible to draw any conclusions, as the average charge can be considered the same across all categories.


--   Total of multiple lines for each customer’s status
select  customer_status,multiple_lines,count(multiple_lines)as total  from telecom_dataset where multiple_lines is not null group by 1,2 order by total desc;

-- Regarding the total of multiple lines for each customer’s status,it is not possible to draw any conclusions, as the total of multiples lines is balanced for all classes.



--  11. Total of internet service for each customer’s status.

with count_data as(select customer_status,internet_service,count(*)as total from telecom_dataset  where internet_type is not null group by customer_status,internet_service),
total_status as(select customer_status,sum(total)as status_total from count_data group by customer_status)
select count_data.customer_status,count_data.internet_service,count_data.total ,round((count_data.total/total_status.status_total*100),2)as percent from count_data join total_status
on count_data.customer_status=total_status .customer_status
order by count_data.customer_status desc ;
 --  With respect to the total number of “Churned” consumers with internet service, it is interesting to note that a large portion of them subscribed to the internet service. Therefore, the company should analyze the benefits of their plan to determine if improvements are needed to make it more competitive in the market. Perhaps this segment of consumers is switching to another company because they find the service better elsewhere.
 






--  Main internet type for each customer’s status
select customer_status,internet_type ,count(internet_type)as total from telecom_dataset where internet_type is not null group by 1,2 order by total desc;

-- Regarding this analysis, it is not possible to conclude anything definitive since the primary type of internet service for both the “Stayed” and “Churned” categories is the same. Therefore, it would be prudent to focus on other features to address this issue.

-- Average monthly of gb download for each customer’s status
select customer_status,round(avg(avg_monthly_gb_download),2)as total from telecom_dataset  where avg_monthly_gb_download is not null group  by 1 order by total desc;

-- This analysis reveals that users categorized as “Churned” consume less internet than other users. This suggests that these individuals may be encountering issues with using your service, could be people who are not accustomed to using the internet frequently and are not seeking to upgrade their network, or may find the company’s offerings to be expensive and prefer to switch to a different company for this reason. The company can create strategics to incetivate this users to use more internet with a promotional offer and conducting customer satisfaction surveys.


--  Proportion of user that has online security for each customer’s status
with total_status as(select customer_status,count(*)as total_status from telecom_dataset as b where online_security is not null  group by 1)
select  a.customer_status,a.online_security,round(count(online_security)*100/b.total_status,2)as percentage from telecom_dataset a join total_status b on a.customer_status=b.customer_status
where a.online_security is not null
group by a.customer_status,a.online_security,b.total_status
order by a.customer_status desc ,a.online_security desc;

--  It can be observed that customers who subscribe to online security services are more likely to remain with the company. A closer examination of the “Stayed” category reveals a higher proportion of users who have opted for online security compared to those who have not. This suggests that the company could benefit from developing strategic initiatives to present more attractive offers to its customers. It is important to understand whether the cost of the service is prohibitive or if the benefits offered do not sufficiently capture the customers’ attention.


-- Proportion of user that has online backup for each customer’s status

with total as(select customer_status,count(*)as total_perstatus from telecom_dataset a where online_backup is not null  group by customer_status)
select a.customer_status,a.online_backup ,count(b.online_backup)as total,round(count(a.online_backup)*100/b.total_per_status,2)as percentage
from telecom_dataset b join total_status a on a.customer_status=b.customer_status where a.online_backup is not null
GROUP BY b.Customer_Status, b.Online_Backup, a.TotalPerStatus
ORDER BY b.Customer_Status, Total DESC;

-- . Proportion of user that has device protection plan for each customer’s status
with total as (select customer_status,count(*)as total from telecom_dataset where device_protection_plan is not null group by customer_status)
select total.customer_status,t.device_protection_plan,count(device_protection_plan)as total_status,
round((count(t.device_protection_plan)*100.0/total.total),2)as percent
from telecom_dataset t join total on total.customer_status=t.customer_status where t.device_protection_plan is not null
group by t.customer_status,t.device_protection_plan,total.total order by total.customer_status,total_status desc;
-- Here we encounter a similar concept: customers who do not have a device protection plan are more likely to churn. This suggests that the company needs to understand why they are opting out of this service and how it can be improved to better serve their needs.


--  Proportion of user that has premium tech support plan for each customer’s status

with total as(select customer_status ,count(*)as total from telecom_dataset  where premium_tech_support is not null group by customer_status)
select b.customer_status,b.premium_tech_support ,count(b.premium_tech_support)as total_status,
round(count(b.premium_tech_support)*100/total.total,2)as percent
from telecom_dataset b  join total on total.customer_status=b.customer_status where b.premium_tech_support is not null 
group by  b.customer_status,b.premium_tech_support,total order by b.customer_status,total desc;
-- An analysis of the customers labeled as ‘Churned’ suggests that those who do not subscribe to premium tech support are more likely to switch to another company. Again, it would be beneficial for the company to devise new strategies to encourage these customers to adopt this offer by understanding their reasons for declining it and how this impacts retention.


-- Proportion of user that has streaming TV plan for each customer’s status
with totalcount as (select customer_status,count(*)as total from telecom_dataset where streaming_tv is not null group by customer_status)
select a.customer_status,streaming_tv,count(streaming_tv)as total_status,round(count(a.streaming_tv)/totalcount.total*100,2)as percent
from telecom_dataset a join totalcount on totalcount.customer_status=a.customer_status
where streaming_tv is not null group by a.customer_status,a.streaming_tv,totalcount.total order by a.customer_status,total desc; 

--  With respect to customer’s that have or don’t have stream TV plan this can not suggest nothing because exist a proportion of customers classified as “Churned” and “Stayed” in this feature.


-- Proportion of user that has streaming movies plan for each customer’s status
with totalcount as (select customer_status ,count(*)as total from telecom_dataset where streaming_movies is not null group by customer_status)
select b.customer_status,streaming_movies,count(b.streaming_movies)as total_count,round(count(b.streaming_movies)/totalcount.total*100.0,2)as percent
from telecom_dataset b join totalcount on totalcount.customer_status=b.customer_status where streaming_movies is not null
group by b.customer_status,b.streaming_movies,totalcount.total order by b.customer_status,total desc;
-- With respect to customer’s that have or don’t have streaming movies plan this can not suggest nothing again, because exist a proportion of customers classified as “Churned” and “Stayed” in this feature.

--  Proportion of user that has streaming music plan for each customer’s status
with totalcount as(select customer_status,count(*)as total from telecom_dataset where streaming_music is not null group by customer_status )
select b.customer_status,b.streaming_music,count(streaming_music)as total_streaming_music ,round(count(b.streaming_music)/totalcount.total*100,2)as percent
from telecom_dataset b join totalcount on totalcount.customer_status=b.customer_status
where streaming_movies is not null group by b.customer_status,b.streaming_music,totalcount.total order by b.customer_status,total desc;

-- Although here we have a similar proportion on the classes mencioned, there is a little diffent in total customers classfied as “Churned”. The company can study if there are correlation betwen the user that dont have streaming music plan with “Churned”.


-- . Proportion of user that has unlimited data plan for each customer’s status
with countdata as(select customer_status,count(*)as total from telecom_dataset  where unlimited_data is not null group by customer_status)
select a.customer_status,unlimited_data,count(unlimited_data)as total_user,round(count(unlimited_data)*100.0/total,2)as percent from telecom_dataset a join countdata
on countdata .customer_status=a.customer_status where unlimited_data is not null
group by a.customer_status,a.unlimited_data order by a.customer_status,total desc;
--  From the analysis, we discern that all classes of customers have a similar disproportion. So apparently this suggest that this feature can not help in nothing to understand the reason behind of customers “Churned”.

--  More used type of contract by each customer’s status
with countdata as(select customer_status,count(*)as total from telecom_dataset where contract is not null group by customer_status)
select a.customer_status,contract,count(contract)as total_count,round(count(contract)*100.0/total,2)as percent_total from telecom_dataset a 
join countdata on a.customer_status=countdata.customer_status where contract is not null
group by a.customer_status,a.contract,countdata.total order by customer_status,total desc;
-- We can see that new users tend to prefer month-to-month contracts, possibly to evaluate the company before committing to a longer-term agreement. Among customers who have stayed, two-year contracts are most prevalent, suggesting that those with longer commitments are more likely to remain with the company. The majority of churned customers were on month-to-month plans, indicating a need for the company to explore ways to encourage these individuals to consider longer-term options. Additionally, a deeper analysis is warranted to understand why one-year contracts are the least favored.


--  Average of monthly charge for each customer’s status
select customer_status,round(avg(monthly_charge),2)as monthly_average_charge from telecom_dataset group by customer_status order by customer_status desc;
-- Customers labeled as “Churned” tend to have higher payments, suggesting that the month-to-month contract may be more costly, possibly due to these customers utilizing the full range of plan benefits and then requiring additional services. This could indicate that the month-to-month plan does not fully meet their needs, prompting them to seek better options elsewhere


--  Average of total charge for each customer’s status

select customer_status,round(avg(total_charges),2)as total_charges_average from telecom_dataset group by customer_status order by customer_status desc;
-- From this feature we can not conclude nothing without know how much time each class of customers was/are in the company and we don’t have this data disponible. So its obvious that who just joined will have less charges and consequently if the customers classified as “Churned” have less days inside the company they will have less charge too and to finish the class “Stayed” will have most charge.


--  Average of total refunds for each customer’s status
select customer_status,round(avg(total_refunds),2)as average_total_refunds from telecom_dataset group by customer_status order by customer_status desc;
-- Here we have the same analysis of the last feature, to conclude something most deep it’s necessary have more data to correlation with this results like average of time that this costumers was/are in the company.


-- Average of total long distance charges for each customer’s status
select customer_status,round(avg(total_long_distance_charges),2)as avg_long_distance_charges from telecom_dataset group by customer_status order by customer_status desc;
-- Here we have the same analysis of the last feature, to conclude something most deep it’s necessary have more data to correlation with this results like average of time that this costumers was/are in the company.

-- Average of total revenue for each customer’s status
select customer_status ,round(avg(total_revenue),2)as average_total_revenue from telecom_dataset group by customer_status order by customer_status desc;
-- Here we have the same analysis of the last feature, to conclude something most deep it’s necessary have more data to correlation with this results like average of time that this costumers was/are in the company.
-- FOR KPI OF RATE % IN POWER BI
create view rate as
select count(case when customer_status='Churned' then 1 end)as churned_customer,
count(case when customer_status='Joined' then 1 end)as Joined_customer,
count(case when customer_status='Stayed' then 1 end)as Stayed_customer,
round(count(case when customer_status='Churned' then 1 end)/count(*)*100,2 )as churned_percentage_customers,
round(count(case when customer_status='Joined' then 1 end)/count(*)*100,2 )as joined_percentage_customers,
round(count(case when customer_status='Stayed' then 1 end)/count(*)*100,2 )as stayed_percentage_customers
from telecom_dataset ;











 













