

---------------------------------------------------------
--Created By:- Akshay Tripathi
--Created date:-09 dec 2022
--USP for:- Selecting User Manage roles request
--Modified By:-
--Modified Date:- 
----------------------------------------------------------

Alter proc [dbo].[UspSelectUserManageRolesRequestHPPay] -- 'HPCL MO'      
(           
@RoleName varchar(200) = ''                  
)                      
as            
SET NOCOUNT ON;        
declare @Condition varchar(4000),@Sql varchar(4000)           
      
begin         
set @Condition=''       
      
If (ISNULL(@RoleName,'') <> '')            
Begin                      
 Set @Condition = IIF(@Condition is null, '', @Condition + ' and' ) + ' Rolename = ''' + @RoleName+ ''''  
            
End         
print @Condition        
Set @Sql = 'select RoleID, Rolename ,Description as RoleDescription from tblRoleMapNew         
            with (nolock) where statusFlag= 1' + @Condition + ' Order by Rolename'    
        
        
--Print @Sql  
exec(@Sql)                      
end   

