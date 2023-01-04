-----------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 2 Jan 2023
--Created USP for:- Get Entity Type list HPPay
--Modified Date:-
--Modified BY:-
------------------------------------------------------

Create Proc [dbo].[UspGetEntityTypeListHPPay]  
as  
begin  
select EntityId, EntityName from mstEntity with(nolock) where StatusFlag = 1 and EntityId in (1,2,3)  
end