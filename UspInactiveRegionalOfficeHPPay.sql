
---------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 22 Dec 2022
--Created USP for:- Inactive Regional office page
--Modified BY:-
--Modified Date:-
-----------------------------------------------------------

Alter proc [dbo].[UspInactiveRegionalOfficeHPPay]      
(      
@ROCode int,    
@ModifiedBy varchar(40)    
)      
as      
begin      
declare @RegionalOfficeCodeChk int            
set @RegionalOfficeCodeChk=(select count(ROCode) from Mst_Regionaloffices with(nolock) where ROCode=@ROCode)            
if(@RegionalOfficeCodeChk>0)      
begin      
 insert into tblLocationLogHPPay(PageName,ActionName,CreatedBy,ModifiedBy,ModifiedTime) values('Regional Office','Delete',@ModifiedBy,@ModifiedBy,GETDATE())  
 update Mst_Regionaloffices set status_flag=0,LastModifiedBy=@ModifiedBy,LastModifiedOn=GETDATE() where ROCode=@ROCode      
 select 1 as Status,'Regional Office deleted successfully' as Reason      
end      
else      
begin      
   select 0 as Status,'Regional Office not found' as Reason      
end      
end      
