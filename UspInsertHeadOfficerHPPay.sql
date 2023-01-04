---------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 21 dec 2022
--Created USP For:- Insert Headofficer page
--Modified BY:-
--Modified Date:-
-----------------------------------------------------

Alter proc [dbo].[UspInsertHeadOfficerHPPay]    
(    
@HOCode varchar(20),    
@HOName varchar(30),    
@HOShortName varchar(10),    
@CreatedBy varchar(40)    
)    
as    
begin    
declare @HQCodeChk int          
set @HQCodeChk=(select count(HOCode) from Mst_headoffices with(nolock) where HOCode=@HOCode)          
          
declare @HQNameCheck int          
set @HQNameCheck=(select count(HOName) from Mst_headoffices with(nolock) where HOCode=@HOCode)          
    
if(@HQCodeChk=0)          
begin      
   if(@HQNameCheck=0)          
   begin      
  insert into tblLocationLogHPPay(PageName,ActionName,CreatedBy,ModifiedBy,ModifiedTime) values('HO','Insert',@CreatedBy,@CreatedBy,GETDATE())
 insert into Mst_headoffices(Id,HOCode,HOName,CreatedBy)values(101,@HOCode,@HOName,@CreatedBy)    
 select 1 as Status,'HO created successfully' as Reason    
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

