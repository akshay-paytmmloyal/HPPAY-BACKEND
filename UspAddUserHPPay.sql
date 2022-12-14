USE [Hppay]
GO
/****** Object:  StoredProcedure [dbo].[UspAddUserHPPay]    Script Date: 08-12-2022 20:15:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:-08 Dec 2022
--Usp For:- Adding User(Admin) from portal 
--Modified BY:-
--Modified Date:- 
-------------------------------------------------------------------

ALTER proc [dbo].[UspAddUserHPPay]   --'Raviadmin','Ravi@gmail.com','Ravi@123','Ravi@123',3,'Delhi','Akshayadmin','Ravi','Gupta',71,null,'8988765555'                
@UserName varchar(50),                        
@Email varchar(200),                        
@Password varchar(800),                        
@ConfirmPassword varchar(800),                        
@SecretQuestion int,                        
@SecretQuestionAnswer varchar(400),                        
@CreatedBy varchar(40) ,                
@FirstName varchar(50)='',                
@LastName varchar(50)='',                
@StateId int,                
@ActionType varchar(100)='' ,    
@MobileNo varchar(10)  =''  
as        
                        
SET XACT_ABORT ON;                          
SET NoCount ON;                          
                          
BEGIN TRY            
BEGIN            
        
if not exists (select 1 from mstKeyDetailNew where LoginKey = @UserName and StatusFlag = 1)        
begin        
 if(@Password=@ConfirmPassword)            
 begin                        
  Begin Tran                        
  insert into  tblNewUserRequestHPPay(UserName,Email,SecretQuestion,SecretQuestionAnswer,StatusFlag,CreatedBy,CreatedTime,                  
  IsApproved,MobileNo)                  
  values(@UserName,@Email,@SecretQuestion,@SecretQuestionAnswer, 1,@CreatedBy,GETDATE(),1,@MobileNo)                      
        
  Insert into  mstKeyDetailNew(LoginKey,KeyValue,UserType,UserSubType,StatusFlag,CreatedBy,CreatedTime,                  
  ReferenceId,LoginStatus,UserRole) values                      
  (@UserName,HASHBYTES('SHA2_512',convert(nvarchar(max),@Password)),1,4,1,@CreatedBy,GETDATE(),                      
  (convert(numeric(19,0),rand() * 8999999999999999999) + 1000000000000000000),1,CONVERT(varchar(200),1))                
                    
  insert into mstOfficernew( OfficerType, FirstName, LastName, UserName, StateId,                 
  EmailId, StatusFlag, CreatedTime, Createdby, ModifiedTime,                
  ModifiedBy, ActionType, Userid, Useragent, MobileNo)                
  values(4,@FirstName,@LastName,@UserName,@StateId,@Email,1,getdate(),null,getdate(),null,@ActionType,                
  null,'Web',@MobileNo)        
  select 1 as Status ,'User Added Successfully' as Reason                
  Commit                 
 end            
end        
else         
begin        
 select 0 as Status ,'User Already Exists' as Reason         
end        
END                        
END TRY                        
BEGIN CATCH                         
IF @@TRANCOUNT > 0                         
BEGIN                         
ROLLBACK TRANSACTION;                         
END                          
DECLARE @error VARCHAR (100)                         
SELECT @error=ERROR_MESSAGE()                         
RAISERROR (@error,16,1)                              
END CATCH 