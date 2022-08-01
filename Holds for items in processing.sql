--Here is a query that I use in the Find Tool if I am looking for high-demand titles. We put "ON ORDER" as the call number of the titles we order. If you have something else, you can replace the string in single quotes below, or possibly use "is null" in place of "like 'ON ORDER%'" if you do not have any call number at all. You can also change the number of active holds to something lower or higher than 10.

Select distinct br. bibliographicrecordid from bibliographicrecords br with (nolock)
join rwriter_bibderiveddataview rw (nolock) on (br.bibliographicrecordid = rw.bibliographicrecordid)
join itemrecords it (nolock) on (br.bibliographicrecordid = it.associatedbibrecordid)
where br.browsecallno like 'on order%'
and it.itemstatusid = 15
and rw.numberactiveholds >= 10
