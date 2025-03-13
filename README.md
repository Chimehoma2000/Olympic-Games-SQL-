# Olympic-Games-SQL-

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


### 5.	Which nation has participated in all of the olympic games?

```sql
SELECT Team, Count (Distinct Games) AS Total_Games_Count
FROM Olympics..events
GROUP BY Team
HAVING Count (Distinct Games) IN
(SELECT Count (Distinct Games) AS Games_Count
FROM Olympics..events)
```


### 6.	Identify the sport which was played in all summer olympics.

```sql
SELECT DISTINCT (Sport)
FROM Olympics..events
WHERE Season = 'Summer'
```


### 7.	Which Sports were just played only once in the olympics?

```sql
SELECT  Sport, COUNT (Sport) AS CountOfSport
FROM Olympics..events
GROUP BY Sport
HAVING COUNT (Sport) = 1
```


### 8.	Fetch the total no of sports played in each olympic games.

```sql
SELECT Games ,COUNT (DISTINCT Sport) AS Sport_Count
FROM Olympics..events
GROUP BY Games
ORDER BY  Games ASC
```


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
