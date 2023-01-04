

----------------------------------------------------------------
--Created By:- Askhay Tripathi
--Created Date:-
--USP For:- Manage Edit User 
--Modified By:-
--Modified Date:- 
-------------------------------------------------------------


Alter Proc UspManageEditUsersHPPay-- 'Akshayadmin'
(
@Username varchar(50)
)

As 

Begin

SET NOCOUNT ON;  
  
Select LoginKey as UserName,'' as Email,convert(varchar(10),CreatedTime,105) as CreatedDate,  
(select MAX(convert(varchar(10),LastLogin,105)) from tblUserLastLogin with(nolock)) as LastLoginDate from mstKeyDetailNew with (nolock)  
where StatusFlag = 1 and LoginKey = @UserName  
  

 End