
---------------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 19 dec 2022
--Created USP for:- Get OFFICER details
--Modified By:-
--Modified Date:-
-----------------------------------------------------------------

Alter Proc UspGetOfficerDetailHPPay
(
@OfficerType int=0,                  
@Location int=0  
)
As
Begin 
declare @results varchar(4000)  
Create table #TempOfficerDetails
(
OfficerTypeID int,
OfficerTypeName varchar(100),
OfficerID int,
FirstName varchar(100),
LastName varchar(100),
UserName varchar(100),
createdTime datetime,
Location varchar(100),
Address1 varchar(100),
Address2 varchar(100),
Address3 varchar(100),
Pin varchar(100),
MobileNo varchar(100),
PhoneNo varchar(100),
EmailId varchar(100),
Fax varchar(100),
Createdby varchar(100),
StateId int,
DistrictId int,
DistrictName varchar(100),
StateName varchar(100),
CityName varchar(100)
)

if(@OfficerType=0)                  
Begin                  
 insert into #TempOfficerDetails
 select a.OfficerType as OfficerTypeID,b.OfficerTypeName,a.OfficerID,a.FirstName,a.LastName,a.UserName,a.createdTime,        
 CASE WHEN e.ROCode > 0 THEN (select ROName from Mst_Regionaloffices with(noLock) where status_flag = 1 and ROCode = e.ROCode)        
 WHEN e.ROCode = 0 and e.ZOCode > 0 THEN       
 (select ZOName from Mst_zonaloffices with(noLock) where Status_Flag = 1 and ZOCode = e.ZOCode)  
 END as Location,                 
 a.Address1,a.Address2,a.Address3,a.Pin,a.MobileNo,a.PhoneNo,a.EmailId,                  
 a.Fax,a.Createdby,a.StateId,a.DistrictId,                  
 c.DistrictName as DistrictName,d.State_Name as StateName,a.CityName                      
 from mstOfficernew a with(nolock) inner join mstOfficerTypenew b with(nolock)                   
 on a.OfficerType=b.OfficerTypeID                  
 left join Tbl_District c with(nolock) on c.DistrictCode=a.DistrictId                  
 left join Tbl_State d with(nolock) on d.StateCode=a.StateID        
 left join mstOfficerLocationMappingNew e with(nolock) on e.OfficerId=a.OfficerID        
 where a.StatusFlag=1 and e.StatusFlag = 1   order by a.CreatedTime desc     
end                  
else if(@OfficerType!=0 and @Location=0)                  
begin                  
 insert into #TempOfficerDetails
 select a.OfficerType as OfficerTypeID,b.OfficerTypeName,a.OfficerID,a.FirstName,a.LastName,a.UserName,a.createdTime,         
  CASE WHEN e.ROCode > 0 THEN (select ROName from Mst_Regionaloffices with(noLock) where Status_Flag = 1 and ROCode = e.ROCode)        
 WHEN e.ROCode = 0 and e.ZOCode > 0 THEN         
 (select ZOName from Mst_zonaloffices with(noLock) where Status_Flag = 1 and ZOCode = e.ZOCode)    
 END as Location,                   
 a.Address1,a.Address2,a.Address3,a.Pin,a.MobileNo,a.PhoneNo,a.EmailId,                  
 a.Fax,a.Createdby,a.StateId,a.DistrictId,                  
 c.DistrictName as DistrictName,d.State_Name as StateName,a.CityName                  
 from mstOfficernew a with(nolock) inner join mstOfficerTypenew b with(nolock)                   
 on a.OfficerType=b.OfficerTypeID                  
 left join Tbl_District c with(nolock) on c.DistrictCode=a.DistrictId                  
 left join Tbl_State d with(nolock) on d.StateCode=a.StateID        
 left join mstOfficerLocationMappingNew e with(nolock) on e.OfficerId=a.OfficerID        
 where a.StatusFlag=1 and a.OfficerType=@OfficerType   order by a.CreatedTime desc                
