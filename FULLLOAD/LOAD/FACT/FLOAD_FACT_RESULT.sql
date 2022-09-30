USE test
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER  PROCEDURE [dbo].[FLOAD_FACT_RESULT]
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

	------------------------------------------------------------------------------------
	BEGIN TRAN;
	BEGIN TRY

		TRUNCATE TABLE dbo.FACT_RESULT;
		/***----------------------------------------------------------------------------------***/

        insert into dbo.FACT_RESULT(
								STARTED_DATE_KEY,
								STARTED_TIME_KEY,
								ANSWERED_DATE_KEY,
								ANSWERED_TIME_KEY,
								DEACTIVATED_DATE_KEY,
								DEACTIVATED_TIME_KEY,
								USER_ID,
								QUESTION_ID,
								QUESTION_TYPE,
								GROUP_NAME_KEY,
								GROUP_NAME_LABEL,
								TRACK_NAME_KEY,
								TRACK_NAME_LABEL,
								SUBTRACKNAME_KEY,
								SUBTRACKNAME_LABEL,
								NUM_PLAYERS,
								QUESTION_SET_ID,
								OUTCOME_KEY,
								SCORE)
		SELECT  d3.DATE_KEY,
          		t3.TIME_KEY,
				d1.DATE_KEY,
          		t1.TIME_KEY,
      			d2.DATE_KEY,
          		t2.TIME_KEY,
				t.user_id,
				t.question_id,
                t.question_type,
				gn.GROUP_NAME_KEY,
				gn.GROUP_NAME_LABEL,
				tn.TRACKNAME_KEY,
                tn.TRACKNAME_LABEL,
				stn.SUBTRACKNAME_KEY,
                stn.SUBTRACKNAME_LABEL,
				t.num_players,
				t.question_set_id,
				o.OUTCOME_KEY,
				o.SCORE
		FROM STG.TRAINING t
		JOIN DIM_GROUP_NAME gn ON t.group_name = gn.GROUP_NAME_ID
		JOIN DIM_TRACKNAME tn ON t.track_name = tn.TRACKNAME_ID
		JOIN DIM_SUB_TRACKNAME stn ON t.subtrack_name = stn.SUBTRACKNAME_ID
		JOIN DIM_OUTCOME o ON t.outcome = o.OUTCOME_ID
        JOIN DIM_DATE d1 ON d1.DATE = t.answered_date
		JOIN DIM_DATE d2 ON d2.DATE = t.deactivated_date
		JOIN DIM_DATE d3 ON d3.DATE = t.round_started_date
		JOIN DIM_TIME t1 ON t1.TIME = t.answered_time
		JOIN DIM_TIME t2 ON t2.TIME = t.deactivated_time
		JOIN DIM_TIME t3 ON t3.TIME = t.round_started_time
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



EXEC [dbo].[FLOAD_FACT_RESULT]
GO


