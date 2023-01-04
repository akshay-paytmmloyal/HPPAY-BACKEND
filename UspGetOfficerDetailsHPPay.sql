----------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 19 Dec 2022
--Created USP For:- Get Officer Details 
--Modified Date:-
--Modified BY:
------------------------------------------------------

Alter proc [dbo].[UspGetOfficerDetailsHPPay]  
(     
@ZO VARCHAR(5),                          
@RO VARCHAR(5),                        
@StateId VARCHAR(5),                        
@DistrictId VARCHAR(5)      
)            
as            
begin   
DECLARE @sql varchar(4000)                        
DECLARE @Condition varchar(400)                        
SET @Condition=''    
  
IF(ISNULL(@ZO,'')<>'')                        
SET @Condition = @Condition +  ' AND b.Zocode ='''+ @ZO+''''                        
                        
IF(ISNULL(@RO,'')<>'')                        
SET @Condition = @Condition +  ' AND b.Rocode ='''+ @RO+''''                        
                        
IF(ISNULL(@StateId,'')<>'')                        
SET @Condition = @Condition + ' AND a.StateId ='''+ @StateId+''''                        
                        
IF(ISNULL(@DistrictId,'')<>'')                        
SET @Condition = @Condition + ' AND a.DistrictId ='''+ @DistrictId+''''       
  
    
SET @sql ='select c.Zoname,d.Roname,e.State_name as StateName,f.DistrictName as DistrictName,  
isnull(a.FirstName,'''')+'' ''+isnull(a.LastName,'''') as MarketingOfficerName,  
a.EmailId as MarketingOfficerEmail,
CASE WHEN b.Rocode = 0 and b.Zocode > 0 THEN a.FirstName + '' '' + a.LastName ELSE '''' END as ZonalOfficerName,
CASE WHEN b.Rocode = 0 and b.Zocode > 0 THEN a.Emailid ELSE '''' END as ZonalOfficerEmail 
from mstOfficernew a with(nolock) 
inner join mstOfficerLocationMappingnew b with(nolock)  
on a.OfficerID=b.OfficerId 
left join mst_zonaloffices c with(nolock) on c.Zocode=b.Zocode  
left join mst_regionaloffices d with(nolock) on d.Rocode=b.Rocode  
left join Tbl_State e with(nolock) on e.statecode=a.StateId  
left join Tbl_District f with(nolock) on f.districtcode=a.DistrictId  
where a.StatusFlag=1 ' + @Condition + ' '  
--PRINT @sql
EXECUTE(@sql)    
end  

