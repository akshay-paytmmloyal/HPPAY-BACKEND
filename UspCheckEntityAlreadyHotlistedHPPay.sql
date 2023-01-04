-------------------------------------------------------------
--Created BY:- Akshay Tripathi
--Created Date:- 2 Jan 2023
--Created USP For:- Check Entity Already Hotlisted HPPay
--Modified BY:-
--Modified Date:-
-------------------------------------------------------------

Alter Proc [dbo].[UspCheckEntityAlreadyHotlistedHPPay]
(@EntityTypeId int,
@EntityIdVal varchar(16))
As Begin
    if(@EntityTypeId=2)begin
        if exists (select 1
                   from loyaluser with(noLock)
                   where Status_flag=12 and Customer_id=@EntityIdVal )begin
            select 0 as Status, 'Customer is Permanent Hotlisted' as Reason
        end
        else if not exists (select 1
                            from loyaluser with(noLock)
                            where Customer_id=@EntityIdVal)begin
                 select 0 as Status, 'Invalid Customer ID' as Reason
        end
		
        else begin
                 select 1 as Status, 'Customer is Available' as Reason
        end
    end
    else if(@EntityTypeId=3)begin
             if exists (select 1
                        from Mst_Stores with(noLock)
                        where   Store_Code=@EntityIdVal and Store_Status=12)begin
                 select 0 as Status, 'Merchant is Permanent Hotlisted' as Reason
             end
             else if not exists (select 1
                                 from Mst_Stores with(noLock)
                                 where  Store_Code=@EntityIdVal)begin
                      select 0 as Status, 'Invalid Merchant ID' as Reason
             end
             else begin
                      select 1 as Status, 'Merchant is Available' as Reason
             end
    end
  
    else begin
             select 0 as Status, 'Invalid Entity Type Id' as Reason
    end
end


