
----------------------------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 08 Dec 2022
--USP for:- Delete User from Mange User page
--Modifed date:-
--Modified By:- 
--------------------------------------------------------------

ALTER proc UspDeleteManageUsersHPPay  

@TypeDeleteUserManage TypeDeleteUserManage readonly  

AS     
  
SET XACT_ABORT ON;    
SET NoCount ON;    
    
 BEGIN TRY    
BEGIN                     
   
   declare @newtable table(ID INT IDENTITY(1,1),UserName varchar(50))      
      
  insert into @newtable(UserName)          
   select UserName from @TypeDeleteUserManage   
  
   declare @totcount int=0,@counter int=1,@User_Name varchar(50);  
   select @totcount=count(ID) from @newtable  
       
 while(@counter<=@totcount)   
 begin  
 select @User_Name=UserName from @newtable Where ID=@counter   
   
       
 if exists (Select count(LoginKey) from mstKeyDetailNew with(nolock) where LoginKey=@User_Name and StatusFlag=1)        
 begin  
  
   Begin Tran  
   update mstKeyDetailNew With (rowLock) Set StatusFlag=0  Where LoginKey=@User_Name   
   Commit   
  
 end  
  set @counter=@counter+1   
   
 end  
  
   
 Select 1 as 'Status','Delete Succesfully' as Reason   
END    
  
END TRY  
BEGIN CATCH   
  IF @@TRANCOUNT > 0   
  BEGIN   
   ROLLBACK TRANSACTION;   
  END      
  DECLARE @error VARCHAR (100)   
  SELECT @error=ERROR_MESSAGE()   
  RAISERROR (@error,16,1)        
 END CATCH  
