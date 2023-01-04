

-----------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 14 Dec 2022
--Created USP for:- Reset Password for Manage User
--Modified By:-
--Modified date:-
------------------------------------------------

Alter proc [dbo].[UspResetPasswordUserManageHPPay] --  'Raviadmin' ,'akshayadmin'
(       
@UserName varchar(50),    
@ModifiedBy Varchar(50)    
)                  
as    
SET XACT_ABORT ON;      
SET NoCount ON;      
      
 BEGIN TRY     
Begin 

DECLARE @Reason VARCHAR(40) , @APIStatus VARCHAR(40) ,@NewPass nvarchar(max),@communicationmobileNo varchar(10),@EmailIdForEmail varchar(150),
@firstname varchar(40),@lastname varchar(40),@individualOrgName varchar(100) ,@RetailOutletName varchar(100); 
IF Exists( select 1 from mstKeyDetailNew with (nolock) where LoginKey=@UserName and StatusFlag=1)    
  BEGIN 
    declare @Password varchar(20);                                     

	IF(LEFT(@UserName,1)='3' )
	BEGIN
	      
			 select @communicationmobileNo= store_person_email,@EmailIdForEmail=Store_emailid, @RetailOutletName =Store_Name
			 from Mst_Stores WITH(NOLOCK) where Store_Code=@UserName  AND Store_Status in (1,4)

			set @Password=(select convert(numeric(8,0),rand() * 89999999) + 10000000)    
		  Begin Tran    
		  update mstKeyDetail with(rowLock) set KeyValue=HASHBYTES('SHA2_512', convert(nvarchar(max),@Password)) where LoginKey=@UserName    
		  Commit    
		  select 1 as Status,'Password reset successfully, Mail has been sent to user.' as Reason, @Password as Password ,
		   @EmailIdForEmail AS Email,@communicationmobileNo as MobileNo, @individualOrgName as Name
    
		
	END
	ELSE
	BEGIN
		     declare @officerId int;          
		    select @officerId= OfficerID from mstOfficernew where UserName=@UserName                          
			select @communicationmobileNo= MobileNo,@firstname=FirstName,@EmailIdForEmail=EmailId, @lastname=LastName
			from mstOfficernew WITH(NOLOCK) where OfficerID=@officerId   AND StatusFlag=1                                                                                     
			set @Password=(select convert(numeric(8,0),rand() * 89999999) + 10000000)    
		  Begin Tran    
		  update mstKeyDetailNew with(rowLock) set KeyValue=HASHBYTES('SHA2_512', convert(nvarchar(max),@Password)) where LoginKey=@UserName    
		  Commit    
		  select 1 as Status,'Password reset successfully, Mail has been sent to user.' as Reason, @Password as Password ,
		   @EmailIdForEmail AS Email,@communicationmobileNo as MobileNo, @firstname+ ' '+@lastname as Name



	END
   
  END    
   ELSE    
  BEGIN    
     select 0 as Status,'Invalid User Name' as Reason, null as Password  
  END    

  end

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
