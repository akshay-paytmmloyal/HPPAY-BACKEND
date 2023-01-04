---------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 21 Dec 2022
--Created USP for:- Inactive Zonaloffice page
--Modified BY:-
--Modified Date:-
---------------------------------------------------------

Alter proc [dbo].[UspInactiveZonalOfficeHPPay]      
(      
@ZoCode int,    
@ModifiedBy varchar(40)    
)      
as      
begin      
declare @ZonalOfficeCodeChk int            
set @ZonalOfficeCodeChk=(select count(ZOCode) from Mst_zonaloffices with(nolock) where ZOCode=@ZoCode)            
if(@ZonalOfficeCodeChk>0)      
begin      
 insert into tblLocationLogHPPay(PageName,ActionName,CreatedBy,ModifiedBy,ModifiedTime) values('Zonal Office','Delete',@ModifiedBy,@ModifiedBy,GETDATE())  
 update Mst_zonaloffices set status_flag=0,LastModifiedBy=@ModifiedBy,LastModifiedOn=GETDATE() where ZOCode=@ZoCode      
 select 1 as Status,'Zonal Office deleted successfully' as Reason      
end      
else      
begin      
   select 0 as Status,'Zonal Office not found' as Reason      
end      
end      
