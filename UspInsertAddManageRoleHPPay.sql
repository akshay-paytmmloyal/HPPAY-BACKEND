
--------------------------------------------------
--Create By:- Akshay Tripathi
--Created Date:- 14 Dec 2022
--Created USP for:- Add manage role
--Modified By:-
--Modified Date:-
--------------------------------------------------

Alter Proc [dbo].[UspInsertAddManageRoleHPPay]      
(@RoleName varchar(200),  
@RoleDescription varchar(200),  
@TypeInsertAddManageUsers TypeInsertAddManageUsers readonly,  
@CreatedBy varchar(40))  
as  
SET XACT_ABORT ON;  
SET NoCount ON;  
BEGIN TRY  
    BEGIN
	Declare @ParentMenuId int = 0

    if Exists (select 1  
               from tblRoleMapNew with(nolock)  
               where RoleName=@RoleName and StatusFlag=1)begin  
        select 0 as Status, 'Role already exists.' as Reason  
    end  
    else begin  
        Begin Tran  
        declare @TypeInsertAddManageUsersTable table(ID INT IDENTITY(1, 1) Primary key,MenuId Int,AllowedAction int)  
        declare @Id int = 0
        
		insert into @TypeInsertAddManageUsersTable(MenuId, AllowedAction)  
        (select [MenuId], [AllowedAction] from @TypeInsertAddManageUsers)  
        
		declare @totcount int=0, @counter int=1, @Menu_Id Int, @Allowed_Action Int;  
        
		select @totcount=count(ID)from @TypeInsertAddManageUsersTable  
        
		insert into tblRoleMapNew(RoleName, StatusFlag, ModifiedBy, ModifiedTime, CreatedBy, CreatedTime, Description)  
        values(@RoleName, 1, null, null, @CreatedBy, GETDATE(), @RoleDescription)  
        
		set @Id=SCOPE_IDENTITY()  
       
	    while(@counter<=@totcount)
		begin
			
			select @Menu_Id=MenuId, @Allowed_Action=AllowedAction from @TypeInsertAddManageUsersTable where ID=@counter
			
			if exists (select 1 from tblRoleMenuMapNew with(noLock) where MenuId = @Menu_Id and StatusFlag = 1 and RoleId = @Id)
			begin
				update tblRoleMenuMapNew with(rowLock) set AllowedAction = @Allowed_Action where MenuId = @Menu_Id and StatusFlag = 1 and RoleId = @Id
			end
			else
			begin
				insert into tblRoleMenuMapNew (RoleId, MenuId, AllowedAction, StatusFlag, ModifiedBy, ModifiedTime, CreatedBy, CreatedTime) values
				(@Id, @Menu_Id, @Allowed_Action, 1, null, null, @CreatedBy, GETDATE()) 
			end

			select @ParentMenuId = ParentMenuId from tblMenuDetailsHPPay with(noLock) where MenuId = @Menu_Id and StatusFlag = 1

			While not exists (select 1 from tblMenuDetailsHPPay with(noLock) where StatusFlag = 1 and MenuId = @ParentMenuId and ParentMenuId = @ParentMenuId)
			begin
				if exists (select 1 from tblRoleMenuMapNew with(noLock) where StatusFlag = 1 and MenuId = @ParentMenuId and RoleId = @Id )
				begin
					update tblRoleMenuMapNew with(rowLock) set AllowedAction = 2 where StatusFlag = 1 and MenuId = @ParentMenuId and RoleId = @Id
				end
				else
				begin
					insert into tblRoleMenuMapNew (RoleId, MenuId, AllowedAction, StatusFlag, ModifiedBy, ModifiedTime, CreatedBy, CreatedTime) values
					(@Id, @ParentMenuId, 2, 1, null, null, @CreatedBy, GETDATE())
				end

				select @ParentMenuId = ParentMenuId from tblMenuDetailsHPPay with(noLock) where MenuId = @ParentMenuId and StatusFlag = 1

			end

			if exists (select 1 from tblMenuDetailsHPPay with(noLock) where StatusFlag = 1 and MenuId = @ParentMenuId and ParentMenuId = @ParentMenuId)
			begin
				if exists (select 1 from tblRoleMenuMapNew with(noLock) where RoleId = @Id and MenuId = @ParentMenuId and StatusFlag = 1)
				begin
					update tblRoleMenuMapNew with(rowLock) set AllowedAction = 2 where StatusFlag = 1 and MenuId = @ParentMenuId and RoleId = @Id
				end				
				else
				begin
					insert into tblRoleMenuMapNew (RoleId, MenuId, AllowedAction, StatusFlag, ModifiedBy, ModifiedTime, CreatedBy, CreatedTime) values
					(@Id, @ParentMenuId, 2, 1, null, null, @CreatedBy, GETDATE()) 
				end

			end
            set @counter=@counter+1  
        end  
		
		select 1 as Status, 'Role added successfully.' as Reason  
        
		COMMIT  
    
	end  
    END  
END TRY  
BEGIN CATCH  
    IF @@TRANCOUNT>0 BEGIN  
        ROLLBACK TRANSACTION;  
    END  
    DECLARE @error VARCHAR(100)  
    SELECT @error=ERROR_MESSAGE()  
    RAISERROR(@error, 16, 1)  
    select 1 as Status, @error as Reason  
END CATCH