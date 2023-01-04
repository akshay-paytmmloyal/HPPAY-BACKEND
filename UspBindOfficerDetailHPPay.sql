
----------------------------------------------------
--created By:- Akshay Tripathi
--Created date:- 19 Dec 2022
--Created USP for:- Bind Officer details
--Modified BY:-
--Modified Date:-
--------------------------------------------------

Alter proc [dbo].[UspBindOfficerDetailHPPay]   --  5
(      
@OfficerID int    
)      
as      
begin      
 select a.OfficerType as OfficerTypeID,b.OfficerTypeName,a.OfficerID,a.FirstName,a.LastName,a.UserName,      
 a.Address1,a.Address2,a.Address3,a.Pin,a.MobileNo,a.PhoneNo,a.EmailId,      
 a.Fax,a.Createdby,a.StateId,a.DistrictId,      
 c.DistrictName as DistrictName,d.State_Name as StateName,a.CityName      
 from mstOfficernew a with(nolock) 
 inner join mstOfficerTypenew b with(nolock)       
 on a.OfficerType=b.OfficerTypeID      
 left join Tbl_District c with(nolock) on c.DistrictCode=a.DistrictId      
 left join Tbl_State d with(nolock) on d.StateCode=a.StateID      
 where a.StatusFlag=1 and a.OfficerID=@OfficerID      
end   