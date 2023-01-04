--------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 3 Jan 2023
--Created USP for:- Get Hotlisted or Reactivated data page
--Modified BY:-
--Modified Date:-
---------------------------------------------------------

Alter Proc UspGetHotlistedOrReactivatedDetailsHPPay
(
@EntityTypeId int,                          
@EntityIdVal varchar(16)  ,          
@Userid varchar(40)=null          
)
As 
Begin
 declare                             
@EntityName varchar(100) = ''                            
                            
select @EntityName = EntityName from mstEntity with(noLock) where EntityId = @EntityTypeId and StatusFlag = 1 
if (@EntityName = 'Customer')    
Begin
select top 1 'Customer' as EntityType,C.Customer_id as EntityIdValue, iif(H.ModifiedTime is null,convert(varchar(10),H.CreatedTime,105),convert(varchar(10),H.ModifiedTime,105))+' '+ iif(H.ModifiedTime is null,convert(varchar(10),H.CreatedTime,108)
 ,convert(varchar(10),H.ModifiedTime,108)) as HotlistDate,                     
 S.StatusName as Action, St.StatusName  as Reason, H.Comments as Remarks                          
 from loyaluser as C with(noLock)                  
 inner join tblHotlistRequestLogHPPay as H with(noLock) on C.Customer_id = H.EntityId                  
 left outer join mstStatusHPPay as S with(noLock) on RequestedStatus = StatusId  
  left outer join mstStatusHPPay as St with(noLock) on H.ReasonId= St.StatusId and St.EntityTypeId in (103,104,105) 
 where H.EntityTypeId = 2  and H.StatusFlag = 0  and S.EntityTypeId = 2 and S.StatusFlag = 1 and Customer_id = @EntityIdVal and H.RequestedStatus in (11, 6, 12)                
 and (H.Status = 1 OR ISnull(H.Status,0) =0 )              
 order by iif(H.ModifiedTime is null,H.CreatedTime,H.ModifiedTime ) desc
 end
 else if (@EntityName = 'Merchant')                          
begin                    
 select top 1 'Merchant' as EntityType,M.Store_Code as EntityIdValue, convert(varchar(10),H.ModifiedTime,105)+' '+ convert(varchar(10),H.ModifiedTime,108) as HotlistDate,                     
 S.StatusName as Action,  St.StatusName  as Reason, H.Comments as Remarks                          
 from Mst_Stores as M with(noLock)                    
 inner join tblHotlistRequestLogHPPay as H with(noLock) on M.Store_Code = H.EntityId                  
 left outer join mstStatusHPPay as S with(noLock) on RequestedStatus = StatusId 
 left outer join mstStatusHPPay as St with(noLock) on H.ReasonId= St.StatusId and St.EntityTypeId in (106,107,108) 
 where H.EntityTypeId = 3 and H.StatusFlag = 0   and S.EntityTypeId = 3 and S.StatusFlag = 1 and Store_Code = @EntityIdVal and H.RequestedStatus in (11, 6, 12)                  
 and H.Status = 1                  
 order by H.ModifiedTime desc                  
end              
end
