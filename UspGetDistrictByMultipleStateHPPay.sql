
--------------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 23 Dec 2022
--Created USP for:- Get District By multiple State page
--Modified BY:-
--Modified Date:-
-------------------------------------------------------------

Alter proc [dbo].[UspGetDistrictByMultipleStateHPPay]
(        
@StateID varchar(4000)=''         
)        
as        
begin        
if(@StateID='')        
begin        
select a.StateCode,b.State_Name as StateName, a.DistrictCode,a.DistrictName as DistrictName,a.DistrictShortName as DistrictShortName,DistrictCode from Tbl_District a  
left join Tbl_State b  with(nolock) on a.StateCode=b.StateCode where a.status_flag=1        
end        
else        
begin        
 select a.StateCode,b.State_Name as StateName, a.DistrictCode,a.DistrictName as DistrictName,a.DistrictShortName as DistrictShortName,DistrictCode from Tbl_District a  
left join Tbl_State b  with(nolock) on a.StateCode=b.StateCode where a.status_flag=1  and a.StateCode in(select * from ConvertintoCommaTable(@StateID))         
end        
end