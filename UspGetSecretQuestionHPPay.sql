
----------------------------------------------
--Created By:- Akshay Tripathi
--Created Date:- 15 Dec 2022
--Created USP for:- Get secret question
------------------------------------------------

Alter proc [dbo].[UspGetSecretQuestionHPPay]
as
begin
select SecretQuestionId,SecretQuestionName from mstSecretQuestionHPPay with(nolock) where StatusFlag=1
end
