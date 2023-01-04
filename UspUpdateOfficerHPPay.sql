
----------------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 19 dec 2022
--Created USp for:- Update Officer details page
--Modified By:-
--Modified Date:-
------------------------------------------------------------------

Alter proc [dbo].[UspUpdateOfficerHPPay]
(@FirstName varchar(50),
@LastName varchar(50),
@Address1 varchar(250),
@Address2 varchar(250),
@Address3 varchar(250),
@StateId int,
@CityName varchar(100),
@DistrictId int,
@Pin varchar(6),
@MobileNo varchar(10),
@PhoneNo varchar(20),
@EmailId varchar(50),
@Fax varchar(20),
@ModifiedBy varchar(40),
@OfficerId int,
@UserAgent varchar(250),
@Userid varchar(250),
@Userip varchar(250))
as begin
    declare @OfficerIDCheck int
    set @OfficerIDCheck=(select count(OfficerID)
                         from mstOfficernew with(nolock)
                         where OfficerID=@OfficerId)
    declare @EmailCheck int
    set @EmailCheck=(select count(EmailId)
                     from mstOfficernew with(nolock)
                     where EmailId=@EmailId and OfficerID !=@OfficerId and EmailId != '' and EmailId is not null)
    declare @MobileNoCheck int
    set @MobileNoCheck=(select count(MobileNo)
                        from mstOfficernew with(nolock)
                        where MobileNo=@MobileNo and OfficerID !=@OfficerId and MobileNo != '' and MobileNo is not null)
    if(@OfficerIDCheck>0)begin
        if(@MobileNoCheck=0)begin
            if(@EmailCheck=0)begin
                update mstOfficernew
                set FirstName=@FirstName, LastName=@LastName, Address1=@Address1, Address2=@Address2, Address3=@Address3, StateId=ISNULL(@StateId, ''), 
				CityName=@CityName, DistrictId=ISNULL(@DistrictId, ''), Pin=@Pin, MobileNo=@MobileNo, PhoneNo=@PhoneNo, EmailId=@EmailId, Fax=@Fax, 
				ModifiedBy=@ModifiedBy, ActionType='Update', ModifiedTime=GETDATE(), Userid=@Userid, Useragent=@Useragent
                where OfficerID=@OfficerId
                insert into mstOfficerLognew(OfficerID, FirstName, LastName, Address1, Address2, Address3, StateId, CityName, DistrictId, Pin, MobileNo, PhoneNo, 
				EmailId, Fax, ModifiedBy, ActionType, Userid, Useragent,  ModifiedTime)
                values(@OfficerId, @FirstName, @LastName, @Address1, @Address2, @Address3, ISNULL(@StateId, ''), @CityName, ISNULL(@DistrictId, ''), @Pin, 
				@MobileNo, @PhoneNo, @EmailId, @Fax, @ModifiedBy, 'Update',  @Userid, @Useragent,  GETDATE())  
				
                select 1 as Status, 'Officer Updated Successfully' as Reason
            end
            else begin
                select 0 as Status, 'Email Id is already exits' as Reason
            end
        end
        else begin
            select 0 as Status, 'Mobile No is already exits' as Reason
        end
    end
    else begin
        select 0 as Status, 'Officer not exits' as Reason
    end
end

