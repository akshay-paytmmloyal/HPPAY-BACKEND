      
-----------------------------------------------      
--Report Name:- For Manage User token details      
-- Created By:- Akshay Tripathi      
--Created date:- 18 Nov 2022      
--Modified date:-       
---------------------------------------------      
  
      
Alter Proc UspCheckManageUsersToken -- 'Akshayadmin','web',''      
(      
@UserId varchar(50),      
@UserAgent varchar(50),      
@UserIp varchar(50)      
)      
As       
Begin      
      
Declare @Token nvarchar(4000) =''      
      if exists (select 1      
                   from mstManageUsersToken with(noLock)      
                   where StatusFlag=1 and UserId=@UserId and TimeEnd>GETDATE()and UserAgent=@UserAgent and UserIp=@UserIp)      
    Begin      
     select @Token=TokenId      
                 from mstManageUsersToken with(noLock)      
                 where StatusFlag=1 and UserId=@UserId and TimeEnd>GETDATE()and UserAgent=@UserAgent and UserIp=@UserIp      
      
     update mstManageUsersToken with(rowLock)      
                 set TimeEnd=DATEADD(mi, 30, GETDATE())      
                 where StatusFlag=1 and UserId=@UserId and UserAgent=@UserAgent and UserIp=@UserIp      
                  
        select 1 as Status, 'Success' as Reason, @Token as Token      
      
     select @UserId as UserID, M.MenuId,       
            MenuName, MenuNameId,       
            ParentMenuId, MenuLevel,      
            MenuOrder, Controller,      
            Action, ImageUrl,      
            Heading, Details,      
               ISNULL(Max(L.AllowedAction),'0') as AllowedAction       
         from tblMenuDetails as M with(noLock)        
         left join (select * from tblRoleMenuMapNew with(noLock)       
                 where RoleId=1 and StatusFlag = 1) as L      
          on M.MenuId=L.MenuID where M.StatusFlag=1       
       Group by       
       M.MenuId, MenuName, MenuNameId, ParentMenuId, MenuLevel, MenuOrder, Controller, Action,       
          ImageUrl, Heading, Details       
      End      
   Else       
     Begin      
        select 0 as Status, 'Token Expired' as Reason, null as Token      
                 select null      
     End      
      
 End      
      
  