-----------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 3 Jan 2023
--Created USP for:- Get Hotlisted Or Reactivation Approval data page
--Modifed Date:-
--Modified BY:-
--------------------------------------------------------------

Alter Proc [dbo].[UspGetHotlistOrReactivateApprovalHPPay]      
(      
@EntityTypeId int,                    
@ActionId int,  
@FromDate varchar(10),                   
@ToDate varchar(10)      
)      
as                    
Begin  
 select EntityId as EntityCode, convert(varchar(10),CreatedTime,105)+' '+convert(varchar(10),CreatedTime,108) as CreationDate     
 from tblHotlistRequestLogHPPay with(noLock) where RequestedStatus = @ActionId  
 and EntityTypeId = @EntityTypeId and convert(varchar(10),CreatedTime,120) between @FromDate and @ToDate and StatusFlag = 1  
 order by CreatedTime desc
End  