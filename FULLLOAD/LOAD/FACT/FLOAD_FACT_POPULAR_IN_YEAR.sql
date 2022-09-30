USE test
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER  PROCEDURE [dbo].[FLOAD_FACT_POPULARITY_IN_YEAR]
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

	------------------------------------------------------------------------------------
	BEGIN TRAN;
	BEGIN TRY

		TRUNCATE TABLE dbo.FACT_POPULARITY_IN_YEAR;
		/***----------------------------------------------------------------------------------***/

        insert into dbo.FACT_POPULARITY_IN_YEAR(
								DATE_KEY,
								GROUP_NAME_KEY,
								GROUP_NAME_LABEL,
								TRACK_NAME_KEY,
								TRACK_NAME_LABEL,
								SUBTRACKNAME_KEY,
								SUBTRACKNAME_LABEL,
                                COUNT
        )
		SELECT  CONVERT(INT, CONVERT(nvarchar,d.LAST_DATE_OF_YEAR,112)) AS DATE,
                r.GROUP_NAME_KEY,
                r.GROUP_NAME_LABEL,
                r.TRACK_NAME_KEY,
                r.TRACK_NAME_LABEL,
                r.SUBTRACKNAME_KEY,
                r.SUBTRACKNAME_LABEL,
                SUM(GROUP_NAME_KEY) AS COUNT
		FROM FACT_RESULT r
        JOIN DIM_DATE d ON d.DATE_KEY = r.STARTED_DATE_KEY
        GROUP BY GROUP_NAME_KEY, SUBTRACKNAME_KEY, TRACK_NAME_KEY, LAST_DATE_OF_YEAR, GROUP_NAME_LABEL, TRACK_NAME_LABEL, SUBTRACKNAME_LABEL
		------------------------------------------------------------------------------------

	-- COMMIT HANDLE DATA
	COMMIT
	RETURN 0
	END TRY
	BEGIN CATCH
		ROLLBACK
		DECLARE @ERRORMESSAGE NVARCHAR(2000)
		SELECT @ERRORMESSAGE = 'ERROR: ' + ERROR_MESSAGE()
		RAISERROR(@ERRORMESSAGE, 16, 1)

	END CATCH

END



EXEC [dbo].[FLOAD_FACT_POPULARITY_IN_YEAR]
GO
