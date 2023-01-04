
----------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 09 Dec 2022
--USP for:- Get User role and regions
--MOdified by:-
--Modified Date:-
-------------------------------------------------------------

Alter Proc [dbo].[UspGetUserRolesAndRegionsHPPay]    
AS      
BEGIN     
SET NOCOUNT ON;  

   select RoleId,  
  RoleName as UserRole  
  from tblRoleMapNew with (nolock)  
  where StatusFlag = 1    
    
   SELECT MR.ROCode,  
   MR.ROName,  
   mo.ZOCode,  
   mo.ZOName  
FROM Mst_Regionaloffices MR    
left outer  join  
Mst_zonaloffices mo  
on MR.ZOCode=mo.ZOCode  
order by MR.ZOCode asc  

END    