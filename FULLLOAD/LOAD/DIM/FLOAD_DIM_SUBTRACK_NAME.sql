USE test
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[FLOAD_DIM_SUB_TRACKNAME]
AS
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET IDENTITY_INSERT test.dbo.DIM_SUB_TRACKNAME OFF

BEGIN TRAN
BEGIN TRY
    TRUNCATE TABLE test.dbo.DIM_SUB_TRACKNAME

    INSERT INTO test.dbo.DIM_SUB_TRACKNAME(SUBTRACKNAME_ID, SUBTRACKNAME_FIELD, SUBTRACKNAME_LABEL)
    SELECT DISTINCT
    id,
    field,
    label
    FROM STG.CATEGORY
    WHERE field = 'subtrack_name'

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

EXEC [dbo].[FLOAD_DIM_SUB_TRACKNAME]
GO

