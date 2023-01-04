
-------------------------------------------------
--Created By:-Akshay Tripathi
--Created Date:- 30 Nov 2022
--USP For:- Get details of Users
--Modified By:-
--Modified Date:- 
------------------------------------------------

Alter Proc UspGetManageUsersHPpay --'Akshayadmin',null,null,null,0,null
(
@UserName varchar(50) = '',                        
@Email varchar(50) = '',                         
@LastLoginTime varchar(30) = '',                    
@UserRole  varchar(20) = '' ,            
@ShowDisabled int,  
@ForAll varchar(50) = ''
)

As 

begin                
SET NOCOUNT ON;            
declare @Sql varchar(4000),@Condition varchar(4000),@StatusFlag varchar (5)              
            
set @Condition=''  
  
If (ISNULL(@ForAll,'') <> '')  
begin  
 Set @Condition = IIF(ISNULL(@Condition,'')='', '', @Condition + ' and') + '( UserName = ''' + @ForAll + ''''  
 Set @Condition = IIF(ISNULL(@Condition,'')='', '', @Condition + ' or') + ' Email = ''' + @ForAll + ''''  
 Set @Condition = IIF(ISNULL(@Condition,'')='', '', @Condition + ' or') + ' UserRole = ''' + @ForAll + ''')'  
end  
else  
begin  
 If (ISNULL(@UserName,'') <> '')                        
 Begin                        
  Set @Condition = IIF(ISNULL(@Condition,'')='', '', @Condition + ' and') + ' UserName = ''' + @UserName + ''''                
 End                        
                        
 If (ISNULL(@Email,'') <> '')                        
 Begin                        
  Set @Condition = IIF(ISNULL(@Condition,'')='', '', @Condition + ' and') + ' Email= ''' + @Email + ''''          
 End                        
                        
 If (ISNULL(@LastLoginTime,'') <> '')                        
 Begin                        
  Set @Condition = IIF(ISNULL(@Condition,'')='', '', @Condition + ' and') + ' LastLoginTime like ''' + @LastLoginTime + '%'''          
 End                        
            
 If (ISNULL(@UserRole,'') <> '')                        
 Begin                        
  Set @Condition = IIF(ISNULL(@Condition,'')='', '', @Condition + ' and') + ' UserRole = ''' + @UserRole + ''''          
 End               
        
end  
    
if (@ShowDisabled = 0)            
            
Begin          
 if (@Condition = '' or @Condition is null)          
 begin          
  set @Sql = 'select * from           
  (select a.LoginKey as UserName,          
  (CASE WHEN (a.UserType = 1) THEN (select EmailId from mstOfficernew with(noLock) where UserName = a.LoginKey  and StatusFlag = 1 and UserName is not null)          
  WHEN (a.UserType = 5) THEN (select Store_emailid from mst_Stores with(noLock) where Store_code = a.LoginKey  and StatusFlag = 1) END)  as Email,
  STUFF((SELECT '','' + s.Rolename FROM (select Rolename from tblRoleMapNew with(noLock) where StatusFlag = 1 and RoleId in (select * from ConvertintoCommaTable(a.UserRole)))s                     
  ORDER BY s.Rolename FOR XML PATH('''')),1, 1, '''')  as UserRole,           
  (select convert(varchar(10),MAX(LastLogin),105)+'' ''+convert(varchar(10),MAX(LastLogin),108) as LastLoginDate
  from tblUserLastLogin with(noLock) where UserName = a.LoginKey Group by UserName) as LastLoginTime          
  from mstKeyDetailnew a with (nolock)          
  where a.StatusFlag = 1 and LoginStatus = 1) Main order by UserName'          
 end          
 else          
 begin          
  set @Sql = 'select * from           
  (select a.LoginKey as UserName,          
  (CASE WHEN (a.UserType = 1) THEN (select EmailId from mstOfficernew with(noLock) where UserName = a.LoginKey  and StatusFlag = 1 and UserName is not null)          
  WHEN (a.UserType = 5) THEN (select Store_emailid from mst_Stores with(noLock) where Store_code = a.LoginKey  and StatusFlag = 1) END) as Email,
  STUFF((SELECT '','' + s.Rolename FROM (select Rolename from tblRoleMapNew with(noLock) where RoleId in (select * from ConvertintoCommaTable(a.UserRole)))s                     
  ORDER BY s.Rolename FOR XML PATH('''')),1, 1, '''')  as UserRole,           
  (select convert(varchar(10),MAX(LastLogin),105)+'' ''+convert(varchar(10),MAX(LastLogin),108) as LastLoginDate
  from tblUserLastLogin with(noLock) where UserName = a.LoginKey Group by UserName) as LastLoginTime          
  from mstKeyDetailnew a with (nolock)          
  where a.StatusFlag = 1 and LoginStatus = 1) Main where ' + @Condition  + ' order by UserName'        
 end          
end            
else            
Begin            
 if (@Condition = '' or @Condition is null)          
 begin          
  set @Sql = 'select * from           
 (select a.LoginKey as UserName,          
  (CASE WHEN (a.UserType = 1) THEN (select EmailId from mstOfficernew with(noLock) where UserName = a.LoginKey  and StatusFlag = 1 and UserName is not null)          
  WHEN (a.UserType = 5) THEN (select Store_emailid from mst_Stores with(noLock) where Store_code = a.LoginKey  and StatusFlag = 1) END)  as Email,
  STUFF((SELECT '','' + s.Rolename FROM (select Rolename from tblRoleMapNew with(noLock) where StatusFlag = 1 and RoleId in (select * from ConvertintoCommaTable(a.UserRole)))s                     
  ORDER BY s.Rolename FOR XML PATH('''')),1, 1, '''')  as UserRole,           
  (select convert(varchar(10),MAX(LastLogin),105)+'' ''+convert(varchar(10),MAX(LastLogin),108) as LastLoginDate
  from tblUserLastLogin with(noLock) where UserName = a.LoginKey Group by UserName) as LastLoginTime          
  from mstKeyDetailnew a with (nolock)          
  where a.StatusFlag = 1 and LoginStatus = 1) Main order by UserName'          
 end          
 else          
 begin          
  set @Sql = 'select * from           
  (select a.LoginKey as UserName,          
  (CASE WHEN (a.UserType = 1) THEN (select EmailId from mstOfficernew with(noLock) where UserName = a.LoginKey  and StatusFlag = 1 and UserName is not null)          
  WHEN (a.UserType = 5) THEN (select Store_emailid from mst_Stores with(noLock) where Store_code = a.LoginKey  and StatusFlag = 1) END) as Email,
  STUFF((SELECT '','' + s.Rolename FROM (select Rolename from tblRoleMapNew with(noLock) where RoleId in (select * from ConvertintoCommaTable(a.UserRole)))s                     
  ORDER BY s.Rolename FOR XML PATH('''')),1, 1, '''')  as UserRole,           
  (select convert(varchar(10),MAX(LastLogin),105)+'' ''+convert(varchar(10),MAX(LastLogin),108) as LastLoginDate
  from tblUserLastLogin with(noLock) where UserName = a.LoginKey Group by UserName) as LastLoginTime          
  from mstKeyDetailnew a with (nolock)          
  where a.StatusFlag = 1 and LoginStatus = 1) Main where ' + @Condition  + ' order by UserName'          
 end          
          
end            
--print (@Sql)                    
exec(@Sql)                        
end 