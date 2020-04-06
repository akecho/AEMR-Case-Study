--AEMR Case. SQL Queries to Retrieve Data
--AEMR Case Study|
--Ask exploratory questions and use SQL queries to answer them.
--Questions are divided into separate sections.
-------------------
-- Question 1.1
SELECT COUNT(status='Approved') AS Total_Number_Outage_Events, Status, Reason
FROM AEMR
WHERE Year(start_time) = 2016 AND status='Approved'
GROUP BY Status, Reason
ORDER BY reason
-----------------------------------------------------------------------------
-- Question 1.3
SELECT COUNT(status='Approved') AS Total_Number_Outage_Events, Status, Reason
FROM AEMR
WHERE Year(start_time) = 2017 AND status='Approved'
GROUP BY Status, Reason
ORDER BY reason

--Solution Query
SELECT
	Count(*) as Total_Number_Outage_Events
        ,Status
	,Reason
FROM
	AEMR
WHERE
	Status='Approved'
	AND YEAR(Start_Time)=2017
GROUP BY
	Status
	,Reason
ORDER BY
	Reason
-----------------------------------------------------------------------------
-- Question 1.5
SELECT Status, 
       Reason, 
       count(reason) AS Total_Number_Outage_Events,
       ROUND(AVG(TIMESTAMPDIFF(minute, start_time, end_time)/1440), 2) AS Average_Outage_Duration_Time_Days, 
       year(start_time) AS Year
FROM AEMR
WHERE year(start_time) IN('2016', '2017') AND status='Approved'
GROUP BY status, reason, year(start_time)
ORDER BY reason, year

--Solution Query
SELECT
	Status
	,Reason
	,Count(*) as Total_Number_Outage_Events
	,ROUND(AVG(ROUND((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/60)/24,2)),2) AS Average_Outage_Duration_Time_Days
	,YEAR(Start_Time) as Year
FROM
	AEMR
WHERE
	Status='Approved'
GROUP BY
	Status
	,Reason
	,YEAR(Start_Time)
ORDER BY
    YEAR(Start_Time)
	,Reason
-----------------------------------------------------------------------------
--Question 2.1
SELECT Status, 
       Reason,
       count(month(start_time)) AS Total_Number_Outage_Events,
       month(start_time) AS Month
FROM AEMR
WHERE year(start_time) IN('2016') AND 
      status IN('Approved')
GROUP BY status, reason, month(start_time)
ORDER BY reason, month(start_time)

--Solution Query
SELECT
	Status
	,Reason
	,Count(*) as Total_Number_Outage_Events
	,Month(Start_Time) as Month
FROM
	AEMR
WHERE
	Status='Approved'
	AND YEAR(Start_Time) = 2016
GROUP BY
	Status
	,Reason
	,Month(Start_Time)
ORDER BY
	Reason
          ,Month
-----------------------------------------------------------------------------
--Question 2.2
SELECT Status, Reason, 
       count(month(start_time)) AS Total_Number_Outage_Events,
       month(start_time) AS Month
FROM AEMR
WHERE status ='Approved' AND year(start_time) = 2017
GROUP BY reason, month(start_time)
ORDER BY reason, month(start_time)

--Solution Query
SELECT
	Status
	,Reason
	,Count(*) as Total_Number_Outage_Events
	,Month(Start_Time) as Month
FROM
	AEMR
WHERE
	Status='Approved'
	AND YEAR(Start_Time) = 2017
GROUP BY
	Status
	,Reason
	,Month(Start_Time)
ORDER BY
	Reason
          ,Month
-------------------------------------------------------------------------------
--Question 2.3
SELECT Status, 
       SUM(status IN('Approved')) AS Total_Number_Outage_Events,
       month(start_time) AS Month,
       year(start_time) AS Year
FROM AEMR
WHERE year(start_time) IN('2016', '2017') AND 
      status IN('Approved')
GROUP BY status, month(start_time), year(start_time)
ORDER BY year(start_time), month(start_time)

--Solution Query
SELECT
	Status
	,Count(*) as Total_Number_Outage_Events
	,Month(Start_Time) as Month
	,Year(Start_Time) as Year
