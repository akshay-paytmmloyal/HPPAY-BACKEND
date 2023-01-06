---------------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 4 Jan 2022
--Created USP For:- Update Hotlist or Reactivation Approval Page
--Modified BY:-
--Modified Date:-
---------------------------------------------------------------

create Proc UspUpdateHotlistOrReactivateApprovalHPPay
(@EntityTypeId int,          
@ActionId int,          
@ActionOnRequest varchar(20),          
@ModifiedBy varchar(100),          
@EntityTypeCodes EntityCodes readonly)          
As 
Begin 
SET XACT_ABORT ON;          
SET NoCount ON;          
BEGIN TRY          
Begin Tran          
declare @newtable table(ID INT IDENTITY(1, 1) Primary key,          
EntityCode varchar(16));          
declare @ActionName varchar(20), @EntityValue varchar(16), @EntityCurrentStatus int, @OkFlag int=0, @ReasonId int=0, @Remarks varchar(250) =''          
create table #tempEntityTypeCodes (Status int,          
Reason varchar(250),          
EntityCode varchar(16))          
declare @totcount int=0, @counter int=1          
insert into @newtable(EntityCode)select EntityCode from @EntityTypeCodes          
select @totcount=count(*)from @newtable          
declare @cardFormNumber varchar(20) ='', @customerReferenceNo bigint=0  
if(@ActionId=6)begin          
    set @ActionName='Temporary Hotlisted'          
end          
else if(@ActionId=12)begin          
            set @ActionName='Permanent Hotlisted'          
end else if(@ActionId=11)begin          
                set @ActionName='Reactivated'          
end       
While(@counter<=@totcount)begin          
    select @EntityValue=EntityCode from @newtable where ID=@counter          
    if not exists (select 1          
                    from tblHotlistRequestLogHPPay with(noLock)          
                    where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId)begin          
        if not exists (select 1          
                        from #tempEntityTypeCodes          
                        where Reason='Request already approved/rejected')begin          
            insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
            select 0 as Status, 'Request already approved/rejected' as Reason, @EntityValue          
        end          
                                              
        Set @OkFlag=@OkFlag+1          
    end          
    SET @counter=@counter+1;          
