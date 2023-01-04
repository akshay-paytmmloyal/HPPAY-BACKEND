----------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 16 Dec 2022
--Created USP for:- Update User role location page
--Modifed By:- 
--Modified Date:-
------------------------------------------------

Create Proc UspUpdateUserRoleLocationHPPay
(
@UserName varchar(50), 
@Email varchar(200) ='',        
@CreatedBy varchar(40),        
@UserRole Int,        
@TypeManageUsersAddUserRoleWithStatusFlag TypeManageUsersAddUserRoleWithStatusFlag readonly
)
As

SET XACT_ABORT ON;        
SET NoCount ON; 

BEGIN TRY 

BEGIN        
DECLARE @UserRoles varchar(200) =''        
declare @TypeManageUsersAddUserRoleWithStatusFlagTable table(ID INT IDENTITY(1, 1) Primary key,        
[ZO] int NULL,        
[RO] int NULL,        
[StatusFlag] int NULL)        
declare @UserType int=0        
declare @OfficerType int=0      
insert into @TypeManageUsersAddUserRoleWithStatusFlagTable([ZO], [RO], [StatusFlag])        
select ZO, RO, StatusFlag from @TypeManageUsersAddUserRoleWithStatusFlag        
declare @totcount int=0, @counter int=1, @ZO int, @RO int, @StatusFlag int, @OfficerID varchar(10)='', @SuccessFlag int=0        
select @totcount=count(ID)        
from @TypeManageUsersAddUserRoleWithStatusFlagTable        
select @UserType=UserType        
from mstKeyDetailNew with(noLock)        
where StatusFlag=1 and LoginKey=@UserName        
select @OfficerID=OfficerID        
from mstOfficernew with(noLock)        
where StatusFlag=1 and UserName=@UserName

IF EXISTS (select 1        
from mstKeyDetailNew with(nolock)        
where LoginKey=@UserName and StatusFlag=1 and UserRole is not null)    
begin       
If not exists (select 1        
from mstKeyDetailNew with(noLock)        
where StatusFlag=1 and(UserRole like '%,'+CONVERT(varchar(10), @UserRole)+',%' or UserRole like ''+    
CONVERT(varchar(10), @UserRole)+',%' or UserRole like '%,'+CONVERT(varchar(10), @UserRole)+'' or UserRole like ''+CONVERT(varchar(10),@UserRole)+''))    
begin        
Select @UserRoles=UserRole        
from mstKeyDetailNew        
where LoginKey=@UserName and StatusFlag=1        
Set @UserRoles=@UserRoles+','+CONVERT(varchar(10), @UserRole);        
Update mstKeyDetailNew with(rowlock)        
set UserRole=@UserRoles, UserSubType = IIF(@OfficerType=0,UserSubType,@OfficerType)      
where LoginKey=@UserName and StatusFlag=1        
end        

while(@counter<=@totcount)
begin        
Begin Tran        
select @ZO=ZO, @RO =RO, @StatusFlag=StatusFlag        
from @TypeManageUsersAddUserRoleWithStatusFlagTable        
where Id=@counter 

if(@UserType=3)begin        
if(@totcount>1)begin        
select 0 as Status, 'Merchant cannot be linked with more than one regions' as Reason        
end        
else begin        
insert into Mst_Stores_Audit(ERP_Code, store_name, store_type, dealer_name, dealer_mobile, Store_Category, highway_no,  highway_name, SBU_type,     
LPCNGSale, pan_no, gst_no, Store_Address,      
Store_Address2, Store_Address3, store_longitude, Store_City, Store_State, Store_district, Store_Zip,     
Store_phonenumber, Store_fax, ZOCode, ROCode,       
SalesArea, Store_mgr, Store_mgr_middlename, Store_mgr_lastname, store_person_mobile, store_person_email, Store_CommAddress1,     
Store_CommAddress2, Store_CommAddress3, Store_CommLocation,Store_CommCity ,      
store_commstate , Store_commDistrict, Store_CommPinCode, Store_CommOfficePhone, Store_CommFax, store_created_by, Store_Created_on, Store_Status    
)     
       
select ERP_Code, store_name, store_type, dealer_name, dealer_mobile, Store_Category, highway_no,  highway_name, SBU_type,     
LPCNGSale, pan_no, gst_no, Store_Address,      
Store_Address2, Store_Address3, store_longitude, Store_City, Store_State, Store_district, Store_Zip,     
Store_phonenumber, Store_fax, ZOCode, ROCode,       
SalesArea, Store_mgr, Store_mgr_middlename, Store_mgr_lastname, store_person_mobile, store_person_email, Store_CommAddress1,     
Store_CommAddress2, Store_CommAddress3, Store_CommLocation,Store_CommCity ,      
store_commstate , Store_commDistrict, Store_CommPinCode, Store_CommOfficePhone, Store_CommFax,     
@CreatedBy, GETDATE(), Store_Status        
from Mst_Stores with(noLock)        
where   Store_Code=@Username        
update Mst_Stores with(rowLock)        
Set Store_emailid=IIF(ISNULL(@Email, '')<>'', @Email, store_emailid), ZOCode=(IIF(@StatusFlag=0, null, @ZO)), ROCode=(IIF(@StatusFlag=0, null, @RO)),    
LastModifiedBy=@CreatedBy, LastModifiedOn=GETDATE()        
where Store_Code=@Username     
end        
end        

