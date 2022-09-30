USE test
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER  PROCEDURE [dbo].[FLOAD_FACT_AVERAGE]
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

	------------------------------------------------------------------------------------
	BEGIN TRAN;
	BEGIN TRY

		TRUNCATE TABLE dbo.FACT_AVERAGE;
		/***----------------------------------------------------------------------------------***/
        insert into dbo.FACT_AVERAGE(
								USER_ID,
								QUESTION_ID,
								QUESTION_TYPE,
								GROUP_NAME_KEY,
								TRACK_NAME_KEY,
								SUBTRACKNAME_KEY,
								NUM_PLAYERS,
								QUESTION_SET_ID,
                                AVERAGE_SCORE)
		SELECT
				r.USER_ID,
				r.QUESTION_ID,
                r.QUESTION_TYPE,
				r.GROUP_NAME_KEY,
				r.TRACK_NAME_KEY,
				r.SUBTRACKNAME_KEY,
				r.NUM_PLAYERS,
				r.QUESTION_SET_ID,
                AVG(SCORE) AS AVERAGE_SCORE
		FROM FACT_RESULT r
		GROUP BY
				r.USER_ID,
				r.QUESTION_ID,
                r.QUESTION_TYPE,
				r.GROUP_NAME_KEY,
				r.TRACK_NAME_KEY,
				r.SUBTRACKNAME_KEY,
				r.NUM_PLAYERS,
				r.QUESTION_SET_ID
		ORDER BY r.USER_ID
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



EXEC [dbo].[FLOAD_FACT_AVERAGE]
GO
