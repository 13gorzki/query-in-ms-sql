declare kursor CURSOR /*FAST_FORWARD*/ FOR
select [Data] from dbo.pom_daty where [Data] between (select dateadd(dd,1,MAX(DataMag)) from dbo.stanyhistoryczne) and CONVERT(date,getdate()-1)
declare @data date
OPEN kursor
FETCH NEXT FROM kursor into @data
WHILE @@FETCH_STATUS = 0
BEGIN 

	insert into dbo.stanyhistoryczne
	select
	s.DataMag
	,s.Magazyn
	,s.Indeks
	,SUM(Ilosc) Ilosc
	,SUM(WartoscN) Wartosc
	from dbo.StanHistData(@data) s
	group by
	s.DataMag
	,s.Magazyn
	,s.Indeks

FETCH NEXT FROM kursor into @data
END
CLOSE kursor
deallocate kursor
