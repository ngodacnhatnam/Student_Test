USE test
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[FLOAD_DIM_GROUP_NAME]
AS
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET IDENTITY_INSERT test.dbo.DIM_GROUP_NAME OFF

BEGIN TRAN
BEGIN TRY
    TRUNCATE TABLE test.dbo.DIM_GROUP_NAME

    INSERT INTO test.dbo.DIM_GROUP_NAME(GROUP_NAME_ID, GROUP_NAME_FIELD,GROUP_NAME_LABEL)
    SELECT DISTINCT
    id,
    field,
    label
    FROM STG.CATEGORY
    WHERE field = 'group_name'

COMMIT
RETURN 0
END TRY
BEGIN CATCH
    ROLLBACK
    DECLARE @errormessage NVARCHAR(2000)
    SELECT @errormessage = 'ERROR ' + ERROR_MESSAGE()
    RAISERROR(@errormessage, 16, 1)
END CATCH

END
GO

EXEC [dbo].[FLOAD_DIM_GROUP_NAME]
GO

