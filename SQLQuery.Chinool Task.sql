
--1-Top 100  Frequent track in playlist 
select top (100)
    Name,
    Count(playlistid) num_of_playlist
from Track t
    join PlaylistTrack pt
        on t.TrackId = pt.TrackId
Group by Name
having (Count(playlistid)) > 1
order by num_of_playlist Desc


--2- Top 100 track has big quantity in sales 
 
Select Top 100
    Name,
    Sum(Quantity) Quantity_Sales
from InvoiceLine i
    join Track t
        on i.TrackId = t.TrackId
Group by Name
order by Quantity_Sales Desc;


--3- Top playlist contains the most Sold Track (As Quantity )

select
    p.PlaylistId,p.Name,
    sum(Quantity) QTY_of_PlayList
from
    InvoiceLine       i
   join
        Track         t
            on i.TrackId = t.TrackId
     join
        PlaylistTrack pt
            on i.TrackId = pt.TrackId
   right  join
        Playlist      p
            on p.PlaylistId = pt.PlaylistId
Group by
   p.PlaylistId, p.Name
order by
    QTY_of_PlayList Desc;



--4- top 100 Salled By Price 

Select top 100
    Sum(Quantity * t.UnitPrice) T,
    t.TrackId,
    Name
From InvoiceLine i
    Join Track t
        on i.TrackId = t.TrackId
Group by t.TrackId,
         Name
order by T Desc  


--5-  Quantity Salled by Genre 
Select sum(Quantity) as Q,
       g.Name
from Genre g
    join Track t
        on g.GenreId = t.GenreId
    left outer join InvoiceLine i
        on i.TrackId = t.TrackId
Group by g.Name
order by Q Desc;



--6-  Top Track Salled By Genre

Select Top 100 t.Name ,g.Name , Sum(Quantity) QTY
from Track t join  InvoiceLine i 
on t.TrackId = i.TrackId 
join Genre g 
on t.GenreId = g.GenreId 
Group by t.Name , g.Name
order by QTY desc;


--7- QTY Saled By Media Type

Select sum(Quantity) as Q,
       m.Name
from MediaType m
    join Track t
        on m.MediaTypeId = t.MediaTypeId
   left outer join InvoiceLine i
        on i.TrackId = t.TrackId
Group by m.Name
order by Q Desc;

 
--8- Top Quantity Salled By  Album 

Select Top 100
    A.Title as Album_Name , 
    Sum(Quantity) Quantity_Sales
from InvoiceLine i
    join Track t
        on i.TrackId = t.TrackId
    join Album A
    on A.AlbumId = t.AlbumId
Group by A.Title
order by Quantity_Sales Desc;



--8- Top Quantity Salled By  Album 
--9- Album that have most Salled Belong to any Artist

Select 
    A.Title Album_Name  , 
    Sum(Quantity) Quantity_Sales ,Ar.Name  Artist_Name
from InvoiceLine i
    join Track t
        on i.TrackId = t.TrackId
   right outer  join Album A
    on A.AlbumId = t.AlbumId 
    join Artist Ar 
    on Ar.ArtistId = A.ArtistId
Group by A.Title ,Ar.Name
order by Quantity_Sales Desc;



select * from Album


--10- The most Salled Track By Artist  

Select a.Name , Sum(Quantity) QY
from Artist a left outer join Album al 
on a.ArtistId = al.ArtistId 
left outer join Track t 
on al.AlbumId = t.AlbumId
left outer join InvoiceLine i 
on t.TrackId = i.TrackId 
Group by a.Name 
order By QY Desc; 


--11- num of Album foreach Artist 

select a.Name Artist_Name , Count(Title) Num_of_Albums 
from Artist a left outer  join  Album  al 
on a.ArtistId = al.ArtistId 
Group by a.Name
order by Num_of_Albums desc ;


--12-  Top 20 Big Album , and the smallest one 

Select Top 20 Title , count(TrackId) T 
from Album a  join  Track t 
on t.AlbumId = a.AlbumId
Group by Title 
order by T Desc ;


Select Top 20 Title , count(t.TrackId) T
from Album a  join  Track t 
on t.AlbumId = a.AlbumId 
Group by Title 
order by T ;

--13-  Top Employee in Sales 
SELECT TOP 5
    e.FirstName,
    SUM(i.Total) AS Sales
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.FirstName
ORDER BY Sales DESC;

--14- Top Country in Sales 
SELECT TOP 10
    BillingCountry,
    SUM(Total) AS Sales
FROM Invoice
GROUP BY BillingCountry
ORDER BY Sales DESC; 


-- 15- Who are our VIP customers? Find the top 10 customers who spent the most money overall.
SELECT TOP 10 
    c.CustomerId, 
    c.FirstName + ' ' + c.LastName AS Customer_Name, 
    SUM(i.Total) AS Total_Spent
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Total_Spent DESC;

-- 16- Let's analyze sales trends over time. What is the total revenue generated for each year?
SELECT 
    YEAR(InvoiceDate) AS Sales_Year, 
    SUM(Total) AS Yearly_Revenue
FROM Invoice
GROUP BY YEAR(InvoiceDate)
ORDER BY Sales_Year DESC;

-- 17- Which countries have the highest average order value? Show the average invoice total per country.
SELECT 
    BillingCountry, 
    AVG(Total) AS Avg_Invoice_Amount
FROM Invoice
GROUP BY BillingCountry
ORDER BY Avg_Invoice_Amount DESC;

-- 18- What are the top 10 longest tracks in the database, and who are the artists behind them?
SELECT TOP 10 
    t.Name AS Track_Name, 
    (t.Milliseconds / 60000) AS Duration_Minutes, 
    al.Title AS Album_Title, 
    ar.Name AS Artist_Name
FROM Track t
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
ORDER BY t.Milliseconds DESC;

-- 19- Check our employees' workload: How many customers is each Support Representative currently handling?
SELECT 
    e.EmployeeId, 
    e.FirstName + ' ' + e.LastName AS Support_Rep_Name, 
    COUNT(c.CustomerId) AS Total_Customers_Assigned
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY Total_Customers_Assigned DESC;

-- 20- Find all tracks that are above average in length compared to the rest of the music library.
SELECT 
    TrackId, 
    Name AS Track_Name, 
    Milliseconds
FROM Track
WHERE Milliseconds > (SELECT AVG(Milliseconds) FROM Track)
ORDER BY Milliseconds DESC;

-- 21- Which artists are the most versatile? Find artists who have tracks across more than 2 different genres.
SELECT 
    ar.Name AS Artist_Name, 
    COUNT(DISTINCT t.GenreId) AS Number_of_Genres
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
GROUP BY ar.Name
HAVING COUNT(DISTINCT t.GenreId) > 2
ORDER BY Number_of_Genres DESC;