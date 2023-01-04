-------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 20 Dec 2022
--Created USP For:- Check User Name page
--Modified BY:-
--Modified Date:-
------------------------------------------------

Alter proc [dbo].[UspChkUserNameHPPay] --'Akshayadmin'
(          
@UserName varchar(50)          
)          
as          
begin          
	declare @UserNameCheck int = 0;
	declare @UserNameCheckMstKeyDetail int = 0;

	set @UserNameCheck =(select count(UserName) from mstOfficernew with(nolock) where UserName=@UserName)
	set @UserNameCheckMstKeyDetail =(select count(Loginkey) from mstKeyDetailNew with(nolock) where LoginKey=@UserName)

	if(@UserNameCheck=0 and @UserNameCheckMstKeyDetail = 0)          
	begin          
		select '1' as Status,'Username available' as Reason          
	end          
	else          
	begin          
		select '0' as Status,'Username exists' as Reason          
	end
end
