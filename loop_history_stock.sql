declare @data date = (select min(Daty) from dbo.pom_daty)
declare @iloscDniWrzuconych int = 0


WHILE convert(varchar,GETDATE(),8)<'20:03:30' and @data<convert(date,dateadd(dd,-1,getdate()))
BEGIN
	INSERT INTO dbo.tmp_pom_stanyhistoryczne
		select 
		s.DataMag
		,s.Magazyn
		,s.Indeks
		,SUM(s.Ilosc) Ilosc
		,SUM(s.WartoscN) WartoscN
		from dbo.StanHistData(@data) s
		group by 
		s.DataMag
		,s.Magazyn
		,s.Indeks

	delete from dbo.pom_daty
	where Daty = @data

	set @data = (select min(Daty) from dbo.pom_daty)
	set @iloscDniWrzuconych = @iloscDniWrzuconych+1
END

print 'Ilość dni wrzuconych: '+convert(nvarchar(100),@iloscDniWrzuconych)
