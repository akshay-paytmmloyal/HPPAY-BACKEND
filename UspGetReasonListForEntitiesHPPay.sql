-------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 2 Jan 2023
--Created USP For:- Get Reason List For Entities HPPay
--Modidfied BY:-
--Modified Date:-
------------------------------------------------------

ALTER Proc [dbo].[UspGetReasonListForEntitiesHPPay]  --3,11   
(      
@EntityTypeId int,      
@Actionid int      
)      
as          
begin      
declare      
@EntityTypeVal int = '',      
@ActionName varchar(100) = '',      
@EntityName varchar(100) = ''      
select @EntityName = EntityName from mstEntity with(noLock) where EntityId = @EntityTypeId and StatusFlag = 1      
select @ActionName = CASE When StatusName = 'Temporary Hotlist' Then 'Temporary Hotlist'  
When StatusName = 'Permanent Hotlist' Then 'Permanent Hotlist'  
When StatusName = 'Reactivate' Then 'Reactivate'  
End  
from mstStatusHPPay with(noLock) where StatusId = @Actionid and EntityTypeId = @EntityTypeId and StatusFlag = 1      
Set @ActionName = @EntityName + ' ' + @ActionName + ' Reasons'      
select @EntityTypeVal = EntityId from mstEntity with(noLock) where EntityName = @ActionName and StatusFlag = 1      
select StatusId, StatusName from mstStatusHPPay with(noLock) where EntityTypeId = @EntityTypeVal and StatusFlag = 1     
end  



