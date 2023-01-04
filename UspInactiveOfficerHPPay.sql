
-------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 20 Dec 2022
--Created USP For:- Inactive officer 
--Modified BY:-
--Modified Date:-
--------------------------------------------------------
Alter proc [dbo].[UspInactiveOfficerHPPay]      
(      
@OfficerId int,      
@ModifiedBy varchar(40)      
)      
as      
begin      
      
declare @OfficerIDCheck int      
set @OfficerIDCheck=(select count(OfficerID) from mstOfficernew with(nolock) where OfficerID=@OfficerId)      
if(@OfficerIDCheck>0)      
begin      
insert into mstOfficerLognew      
(      
OfficerID,FirstName,LastName,UserName,Address1,Address2,Address3,StateId,CityName,DistrictId,Pin,MobileNo,      
PhoneNo,EmailId,Fax,Createdby,ActionType,OfficerType,ModifiedBy,ModifiedTime,CreatedTime     
)      
select OfficerID,FirstName,LastName,UserName,Address1,Address2,Address3,StateId,CityName,DistrictId,Pin,MobileNo,      
PhoneNo,EmailId,Fax,Createdby,ActionType,OfficerType,ModifiedBy,ModifiedTime,CreatedTime      
from mstOfficernew where OfficerID=@OfficerId      
      
update mstOfficernew with(rowLock) set StatusFlag=0,ModifiedBy=@ModifiedBy,ModifiedTime=GETDATE(),ActionType='Delete' where OfficerID=@OfficerId      

update mstKeyDetailNew with(rowLock) set StatusFlag = 0,ModifiedBy=@ModifiedBy,ModifiedTime=GETDATE() where LoginKey = (select UserName from mstOfficernew with(noLock) where OfficerId = @OfficerId)

 select '1' as Status,'Officer Deleted Successfully' as Reason      
end      
else      
begin      
 select '0' as Status,'Officer not exits' as Reason      
end      
end      