end          
set @counter=1;    
if(@OkFlag=0)begin          
    While(@counter<=@totcount)begin          
        select @EntityValue=EntityCode from @newtable where ID=@counter
		if(@ActionOnRequest='Approve')begin          
            if(@EntityTypeId=2)begin          
                if exists (select 1          
                            from tblHotlistRequestLogHPPay with(noLock)          
                            where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId)begin          
                              
     select @EntityCurrentStatus=Status_flag , @customerReferenceNo= referralcode         
                    from loyaluser with(noLock)          
                    where Customer_id=@EntityValue         
                              
     select @ReasonId=ReasonId, @Remarks=Comments          
                    from tblHotlistRequestLogHPPay with(noLock)          
                    where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId
	  if((@ActionId=6 or @ActionId=12)and @EntityCurrentStatus !=12)begin          
                        update loyaluser with(rowLock)          
                        set Status_flag=@ActionId, LastModifiedBy=@ModifiedBy, LastModifiedOn=GETDATE()       
                        where Customer_id=@EntityValue and Status_flag=@EntityCurrentStatus 

						delete from mstManageUsersToken with(rowLock) where UserId = @EntityValue
	 insert into loyaluserLogHPPay(MobileNo,Customer_id,Title,FirstName,LastName,Gender,Dob,ZOCode,ROCode,ReferralCode,PayBackCardNo,KYCFlag,
	  HPGasFlag,CustomerType,BusinessEntity,CompanyName,CompanyPhoneNo,Company_MobileNo,Approvalstatus,Approval_Remarks,CreatedBy,Created_On,
	  Status_flag,LastLogin,User_Identifier,reg_by_source,Control_Card_No,Is_Migrated,Fastlane_ID,VF_CustomerID,
	  ProfileImage,LubeCategory)
	  Select MobileNo,Customer_id,Title,FirstName,LastName,Gender,Dob,ZOCode,ROCode,ReferralCode,PayBackCardNo,KYCFlag,HPGasFlag,CustomerType,
	  BusinessEntity,CompanyName,CompanyPhoneNo,Company_MobileNo,Approvalstatus,Approval_Remarks,@ModifiedBy,GETDATE(),Status_flag,LastLogin,
	  User_Identifier,reg_by_source,Control_Card_No,Is_Migrated,Fastlane_ID,VF_CustomerID,ProfileImage,LubeCategory
	                     From loyaluser with (nolock)
						 where Customer_id=@EntityValue 

		update tblHotlistRequestLogHPPay with(rowLock)          
                        set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE(), Status = IIF(@ActionOnRequest = 'Approve',1,2)      
                        where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId  
		if(@counter=1)begin    
       insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                            values(1, 'Customer ID(s) Successfully '+@ActionName, '');          
                        end          
                        insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                        values(1, 'Customer ID : '+@EntityValue, '');          
                    end          

		 else if(@ActionId=11 and @EntityCurrentStatus=6)begin
		  update loyaluser with(rowLock)          
                        set Status_flag=4, LastModifiedBy=@ModifiedBy, LastModifiedOn=GETDATE()        
                        where Customer_id=@EntityValue and Status_flag=@EntityCurrentStatus  
		  insert into loyaluserLogHPPay(MobileNo,Customer_id,Title,FirstName,LastName,Gender,Dob,ZOCode,ROCode,ReferralCode,PayBackCardNo,KYCFlag,
	      HPGasFlag,CustomerType,BusinessEntity,CompanyName,CompanyPhoneNo,Company_MobileNo,Approvalstatus,Approval_Remarks,CreatedBy,Created_On,
	      Status_flag,LastLogin,User_Identifier,reg_by_source,Control_Card_No,Is_Migrated,Fastlane_ID,VF_CustomerID,
	      ProfileImage,LubeCategory)
	      Select MobileNo,Customer_id,Title,FirstName,LastName,Gender,Dob,ZOCode,ROCode,ReferralCode,PayBackCardNo,KYCFlag,HPGasFlag,CustomerType,
	      BusinessEntity,CompanyName,CompanyPhoneNo,Company_MobileNo,Approvalstatus,Approval_Remarks,@ModifiedBy,GETDATE(),Status_flag,LastLogin,
	      User_Identifier,reg_by_source,Control_Card_No,Is_Migrated,Fastlane_ID,VF_CustomerID,ProfileImage,LubeCategory
	                     From loyaluser with (nolock)
						 where Customer_id=@EntityValue 
		 update tblHotlistRequestLogHPPay with(rowLock)          
                        set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE(), Status = IIF(@ActionOnRequest = 'Approve',1,2)      
                        where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId 
		    if(@counter=1)begin          
                            insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                            values(1, 'Customer ID(s) Successfully '+@ActionName, '');          
                        end          
                        insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                        values(1, 'Customer ID : '+@EntityValue, '');          
                  end          
                    else begin          
                        if not exists (select 1          
                                    from #tempEntityTypeCodes          
                                    where Reason='Request already approved/rejected')begin          
                            insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                            select 0 as Status, 'Request already approved/rejected' as Reason, @EntityValue
							end
						 end 
					end
				end
			else if(@EntityTypeId=3)begin        
				 if exists (select 1          
                        from tblHotlistRequestLogHPPay with(noLock)          
                        where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId)begin          
                    select @EntityCurrentStatus=Store_Status          
                    from Mst_Stores with(noLock)          
                    where Store_Code=@EntityValue           
                    select @ReasonId=ReasonId, @Remarks=Comments          
                    from tblHotlistRequestLogHPPay with(noLock)          
                    where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId 
			 if((@ActionId=6 or @ActionId=12)and @EntityCurrentStatus !=12)begin   
					 
                        update Mst_Stores with(rowLock)          
                        set Store_Status=@ActionId, LastModifiedBy=@ModifiedBy, LastModifiedOn=GETDATE()         
					       
                        where Store_Code=@EntityValue and Store_Status=@EntityCurrentStatus          
                        
						delete from mstManageUsersToken with(rowLock) where UserId = @EntityValue

			 insert into Mst_Stores_Audit(Store_Name,Store_mgr,Store_mgr_middlename,Store_mgr_lastname,Store_Address,Store_Address2,
			 Store_Address3,Store_Location,Store_district,Store_City,Store_State,Store_Class,store_longitude,store_latitude,Store_Category,
			 live_store_status,live_store_date,deactivated_date,deactivate_store_date,deactivated_userid,default_passcode,pan_no,gst_no,adhaar_no,
			 store_commission,dealer_name,highway_name,highway_no,SBU_type,MonthlyHSDsale,ZOCode,ROCode,SalesArea,misc,store_person_add1,
			 store_person_add2,store_person_add3,store_person_location,store_person_city,store_person_state,store_person_district,store_person_zip,
			 store_person_Stdcode,store_person_phoneno,store_person_fax,approvalstatus,store_created_by,Store_Created_on, Store_Approved_By,Request_Received_On,
			 Store_Approved_on,status,highway_city,beneficiary_name,store_type,store_person_email,store_person_mobile,ERP_Code,dealer_mobile,
			 SupplyLocationCode,LPCNGSale,RetailoutletHigway,Store_CommAddress1,Store_CommAddress2,Store_CommAddress3,Store_CommLocation,CommunicationHighway,
			 Store_CommCity,Store_commDistrict,Store_CommState,Store_CommPinCode,Store_CommOfficePhone,Store_CommFax,store_mgr_designation,Verifone_merchantid)
					
			 Select  Store_Name,Store_mgr,Store_mgr_middlename,Store_mgr_lastname,Store_Address,Store_Address2,Store_Address3,Store_Location,Store_district,
			 Store_City,Store_State,Store_Class,store_longitude,store_latitude,Store_Category,live_store_status,live_store_date,deactivated_date,deactivate_store_date,
			 deactivated_userid,default_passcode,pan_no,gst_no,adhaar_no,store_commission,dealer_name,highway_name,highway_no,SBU_type,MonthlyHSDsale,
			 ZOCode,ROCode,SalesArea,misc,store_person_add1,store_person_add2,store_person_add3,store_person_location,store_person_city,store_person_state,
			 store_person_district,store_person_zip,store_person_Stdcode,store_person_phoneno,store_person_fax,approvalstatus,@ModifiedBy,
			 GETDATE(),Store_Approved_By,Request_Received_On,Store_Approved_on,status,highway_city,beneficiary_name,store_type,store_person_email,
			 store_person_mobile,ERP_Code,dealer_mobile,SupplyLocationCode,LPCNGSale,RetailoutletHigway,Store_CommAddress1,Store_CommAddress2,
			 Store_CommAddress3,Store_CommLocation,CommunicationHighway,Store_CommCity,Store_commDistrict,Store_CommState,Store_CommPinCode,
			 Store_CommOfficePhone,Store_CommFax,store_mgr_designation,Verifone_merchantid

			             From Mst_Stores with(Nolock)
						 where Store_Code=@EntityValue 

			  update tblHotlistRequestLogHPPay with(rowLock)          
                        set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE(), Status = IIF(@ActionOnRequest = 'Approve',1,2)      
                        where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId 
			 if(@counter=1)begin          
                            insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                            values(1, 'Merchant ID(s) Successfully '+@ActionName, '');          
                       end          
                        insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                        values(1, 'Merchant ID : '+@EntityValue, '');          
                    end      
			else if(@ActionId=11 and @EntityCurrentStatus=6)begin          
                        update Mst_Stores with(rowLock)          
                        set Store_Status=4, LastModifiedBy=@ModifiedBy, LastModifiedOn=GETDATE()       
                        where Store_Code=@EntityValue  and Store_Status=@EntityCurrentStatus 

			 insert into Mst_Stores_Audit(Store_Name,Store_mgr,Store_mgr_middlename,Store_mgr_lastname,Store_Address,Store_Address2,
			 Store_Address3,Store_Location,Store_district,Store_City,Store_State,Store_Class,store_longitude,store_latitude,Store_Category,
			 live_store_status,live_store_date,deactivated_date,deactivate_store_date,deactivated_userid,default_passcode,pan_no,gst_no,adhaar_no,
			 store_commission,dealer_name,highway_name,highway_no,SBU_type,MonthlyHSDsale,ZOCode,ROCode,SalesArea,misc,store_person_add1,
			 store_person_add2,store_person_add3,store_person_location,store_person_city,store_person_state,store_person_district,store_person_zip,
			 store_person_Stdcode,store_person_phoneno,store_person_fax,approvalstatus,store_created_by,Store_Created_on, Store_Approved_By,Request_Received_On,
			 Store_Approved_on,status,highway_city,beneficiary_name,store_type,store_person_email,store_person_mobile,ERP_Code,dealer_mobile,
			 SupplyLocationCode,LPCNGSale,RetailoutletHigway,Store_CommAddress1,Store_CommAddress2,Store_CommAddress3,Store_CommLocation,CommunicationHighway,
			 Store_CommCity,Store_commDistrict,Store_CommState,Store_CommPinCode,Store_CommOfficePhone,Store_CommFax,store_mgr_designation,Verifone_merchantid)
					
			 Select  Store_Name,Store_mgr,Store_mgr_middlename,Store_mgr_lastname,Store_Address,Store_Address2,Store_Address3,Store_Location,Store_district,
			 Store_City,Store_State,Store_Class,store_longitude,store_latitude,Store_Category,live_store_status,live_store_date,deactivated_date,deactivate_store_date,
			 deactivated_userid,default_passcode,pan_no,gst_no,adhaar_no,store_commission,dealer_name,highway_name,highway_no,SBU_type,MonthlyHSDsale,
			 ZOCode,ROCode,SalesArea,misc,store_person_add1,store_person_add2,store_person_add3,store_person_location,store_person_city,store_person_state,
			 store_person_district,store_person_zip,store_person_Stdcode,store_person_phoneno,store_person_fax,approvalstatus,@ModifiedBy,
			 GETDATE(),Store_Approved_By,Request_Received_On,Store_Approved_on,status,highway_city,beneficiary_name,store_type,store_person_email,
			 store_person_mobile,ERP_Code,dealer_mobile,SupplyLocationCode,LPCNGSale,RetailoutletHigway,Store_CommAddress1,Store_CommAddress2,
			 Store_CommAddress3,Store_CommLocation,CommunicationHighway,Store_CommCity,Store_commDistrict,Store_CommState,Store_CommPinCode,
			 Store_CommOfficePhone,Store_CommFax,store_mgr_designation,Verifone_merchantid

			             From Mst_Stores with(Nolock)
						 where Store_Code=@EntityValue 
			update tblHotlistRequestLogHPPay with(rowLock)          
                        set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE(), Status = IIF(@ActionOnRequest = 'Approve',1,2)      
                        where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId          
                        if(@counter=1)begin          
                            insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                            values(1, 'Merchant ID(s) Successfully '+@ActionName, '');          
                        end          
                        insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                        values(1, 'Merchant ID : '+@EntityValue, '');          
                    end          
                    else begin          
                        if not exists (select 1          
                                        from #tempEntityTypeCodes          
                                        where Reason='Request already approved/rejected')begin          
                            insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                            select 0 as Status, 'Request already approved/rejected' as Reason, @EntityValue          
                        end                     
                    end          
                end          
      end          
	end
	else if(@ActionOnRequest='Reject')begin          
            update tblHotlistRequestLogHPPay with(rowLock)          
            set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE(), Status = IIF(@ActionOnRequest = 'Approve',1,2)      
            where EntityId=@EntityValue and StatusFlag=1 and RequestedStatus=@ActionId and EntityTypeId=@EntityTypeId          
            if(@EntityTypeId=2)begin          
                if(@counter=1)begin          
                    insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                    values(1, 'Customer ID(s) Successfully Rejected', '');          
                end          
                insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                values(1, 'Customer ID : '+@EntityValue, '');          
            end          
            else if(@EntityTypeId=3)begin          
                if(@counter=1)begin          
                    insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                    values(1, 'Merchant ID(s) Successfully Rejected', '');          
                end          
                insert into #tempEntityTypeCodes(Status, Reason, EntityCode)          
                values(1, 'Merchant ID : '+@EntityValue, '');          
            end    
		end
	   SET @counter=@counter+1;  
	end
  end
select * from #tempEntityTypeCodes;          
drop table #tempEntityTypeCodes 
Commit          
End TRY          
BEGIN CATCH          
IF @@TRANCOUNT>0 BEGIN          
    ROLLBACK TRANSACTION;          
END          
DECLARE @error VARCHAR(100)          
SELECT @error=ERROR_MESSAGE()          
RAISERROR(@error, 16, 1)          
END CATCH          
end