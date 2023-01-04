
----------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 20 Dec 2022
--Created USP for:- Update Head Office 
--Modified BY:-
--Modified Date:-
-----------------------------------------------------------


Alter proc [dbo].[UspUpdateHeadofficeHPPay]    
(    
@ID int,    
@HOCode varchar(20),    
@HOName varchar(30),    
@HOShortName varchar(10),    
@ModifiedBy varchar(40)    
)    
as    
begin    
declare @HQCodeChk int          
set @HQCodeChk=(select count(HOCode) from Mst_headoffices with(nolock) where HOCode=@HOCode)          
          
declare @HQNameCheck int          
set @HQNameCheck=(select count(HOName) from Mst_headoffices with(nolock) where HOName=@HOName)          
    
if(@HQCodeChk=0)          
begin      
   if(@HQNameCheck=0)          
   begin      
 insert into tblLocationLogHPPay(PageName,ActionName,CreatedBy,ModifiedBy,ModifiedTime) values('HO','Update',@ModifiedBy,@ModifiedBy,GETDATE())
 update Mst_headoffices set HOCode=@HOCode,HOName=@HOName,HOShortName=@HOShortName,LastModifiedBy=@ModifiedBy,LastModifiedOn=getdate()    
 where Id=@ID    
 select 1 as Status,'HO updated successfully' as Reason    
   end    
   else    
   begin    
 select 0 as Status,'HO Name already exits' as Reason    
   end    
end    
else    
begin    
 select 0 as Status,'HO Code already exits' as Reason    
end    
end    