end
else if(@OfficerType!=0 and @Location!=0)                  
begin                  
 insert into #TempOfficerDetails
 select a.OfficerType as OfficerTypeID,b.OfficerTypeName,a.OfficerID,a.FirstName,a.LastName,a.UserName, a.CreatedTime,       
 (select ROName from Mst_Regionaloffices with(noLock) where Status_Flag = 1 and ROCode = @Location) as Location,                   
 a.Address1,a.Address2,a.Address3,a.Pin,a.MobileNo,a.PhoneNo,a.EmailId,                  
 a.Fax,a.Createdby,a.StateId,a.DistrictId,                  
 c.DistrictName as DistrictName,d.State_Name as StateName,a.CityName     
 from mstOfficernew a with(nolock) inner join mstOfficerTypenew b with(nolock)              
 on a.OfficerType=b.OfficerTypeID                  
 left join Tbl_District c with(nolock) on c.DistrictCode=a.DistrictId          
 left join Tbl_State d with(nolock) on d.StateCode=a.StateID              
 left join mstOfficerLocationMappingNew e with(nolock) on e.OfficerId=a.OfficerID             
 where a.StatusFlag=1 and a.OfficerType=@OfficerType and a.OfficerType=1  and e.ROCode=@Location            
 union all            
 select a.OfficerType as OfficerTypeID,b.OfficerTypeName,a.OfficerID,a.FirstName,a.LastName,a.UserName,   a.CreatedTime,       
 (select ZOName from Mst_zonaloffices with(noLock) where Status_Flag = 1 and ZOCode = e.ZOCode)    
 as Location,          
 a.Address1,a.Address2,a.Address3,a.Pin,a.MobileNo,a.PhoneNo,a.EmailId,                  
 a.Fax,a.Createdby,a.StateId,a.DistrictId,                  
 c.DistrictName as DistrictName,d.State_Name as StateName,a.CityName                  
 from mstOfficernew a with(nolock) inner join mstOfficerTypenew b with(nolock)                   
 on a.OfficerType=b.OfficerTypeID                  
 left join Tbl_District c with(nolock) on c.DistrictCode=a.DistrictId                  
 left join Tbl_State d with(nolock) on d.StateCode=a.StateID              
 left join mstOfficerLocationMappingNew e with(nolock) on e.OfficerId=a.OfficerID             
 where a.StatusFlag=1 and a.OfficerType=@OfficerType and a.OfficerType =3  and e.ZOCode=@Location              
 union all            
 select a.OfficerType as OfficerTypeID,b.OfficerTypeName,a.OfficerID,a.FirstName,a.LastName,a.UserName,  a.CreatedTime,      
 'HQO' as Location,         
 a.Address1,a.Address2,a.Address3,a.Pin,a.MobileNo,a.PhoneNo,a.EmailId,                  
 a.Fax,a.Createdby,a.StateId,a.DistrictId,                  
 c.DistrictName as DistrictName,d.State_Name as StateName,a.CityName                  
 from mstOfficernew a with(nolock) inner join mstOfficerTypenew b with(nolock)                   
 on a.OfficerType=b.OfficerTypeID                  
 left join Tbl_District c with(nolock) on c.DistrictCode=a.DistrictId                  
 left join Tbl_State d with(nolock) on d.StateCode=a.StateID              
 left join mstOfficerLocationMappingNew e with(nolock) on e.OfficerId=a.OfficerID             
 where a.StatusFlag=1 and a.OfficerType=@OfficerType and a.OfficerType=2   
 order by a.CreatedTime desc  
end

select distinct OfficerTypeID,OfficerTypeName,OfficerID,FirstName,LastName,UserName,createdTime,Address1,Address2,Address3,
STUFF((SELECT ', ' + CAST(Location AS VARCHAR(10)) [text()]
         FROM #TempOfficerDetails 
         WHERE OfficerTypeID = t.OfficerTypeID
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') as Location,
Pin,MobileNo,PhoneNo,EmailId,Fax,Createdby,StateId,DistrictId,DistrictName,StateName,CityName from #TempOfficerDetails t

drop table #TempOfficerDetails
end



select * from mstOfficernew

select * From mstOfficerTypenew