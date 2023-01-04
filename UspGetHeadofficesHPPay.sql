
--------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 20 Dec 2022
--Created USP For:- Get Details for Headoffice
--Modified BY:-
--Modified Date:-
---------------------------------------------------

Alter proc [dbo].[UspGetHeadofficesHPPay]  
as  
begin  
select Id,HOCode,HOName,HOShortName from Mst_headoffices with(nolock) where status_flag=1  
end 
