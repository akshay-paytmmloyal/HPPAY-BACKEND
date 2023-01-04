-------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 19 Dec 2022
--Created USP for:- Get Officer Location Mapping page
--Modified BY:-
--Modified Date:-
-------------------------------------------------------

Alter proc [dbo].[UspGetOfficerLocationMappingHPPay]  --  '1'
(      
@OfficerId int      
)      
as      
begin  
 if exists (select 1 from mstOfficernew with(noLock) where OfficerId = @OfficerId and StatusFlag = 1 and OfficerType in (3))  
 begin  
  select a.OfficerId,'Zone' as ZoneValue,a.ZOCode as ZOId,c.ZOName as ZOName,      
  a.ROCode as ROId,b.ROName as ROName, a.UserName 
  from mstOfficerLocationMappingNew a       
  left join Mst_Regionaloffices b on b.ROCode =a.ROCode      
  left join Mst_zonaloffices c on c.ZOCode=a.ZOCode      
  where a.StatusFlag=1 and OfficerId=@OfficerId and a.ROCode = 0 order by ZoId, RoId  
 end  
 else  
 begin  
  select a.OfficerId,'Region' as ZoneValue,a.ZOCode as ZOId,c.ZOName as ZOName,      
  a.ROCode as ROId,b.ROName as ROName, a.UserName from mstOfficerLocationMappingNew a       
  left join Mst_Regionaloffices b on b.ROCode=a.ROCode      
  left join Mst_zonaloffices c on c.ZOCode=a.ZOCode      
  where a.StatusFlag=1 and OfficerId=@OfficerId order by ZoId, RoId  
 end  
end   


