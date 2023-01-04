
--------------------------------------------------------
--created by :- Akshay Tripathi
--Created Date:- 22 dec 2022
--Created USP for:- Get Zonal office details
--Modified BY:-
--Modified Date:-
-------------------------------------------------------

Alter proc [dbo].[UspGetZonalOfficeHPPay]     

as          
begin      
select Id,ZOCode,ZOName,ZOShortName,ZOERPCode       
from Mst_zonaloffices with(nolock) where status_flag=1  order by ZOName         
end 

