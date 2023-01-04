
------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 14 dec 2022
--Created USP For:- Delete manage user
--Modified by:-
--Modified Date:-
-----------------------------------------------

Alter proc [dbo].[UspDeleteRolesHPPay]
  
(  
@ModifiedBy VARCHAR(40),  
@TypeRoleNameAndRoleDescriptionMappingHPPay  TypeRoleNameAndRoleDescriptionMappingHPPay readonly  
)  
  
as  
   
  
SET XACT_ABORT ON;    
SET NoCount ON;    
    
 BEGIN TRY  
Begin  
  
Declare @newtable table(ID INT IDENTITY(1,1) Primary key,RoleName varchar (200),RoleDescription varchar (500))  
Declare @SuccessFlag varchar(10) = 'N';  
insert into @newtable (RoleName,RoleDescription)  
select RoleName, RoleDescription  from @TypeRoleNameAndRoleDescriptionMappingHPPay  
  
Declare @totcount int=0, @counter int=1, @RoleName varchar (200),@RoleDescription varchar (500)  
Select @totcount=count(ID) From @newtable  
  
  
while(@counter <= @totcount)  
BEGIN  
Select @RoleName= RoleName,@RoleDescription=RoleDescription FROM @newtable WHERE ID = @counter  
  
      if exists (select 1  from tblRoleMapNew with(nolock) where RoleName = @RoleName and  Description = @RoleDescription  and StatusFlag = 1)  
   Begin  
      Begin Tran  
     Update tblRoleMapNew with (rowlock) set StatusFlag=0, ModifiedBy = @ModifiedBy, ModifiedTime = GETDATE() WHERE RoleName = @RoleName and  Description = @RoleDescription  and StatusFlag = 1  
   Commit   
   Set @SuccessFlag = 'Y'  
  
   END  
   Else  
   Begin  
  Set @SuccessFlag = 'N'  
  break  
   End  
  
  
    SET @counter=@counter+1  
END  
if(@SuccessFlag ='Y')  
Begin  
   Select 1 as STATUS,'Role Deleted Successfully' as Reason  
   End  
  
if @SuccessFlag = 'N'  
Begin  
   Select 0 as STATUS,'RoleName does not exists' as Reason  
end  
  
End  
END TRY  
BEGIN CATCH   
  IF @@TRANCOUNT > 0   
  BEGIN   
   ROLLBACK TRANSACTION;   
  END      
  DECLARE @error VARCHAR (100)   
  SELECT @error=ERROR_MESSAGE()   
  RAISERROR (@error,16,1)  
  SELECT 0 AS sTATUS, @ERROR AS REASON  
 END CATCH  
