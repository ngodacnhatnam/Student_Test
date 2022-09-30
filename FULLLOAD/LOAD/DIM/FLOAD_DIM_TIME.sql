USE test
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[FLOAD_DIM_TIME]

AS
BEGIN


SET NOCOUNT ON
SET XACT_ABORT ON
--SET IDENTITY_INSERT test.dbo.DIM_TIME ON

BEGIN TRAN;
BEGIN TRY;


	TRUNCATE TABLE test.dbo.DIM_TIME;

	DECLARE @HOUR int
    DECLARE @MINUTE int
    DECLARE @SECOND int

	/***----------------------------------------------------------------------------------***/
	-- INSERT DIM_TIME
	SET @HOUR=0
	WHILE @HOUR < 24
	BEGIN
		SET @MINUTE = 0
		WHILE @MINUTE < 60
		BEGIN
			SET @SECOND = 0
			WHILE @SECOND <60
			BEGIN

			INSERT INTO test.dbo.DIM_TIME(
				TIME_KEY,
				TIME,
				MINUTE,
				SECOND,
				HOUR_24,
				HOUR_12
			)

			SELECT
			(@HOUR*10000) + (@MINUTE*100) + @SECOND AS TIME_KEY,
			CASE
			WHEN @HOUR<12 THEN right('0'+CONVERT(VARCHAR(2),@HOUR),2)+':'+
				right('0'+CONVERT(VARCHAR(2),@MINUTE),2)+':'+
				right('0'+CONVERT(VARCHAR(2),@SECOND),2) +' ' +'AM'
			ELSE right('0'+CONVERT(VARCHAR(2),@HOUR),2)+':'+
				right('0'+CONVERT(VARCHAR(2),@MINUTE),2)+':'+
				right('0'+CONVERT(VARCHAR(2),@SECOND),2) +' ' + 'PM' END AS [TIME],
			@SECOND as [SECOND],
			@MINUTE as [MINUTE],
			@HOUR as [HOUR_24],
			@HOUR%12 as [HOUR_12]
			SET @SECOND=@SECOND+1
			END
		SET @MINUTE=@MINUTE+1
		END
	SET @HOUR=@HOUR+1
	END

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

-- EXEC sp_configure 'clr enabled', 1;
-- RECONFIGURE;
-- GO

EXEC [dbo].[FLOAD_DIM_TIME]
GO


-- drop PROCEDURE [dbo].[SP_FLOAD_DIM_DATE]

-- select * from DIM_TIME
