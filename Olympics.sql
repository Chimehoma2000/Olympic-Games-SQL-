


--List of SQL Queries:

--1.	How many olympics games have been held?

SELECT COUNT (DISTINCT Games) AS CountOfGames
FROM Olympics..events

--2.	List down all Olympics games held so far.

SELECT DISTINCT (Games) AS Games
FROM Olympics..events
ORDER BY Games ASC

--3.	Mention the total no of nations who participated in each olympics game?

SELECT r.region, COUNT(DISTINCT e.Games) AS CountOfGames
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
GROUP BY r.region
ORDER BY CountOfGames DESC

--4.	Which year saw the highest and lowest no of countries participating in olympics? 

--LOWEST

SELECT TOP 1 Year, COUNT (DISTINCT NOC) AS CountOfCountries
FROM Olympics..events
GROUP BY Year
ORDER BY CountOfCountries

--HIGHEST
SELECT TOP 1 Year, COUNT (DISTINCT NOC) AS CountOfCountries
FROM Olympics..events
GROUP BY Year
ORDER BY CountOfCountries DESC

--5.	Which nation has participated in all of the olympic games?


SELECT Team, Count (Distinct Games) AS Total_Games_Count
FROM Olympics..events
GROUP BY Team
HAVING Count (Distinct Games) IN
(SELECT Count (Distinct Games) AS Games_Count
FROM Olympics..events)



--6.	Identify the sport which was played in all summer olympics.

SELECT DISTINCT (Sport)
FROM Olympics..events
WHERE Season = 'Summer'

--7.	Which Sports were just played only once in the olympics?

SELECT  Sport, COUNT (Sport) AS CountOfSport
FROM Olympics..events
GROUP BY Sport
HAVING COUNT (Sport) = 1

--8.	Fetch the total no of sports played in each olympic games.

SELECT Games ,COUNT (DISTINCT Sport) AS Sport_Count
FROM Olympics..events
GROUP BY Games
ORDER BY  Games ASC

--9.	Fetch details of the oldest athletes to win a gold medal. ---STUDY THIS QUERY

SELECT *
FROM Olympics..events
WHERE Medal = 'Gold' AND Age = 
(
SELECT MAX(Age) AS Max_Age --- MAX AGE
FROM Olympics..events
WHERE Medal = 'Gold'
)

--10.	Find the Ratio of male and female athletes that participated in all Olympic games. -- NOT ANSWERED


SELECT 
    Sex, 
    COUNT(DISTINCT Name) AS gender_count,
    COUNT(DISTINCT Name) * 100 / SUM(COUNT(DISTINCT Name)) OVER() AS proportion_percentage
FROM Olympics..events
GROUP BY Sex


--11.	Fetch the top 5 athletes who have won the most gold medals.

SELECT TOP 5 Name, COUNT(Medal) AS Count_Of_Gold_Medals
FROM Olympics..events
WHERE Medal = 'Gold'
GROUP BY Name
ORDER BY Count_Of_Gold_Medals DESC

--12.	Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

SELECT TOP 5 Name, COUNT(Medal) AS Count_Of_Medals
FROM Olympics..events
GROUP BY Name
ORDER BY Count_Of_Medals DESC

--13.	Fetch the top 5 most successful countries in Olympics. Success is defined by no of medals won.

SELECT TOP 5 r.region, Count (e.Medal) AS Count_Of_Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
GROUP BY r.region
ORDER BY Count_Of_Medals DESC

--14.	List down total gold, silver and bronze medals won by each country.

SELECT r.region, e.Medal
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
WHERE e.Medal IS NOT NULL



--15.	List down total gold, silver and bronze medals won by each country corresponding to each Olympic games.

SELECT r.region, LAG(e.Medal) OVER (PARTITION BY e.Games ORDER BY r.region) AS Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
ORDER BY r.region

--16.	Identify which country won the most gold, most silver and most bronze medals in each olympic games.

--MOST GOLD MEDAL WON BY COUNTRY

SELECT TOP 1 r.region, COUNT (Medal) AS Count_Of_Gold_Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
WHERE Medal = 'Gold' 
GROUP BY r.region
ORDER BY Count_Of_Gold_Medals DESC

--MOST SILVER MEDAL WON BY COUNTRY

SELECT TOP 1 r.region, COUNT (Medal) AS Count_Of_Silver_Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
WHERE Medal = 'Silver' 
GROUP BY r.region
ORDER BY Count_Of_Silver_Medals DESC

--MOST BRONZE MEDAL WON BY COUNTRY

SELECT TOP 1 r.region, COUNT (Medal) AS Count_Of_Bronze_Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
WHERE Medal = 'Bronze' 
GROUP BY r.region
ORDER BY Count_Of_Bronze_Medals DESC

--17.	Identify which country won the most gold, most silver, most bronze medals and the most medals in each Olympic games.

--MOST GOLD MEDAL BY COUNTRY 

WITH CTE AS
(
SELECT   r.region, e.Games, COUNT (e.Medal) AS Gold_Medals,
RANK() OVER (PARTITION BY e.Games ORDER BY COUNT (e.Medal) DESC) AS RANK
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC 
WHERE Medal = 'Gold'
GROUP BY r.region, e.Games
)
SELECT   Games, region,Gold_Medals
FROM CTE 
WHERE RANK = 1

--MOST SILVER MEDAL BY COUNTRY 

WITH CTE AS
(
SELECT   r.region, e.Games, COUNT (e.Medal) AS Silver_Medals,
RANK() OVER (PARTITION BY e.Games ORDER BY COUNT (e.Medal) DESC) AS RANK
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC 
WHERE Medal = 'Silver'
GROUP BY r.region, e.Games
)
SELECT  Games, region,Silver_Medals
FROM CTE 
WHERE RANK = 1

--MOST BRONZE MEDAL BY COUNTRY 

WITH CTE AS
(
SELECT   r.region, e.Games, COUNT (e.Medal) AS Bronze_Medals,
RANK() OVER (PARTITION BY e.Games ORDER BY COUNT (e.Medal) DESC) AS RANK
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC 
WHERE Medal = 'Bronze'
GROUP BY r.region, e.Games
)
SELECT  Games, region,Bronze_Medals
FROM CTE 
WHERE RANK = 1

--18.	Which countries have never won gold medal but have won silver/bronze medals?

--COUNTRIES WITHOUT GOLD MEDAL--- (Apparently, there is no country without a Gold Medal)

WITH Medals AS
(
SELECT Team ,  Medal,
CASE 
	WHEN Medal = 'Gold' THEN '1'
	ELSE 'NULL'
END AS GoldCount
FROM Olympics..events
WHERE Medal IS NOT NULL
)

SELECT Team, COUNT (GoldCount) AS Gold_Medal_Count
FROM Medals 
GROUP BY Team
ORDER BY COUNT (GoldCount) ASC




--19.	In which Sport/event, India has won highest medals.

SELECT TOP 1 e.Sport, COUNT(Medal) AS Count_Of_Medal
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC 
WHERE r.region = 'India'
GROUP BY e.Sport 
ORDER BY Count_Of_Medal DESC

--20.	Break down all Olympic games where india won medal for Hockey and how many medals in each Olympic games.

SELECT DISTINCT (e.Games), e.Medal, COUNT(e.Medal) Count_Of_Medal
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC 
WHERE r.region = 'India' AND Sport = 'Hockey' AND e.Medal IS NOT NULL
GROUP BY e.Games, e.Medal
ORDER BY e.Games ASC