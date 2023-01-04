------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 14 Dec 2022
--Created USP For:- Insert update manage role
--Modified By:-
--Modified Date:-
-------------------------------------------------------

Create Proc [dbo].[UspUpdateInsertManageRoleHPPay]
(@RoleId int,
@RoleName varchar(200),
@RoleDescription varchar(200),
@ModifiedBy varchar(100),
@TypeInsertAddManageUsers TypeInsertAddManageUsers readonly)
as
SET XACT_ABORT ON;
SET NoCount ON;
BEGIN TRY
    BEGIN
    declare @TypeInsertAddManageUsersTable table(ID INT IDENTITY(1, 1) Primary key,
    MenuId Int,
    AllowedAction int)
    declare @SubLevelId int=0;
    declare @existsingMenuIds int=0;
    declare @RoleNameOld varchar(200);
    declare @RoleDescriptionOld varchar(500);
    create table #tempUpdateInsertManageRole (Status int,
    Reason varchar(250))
    declare @Id int=0
    Declare @ParentMenuId int=0,
	@MenuLevel int = 0;
    insert into @TypeInsertAddManageUsersTable(MenuId, AllowedAction)
    (select [MenuId], [AllowedAction] from @TypeInsertAddManageUsers)
    declare @totcount int=0, @counter int=1, @Menu_Id Int, @Allowed_Action Int;
    select @totcount=count(ID)from @TypeInsertAddManageUsersTable
    Begin Tran
    if Exists (select 1
               from tblRoleMapNew with(nolock)
               where StatusFlag=1 and RoleId=@RoleId)begin
        set @SubLevelId=@RoleId
        select @RoleNameOld=RoleName, @RoleDescriptionOld=Description
        from tblRoleMapNew with(nolock)
        where StatusFlag=1 and RoleId=@RoleId
        if(@RoleName !=@RoleNameOld or @RoleDescription !=@RoleDescriptionOld)begin
            update tblRoleMapNew with(rowLock)
            set RoleName=@RoleName, Description=@RoleDescription
            where StatusFlag=1 and RoleId=@RoleId
        end

		--Delete the existing details for the Role
		delete from tblRoleMenuMapNew where RoleId = @RoleId

        while(@counter<=@totcount)begin
            select @Menu_Id=MenuId, @Allowed_Action=AllowedAction
            from @TypeInsertAddManageUsersTable
            where ID=@counter and AllowedAction in (1,2)

            Insert Into tblRoleMenuMapNew With(rowlock)(RoleId, MenuId, AllowedAction, StatusFlag, ModifiedBy, ModifiedTime, CreatedBy, CreatedTime)    
            Values(@RoleId, @Menu_Id, @Allowed_Action, 1, null, null, @ModifiedBy, GETDATE())

			set @ParentMenuId = 0;
			set @MenuLevel = 0;
			select @ParentMenuId = ParentMenuId, @MenuLevel = MenuLevel from tblMenuDetailsHPPay with(noLock) where StatusFlag = 1 and MenuId = @Menu_Id;

			while(@MenuLevel <> 1)
			begin
				Insert Into tblRoleMenuMapNew With(rowlock)(RoleId, MenuId, AllowedAction, StatusFlag, ModifiedBy, ModifiedTime, CreatedBy, CreatedTime)    
				Values(@RoleId, @ParentMenuId, 2, 1, null, null, @ModifiedBy, GETDATE());
				set @MenuLevel = 0;
				select @ParentMenuId = ParentMenuId, @MenuLevel = MenuLevel from tblMenuDetailsHPPay with(noLock) where StatusFlag = 1 and MenuId = @ParentMenuId;
			end

			if (@MenuLevel = 1)
			begin
				Insert Into tblRoleMenuMapNew With(rowlock)(RoleId, MenuId, AllowedAction, StatusFlag, ModifiedBy, ModifiedTime, CreatedBy, CreatedTime)    
				Values(@RoleId, @ParentMenuId, 2, 1, null, null, @ModifiedBy, GETDATE());
			end

            set @counter = @counter + 1;
        end
        insert into #tempUpdateInsertManageRole(Status, Reason)
        values(1, 'Menu(s) updated Successfully for the Role.')
    END
    else begin
        insert into #tempUpdateInsertManageRole(Status, Reason)
        values(0, 'Role does not exists.')
    end
    select * from #tempUpdateInsertManageRole
    drop table #tempUpdateInsertManageRole
    Commit Tran
    END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 BEGIN
        ROLLBACK TRANSACTION;
    END
    DECLARE @error VARCHAR(100)
    SELECT @error=ERROR_MESSAGE()
    RAISERROR(@error, 16, 1)
END CATCH