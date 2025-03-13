
# <h1 align="center">Olympic-Games-SQL</h1>
------------------------


## OVERVIEW
The Olympic dataset provides overview on athlete participation in different olympic games 








#  <h1 align="center"> QUESTIONS AND SOLUTION </h1>
 --------------------------------

###  1. How many olympics games have been held?

```sql
 SELECT COUNT (DISTINCT Games) AS CountOfGames
FROM Olympics..events

```
![Image](https://github.com/user-attachments/assets/730e29ef-8f96-47da-8d8f-54a2a399e83c)


###  2.	List down all Olympics games held so far.

```sql
SELECT DISTINCT (Games) AS Games
FROM Olympics..events
ORDER BY Games ASC
```
![Image](https://github.com/user-attachments/assets/ab713561-4aac-47d7-a03d-9a25bf3000ce)

###  3.	Mention the total no of nations who participated in each olympics game?

```sql
SELECT r.region, COUNT(DISTINCT e.Games) AS CountOfGames
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
GROUP BY r.region
ORDER BY CountOfGames DESC
```
![Image](https://github.com/user-attachments/assets/52db3601-18c6-40dc-934f-f1603aec8dc7)


###  4.	Which year saw the highest and lowest no of countries participating in olympics? 
--LOWEST

```sql
SELECT TOP 1 Year, COUNT (DISTINCT NOC) AS CountOfCountries
FROM Olympics..events
GROUP BY Year
ORDER BY CountOfCountries
```

--HIGHEST

```sql
SELECT TOP 1 Year, COUNT (DISTINCT NOC) AS CountOfCountries
FROM Olympics..events
GROUP BY Year
ORDER BY CountOfCountries DESC
```
![Image](https://github.com/user-attachments/assets/835420da-faba-4e60-991f-7864e940e5d4)


### 5.	Which nation has participated in all of the olympic games?

```sql
SELECT Team, Count (Distinct Games) AS Total_Games_Count
FROM Olympics..events
GROUP BY Team
HAVING Count (Distinct Games) IN
(SELECT Count (Distinct Games) AS Games_Count
FROM Olympics..events)
```
![Image](https://github.com/user-attachments/assets/2e48695c-72f3-445d-83c9-ee217772e41f)


### 6.	Identify the sport which was played in all summer olympics.

```sql
SELECT DISTINCT (Sport)
FROM Olympics..events
WHERE Season = 'Summer'
```
![Image](https://github.com/user-attachments/assets/9392c2d0-18da-4211-b249-d4e7ae7181b0)


### 7.	Which Sports were just played only once in the olympics?

```sql
SELECT  Sport, COUNT (Sport) AS CountOfSport
FROM Olympics..events
GROUP BY Sport
HAVING COUNT (Sport) = 1
```
![Image](https://github.com/user-attachments/assets/6cbd3199-17e8-4f4c-9e60-746138dcf7e2)


### 8.	Fetch the total no of sports played in each olympic games.

```sql
SELECT Games ,COUNT (DISTINCT Sport) AS Sport_Count
FROM Olympics..events
GROUP BY Games
ORDER BY  Games ASC
```
![Image](https://github.com/user-attachments/assets/9cc4b502-188b-468d-9d0f-4d130a81b568)


### 9.	Fetch details of the oldest athletes to win a gold medal. 

```sql
SELECT *
FROM Olympics..events
WHERE Medal = 'Gold' AND Age = 
(
SELECT MAX(Age) AS Max_Age --- MAX AGE
FROM Olympics..events
WHERE Medal = 'Gold'
)
```
![Image](https://github.com/user-attachments/assets/05b5d328-661c-4ebb-b90b-d3206c52f38e)

### 10.	Find the Ratio of male and female athletes participated in all Olympic games. 

```sql
WITH Athlete_Count AS
(
SELECT Sex,COUNT(DISTINCT ID) AS Male_Distinct_Count
FROM Olympics..events
WHERE Sex = 'M'
--GROUP BY Sex
)
SELECT    Male_Distinct_Count/  COUNT(DISTINCT ID) * 100 AS Male_percent
FROM Athlete_Count 
JOIN Olympics..events 
--WHERE Sex = 'M'
GROUP BY Sex
```


### 11.	Fetch the top 5 athletes who have won the most gold medals.

```sql
SELECT TOP 5 Name, COUNT(Medal) AS Count_Of_Gold_Medals
FROM Olympics..events
WHERE Medal = 'Gold'
GROUP BY Name
ORDER BY Count_Of_Gold_Medals DESC
```
![Image](https://github.com/user-attachments/assets/4849a4bd-cf43-4fe3-bdfb-bcbf26ee84ae)

### 12.	Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
```sql
SELECT TOP 5 Name, COUNT(Medal) AS Count_Of_Medals
FROM Olympics..events
GROUP BY Name
ORDER BY Count_Of_Medals DESC
```
![Image](https://github.com/user-attachments/assets/9f98ad1d-8040-4672-9176-209bedeca11c)


### 13.	Fetch the top 5 most successful countries in Olympics. Success is defined by no of medals won.

```sql
SELECT TOP 5 r.region, Count (e.Medal) AS Count_Of_Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
GROUP BY r.region
ORDER BY Count_Of_Medals DESC
```
![Image](https://github.com/user-attachments/assets/6a73024b-7d52-4062-9ff3-2d8c7278961c)

### 14.	List down total gold, silver and bronze medals won by each country.

```sql
SELECT r.region, e.Medal
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
WHERE e.Medal IS NOT NULL
```
![Image](https://github.com/user-attachments/assets/e7cb1086-17ac-4129-ad38-5a80e3a49485)


### 15.	List down total gold, silver and bronze medals won by each country corresponding to each Olympic games.
```sql
SELECT r.region, LAG(e.Medal) OVER (PARTITION BY e.Games ORDER BY r.region) AS Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
ORDER BY r.region
```
![Image](https://github.com/user-attachments/assets/74514b22-30e8-4fb5-acb7-a4ec9f56168b)


### 16.	Identify which country won the most gold, most silver and most bronze medals in each olympic games.

--MOST GOLD MEDAL WON BY COUNTRY

```sql
SELECT TOP 1 r.region, COUNT (Medal) AS Count_Of_Gold_Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
WHERE Medal = 'Gold' 
GROUP BY r.region
ORDER BY Count_Of_Gold_Medals DESC
```

--MOST SILVER MEDAL WON BY COUNTRY
```sql
SELECT TOP 1 r.region, COUNT (Medal) AS Count_Of_Silver_Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
WHERE Medal = 'Silver' 
GROUP BY r.region
ORDER BY Count_Of_Silver_Medals DESC
```

--MOST BRONZE MEDAL WON BY COUNTRY
```sql
SELECT TOP 1 r.region, COUNT (Medal) AS Count_Of_Bronze_Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
WHERE Medal = 'Bronze' 
GROUP BY r.region
ORDER BY Count_Of_Bronze_Medals DESC
```
![Image](https://github.com/user-attachments/assets/d984f059-4724-4f2a-a6ed-c51d9c44a719)

### 17.	Identify which country won the most gold, most silver, most bronze medals and the most medals in each Olympic games.

--MOST GOLD MEDAL BY COUNTRY 
```sql
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
SELECT  region, Games, Gold_Medals
FROM CTE 
WHERE RANK = 1
```
![Image](https://github.com/user-attachments/assets/bdc3b6d2-91d6-4e5b-84f0-719ffb83fe55)

--MOST SILVER MEDAL BY COUNTRY 

```sql
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
SELECT  region, Games,Silver_Medals
FROM CTE 
WHERE RANK = 1
```
![Image](https://github.com/user-attachments/assets/0436b8be-7901-4f47-be8c-02703afcf22b)

--MOST BRONZE MEDAL BY COUNTRY 

```sql
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
```
![Image](https://github.com/user-attachments/assets/83bc52a0-6bdd-41c2-85b9-672e8f906e0e)

### 18.	Which countries have never won gold medal but have won silver/bronze medals?

--COUNTRIES WITHOUT GOLD MEDAL--- (Apparently, there is no country without a Gold Medal)
```sql

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
```
![Image](https://github.com/user-attachments/assets/c645de9c-8803-4c9b-996e-0a7ed202f1af)



### 19.	In which Sport/event, India has won highest medals.
```sql
SELECT TOP 1 e.Sport, COUNT(Medal) AS Count_Of_Medal
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC 
WHERE r.region = 'India'
GROUP BY e.Sport 
ORDER BY Count_Of_Medal DESC
```
![Image](https://github.com/user-attachments/assets/b43ba552-2e17-409d-a7af-a2b224159291)

### 20.	Break down all Olympic games where india won medal for Hockey and how many medals in each Olympic games.

```sql
SELECT DISTINCT (e.Games), e.Medal, COUNT(e.Medal) Count_Of_Medal
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC 
WHERE r.region = 'India' AND Sport = 'Hockey' AND e.Medal IS NOT NULL
GROUP BY e.Games, e.Medal
ORDER BY e.Games ASC
```
![Image](https://github.com/user-attachments/assets/d91bc8c9-a962-4b31-bc0e-dc96d8ab9f0f)
