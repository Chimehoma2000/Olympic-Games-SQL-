
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



###  2.	List down all Olympics games held so far.

```sql
SELECT DISTINCT (Games) AS Games
FROM Olympics..events
ORDER BY Games ASC
```


###  3.	Mention the total no of nations who participated in each olympics game?

```sql
SELECT r.region, COUNT(DISTINCT e.Games) AS CountOfGames
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
GROUP BY r.region
ORDER BY CountOfGames DESC
```
![Image](https://github.com/user-attachments/assets/ba1498f6-d912-4007-8280-c771bc4c0c07)




###  4.	Which year saw the highest and lowest no of countries participating in olympics? 
![Image](https://github.com/user-attachments/assets/c4d52819-a16c-447f-a888-6836b9f2802c)


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



### 5.	Which nation has participated in all of the olympic games?
![Image](https://github.com/user-attachments/assets/b05e5b6d-2a2d-42ce-98d2-c11955de947a)


```sql
SELECT Team, Count (Distinct Games) AS Total_Games_Count
FROM Olympics..events
GROUP BY Team
HAVING Count (Distinct Games) IN
(SELECT Count (Distinct Games) AS Games_Count
FROM Olympics..events)
```



### 6.	Identify the sport which was played in all summer olympics.

![Image](https://github.com/user-attachments/assets/a647abf8-a4fc-4bf2-b5ef-1a1ea14c633b)


```sql
SELECT DISTINCT (Sport)
FROM Olympics..events
WHERE Season = 'Summer'
```



### 7.	Which Sports were just played only once in the olympics?
![Image](https://github.com/user-attachments/assets/22dad7db-477c-418a-a9e6-2c87e8289468)



```sql
SELECT  Sport, COUNT (Sport) AS CountOfSport
FROM Olympics..events
GROUP BY Sport
HAVING COUNT (Sport) = 1
```



### 8.	Fetch the total no of sports played in each olympic games.

![Image](https://github.com/user-attachments/assets/d0288234-9a16-4990-9cc6-1e7dec57e26a)


```sql
SELECT Games ,COUNT (DISTINCT Sport) AS Sport_Count
FROM Olympics..events
GROUP BY Games
ORDER BY  Games ASC
```



### 9.	Fetch details of the oldest athletes to win a gold medal. 

![Image](https://github.com/user-attachments/assets/166745a5-26a9-4962-a836-957afded5d08)



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
![Image](https://github.com/user-attachments/assets/b5489f30-ea41-445b-b1d3-03dd51d88fc3)



```sql
SELECT TOP 5 Name, COUNT(Medal) AS Count_Of_Gold_Medals
FROM Olympics..events
WHERE Medal = 'Gold'
GROUP BY Name
ORDER BY Count_Of_Gold_Medals DESC
```


### 12.	Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
![Image](https://github.com/user-attachments/assets/cb4e8393-d6da-4d27-9735-30b5e86cd8c1)



```sql
SELECT TOP 5 Name, COUNT(Medal) AS Count_Of_Medals
FROM Olympics..events
GROUP BY Name
ORDER BY Count_Of_Medals DESC
```



### 13.	Fetch the top 5 most successful countries in Olympics. Success is defined by no of medals won.
![Image](https://github.com/user-attachments/assets/96c45bad-a934-40e9-a1da-8b71053d9a04)


```sql
SELECT TOP 5 r.region, Count (e.Medal) AS Count_Of_Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
GROUP BY r.region
ORDER BY Count_Of_Medals DESC
```


### 14.	List down total gold, silver and bronze medals won by each country.
![Image](https://github.com/user-attachments/assets/26d92b51-868f-42c0-8d05-8fb647239746)


```sql
SELECT r.region, e.Medal
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
WHERE e.Medal IS NOT NULL
```



### 15.	List down total gold, silver and bronze medals won by each country corresponding to each Olympic games.
![Image](https://github.com/user-attachments/assets/568c5d0f-fed8-40cc-9f8c-78f08da9bc0b)


```sql
SELECT r.region, LAG(e.Medal) OVER (PARTITION BY e.Games ORDER BY r.region) AS Medals
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
ORDER BY r.region
```


### 16.	Identify which country won the most gold, most silver and most bronze medals in each olympic games.
![Image](https://github.com/user-attachments/assets/7a6d2acd-482a-47e3-8664-daf72377d350)


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


### 17.	Identify which country won the most gold, most silver, most bronze medals and the most medals in each Olympic games.
![Image](https://github.com/user-attachments/assets/dd58815c-045e-48d0-961b-4100c5b80d41)


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


### 18.	Which countries have never won gold medal but have won silver/bronze medals?
![Image](https://github.com/user-attachments/assets/9aec093b-b913-4724-a64a-2d5f2480d8df)


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




### 19.	In which Sport/event, India has won highest medals.
![Image](https://github.com/user-attachments/assets/ed27651d-943c-4b9f-aa56-eaa895faae6a)



```sql
SELECT TOP 1 e.Sport, COUNT(Medal) AS Count_Of_Medal
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC 
WHERE r.region = 'India'
GROUP BY e.Sport 
ORDER BY Count_Of_Medal DESC
```


### 20.	Break down all Olympic games where india won medal for Hockey and how many medals in each Olympic games.
![Image](https://github.com/user-attachments/assets/096a1c7c-14c6-4771-a4cf-f6fdd9a1abd6)
```sql
SELECT DISTINCT (e.Games), e.Medal, COUNT(e.Medal) Count_Of_Medal
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC 
WHERE r.region = 'India' AND Sport = 'Hockey' AND e.Medal IS NOT NULL
GROUP BY e.Games, e.Medal
ORDER BY e.Games ASC
```

