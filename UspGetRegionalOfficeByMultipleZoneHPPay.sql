
--------------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 22 dec 2022
--Created USP for:- Get Regionaloffice By Multiple Zone page
--Modified BY:-
--Modified Date:-
---------------------------------------------------------------
Alter proc [dbo].[UspGetRegionalOfficeByMultipleZoneHPPay]  
(          
@ZoCode varchar(4000)=''          
)          
as          
begin          
if(@ZoCode='')          
begin          
  select a.ZOCode,b.ZOName,a.ROCode,a.ROName,a.ROShortName,a.ROERPCode       
  from Mst_Regionaloffices a with(nolock) left join Mst_zonaloffices b on a.ZOCode=b.ZOCode where a.status_flag=1 order by ROName         
end          
else          
begin          
  select a.ZOCode,b.ZOName,a.ROCode,a.ROName,a.ROShortName,a.ROERPCode       
  from Mst_Regionaloffices a with(nolock) left join Mst_zonaloffices b on a.ZOCode=b.ZOCode where a.status_flag=1 
  and a.ZOCode in(select * from ConvertintoCommaTable(@ZoCode)) order by ROName          
end          
end       