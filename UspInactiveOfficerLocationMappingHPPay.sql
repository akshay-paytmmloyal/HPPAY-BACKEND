------------------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 19 Dec 2022
--Created USP for:- Inactive officer location mapping page
--Modifed BY:-
--Modified Date:-
------------------------------------------------------------------

Create proc [dbo].[UspInactiveOfficerLocationMappingHPPay]     
(          
@UserName varchar(50),          
@RO int,          
@ZO int,          
@ModifiedBy varchar(40)          
)          
as          
begin          
declare @LocationCheck int = 0;

if exists (select 1 from mstOfficernew with(noLock) where StatusFlag = 1 and UserName = @UserName and OfficerType in (3))
begin
	set @LocationCheck=(select count(OfficerID) from mstOfficerLocationMappingNew with(nolock)           
	where UserName=@UserName and ZOCode=@ZO and  ROCode=0 and StatusFlag = 1)
	if(@LocationCheck>0)          
	begin         
		update mstOfficerLocationMappingNew set StatusFlag=0,ModifiedBy=@ModifiedBy,ModifiedTime=GETDATE()           
		where ZOCode=@ZO and UserName=@UserName       
		select '1' as Status,'Location Deleted Successfully' as Reason          
	end 
	else
	begin          
		select '0' as Status,'Location not exits' as Reason          
	end
end
else
begin
	set @LocationCheck=(select count(OfficerID) from mstOfficerLocationMappingNew with(nolock)           
	where UserName=@UserName and ROCode=@RO and StatusFlag = 1)
	if(@LocationCheck>0)          
	begin         
		update mstOfficerLocationMappingNew set StatusFlag=0,ModifiedBy=@ModifiedBy,ModifiedTime=GETDATE()           
		where ROCode=@RO and UserName=@UserName       
		select '1' as Status,'Location Deleted Successfully' as Reason          
	end 
	else
	begin          
		select '0' as Status,'Location not exits' as Reason          
	end
end
end          