Else if(@UserType=1)
Begin        
if (@OfficerID <> '')        
begin        
if(@StatusFlag=0)begin        
if exists (select 1        
from mstOfficerLocationMappingNew with(noLock)        
where ZOCode=@ZO and ROCode=@RO and StatusFlag=1 and OfficerId=@OfficerID and UserName=@UserName and(MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+',%'     
or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+',%' or MappedUserRoles like '    
      
%,'+CONVERT(varchar(10), @UserRole)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+''))begin        
update mstOfficerLocationMappingNew with(rowLock)        
set StatusFlag=0        
where ZOCode=@ZO and ROCode=@RO and OfficerId=@OfficerID and StatusFlag=1 and UserName=@UserName and(MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+',%'     
or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+',%' or MappedUserRoles like '%,'+    
CONVERT(varchar(10), @UserRole)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+'')        
if(@ZO<>0 and @RO<>0)begin        
if exists (select 1        
from mstOfficerLocationMappingNew with(noLock)        
where ZOCode=@ZO and ROCode=0 and StatusFlag=1 and OfficerId=@OfficerID and UserName=@UserName and(MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+',%'     
or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+',%' or MappedUserRoles like '%,'+    
CONVERT(varchar(10), @UserRole)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+''))begin        
update mstOfficerLocationMappingNew with(rowLock)        
set StatusFlag=0        
where ZOCode=@ZO and ROCode=0 and OfficerId=@OfficerID and StatusFlag=1 and UserName=@UserName and(MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+',%'     
or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+',%' or MappedUserRoles like '%,'+    
CONVERT(varchar(10), @UserRole)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+'')        
end        
end        
end        
end        
else if(@StatusFlag=1)begin        
if exists (select 1        
from mstOfficerLocationMappingNew with(noLock)        
where ZOCode=@ZO and ROCode=@RO and OfficerId=@OfficerID and UserName=@UserName and(MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+',%' or    
MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+',%' or MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+''     
or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+''))begin        
update mstOfficerLocationMappingNew with(rowLock)        
set StatusFlag=1        
where ZOCode=@ZO and ROCode=@RO and OfficerId=@OfficerID and UserName=@UserName and(MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+',%' or     
MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+',%' or MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+'' or MappedUserRoles     
like ''+CONVERT(varchar(10), @UserRole)+'')        
end        
else begin        
insert into mstOfficerLocationMappingNew(OfficerId, UserName, ZOCode, ROCode, CreatedBy, CreatedTime, ModifiedBy, ModifiedTime, StatusFlag, MappedUserRoles)        
values(@OfficerID, @UserName, @ZO, @RO, @CreatedBy, GETDATE(), null, null, 1, CONVERT(varchar(10), @UserRole))        
end        
end        
end        
else        
begin        
if exists (select 1 from mstOfficernew  with(noLock) where StatusFlag=1 and UserName=@UserName)        
begin        
select 0 as Status, 'Officer is Not Active.' as Reason        
end        
else        
begin        
select 0 as Status, 'Officer Not Found.' as Reason        
end        
end        
end      
else begin        
select 0 as Status, 'Invalid User Type Found.' as Reason        
end        
SET @counter=@counter+1        
COMMIT        
end       
select 1 as Status, 'User Role, Location and Email Updated Successfully' as Reason
end

Else

Begin        
Begin Tran        
Update mstKeyDetailNew with(rowlock)        
set UserRole=@UserRole        
where LoginKey=@UserName        
while(@counter<=@totcount)begin        
BEGIN TRAN        
select @ZO=ZO, @RO =RO, @StatusFlag=StatusFlag        
from @TypeManageUsersAddUserRoleWithStatusFlagTable        
where Id=@counter        
If(@RO=0 and @ZO<>0)begin        
if not exists 
(select 1        
from mstOfficerLocationMappingNew with(noLock)        
where StatusFlag=1 and OfficerId=@OfficerID and UserName=@UserName and ZOCode=@ZO and ROCode=0 and(MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+',%'     
or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+',%' or     
MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+''))begin        
insert into mstOfficerLocationMappingNew(OfficerId, UserName, ZOCode, ROCode, CreatedBy, CreatedTime, ModifiedBy, ModifiedTime,  MappedUserRoles)        
values(@OfficerID, @UserName, @ZO, 0, @CreatedBy, getdate(), null, null,  CONVERT(varchar(10), @UserRole))        
end        
end        
else if(@RO<>0)begin        
if not exists (select 1        
from mstOfficerLocationMappingNew with(noLock)        
where StatusFlag=1 and OfficerId=@OfficerID and UserName=@UserName and ROCode=@RO and(MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+',%'     
or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+',%' or MappedUserRoles like '%,'+CONVERT(varchar(10), @UserRole)+''     
or MappedUserRoles like ''+CONVERT(varchar(10), @UserRole)+''))
begin        
insert into mstOfficerLocationMappingNew(OfficerId, UserName, ZOCode, ROCode, CreatedBy, CreatedTime, ModifiedBy, ModifiedTime,  MappedUserRoles)        
values(@OfficerID, @UserName, @ZO, @RO, @CreatedBy, getdate(), null, null,  CONVERT(varchar(10), @UserRole))        
end        
end        
SET @counter=@counter+1        
COMMIT        
end       

select 1 as Status, 'User Role and Location Added Successfully' as Reason  

commit
end        
END        
END TRY        
BEGIN CATCH        
IF @@TRANCOUNT>0 BEGIN        
ROLLBACK TRANSACTION;        
END        
DECLARE @error VARCHAR(100)        
SELECT @error=ERROR_MESSAGE()        
RAISERROR(@error, 16, 1)        
END CATCH 




