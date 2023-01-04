-------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 22 Dec 2022
--Created USP for:- Get City details
--Modified BY:- 
--Modified Date:- 
--------------------------------------------------------

Alter proc [dbo].[UspGetCityHPPay]  
as  
begin  
select City_Id,CityCode,City_Name,CityShortName,isnull(StateCode,0) as StateId from Tbl_City with(nolock) where Status_Flag=1  
end

