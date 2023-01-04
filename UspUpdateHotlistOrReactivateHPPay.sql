-----------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 3 Jan 2023
--Created USP for:- Update Hotlist or Reactivation Page
--Modified BY:-
--Modified Date:-
------------------------------------------------------

Create Proc UspUpdateHotlistOrReactivateHPPay
(
@EntityTypeId int,      
@EntityIdVal varchar(16),      
@ActionId int,      
@ReasonId int,      
@ReasonDetails varchar(1000) ='',      
@Remarks varchar(1000),      
@ModifiedBy varchar(100))

As 

Begin
declare @EntityCurrentStatus int=0, @EntityPendingStatus int=0, @OkFlag int=0, @CustomerID varchar(15) ='', @MerchantID varchar(15) ='',       
@CustomerStatus int=0, @MerchantStatus int=0      
create table #tempUpdateHotlistOrReactivate (Status int,      
ActionName varchar(250),      
EntityTypeValue varchar(16))
if(@EntityTypeId=2)begin      
    if not exists (select 1      
                    from loyaluser with(noLock)      
                    where Customer_id=@EntityIdVal  )begin      
        set @OkFlag=1      
    end      
end      
else if(@EntityTypeId=3)begin      
    if not exists (select 1      
                from Mst_Stores with(noLock)      
                where Store_Code=@EntityIdVal)begin      
        set @OkFlag=1      
    end      
