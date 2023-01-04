
  --use hppay
----------------------------------------------------  
--Created By:- Akshay Tripathi  
-- USP:- Web portal login   
--Created date:- 27 Nov 2022  
--Modified By:-  
--Modified Date:-  
-------------------------------------------------------  
Alter Proc UspGetUserLoginNew --'Akshayadmin','Akshay@123','Web',''
(  
@UserId varchar(40),                                                                                            
@Password varchar(40),  
@Useragent varchar(50) ,                                                                            
@DeviceId varchar(100)=''   
)  
As   
Begin  
                                                                                               
declare @PassworChk int;                                                                                                                                          
declare @UserType int;     declare @mobileNo varchar(10);                                                                                                                         
declare @UserSubType int;                                                                                                                       
declare @UserRole varchar(1000),@UserRole1 varchar(1000);                                                                                                                             
declare @LoginCount int,@SuccessStatus int =0;    
declare @status int =1;
declare @Reason varchar(20)='Successfully Login';
select @UserType=UserType,@UserSubType=UserSubType, @UserRole = UserRole                                                                                                                      
from mstKeyDetailNew with(nolock) where LoginKey=@UserId and StatusFlag = 1 and LoginStatus = 1 

if(@UserType=1) 
Begin
set @PassworChk= (select count(KeyValue) from mstKeyDetailNew with(nolock)                                                                        
where KeyValue=HASHBYTES('SHA2_512', convert(nvarchar(max),@Password)) and StatusFlag = 1 and LoginStatus = 1 and  LoginKey=@UserId)                                                                                                  
if(@PassworChk>0)  
Begin

   
if exists(select 1 from mstOfficernew with(nolock) where UserName=@UserId and StatusFlag=1  )                                                                                                    
begin                                                                  
select 'Admin' as LoginType,a.LoginKey as UserId,                                                            
case isnull(b.FirstName,'') when '' then @UserId else isnull(b.FirstName,'')+' '+isnull(b.LastName,'') end as UserName,b.EmailId,                                                                                                                    
b.FirstName,b.LastName,                                                                                     
b.MobileNo,                                                                                                                                  
                                              
(SELECT STUFF((Select distinct ',' + cast(olm.ROCode as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) 
where  olm.StatusFlag=1 and                                                                  
olm.OfficerId=b.OfficerID  FOR XML PATH ('')), 1, 1, ''))  as RegionalOfficeID,                                                                                                                                  
                                                                                                                              
(SELECT STUFF((Select distinct ',' + cast(ro.ROName as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) 
left join Mst_Regionaloffices ro with(nolock) on olm.ROCode=ro.ROCode where  olm.StatusFlag=1 and                                                                                                                                 
olm.OfficerId=b.OfficerID FOR XML PATH ('')), 1, 1, ''))  as RegionalOfficeName,                                           
                                                                                                                                  
(SELECT STUFF((Select distinct ',' + cast(olm.ZOCode as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) where  olm.StatusFlag=1 and                      
olm.OfficerId=b.OfficerID FOR XML PATH ('')), 1, 1, ''))  as ZonalOfficeID,                                                                                                 
                                                                                                                                  
(SELECT STUFF((Select distinct ',' + cast(zo.ZOName as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) 
left join Mst_zonaloffices zo with(nolock) on olm.ZOCode=zo.ZOCode where olm.StatusFlag=1 and                                                                                                                                  
olm.OfficerId=b.OfficerID FOR XML PATH ('')), 1, 1, ''))  as ZonalOfficeName,                                                                                                          

@UserType as UserType,  @UserSubType as UserSubType, @UserRole as UserRole    ,
@status As Status,
@Reason As Reason
            
from mstKeyDetailNew a with(nolock) 
inner join mstOfficernew b with(nolock) on a.UserSubType=b.OfficerType and a.LoginKey=b.UserName                                                                                              
inner join mstOfficerTypenew c with(nolock) on c.OfficerTypeID=b.OfficerType                                                                                                                                                                                                                                                                                       
where LoginKey=@UserId and KeyValue=HASHBYTES('SHA2_512', convert(nvarchar(max),@Password)) and                                                                 
a.UserType=1  and b.OfficerType in(4) and a.StatusFlag = 1 and a.LoginStatus = 1 
Union All

select 'HPCL-OFFICER' as LoginType,a.LoginKey as UserId,                                                            
case isnull(b.FirstName,'') when '' then @UserId else isnull(b.FirstName,'')+' '+isnull(b.LastName,'') end as UserName,b.EmailId,                                                                                                                    
b.FirstName,b.LastName,                                                                                     
b.MobileNo,                                                                                                                                  
                                              
