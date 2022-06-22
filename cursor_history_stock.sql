declare kursor CURSOR FAST_FORWARD 
FOR
	select distinct
	DataMag
	from dbo.stanyhistoryczne_daty
	where year(DataMag) between 2020 and 2021
	order by DataMag

declare @data date
OPEN kursor
FETCH NEXT FROM kursor into @data
WHILE @@FETCH_STATUS = 0
BEGIN 

	INSERT INTO dbo.stanyhistoryczne_transfer

	select 
		@data 'DokNadzien'
		,m.MagSym
		,sum(l._IloscRazem) Ilosc
		from dbo.DOKData l 
		left join dbo.DOKMag m on l.DokMagId=m.MagId
		where l.DokTypId in (1,2,3) 
		and l.FlgAnul=0
		and l.FlgDuplik=0
		and l.FlgBlok=1
		and l.Ilosc<>0
		and m.MagSym in (select distinct Mag from dbo.MagSym)
		group by
		m.MagSym


FETCH NEXT FROM kursor into @data
END
CLOSE kursor
deallocate kursor
