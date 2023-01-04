
----------------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 16 Dec 2022
--Created USP for:- User Role location delete page
--Modified By:-
--Modified Date:-
----------------------------------------------------------------

Create proc UspManageUsersRoleLocationDeleteHPPay
(
@Username varchar(50),
@RoleId varchar(10),
@ModifiedBy varchar(50),
@TypeManageUsersAddUserRole TypeManageUsersAddUserRole readonly
)
As 
Begin
declare @UserRole varchar(1000) ='', @UserRoleLatest varchar(1000) ='', @UserType int=0, @OfficerID int=0, @MappedUserRoles varchar(1000) =''
    Begin Tran
    declare @TypeManageUsersAddUserRoleTable table(ID INT IDENTITY(1, 1) Primary key,
    [ZO] int NULL,
    [RO] int NULL)
    insert into @TypeManageUsersAddUserRoleTable([ZO], [RO])
    select ZO, RO from @TypeManageUsersAddUserRole
    declare @totcount int=0, @counter int=1, @ZO int, @RO int, @SuccessFlag int=0
    select @totcount=count(ID)from @TypeManageUsersAddUserRoleTable

	if exists (select 1
               from mstKeyDetailNew with(noLock)
               where LoginKey=@Username and StatusFlag=1)begin
        select @UserRole=UserRole
        from mstKeyDetailNew with(noLock)
        where LoginKey=@Username and StatusFlag=1
        Set @UserRoleLatest=STUFF((SELECT ','+CONVERT(varchar(10), Value)
                                   FROM(select Value
                                        from ConvertintoCommaTable(@UserRole)
                                        where Value<>@RoleId) as s
                                   ORDER BY s.Value
                                  FOR XML PATH('')), 1, 1, '')
        update mstKeyDetailNew with(rowLock)
        set UserRole=@UserRoleLatest
        where LoginKey=@Username and StatusFlag=1
        
		select @UserType=UserType
        from mstKeyDetailNew with(noLock)
        where LoginKey=@Username and StatusFlag=1
        
		select @OfficerID=OfficerID
        from mstOfficernew with(noLock)
        where StatusFlag=1 and UserName=@Username
        
		select @MappedUserRoles=MappedUserRoles
        from mstOfficerLocationMappingNew with(noLock)
        where OfficerId=@OfficerID and StatusFlag=1 and(MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+'')
        
		Set @MappedUserRoles=STUFF((SELECT ','+CONVERT(varchar(10), Value)
                                    FROM(select Value
                                         from ConvertintoCommaTable(@MappedUserRoles)
                                         where Value<>@RoleId) as s
                                    ORDER BY s.Value
                                   FOR XML PATH('')), 1, 1, '')

		  while(@counter<=@totcount)begin
            select @ZO=ZO, @RO =RO
            from @TypeManageUsersAddUserRoletable
            where Id=@counter
            If(@RO=0 and @ZO<>0)begin
			if(@UserType=3 and ISNULL(@UserRoleLatest, '')='')begin
                         insert into Mst_Stores_Audit(ERP_Code, store_name, store_type, dealer_name, dealer_mobile, Store_Category, highway_no, highway_name, SBU_type, LPCNGSale , pan_no, gst_no, Store_Address, Store_Address2, Store_Address3, Store_Location, Store_City, Store_State, Store_district, Store_Zip, Store_phonenumber, Store_fax, ZOCode, ROCode, SalesArea, Store_mgr, Store_mgr_middlename, Store_mgr_lastname, store_person_mobile, store_person_email,  Store_CommAddress1, Store_CommAddress2, Store_CommAddress3, Store_CommLocation, Store_CommCity, Store_CommState, Store_commDistrict, Store_CommPinCode, Store_CommOfficePhone, Store_CommFax, Store_Approved_on, Store_Approved_By, Store_Status)
                         select ERP_Code, store_name, store_type, dealer_name, dealer_mobile, Store_Category, highway_no, highway_name, SBU_type, LPCNGSale , pan_no, gst_no, Store_Address, Store_Address2, Store_Address3, Store_Location, Store_City, Store_State, Store_district, Store_Zip, Store_phonenumber, Store_fax, ZOCode, ROCode, SalesArea, Store_mgr, Store_mgr_middlename, Store_mgr_lastname, store_person_mobile, store_person_email,  Store_CommAddress1, Store_CommAddress2, Store_CommAddress3, Store_CommLocation, Store_CommCity, Store_CommState, Store_commDistrict, Store_CommPinCode, Store_CommOfficePhone, Store_CommFax, @ModifiedBy, GETDATE(), Store_Status
                         from Mst_Stores with(noLock)
                         where  Store_Code=@Username
                         update Mst_Stores with(rowLock)
                         Set ZOCode=null, Store_Approved_By=@ModifiedBy, Store_Approved_on=GETDATE()
                         where Store_Code=@Username and ZOCode=@ZO and ROCode=@RO
                end
				else if(@UserType=1)begin
                         if(ISNULL(@MappedUserRoles, '')='')begin
                             update mstOfficerLocationMappingNew with(rowLock)
                             Set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE()
                             where OfficerId=@OfficerID and StatusFlag=1 and ZOCode=@ZO and ROCode=0 and(MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+'')
                             
							 update mstOfficerLocationMappingNew with(rowLock)
                             Set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE()
                             where OfficerId=@OfficerID and StatusFlag=1 and ROCode in(select ROCode
                                                                                   from Mst_Regionaloffices with(noLock)
                                                                                   where ZOCode=@ZO)
																				   and(MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+'')
                         end
						 if (CHARINDEX(',', @MappedUserRoles) > 0)
						 begin
							 update mstOfficerLocationMappingNew with(rowLock)
							 Set MappedUserRoles=@MappedUserRoles
							 where OfficerId=@OfficerID and StatusFlag=1 and(MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+'')
						 end
                end
            end
		else if(@RO<>0)begin
		 if(@UserType=3 and ISNULL(@UserRoleLatest, '')='')begin
                              insert into Mst_Stores_Audit(ERP_Code, store_name, store_type, dealer_name, dealer_mobile, Store_Category, highway_no, highway_name, SBU_type, LPCNGSale , pan_no, gst_no, Store_Address, Store_Address2, Store_Address3, Store_Location, Store_City, Store_State, Store_district, Store_Zip, Store_phonenumber, Store_fax, ZOCode, ROCode, SalesArea, Store_mgr, Store_mgr_middlename, Store_mgr_lastname, store_person_mobile, store_person_email,  Store_CommAddress1, Store_CommAddress2, Store_CommAddress3, Store_CommLocation, Store_CommCity, Store_CommState, Store_commDistrict, Store_CommPinCode, Store_CommOfficePhone, Store_CommFax, Store_Approved_on, Store_Approved_By, Store_Status)
                              select ERP_Code, store_name, store_type, dealer_name, dealer_mobile, Store_Category, highway_no, highway_name, SBU_type, LPCNGSale , pan_no, gst_no, Store_Address, Store_Address2, Store_Address3, Store_Location, Store_City, Store_State, Store_district, Store_Zip, Store_phonenumber, Store_fax, ZOCode, ROCode, SalesArea, Store_mgr, Store_mgr_middlename, Store_mgr_lastname, store_person_mobile, store_person_email,  Store_CommAddress1, Store_CommAddress2, Store_CommAddress3, Store_CommLocation, Store_CommCity, Store_CommState, Store_commDistrict, Store_CommPinCode, Store_CommOfficePhone, Store_CommFax, @ModifiedBy, GETDATE(), Store_Status
                              from Mst_Stores with(noLock)
                              where   Store_Code=@Username
                              update Mst_Stores with(rowLock)
                              Set ROCode=null, Store_Approved_By=@ModifiedBy, Store_Approved_on=GETDATE()
                              where Store_Code=@Username  and ROCode=@RO
                     end
                     else if(@UserType=1)begin
                              if(ISNULL(@MappedUserRoles, '')='')begin
                                  update mstOfficerLocationMappingNew with(rowLock)
                                  Set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE()
                                  where OfficerId=@OfficerID and StatusFlag=1 and ROCode=@RO and(MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+'')
                              end
							 if (CHARINDEX(',', @MappedUserRoles) > 0)
							 begin
								  update mstOfficerLocationMappingNew with(rowLock)
								  Set MappedUserRoles=@MappedUserRoles
								  where OfficerId=@OfficerID and StatusFlag=1 and(MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+',%' or MappedUserRoles like '%,'+CONVERT(varchar(10), @RoleId)+'' or MappedUserRoles like ''+CONVERT(varchar(10), @RoleId)+'')
							 end
                     end
            end
			 SET @counter=@counter+1
        end
        select 1 as Status, 'Role Deleted for the User.' as Reason
        COMMIT
    end
    else begin
        ROLLBACK
        select 0 as Status, 'User not found.' as Reason
    end
End