end     
if(@OkFlag=0)begin      
    if(@EntityTypeId=2)begin
        select @EntityCurrentStatus=Status_flag      
        from loyaluser with(noLock)      
        where Customer_id=@EntityIdVal      
        select @EntityPendingStatus=RequestedStatus      
        from tblHotlistRequestLogHPPay with(noLock)      
        where EntityId=@EntityIdVal and EntityTypeId=@EntityTypeId and StatusFlag=1 
		if(@EntityPendingStatus=0)begin      
            if(@ActionId=6)begin      
                if(@EntityCurrentStatus=6)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Customer ID is already Temporary Hotlisted', @EntityIdVal);      
                end      
                else if(@EntityCurrentStatus=12)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Customer ID is Permanet Hotlisted', @EntityIdVal);      
                end      
                else if(@EntityCurrentStatus=0)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Customer ID', @EntityIdVal);      
                end      
                else begin      
                    insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Temporary Hotlisting request placed Successfully for Customer ID : '+@EntityIdVal, @EntityIdVal);      

					
                end
            end
			 else if(@ActionId=12)begin      
				if(@EntityCurrentStatus=12)begin      
					insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
					values(0, 'Customer ID is already Permanet Hotlisted', @EntityIdVal);      
				end      
				else if(@EntityCurrentStatus=0)begin      
					insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
					values(0, 'Invalid Customer ID', @EntityIdVal);      
				end      
				else begin      
					insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
					values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
					insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
					values(1, 'Permanent Hotlisting request placed Successfully for Customer ID : '+@EntityIdVal, @EntityIdVal);      
      
					
				end
            end    
			 else if(@ActionId=11)begin      
                if(@EntityCurrentStatus=12
				)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Customer ID is Permanet Hotlisted', @EntityIdVal);      
                end      
                else if(@EntityCurrentStatus=1 or @EntityCurrentStatus=4 )begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Customer ID is Active', @EntityIdVal);      
                end      
                else if(@EntityCurrentStatus=0)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Customer ID', @EntityIdVal);      
                end      
                else begin      
                    insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Reactivation request placed Successfully for Customer ID : '+@EntityIdVal, @EntityIdVal);      
     
					
					
                end      
            end   
			 else begin      
                insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                values(0, 'Invalid Pending Status found for the Customer ID', @EntityIdVal);      
            end      
        end  
		else begin      
            print 1      
            Print @EntityPendingStatus      
            if(@ActionId=12)begin      
                if(@EntityPendingStatus=12)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Already Request for Permanent Hotlisting is pending for this Customer ID', @EntityIdVal);      
                end     
				else if(@EntityPendingStatus=6)begin      
					update tblHotlistRequestLogHPPay with(rowLock)      
                    set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE()      
                    where EntityId=@EntityIdVal and EntityTypeId=@EntityTypeId and StatusFlag=1 and RequestedStatus=6      
                                   
					insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Request for Permanent Hotlist placed Successfully for Customer ID : '+@EntityIdVal, @EntityIdVal);
				end
				else if(@EntityPendingStatus=11)begin      
                    update tblHotlistRequestLogHPPay with(rowLock)      
                    set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE()      
                    where EntityId=@EntityIdVal and EntityTypeId=@EntityTypeId and StatusFlag=1 and RequestedStatus=11      
                                   
					insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Request for Permanent Hotlist placed Successfully for Customer ID : '+@EntityIdVal, @EntityIdVal);     
					end
					 else begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Pending Status found for the Customer ID', @EntityIdVal);      
                end      
            end      
			 else if(@ActionId=6)begin      
                if(@EntityPendingStatus=12)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
					values(0, 'Already Request for Permanent Hotlisting is pending for this Customer ID', @EntityIdVal);      
                end      
                else if(@EntityPendingStatus=6)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Already Request for Temporary Hotlisting is pending for this Customer ID', @EntityIdVal);      
                end      
                else if(@EntityPendingStatus=11)begin      
                    update tblHotlistRequestLogHPPay with(rowLock)      
                    set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE()      
                    where EntityId=@EntityIdVal and EntityTypeId=@EntityTypeId and StatusFlag=1 and RequestedStatus=11      
                                        
					insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Request for Temporary Hotlist placed Successfully for Customer ID : '+@EntityIdVal, @EntityIdVal);
                 end
				  else begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Pending Status found for the Customer ID', @EntityIdVal);      
                end      
            end      
			 else if(@ActionId=11)begin      
                if(@EntityPendingStatus=12)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Already Request for Permanent Hotlisting is pending for this Customer ID', @EntityIdVal);      
                end      
                else if(@EntityPendingStatus=6)begin      
                        insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                        values(0, 'Already Request for Temporary Hotlisting is pending for this Customer ID', @EntityIdVal);      
                end      
                else if(@EntityPendingStatus=11)begin      
                        insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                        values(0, 'Already Request for Reactivation is pending for this Customer ID', @EntityIdVal);      
                end      
                else begin      
                        insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                        values(0, 'Invalid Pending Status found for the Customer ID', @EntityIdVal);      
                end      
            end      
            else begin      
                insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                values(0, 'Already an Action is pending for approval for this Customer ID', @EntityIdVal);      
            end      
        end      
    end      
	else if(@EntityTypeId=3)begin      
        select @EntityCurrentStatus=Store_Status      
		from Mst_Stores with(noLock)      
        where Store_Code=@EntityIdVal     
        select @EntityPendingStatus=RequestedStatus      
        from tblHotlistRequestLogHPPay with(noLock)      
        where EntityId=@EntityIdVal and EntityTypeId=@EntityTypeId and StatusFlag=1 
		 if(@EntityPendingStatus=0)begin      
            if(@ActionId=6)begin      
                if(@EntityCurrentStatus=6)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Merchant ID is already Temporary Hotlisted', @EntityIdVal);      
                end      
                else if(@EntityCurrentStatus=12)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Merchant ID is Permanet Hotlisted', @EntityIdVal);      
                end      
                else if(@EntityCurrentStatus=0)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Merchant ID', @EntityIdVal);      
                end      
				 else begin      
                    insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Temporary Hotlisting request placed Successfully for Merchant ID : '+@EntityIdVal, @EntityIdVal); 
					end 
				end
				 else if(@ActionId=12)begin      
                if(@EntityCurrentStatus=12)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Merchant ID is already Permanet Hotlisted', @EntityIdVal);      
                end      
                else if(@EntityCurrentStatus=0)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Merchant ID', @EntityIdVal);      
                end      
                else begin      
                    insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Permanent Hotlisting request placed Successfully for Merchant ID : '+@EntityIdVal, @EntityIdVal);      
      
					   
                end      
            end      
			 else if(@ActionId=11)begin      
                if(@EntityCurrentStatus=12)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Merchant ID is Permanet Hotlisted', @EntityIdVal);      
                end      
                else if(@EntityCurrentStatus=1 or @EntityCurrentStatus=4 )begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Merchant ID is Active', @EntityIdVal);      
                end      
                else if(@EntityCurrentStatus=0)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Merchant ID', @EntityIdVal);      
                end      
                else begin      
                    insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Reactivation request placed Successfully for Merchant ID : '+@EntityIdVal, @EntityIdVal);      
      
					     
                end      
            end    
			else begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Action', @EntityIdVal);      
            end      
        end      
		else begin      
            if(@ActionId=12)begin      
                if(@EntityPendingStatus=12)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Already Request for Permanent Hotlisting is pending for this Merchant ID', @EntityIdVal);      
                end   
				 else if(@EntityPendingStatus=6)begin      
                    update tblHotlistRequestLogHPPay with(rowLock)      
                    set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE()      
                    where EntityId=@EntityIdVal and EntityTypeId=@EntityTypeId and StatusFlag=1 and RequestedStatus=6      
                                        
					insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Request for Permanent Hotlist placed Successfully for Merchant ID : '+@EntityIdVal, @EntityIdVal); 
					end 
				
				 else if(@EntityPendingStatus=11)begin      
                    update tblHotlistRequestLogHPPay with(rowLock)      
                    set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE()      
                    where EntityId=@EntityIdVal and EntityTypeId=@EntityTypeId and StatusFlag=1 and RequestedStatus=11      
                                        
					insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Request for Permanent Hotlist placed Successfully for Merchant ID : '+@EntityIdVal, @EntityIdVal);
					 
				end
				else begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Pending Status found for the Merchant ID', @EntityIdVal);      
                end      
            end      
			else if(@ActionId=6)begin      
                if(@EntityPendingStatus=12)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Already Request for Permanent Hotlisting is pending for this Merchant ID', @EntityIdVal);      
                end      
                else if(@EntityPendingStatus=6)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Already Request for Temporary Hotlisting is pending for this Merchant ID', @EntityIdVal);      
                end      
                else if(@EntityPendingStatus=11)begin      
                    update tblHotlistRequestLogHPPay with(rowLock)      
                    set StatusFlag=0, ModifiedBy=@ModifiedBy, ModifiedTime=GETDATE()      
                    where EntityId=@EntityIdVal and EntityTypeId=@EntityTypeId and StatusFlag=1 and RequestedStatus=11      
                                             
					insert into tblHotlistRequestLogHPPay(EntityTypeId, EntityId, RequestedStatus, ReasonId, Comments, CreatedBy, CreatedTime, ModifiedBy,       
					ModifiedTime, StatusFlag, ReasonIdDetail)      
                    values(@EntityTypeId, @EntityIdVal, @ActionId, @ReasonId, @Remarks, @ModifiedBy, GETDATE(), null, null, 1, @ReasonDetails);      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(1, 'Request for Temporary Hotlist placed Successfully for Merchant ID : '+@EntityIdVal, @EntityIdVal);      
      
					     
                end     
				else begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Pending Status found for the Merchant ID', @EntityIdVal);      
                end      
            end
			else if(@ActionId=11)begin      
                if(@EntityPendingStatus=12)begin      
					insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
					values(0, 'Already Request for Permanent Hotlisting is pending for this Merchant ID', @EntityIdVal);      
                end      
                else if(@EntityPendingStatus=6)begin      
					insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
					values(0, 'Already Request for Temporary Hotlisting is pending for this Merchant ID', @EntityIdVal);      
                end      
                else if(@EntityPendingStatus=11)begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Already Request for Reactivation is pending for this Merchant ID', @EntityIdVal);      
                end      
                else begin      
                    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                    values(0, 'Invalid Pending Status found for the Merchant ID', @EntityIdVal);      
                end      
            end      
            else begin      
                insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
                values(0, 'Already an Action is pending for approval for this Merchant ID', @EntityIdVal);      
            end      
        end      
    end    
  end
  else begin      
    insert into #tempUpdateHotlistOrReactivate(Status, ActionName, EntityTypeValue)      
    values(0, 'Entity ID not found', @EntityIdVal);      
end     
select * from #tempUpdateHotlistOrReactivate      
drop table #tempUpdateHotlistOrReactivate
end
      