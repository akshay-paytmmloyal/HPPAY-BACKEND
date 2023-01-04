-----------------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 19 Dec 2022
--Created USP for:- Insert Officer location mapping page
--Modified By:-
--Modified Date:-
-----------------------------------------------------------------

Create proc [dbo].[UspInsertOfficerLocationMappingHPPay]              
(              
@OfficerId int,              
@ZO int,              
@RO int,              
@CreatedBy varchar(40)          
)              
as              
begin              
              
declare @OfficerIDCheck int = 0    
declare @UserRole varchar(1000) = '';    
declare @UserName varchar(100) = '';  
declare @OfficerType int = 0;
declare @TypeGetZoRoTable table(ID INT IDENTITY(1, 1) Primary key,    ZoId int,    RoId int)    
declare @totcount int=0, @counter int=1, @ROID int=0;  

set @OfficerIDCheck=(select count(OfficerID) from mstOfficernew with(nolock) where OfficerID=@OfficerId and StatusFlag = 1 )              
    
if(@OfficerIDCheck>0)      
begin              
declare @LocationCheck int = 0;    

select @UserName = UserName, @OfficerType=OfficerType from mstOfficernew with(noLock) where OfficerID = @OfficerId and StatusFlag = 1    
set @UserRole = (select UserRole from mstKeyDetailNew with(noLock) where LoginKey = @UserName and StatusFlag = 1)    

set @LocationCheck=(select count(OfficerID) from mstOfficerLocationMappingNew with(nolock)               
where UserName=@UserName and ZOCode=@ZO and ROCode=@RO and StatusFlag = 1 and OfficerId = @OfficerId)              
if(@LocationCheck=0)              
begin              

if (@OfficerType = 3 )
begin
	insert into mstOfficerLocationMappingNew(OfficerId,UserName,ZOCode,ROCode,CreatedBy, MappedUserRoles)              
	values(@OfficerId,@UserName,@ZO,@RO,@CreatedBy,@UserRole)    

    Insert into @TypeGetZoRoTable    
    select ZOCode, ROCode    
    from Mst_Regionaloffices with(noLock)    
    where ZOCode=@ZO    
    select @totcount=count(ID)from @TypeGetZoRoTable;    
    while(@counter<=@totcount)begin    
        select @ROID=RoId from @TypeGetZoRoTable where ID=@counter    
        insert into mstOfficerLocationMappingNew(OfficerId, UserName, ZOCode, ROCode, CreatedBy,  MappedUserRoles)    
        values(@OfficerID, @UserName, @ZO, @ROID, @CreatedBy, @UserRole)    
        set @counter=@counter+1    
    end  

	select '1' as Status,'Location Mapped Successfully' as Reason 
end
else
begin
	insert into mstOfficerLocationMappingNew(OfficerId,UserName,ZOCode,ROCode,CreatedBy, MappedUserRoles)              
	values(@OfficerId,@UserName,@ZO,@RO,@CreatedBy,@UserRole)    
	   select '1' as Status,'Location Mapped Successfully' as Reason 
end
             
end              
else              
begin              
    select '0' as Status,'Location already mapped' as Reason              
end              
              
end              
begin              
    select '0' as Status,'Officer not exits' as Reason              
end              
end 


