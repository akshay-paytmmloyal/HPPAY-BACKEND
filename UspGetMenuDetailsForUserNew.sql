
------------------------------------------
--Created By:- Akshay Tripathi
--USP for:- Get details of all pages accroding the roles
--Created Date:- 28 Nov 2022
--Modifed Date:-
--Modified By:- 
--------------------------------------------------

Alter Proc UspGetMenuDetailsForUserNew --'1','Akshayadmin'
(
@UserType varchar(1000),            
@UserId varchar(50)
)
As


Begin

Set nocount on ;

select @UserId as UserID,
M.MenuId,
MenuName,
MenuNameId,
ParentMenuId,
MenuLevel,
MenuOrder,
Controller,
Action, 
ImageUrl,
Heading, 
Details ,
Max(L.AllowedAction) as AllowedAction        
from tblMenuDetailsHPPay as M with(noLock)              
inner join tblRoleMenuMapNew as L with(noLock) on M.MenuId = L.MenuID          
where M.StatusFlag = 1 and L.StatusFlag = 1 and L.RoleId=@UserType and AllowedAction in (1,2)  
Group by M.MenuId, MenuName,MenuNameId,ParentMenuId,MenuLevel,MenuOrder,Controller,Action, ImageUrl, Heading, Details

End
