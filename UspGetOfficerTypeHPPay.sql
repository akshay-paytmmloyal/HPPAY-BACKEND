
----------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 20 Dec 2022
--Created USP for:- Get Officer type details
--Modified BY:-
--Modified Date:- 
----------------------------------------------

Alter proc [dbo].[UspGetOfficerTypeHPPay]  
as  
begin  
select OfficerTypeID,OfficerTypeName,OfficerTypeShortName from mstOfficerTypenew with(nolock) where StatusFlag=1 
end  