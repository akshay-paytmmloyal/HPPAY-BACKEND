
-------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 13 dec 2022
--Created USP for:- Manage Edit user page
--Modified By:-
--Modified Date:-
-------------------------------------------------------

Alter proc [dbo].[UspManageEditUserHPPay] --'akshayadmin'
(@UserName varchar(15))
as BEGIN
    SET NOCOUNT ON;
    Declare @UserType int=0, @UserRole varchar(200) ='', @OfficerId int=0, @Sql1 nvarchar(4000) ='', @Sql2 nvarchar(4000) ='', @temp VARCHAR(4000)
    if exists (select 1
               from mstKeyDetailNew with(nolock)
               where LoginKey=@UserName and StatusFlag=1)
			   begin
              
        declare @totcount int=0, @counter int=1, @RoleId int=0
        declare @newtable table(ID INT IDENTITY(1, 1) Primary key,
        RoleID int)	
        declare @OfficerNewTable table(ID INT IDENTITY(1, 1) Primary key,
        RoleID int)
        select @UserType=UserType, @UserRole=UserRole
        from mstKeyDetailNew with(noLock)
        where StatusFlag=1 and LoginKey=@UserName
		insert into @newtable(RoleID)
        Select Value from ConvertintoCommaTable(@UserRole)
        select @totcount=count(*)from @newtable
        Set @Sql1='SELECT MK.LoginKey,MK.UserType,              
    (CASE WHEN (MK.UserType = 3) THEN (select store_emailid from mst_stores with(noLock) where store_code = MK.LoginKey and StatusFlag = 1)              
    WHEN (MK.UserType = 1) THEN (select EmailId from mstofficernew with(noLock) where UserName = MK.LoginKey and StatusFlag = 1) END)              
    as Email,      
 convert(varchar(10),MK.CreatedTime,105)+'' ''+ convert(varchar(10),MK.CreatedTime,108) CreatedDate,      
 convert(varchar(10),(select MAX(LastLogin) from tblUserLastLogin with(noLock) where UserName = MK.LoginKey Group By UserName),105)+'' ''+       
 convert(varchar(10),(select MAX(LastLogin) from tblUserLastLogin with(noLock) where UserName = MK.LoginKey Group By UserName),108) LastLogin      
    ,1 as Status ,''Success'' as Reason               
    from mstKeyDetailnew MK with(nolock)              
    where MK.LoginKey='''+@UserName+''' and MK.StatusFlag=1'
        
		 if(@UserType=1)
		begin
                 select @OfficerId=OfficerID
                 from mstOfficernew with(noLock)
                 where UserName=@UserName and StatusFlag=1
                 select @temp=COALESCE(@temp+', ', '')+MappedUserRoles
                 from mstOfficerLocationMappingNew with(noLock)
                 where UserName=@UserName and StatusFlag=1 and OfficerId=@OfficerId
                 Print @temp
                 Insert into @OfficerNewTable
                 select RoleId
                 from(select Distinct(Value) as RoleId from ConvertintoCommaTable(@temp) )A
                 select @totcount=count(*)from @OfficerNewTable
                 while(@counter<=@totcount)begin
                     select @RoleId=RoleID from @OfficerNewTable where ID=@counter
                     if(ISNULL(@Sql2, '')='')begin
                         Set @Sql2='Select '+CONVERT(varchar(10), @RoleId)+' as RoleId,(SELECT RM.Rolename from tblRoleMapNew RM with(nolock) where RM.RoleID='+CONVERT(varchar(10), @RoleId)+') as UserRole,              
  '''                              +@UserName+''' as UserName,B.Rocode,B.Roname, C.Zocode ,C.Zoname              
  From mstOfficerLocationMappingNew A with(nolock)              
  left outer join Mst_Regionaloffices B with(nolock) on A.ROCode = B.Rocode                        
  left outer join Mst_zonaloffices C with(nolock) on A.ZOCode = C.Zocode                      
  Where A.OfficerId = '            +CONVERT(varchar(10), @OfficerId)+'and A.StatusFlag = 1 and A.MappedUserRoles like ''%'+CONVERT(varchar(10), @RoleId)+'%'''
                     end
                     else begin
                         Set @Sql2=@Sql2+' Union Select '+CONVERT(varchar(10), @RoleId)+' as RoleId,(SELECT RM.Rolename from tblRoleMapNew RM with(nolock) where RM.RoleID='+CONVERT(varchar(10), @RoleId)+') as UserRole,  
  '''                              +@UserName+''' as UserName,B.Rocode,B.Roname, C.Zocode ,C.Zoname              
  From mstOfficerLocationMappingNew A with(nolock)              
  left outer join Mst_Regionaloffices B with(nolock) on A.ROCode = B.Rocode                        
  left outer join Mst_zonaloffices C with(nolock) on A.ZOCode = C.Zocode                      
  Where A.OfficerId = '            +CONVERT(varchar(10), @OfficerId)+' and A.StatusFlag = 1 and (A.MappedUserRoles like ''%,'+CONVERT(varchar(10), @RoleId)+',%''   
  or A.MappedUserRoles like '''    +CONVERT(varchar(10), @RoleId)+',%'' or A.MappedUserRoles like ''%,'+CONVERT(varchar(10), @RoleId)+'''  
  or A.MappedUserRoles like '''    +CONVERT(varchar(10), @RoleId)+''')'
                     end
                     set @counter=@counter+1
                 end
        end
       
        If(@UserType=3)begin
                 while(@counter<=@totcount)begin
                     select @RoleId=RoleID from @newtable where ID=@counter
                     if(ISNULL(@Sql2, '')='')begin
                         Set @Sql2='Select '+CONVERT(varchar(10), @RoleId)+' as RoleId,(SELECT RM.Rolename from tblRoleMapNew RM with(nolock) where RM.RoleID = '+CONVERT(varchar(10), @RoleId)+') as UserRole,              
  '''                              +@UserName+''' as UserName, B.Rocode,B.Roname, C.Zocode ,C.Zoname              
  From mst_stores A with(nolock)                        
  left outer join Mst_Regionaloffices B with(nolock) on A.Rocode = B.Rocode                        
  left outer join Mst_zonaloffices C with(nolock) on A.Zocode = C.Zocode                      
  Where A.store_code = '''         +@UserName+''''
                     end
                     else begin
                         Set @Sql2=@Sql2+' and A.StatusFlag = 1 Union Select '+CONVERT(varchar(10), @RoleId)+' as RoleId,(SELECT RM.Rolename from tblRoleMapNew RM with(nolock) where RM.RoleID = '+CONVERT(varchar(10), @RoleId)+') as UserRole,              
  '''                              +@UserName+''' as UserName, B.Rocode,B.Roname, C.Zocode ,C.Zoname              
  From mst_stores A with(nolock)                        
  left outer join Mst_Regionaloffices B with(nolock) on A.Rocode = B.Rocode                        
  left outer join Mst_zonaloffices C with(nolock) on A.Zocode = C.Zocode                      
  Where A.store_code = '''         +@UserName+''''
                     end
                     set @counter=@counter+1
                 end
        end
       
       
    end
    else begin
        select 0 as Status, 'User not found' as Reason
        select null
    end
    --Print @Sql1
    --Print @Sql2
    If(ISNULL(@Sql1, '')<>'' and ISNULL(@Sql2, '')<>'')begin
        EXECUTE sp_executesql @Sql1
        EXECUTE sp_executesql @Sql2
    end
    else If(ISNULL(@Sql2, '')='')begin
             EXECUTE sp_executesql @Sql1
             select null
    end else begin
             select null
             EXECUTE sp_executesql @Sql2
    end
end

