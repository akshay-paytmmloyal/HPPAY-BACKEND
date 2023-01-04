
------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 22 Dec 2022
--Created USP For:- Get Regional office page
--Modified BY:-
--Modified Date:-
------------------------------------------------------

Alter proc [dbo].[UspGetRegionalOfficeHPPay]      
(      
@Zocode int=0      
)      
as      
begin      
if(@Zocode=0)      
begin      
  select a.ZOCode,b.ZOName,a.ROCode,a.ROCode,a.ROName,a.ROShortName,a.ROERPCode   
  from Mst_Regionaloffices a with(nolock) left join Mst_zonaloffices b on a.ZOCode=b.ZOCode where a.status_flag=1  order by ROName     
end      
else      
begin      
 select a.ZOCode,b.ZOName,a.ROCode,a.ROCode,a.ROName,a.ROShortName,a.ROERPCode   
  from Mst_Regionaloffices a with(nolock) left join Mst_zonaloffices b on a.ZOCode=b.ZOCode where a.status_flag=1 and a.ZOCode=@Zocode order by ROName      
end      
end   