FROM
	AEMR
WHERE
	Status='Approved'
GROUP BY
	Status
	,Month(Start_Time)
	,Year(Start_Time)
ORDER BY
	Year(Start_Time)
	,Month(Start_Time)
-----------------------------------------------------------------------------
--Question 3.1
SELECT SUM(status IN('Approved')) AS Total_Number_Outage_Events, 
       Participant_Code, 
       Status,
       year(start_time) AS Year
FROM AEMR
WHERE year(start_time) IN('2016', '2017') AND 
      status IN('Approved')
GROUP BY status, year(start_time), Participant_Code
ORDER BY year(start_time), Participant_Code

--Solution Query
SELECT
	Count(*) as Total_Number_Outage_Events
	,(Participant_Code)
	,Status
	,Year(Start_Time) as Year
FROM
	AEMR
WHERE
	Status='Approved'
GROUP BY
	(Participant_Code)
	,Status
	,Year(Start_Time)
ORDER BY 
	Year(Start_Time)
	,(Participant_Code)
-----------------------------------------------------------------------------
--Question 3.2  
SELECT Participant_Code, 
       Status,
       year(start_time) AS Year,
       ROUND(AVG(ROUND((TIMESTAMPDIFF(minute, start_time, end_time)/1440), 2)), 2) AS Average_Outage_Duration_Time_Days
FROM AEMR
WHERE year(start_time) IN('2016', '2017') AND 
      status IN('Approved')
GROUP BY status, year, Participant_Code
ORDER BY year, Average_Outage_Duration_Time_Days DESC

Solution Query
SELECT
	Participant_Code
	,Status
	,Year(Start_Time) as Year
	,ROUND(AVG(ROUND((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/60)/24,2)),2) AS Average_Outage_Duration_Time_Days
FROM
	AEMR
WHERE
	Status='Approved'
GROUP BY
	Participant_Code
	,Status
	,Year(Start_Time)
ORDER BY 
	Year(Start_Time)
	,CAST(Avg(CAST(TIMESTAMPDIFF(DAY,Start_Time,End_Time)AS DECIMAL(18,2))) AS DECIMAL(18,2)) DESC

-----------------------------------------------------------------------------

---PART 2
-- Question 1.1
SELECT count(reason IN('Forced')) AS Total_Number_Outage_Events,
       Reason,
       year(start_time) AS Year
FROM AEMR
WHERE status IN('Approved') AND
      reason IN('Forced')
GROUP BY Reason, 
         Year

--Solution Query
SELECT
	Count(*) as Total_Number_Outage_Events
	,Reason
	,Year(Start_Time) as Year
FROM
AEMR
WHERE
	Reason='Forced'
	AND Status = 'Approved'
GROUP BY
	Reason
	,Year(Start_Time)
-----------------------------------------------------------------------------
-- Question 1.2 
SELECT SUM(CASE WHEN reason ='Forced'
           THEN 1 ELSE 0 END)
                  AS Total_Number_Forced_Outage_Events,
       COUNT(*) AS Total_Number_Outage_Events,
       
       ROUND(100 * (SUM(CASE WHEN reason ='Forced' 
           THEN 1 ELSE 0 END) / COUNT(*)), 2) AS Forced_Outage_Percentage,
       
       year(start_time) AS Year
FROM AEMR
WHERE status IN('Approved')
GROUP BY Year

--Solution Query
SELECT
	SUM(CASE WHEN Reason = 'Forced' THEN 1 ELSE 0 END) as Total_Number_Forced_Outage_Events
	,Count(*) as Total_Number_Outage_Events
	,CAST((CAST(SUM(CASE WHEN Reason = 'Forced' THEN 1 ELSE 0 END)AS DECIMAL(18,2))/CAST(Count(*) AS DECIMAL(18,2)))*100 AS DECIMAL(18,2)) as Forced_Outage_Percentage
	,Year(Start_Time) as Year
FROM
	AEMR
WHERE
	Status = 'Approved'
GROUP BY
	Year(Start_Time)

