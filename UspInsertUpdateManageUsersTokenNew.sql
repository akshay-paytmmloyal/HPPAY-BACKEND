USE [Hppay]
GO
/****** Object:  StoredProcedure [dbo].[UspInsertUpdateManageUsersTokenNew]    Script Date: 28-11-2022 15:58:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------
--Created By:- Akshay Tripathi  
-- USP For:- Insert update Token after login 
--Created date:- 28 Nov 2022  
--Modified By:-  
--Modified Date:- 
------------------------------------------------------

ALTER Proc [dbo].[UspInsertUpdateManageUsersTokenNew]
(
@UserId varchar(50),      
@Token nvarchar(4000),      
@UserAgent varchar(50),    
@UserIp varchar(50)
)
As 
Begin 

if exists (select 1      
                   from mstManageUsersToken with(noLock)      
                   where UserId=@UserId and UserAgent=@UserAgent) 
		Begin

		delete from mstManageUsersToken where UserId=@UserId and UserAgent=@UserAgent    
      Insert into mstManageUsersToken(UserId, TokenId, TimeStart, TimeEnd, UserAgent, UserIp)    
      values(@UserId, @Token, GETDATE(), DATEADD(mi, 30, GETDATE()), @UserAgent, @UserIp)    
      select 1 as Status, 'Success' as Reason    
       end      
       else   
       begin      
        Insert into mstManageUsersToken(UserId, TokenId, TimeStart, TimeEnd, UserAgent, UserIp)    
        values(@UserId, @Token, GETDATE(), DATEADD(mi, 30, GETDATE()), @UserAgent, @UserIp)    
    
        select 1 as Status, 'Success' as Reason    
       end      

	End


