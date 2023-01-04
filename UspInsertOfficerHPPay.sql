---------------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 20 Dec 2022
--Created USP for:- Insert Officer Pages
--Modified BY:-
--Modified Date:-
----------------------------------------------------------------

Alter  proc [dbo].[UspInsertOfficerHPPay]
(@FirstName varchar(50),                  
@LastName varchar(50),                  
@UserName varchar(50),                  
@LocationId int,                  
@Address1 varchar(250),                  
@Address2 varchar(250),                  
@Address3 varchar(250),                  
@StateId int,                  
@CityName varchar(100),                  
@DistrictId int,                  
@Pin varchar(6),                  
@MobileNo varchar(10),                  
@PhoneNo varchar(20),                  
@EmailId varchar(50),                  
@Fax varchar(20),                  
@CreatedBy varchar(40),                                  
@OfficerType int,                  
@UserAgent varchar(250),                  
@Userid varchar(250),                  
@Userip varchar(250),                  
@Password varchar(20) ='')                  
as begin                  
    declare @OfficerStatus int, @OfficerName varchar(40);                  
    declare @UserRole int=0;                  
    declare @TypeGetZoRoTable table(ID INT IDENTITY(1, 1) Primary key,                  
    ZoId int,                  
    RoId int)                  
    declare @totcount int=0, @counter int=1, @ROID int=0;                  
    if(@OfficerType=4)set @OfficerStatus=0 else set @OfficerStatus=4                  
    declare @UserNameChk int=0                  
    if(ISNULL(@UserName, '')!='')begin                  
        set @UserNameChk=(select count(UserName)from mstOfficernew with(nolock)where UserName=@UserName and StatusFlag = 1)                  
    end                  
    declare @EmailCheck int=0                  
    if(ISNULL(@EmailId, '')!='')begin                  
        set @EmailCheck=(select count(EmailId)from mstOfficernew with(nolock)where EmailId=@EmailId  and StatusFlag = 1)                  
    end                  
    declare @MobileNoCheck int=0                  
    if(ISNULL(@MobileNo, '')!='')begin                  
        set @MobileNoCheck=(select count(MobileNo)from mstOfficernew with(nolock)where MobileNo=@MobileNo and StatusFlag = 1)                  
    end                  
                     
    if(@MobileNoCheck=0)        
 begin                  
                        
        if(@EmailCheck=0)        
  begin                  
                          
            if(@UserNameChk=0)        
   begin                  
                 
             if(@OfficerType=1)        
    begin                  
                    set @UserRole=3                  
                end              
    else if (@OfficerType = 3)        
    begin            
     set @UserRole = 2           
    end            
    else if (@OfficerType = 2)        
    begin            
     set @UserRole = 4          
    end 	
    else         
    begin                  
                         set @UserRole=0                  
                end                  
                insert into mstOfficernew(FirstName, LastName, UserName, Address1, Address2, Address3, StateId, CityName, DistrictId, Pin, MobileNo,              
    PhoneNo, EmailId, Fax, Createdby, ActionType,  OfficerType,               
    Userid, Useragent)                  
                values(@FirstName, @LastName, @UserName, @Address1, @Address2, @Address3, @StateId, @CityName, @DistrictId, @Pin, @MobileNo, @PhoneNo,               
    @EmailId, @Fax, @CreatedBy, 'Insert',  @OfficerType,  @Userid, @Useragent)                  
                declare @OfficerID int                  
                set @OfficerID=(select top 1 OfficerID                  
                                from mstOfficernew with(nolock)                  
                                where UserName=@UserName)       
               insert into mstOfficerLognew(OfficerID, FirstName, LastName, UserName, Address1, Address2, Address3, StateId, CityName,     
    DistrictId, Pin, MobileNo, PhoneNo, EmailId, Fax, Createdby, ActionType,  OfficerType,  Userid, Useragent)                  
                values(@OfficerID, @FirstName, @LastName, @UserName, @Address1, @Address2, @Address3, @StateId, @CityName,              
     @DistrictId, @Pin, @MobileNo, @PhoneNo, @EmailId, @Fax, @CreatedBy, 'Insert',  @OfficerType,              
    @Userid, @Useragent)                  
    if(@OfficerType=1 )begin                  
                    declare @ZO int=0;                  
                    set @ZO=(select top 1 ZOCode                  
                             from Mst_Regionaloffices with(nolock)                  
                             where ROCode=@LocationId)                  
                    insert into mstOfficerLocationMappingNew(OfficerId, UserName, ZOCode, ROCode, CreatedBy, MappedUserRoles)                  
                    values(@OfficerID, @UserName, @ZO, @LocationId, @CreatedBy, @UserRole)           
        
     end        
                                  
                else if(@OfficerType=3 )begin                  
                   insert into mstOfficerLocationMappingNew(OfficerId, UserName, ZOCode, ROCode, CreatedBy,  MappedUserRoles)                  
                         values(@OfficerID, @UserName, @LocationId, 0, @CreatedBy,  @UserRole)                  
                         Insert into @TypeGetZoRoTable                  
                         select ZOCode, ROCode                  
                         from Mst_Regionaloffices with(noLock)                  
                         where ZOCode=@LocationId                  
                         select @totcount=count(ID)from @TypeGetZoRoTable;                  
                         while(@counter<=@totcount)begin                  
                             select @ROID=RoId from @TypeGetZoRoTable where ID=@counter                  
                             insert into mstOfficerLocationMappingNew(OfficerId, UserName, ZOCode, ROCode, CreatedBy,  MappedUserRoles)                  
                             values(@OfficerID, @UserName, @LocationId, @ROID, @CreatedBy,  @UserRole)                  
                             set @counter=@counter+1                  
                         end                  
                end                  
                                                       
                if(@Password='' or @Password is null)                  
                    set @Password=(select convert(numeric(8, 0), rand()* 89999999)+10000000)                  
                insert into mstKeyDetailNew(LoginKey, KeyValue, UserType, UserSubType, CreatedBy,  UserRole)                  
                values(@UserName, HASHBYTES('SHA2_512', convert(nvarchar(max), @Password)), 1, @OfficerType, @CreatedBy,  @UserRole)                  
                set @OfficerName=(select top 1 OfficerTypeName                  
                                  from mstOfficerTypenew with(nolock)                  
                                  where OfficerTypeID=@OfficerType)                  
                select 1 as Status, 'Officer Created Successfully' as Reason, @Password as Password, @OfficerID as OfficerID, @OfficerName as OfficerName                  
                update mstOfficerLognew                  
                set StatusFlag=1 ,  Reason='Officer Created Successfully'                  
                where OfficerID=@OfficerID and ActionType='Insert'         
            end                  
            else
			begin                  
                                 
                             
                select 0 as Status, 'Username already exists' as Reason, '' as Password,  0 as OfficerID                  
                    update mstOfficerLognew                  
                  set StatusFlag=0, Reason='Username already exists'                  
                    where OfficerID=@OfficerID and ActionType='Insert' 
               end
                                  
           end     
		   
		   Else
		   Begin
		    select 0 as Status, 'Email Id already exists' as Reason, '' as Password, '' as ReferenceId, 0 as OfficerID                  
            update mstOfficerLognew                  
            set StatusFlag=0, Reason='Email Id already exists'                  
            where OfficerID=@OfficerID and ActionType='Insert' 
			end
		End
		Else 
		   Begin
		        select 0 as Status, 'Mobile No already exists' as Reason, '' as Password, '' as ReferenceId, 0 as OfficerID                  
            update mstOfficerLognew                 
            set StatusFlag=0, Reason='Mobile No already exists'                  
            where OfficerID=@OfficerID and ActionType='Insert' 
			end

		End
                             
                                  
                              
        