----------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 22 Dec 2022
--Created USP for:- Inactive State page
--Modified BY:-
--Modified Date:- 
----------------------------------------------------

Alter proc [dbo].[UspInactiveStateHPPay]      
(      
@StateCode int,    
@ModifiedBy varchar(40)    
)      
as      
begin      
declare @StateCodeChk int            
set @StateCodeChk=(select count(StateCode) from Tbl_State with(nolock) where StateCode=@StateCode)            
if(@StateCodeChk>0)      
begin      
 insert into tblLocationLogHPPay(PageName,ActionName,CreatedBy,ModifiedBy,ModifiedTime) values('State','Delete',@ModifiedBy,@ModifiedBy,GETDATE())  
 update Tbl_State set Status_Flag=0,LastModifiedBy=@ModifiedBy,LastModifiedOn=GETDATE() where StateCode=@StateCode      
 select 1 as Status,'State deleted successfully' as Reason      
end      
else      
begin      
   select 0 as Status,'State not found' as Reason      
end      
end      