-----------------------------------------------------------------------------
-- Question 2.1
SELECT Status,
       year(start_time) AS Year, 
       ROUND(AVG(Outage_MW), 2) AS Avg_Outage_MW_Loss, 
       ROUND(AVG(ROUND((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)),2)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR
WHERE status ='Approved' AND reason = 'Forced'
GROUP BY year(start_time)
ORDER BY year(start_time)

--Solution Query
SELECT 
	Status
	,Year(Start_Time) AS Year
	,ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss
	,Cast(ROUND(AVG(Cast(TIMESTAMPDIFF(MINUTE, Start_Time, End_Time) AS DECIMAL(18,2))),2) AS DECIMAL(18,2)) AS Average_Outage_Duration_Time_Minutes
FROM 
	AEMR
WHERE 
	Status='Approved' 
	And Reason='Forced'
GROUP BY 
	Status
	,Year(Start_Time)
ORDER BY 
	Year(Start_Time)
    
-----------------------------------------------------------------------------
-- Question 2.2
SELECT Status, Reason,
       year(start_time) AS Year, 
       ROUND(AVG(Outage_MW), 2) AS Avg_Outage_MW_Loss, 
       ROUND(AVG(ROUND((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)),2)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR
WHERE status ='Approved'
GROUP BY reason, year(start_time)
ORDER BY year(start_time) 

--Solution Query
SELECT 
	Status
	,Reason
	,Year(Start_Time) AS Year
	,ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss
	,Cast(ROUND(AVG(Cast(TIMESTAMPDIFF(MINUTE, Start_Time, End_Time) AS DECIMAL(18,2))),2) AS DECIMAL(18,2)) AS Average_Outage_Duration_Time_Minutes
FROM 
	AEMR
WHERE 
	Status='Approved' 
GROUP BY 
	Status
	,Reason
	,Year(Start_Time)
ORDER BY 
	Year(Start_Time)
	,Reason

-------------------------------------------------------------------------------
-- Question 3.1
SELECT Participant_Code, Status,
       year(start_time) AS Year,
       ROUND(AVG(Outage_MW), 2) AS Avg_Outage_MW_Loss,
       ROUND(AVG(ROUND((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/1440),2)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR
WHERE status ='Approved' AND reason = 'Forced'
GROUP BY year(start_time), Participant_Code
ORDER BY year(start_time), Avg_Outage_MW_Loss DESC

--Solution Query
SELECT 
	Participant_Code
	,Status
	,Year(Start_Time) AS Year
	,ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss
	,ROUND(AVG(ROUND((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/60)/24,2)),2) AS Average_Outage_Duration_Time_Minutes
FROM 
	AEMR
WHERE 
	Status='Approved' 
	AND Reason='Forced'
GROUP BY 
	Participant_Code
	,Status
	,Reason
	,Year(Start_Time)
ORDER BY 
	Year(Start_Time) ASC
	,ROUND(AVG(Outage_MW),2) DESC
-----------------------------------------------------------------------------
-- Question 3.2
SELECT Participant_Code, Facility_Code, Status,
       year(start_time) AS Year,
       ROUND(AVG(Outage_MW), 2) AS Avg_Outage_MW_Loss,
       ROUND(SUM(Outage_MW), 2) AS Summed_Energy_Lost
FROM AEMR
WHERE status ='Approved' AND reason = 'Forced'
GROUP BY year(start_time), Participant_Code, Facility_Code
ORDER BY year(start_time), Avg_Outage_MW_Loss DESC

--Solution Query
SELECT 
	Participant_Code
	,Facility_Code
	,Status
	,Year(Start_Time) AS Year
	,ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss
	,ROUND(SUM(Outage_MW),2) AS Summed_Energy_Lost
FROM 
	AEMR
WHERE 
	Status='Approved' 
	AND Reason='Forced'
GROUP BY 
	Participant_Code
	,Facility_Code
	,Status
	,Year(Start_Time)
ORDER BY 
	Year(Start_Time) ASC
	,ROUND(SUM(Outage_MW),2) DESC
-----------------------------------------------------------------------------







