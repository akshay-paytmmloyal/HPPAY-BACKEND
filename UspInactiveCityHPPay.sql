
------------------------------------------------------
--Created BY:- Akshay Tripathi
--Create Date:- 22 Dec 2022
--Created USP for:- Inactive City page
--Modified BY:- 
--Modified Date:-
-------------------------------------------------------

Alter proc [dbo].[UspInactiveCityHPPay]      
(      
@CityID int,    
@ModifiedBy varchar(40)    
)      
as      
begin      
declare @CityCodeChk int            
set @CityCodeChk=(select count(City_Id) from Tbl_City with(nolock) where City_Id=@CityID)            
if(@CityCodeChk>0)   
begin      
 insert into tblLocationLogHPPay(PageName,ActionName,CreatedBy,ModifiedBy,ModifiedTime) values('City','Delete',@ModifiedBy,@ModifiedBy,GETDATE())  
 update Tbl_City set Status_Flag=0,LastModifiedBy=@ModifiedBy,LastModifiedOn=GETDATE() where City_Id=@CityID      
 select 1 as Status,'City deleted successfully' as Reason      
end      
else      
begin      
   select 0 as Status,'City not found' as Reason      
end      
end      