

------------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 09 Dec 2022
--USP For:- Get User Role List
--Modified By:-
--Modifed Date:-
-------------------------------------------------------------

ALTER proc [dbo].[UspGetUserManageRoleListHPPay] -- '1'
(
@RoleId varchar(100)   
)
as                 
BEGIN                
              
select C.RoleName,C.Description from tblRoleMapNew C with(nolock) where StatusFlag=1 and RoleId in (select Value from ConvertintoCommaTable(@RoleId))                 
                
select M.MenuId,MenuName,MenuNameId,ParentMenuId,MenuLevel,MenuOrder,Controller,Action,     
ImageUrl, Heading ,L.AllowedAction as AllowedAction, IsFinalPage          
from tblMenuDetailsHPPay as M with(noLock)     
left join
(select MenuId, MAX(AllowedAction) as AllowedAction  from tblRoleMenuMapNew with(noLock)    
where StatusFlag = 1 and RoleId in (1,2,3,4,5,6)    
Group by MenuId) as L    
on M.MenuId = L.MenuID            
where M.StatusFlag = 1 Group by M.MenuId, MenuName,MenuNameId,ParentMenuId,MenuLevel,    
MenuOrder,Controller,Action, ImageUrl, Heading,L.AllowedAction, IsFinalPage
            
End 