(SELECT STUFF((Select distinct ',' + cast(olm.ROCode as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) where  olm.StatusFlag=1 and                                                                  
olm.OfficerId=b.OfficerID  FOR XML PATH ('')), 1, 1, ''))  as RegionalOfficeID,                                                                                                                                  
                                                                                                                              
(SELECT STUFF((Select distinct ',' + cast(ro.ROName as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) 
left join Mst_Regionaloffices ro with(nolock) on olm.ROCode=ro.ROCode where  olm.StatusFlag=1 and                                                                                                                                 
olm.OfficerId=b.OfficerID FOR XML PATH ('')), 1, 1, ''))  as RegionalOfficeName,                                           
                                                                                                                                  
(SELECT STUFF((Select distinct ',' + cast(olm.ZOCode as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) where  olm.StatusFlag=1 and                      
olm.OfficerId=b.OfficerID FOR XML PATH ('')), 1, 1, ''))  as ZonalOfficeID,                                                                                                 
                                                                                                                                  
(SELECT STUFF((Select distinct ',' + cast(zo.ZOName as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) 
left join Mst_zonaloffices zo with(nolock) on olm.ZOCode=zo.ZOCode where olm.StatusFlag=1 and                                                                                                                                  
olm.OfficerId=b.OfficerID FOR XML PATH ('')), 1, 1, ''))  as ZonalOfficeName,                                                                                                          

@UserType as UserType,  @UserSubType as UserSubType, @UserRole as UserRole    ,
@status As Status,
@Reason As Reason
            
from mstKeyDetailNew a with(nolock) 
inner join mstOfficernew b with(nolock) on a.UserSubType=b.OfficerType and a.LoginKey=b.UserName                                                                                              
inner join mstOfficerTypenew c with(nolock) on c.OfficerTypeID=b.OfficerType                                                                                                                                                                                                                                                                                       
where LoginKey=@UserId and KeyValue=HASHBYTES('SHA2_512', convert(nvarchar(max),@Password)) and                                                                 
a.UserType=1  and b.OfficerType in(1,3) and a.StatusFlag = 1 and a.LoginStatus = 1 

Union All        

select 'HO' as LoginType,a.LoginKey as UserId,                                                            
case isnull(b.FirstName,'') when '' then @UserId else isnull(b.FirstName,'')+' '+isnull(b.LastName,'') end as UserName,b.EmailId,                                                                                                                    
b.FirstName,b.LastName,                                                                                     
b.MobileNo,                                                                                                                                  
                                              
(SELECT STUFF((Select distinct ',' + cast(olm.ROCode as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) where  olm.StatusFlag=1 and                                                                  
olm.OfficerId=b.OfficerID  FOR XML PATH ('')), 1, 1, ''))  as RegionalOfficeID,                                                                                                                                  
                                                                                                                              
(SELECT STUFF((Select distinct ',' + cast(ro.ROName as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) 
left join Mst_Regionaloffices ro with(nolock) on olm.ROCode=ro.ROCode where  olm.StatusFlag=1 and                                                                                                                                 
olm.OfficerId=b.OfficerID FOR XML PATH ('')), 1, 1, ''))  as RegionalOfficeName,                                           
                                                                                                                                  
(SELECT STUFF((Select distinct ',' + cast(olm.ZOCode as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) where  olm.StatusFlag=1 and                      
olm.OfficerId=b.OfficerID FOR XML PATH ('')), 1, 1, ''))  as ZonalOfficeID,                                                                                                 
                                                                                                                                  
(SELECT STUFF((Select distinct ',' + cast(zo.ZOName as varchar) FROM mstOfficerLocationMappingNew olm with(nolock) 
left join Mst_zonaloffices zo with(nolock) on olm.ZOCode=zo.ZOCode where olm.StatusFlag=1 and                                                                                                                                  
olm.OfficerId=b.OfficerID FOR XML PATH ('')), 1, 1, ''))  as ZonalOfficeName,   


@UserType as UserType,  @UserSubType as UserSubType, @UserRole as UserRole     ,
@status As Status,
@Reason As Reason
            
from mstKeyDetailNew a with(nolock) 
inner join mstOfficernew b with(nolock) on a.UserSubType=b.OfficerType and a.LoginKey=b.UserName                                                                                              
inner join mstOfficerTypenew c with(nolock) on c.OfficerTypeID=b.OfficerType                                                                                                                                                                                                                                                                                       
where LoginKey=@UserId and KeyValue=HASHBYTES('SHA2_512', convert(nvarchar(max),@Password)) and                                                                 
a.UserType=1  and b.OfficerType in(2) and a.StatusFlag = 1 and a.LoginStatus = 1 

Insert into tblUserLastLogin values (@UserId,GETDATE(),1,@Useragent)  

End

Else
    Begin

         select 0 As Status, 'Invalid Username or Password' as Reason
      End

End

End

End