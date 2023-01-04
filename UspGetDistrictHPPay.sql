----------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 22 Dec 2022
--Created USP For:- Get district page
--MOdified BY:-
--Modified Date:- 
-----------------------------------------------------

Alter proc [dbo].[UspGetDistrictHPPay]  
(      
@StateID int=0      
)      
as      
begin      
if(@StateID=0)      
begin      
select a.StateCode,b.State_Name as StateName, a.DistrictCode,a.DistrictName as DistrictName,a.DistrictShortName as DistrictShortName,DistrictCode 
from Tbl_District a
left join Tbl_State b  with(nolock) on a.StateCode=b.StateCode where a.status_flag=1      
end      
else      
begin      
select a.StateCode,b.State_Name as StateName, a.DistrictCode,a.DistrictName as DistrictName,a.DistrictShortName as DistrictShortName,DistrictCode 
from Tbl_District a
left join Tbl_State b  with(nolock) on a.StateCode=b.StateCode where a.status_flag=1  and a.StateCode=@StateID   
end      
end    

