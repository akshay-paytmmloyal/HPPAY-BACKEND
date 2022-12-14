USE [Hppay]
GO
/****** Object:  StoredProcedure [dbo].[UspUpdateManageUsersHPPay]    Script Date: 08-12-2022 18:52:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------
--Created By:- Akshay Tripathi
--Created date:- 08 Dec 2022
--Usp For:- Enable/Disable of User in Mange user page
--Modified By:-
--Modifed Date:-
---------------------------------------------------------


ALTER proc [dbo].[UspUpdateManageUsersHPPay] --'Akshayadmin','Enable'
(
  
@UserName varchar(50),
@Actions varchar(15)
)
as
SET XACT_ABORT ON;  
SET NoCount ON;  
  
 BEGIN TRY  
Begin
BEGIN TRAN
	if exists(select 1 from mstKeyDetailNew with (nolock)  where LoginKey = @UserName and StatusFlag = 1)
	begin
		if(@Actions = 'Disable')
		begin
			if exists(select 1 from mstKeyDetailNew with (nolock)  where LoginKey = @UserName and StatusFlag =1 and LoginStatus=0)
			begin
				Select 0 as Status,@UserName + ' is Already Disabled' as Reason
			end
			else
			begin
				Update mstKeyDetailNew with (rowlock)  set LoginStatus = 0 where LoginKey = @UserName and StatusFlag = 1
				Select 1 as Status, @UserName + ' Successfully disabled' as Reason
			end
		end
		else if(@Actions = 'Enable')
		begin
			if exists(select 1 from mstKeyDetailNew with (nolock)  where LoginKey = @UserName and StatusFlag = 1 and LoginStatus = 1)
			begin
				Select 0 as status, @UserName + ' Already enabled' as Reason
			end
			else
			begin
				Update mstKeyDetailNew with (rowlock) set LoginStatus = 1  where LoginKey = @UserName and StatusFlag = 1
				select 1 as status, @UserName + ' Successfully enabled' as Reason
			end
		end
	
	end
else

begin
		Select 0 as status, 'UserName does not exist' as Reason
	end
COMMIT
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

