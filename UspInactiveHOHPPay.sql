
---------------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 22 dec 2022
--Created USP for:- Inactive HO page
--Modified BY:-
--Modified Date:- 
---------------------------------------------------------------

Alter proc [dbo].[UspInactiveHOHPPay]  
(  
@HOID int,
@ModifiedBy varchar(40)
)  
as  
begin  
declare @HQCodeChk int        
set @HQCodeChk=(select count(HOCode) from Mst_headoffices with(nolock) where HOCode=@HOID)        
if(@HQCodeChk>0)  
begin  
 update Mst_headoffices set status_flag=0,LastModifiedBy=@ModifiedBy,LastModifiedOn=GETDATE() where HOCode=@HOID  
 select 1 as Status,'HO deleted successfully' as Reason  
end  
else  
begin  
   select 0 as Status,'HO not found' as Reason  
end  
end   


