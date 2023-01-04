--------------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 22 Dec 2022
--Created USP for:- Inactive District page
--Modified BY:-
--Modified Date:-
-------------------------------------------------------------

Alter proc [dbo].[UspInactiveDistrictHPPay]      
(      
@DistrictID int,    
@ModifiedBy varchar(40)    
)      
as      
begin      
declare @DistrictCodeChk int            
set @DistrictCodeChk=(select count(DistrictCode) from Tbl_District with(nolock) where DistrictCode=@DistrictID)            
if(@DistrictCodeChk>0)   
begin      
 insert into tblLocationLogHPPay(PageName,ActionName,CreatedBy,ModifiedBy,ModifiedTime) values('District','Delete',@ModifiedBy,@ModifiedBy,GETDATE())  
 update Tbl_District set status_flag=0,LastModifiedBy=@ModifiedBy,LastModifiedOn=GETDATE() where DistrictCode=@DistrictID      
 select 1 as Status,'District deleted successfully' as Reason      
end      
else      
begin      
   select 0 as Status,'District not found' as Reason      
end      
end      

