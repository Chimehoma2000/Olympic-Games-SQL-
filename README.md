# Olympic-Games-SQL-

#  <h1 align="center"> QUESTIONS AND SOLUTION </h1>
 --------------------------------

###  --1. How many olympics games have been held?

```sql
 SELECT COUNT (DISTINCT Games) AS CountOfGames
FROM Olympics..events

```



###  --2.	List down all Olympics games held so far.

```sql
SELECT DISTINCT (Games) AS Games
FROM Olympics..events
ORDER BY Games ASC
```

###  --3.	Mention the total no of nations who participated in each olympics game?

```sql
SELECT r.region, COUNT(DISTINCT e.Games) AS CountOfGames
FROM Olympics..events e
JOIN Olympics..regions r
ON e.NOC = r.NOC
GROUP BY r.region
ORDER BY CountOfGames DESC
```



