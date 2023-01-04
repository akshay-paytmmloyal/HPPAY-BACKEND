--------------------------------------------------------  
--Created BY:- Akshay Tripathi  
--Created Date:- 2 Jan 2023  
--Created USP for:- Get Action List HPPay  
--Modified BY:-  
--Modified Date:-   
--------------------------------------------------------  
  
Alter Proc [dbo].[UspGetActionListHPPay]  -- 3   
(        
@EntityTypeId int        
)        
as            
begin            
select EntityTypeId, StatusId,   
CASE WHEN StatusName = 'Temporary Hotlist' THEN 'Temporary Hotlist'    
WHEN StatusName = 'Permanent Hotlist' THEN 'Permanent Hotlist'    
WHEN StatusName = 'Reactivate' THEN 'Reactivate' END as StatusName     
from mstStatusHPPay with(nolock) where EntityTypeId = @EntityTypeId and StatusId in (6, 12, 11) and StatusFlag = 1        
end        
  
  

  
  
  