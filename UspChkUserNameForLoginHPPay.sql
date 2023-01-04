use hppay
-----------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 20 Dec 2022
--Created USP for:- Check User name for login in HPPay
--Modified BY:-
--Modified Date:-
-----------------------------------------------------------

Alter Proc UspChkUserNameForLoginHPPay --'Raviadmin'
(
@UserName varchar(50) 
)
As
Begin 
declare @UserNameCheck int      
set @UserNameCheck =(select count(LoginKey) from mstKeyDetailNew with(nolock) where LoginKey=@UserName)      
if(@UserNameCheck=0)      
begin      
 select '1' as Status,'Username available' as Reason      
end      
else      
begin      
 select '0' as Status,'Username exists' as Reason      
end      
end   