
----------------------------------------------------------
--Create BY:- Akshay Tripathi
--Created Date:- 22 Dec 2022
--Created USP for:- Get State page
--Modified Date:-
--Modified BY:-
----------------------------------------------------------

Alter proc [dbo].[UspGetStateHPPay]  
(  
@CountryregCode int=0  
)  
as  
begin  
if(@CountryregCode=0)  
begin  
 select CountryRegCode,StateCode,State_Name as StateName,StateShortName as StateShortName from Tbl_State with(nolock) where Status_Flag=1  
end  
else  
begin  
 select CountryRegCode,StateCode,State_Name as StateName,StateShortName as StateShortName from Tbl_State with(nolock) where Status_Flag=1  
 and CountryRegCode=@CountryregCode  
end  
end  


