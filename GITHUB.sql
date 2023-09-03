Use WorldEvents
------------------STORED PROCEDURES
Select * from WorldEvents.dbo.tblCountry
Select * from WorldEvents.dbo.tblContinent
Select * from WorldEvents.dbo.tblEvent
Select * from WorldEvents.dbo.tblCategory

go
Create Procedure FullEventsOnGivenDates(@Date date)
--Gives full event details based on specified dates
as
begin
   Select EventName, CountryName, EventDetails, CategoryName, EventDate
   from tblEvent as eve
   join tblCountry as cont
   on eve.CountryID = cont.CountryID
   join tblCategory as cat
   on eve.CategoryID = cat.CategoryID
   Where Datepart(yyyy, EventDate) = DatePart(yyyy, @Date)
end
go
 
Exec FullEventsOnGivenDates '1980-01-01'

Create Procedure NumberOfEventsInCountries
--Gives the number of times a particular event occured in a country
as
Begin
   Select CountryName, EventName, CategoryName, 
   count(CountryName) over(partition by CountryName, CategoryName ) NumberOfOccurences
   from tblCountry as cont
   join tblEvent as eve
   on cont.CountryID = eve.CountryID
   join tblCategory as cat
   on eve.CategoryID = cat.CategoryID
   order by CountryName
end

Exec NumberOfEventsInCountries


Create Procedure CountryEventDetails @CountryName Varchar(40)
--Outputs full details of the specified country
AS
Begin
  Select EventName, CountryName, EventDetails, CategoryName, EventDate
   from tblEvent as eve
   join tblCountry as cont
   on eve.CountryID = cont.CountryID
   join tblCategory as cat
   on eve.CategoryID = cat.CategoryID
   where CountryName = @CountryName
end

Exec CountryEventDetails 'France'

Create Procedure SpecificEventDetails @CategoryName Varchar(40)
--Gives all occurences of the specified Event
AS
begin
  Select EventName, CategoryName, CountryName, EventDetails, EventDate
   from tblEvent as eve
   join tblCountry as cont
   on eve.CountryID = cont.CountryID
   join tblCategory as cat
   on eve.CategoryID = cat.CategoryID
   where CategoryName = @CategoryName
end


Create Procedure SpecificContinentsEvents 
--Outputs number of events in Continents
AS
begin
  Select ContinentName, Count(CategoryName) as NumberOfEvents
   from tblCountry as Cont
   Join tblContinent as Conti
   on conti.ContinentID = Cont.ContinentID
   join tblEvent as eve
   on eve.CountryID = cont.CountryID
   join tblCategory as cat
   on eve.CategoryID = cat.CategoryID
   Group by ContinentName
end
