USE SFGPRODU;
--  DDL for Package Body SFGWEBDETALLETAREA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBDETALLETAREA */ 

  -- Creates a new record in the DETALLETAREA table
  IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_AddRecord(@p_CODTAREA                NUMERIC(22,0),
                      @p_NOMDETALLETAREA         NVARCHAR(2000),
                      @p_CODINFOEJECUCION        NUMERIC(22,0),
                      @p_PARAMETRO               NVARCHAR(2000),
                      @p_FECHAHORAMODIFICACION   DATETIME,
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ACTIVE                  NUMERIC(22,0),
                      @p_TIENEPREDECESOR         NUMERIC(22,0),
                      @p_ORDEN                   NUMERIC(22,0),
                      @p_CODINFOEJECUCIONWARNING NUMERIC(22,0),
                      @p_CODINFOEJECUCIONERROR   NUMERIC(22,0),
                      @p_ID_DETALLETAREA_out     NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @v_validateemail  NUMERIC(22,0);
    DECLARE @p_EMAIL_INVALIDO varchar(max);

   
  SET NOCOUNT ON;

    /*sfgwebdetalletarea.validateemail(p_parametros     => p_PARAMETRO,
                                     p_RESULTADO      => v_validateemail,
                                     p_EMAIL_INVALIDO => p_EMAIL_INVALIDO);

    if v_validateemail = 0 then

\*      WSXML_SFG.SFGTMPTRACE.TraceLog('Create Task',
                                     'Email Task  - ' || p_EMAIL_INVALIDO ||
                                     ' format error');
    *\
      RAISE_APPLICATION_ERROR(-20053,
                              'Formato de Correo Invalido. ' ||
                              p_EMAIL_INVALIDO);
    \*elsif v_validateemail = 1 then
      WSXML_SFG.SFGTMPTRACE.TraceLog('Create Task',
                                     'Email Task  - ' || p_EMAIL_INVALIDO ||
                                     ' format OK');*\
    end if;*/

    INSERT INTO WSXML_SFG.DETALLETAREA
      (
       CODTAREA,
       NOMDETALLETAREA,
       CODINFOEJECUCION,
       PARAMETRO,
       CODUSUARIOMODIFICACION,
       ORDEN,
       CODINFOEJECUCIONWARNING,
       CODINFOEJECUCIONERROR)
    VALUES
      (
       @p_CODTAREA,
       @p_NOMDETALLETAREA,
       @p_CODINFOEJECUCION,
       @p_PARAMETRO,
       @p_CODUSUARIOMODIFICACION,
       @p_ORDEN,
       @p_CODINFOEJECUCIONWARNING,
       @p_CODINFOEJECUCIONERROR);
    SET @p_ID_DETALLETAREA_out = SCOPE_IDENTITY();

    -- Call UPDATE for fields that have database defaults
    IF @p_FECHAHORAMODIFICACION IS NOT NULL BEGIN
      UPDATE WSXML_SFG.DETALLETAREA
         SET FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION
       WHERE ID_DETALLETAREA = @p_ID_DETALLETAREA_out;
    END 
    IF @p_ACTIVE IS NOT NULL BEGIN
      UPDATE WSXML_SFG.DETALLETAREA
         SET ACTIVE = @p_ACTIVE
       WHERE ID_DETALLETAREA = @p_ID_DETALLETAREA_out;
    END 
    IF @p_TIENEPREDECESOR IS NOT NULL BEGIN
      UPDATE WSXML_SFG.DETALLETAREA
         SET TIENEPREDECESOR = @p_TIENEPREDECESOR
       WHERE ID_DETALLETAREA = @p_ID_DETALLETAREA_out;
    END 
  END;
GO

  -- Updates a record in the DETALLETAREA table.
  IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_UpdateRecord(@pk_ID_DETALLETAREA        NUMERIC(22,0),
                         @p_CODTAREA                NUMERIC(22,0),
                         @p_NOMDETALLETAREA         NVARCHAR(2000),
                         @p_CODINFOEJECUCION        NUMERIC(22,0),
                         @p_PARAMETRO               NVARCHAR(2000),
                         @p_FECHAHORAMODIFICACION   DATETIME,
                         @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                         @p_ACTIVE                  NUMERIC(22,0),
                         @p_TIENEPREDECESOR         NUMERIC(22,0),
                         @p_ORDEN                   NUMERIC(22,0),
                         @p_CODINFOEJECUCIONWARNING NUMERIC(22,0),
                         @p_CODINFOEJECUCIONERROR   NUMERIC(22,0)) AS
 BEGIN
    DECLARE @v_validateemail  NUMERIC(22,0);
    DECLARE @p_EMAIL_INVALIDO varchar(max);

   
  SET NOCOUNT ON;

   /* sfgwebdetalletarea.validateemail(p_parametros     => p_PARAMETRO,
                                     p_RESULTADO      => v_validateemail,
                                     p_EMAIL_INVALIDO => p_EMAIL_INVALIDO);

    if v_validateemail = 0 then

      \*WSXML_SFG.SFGTMPTRACE.TraceLog('Create Task',
                                     'Email Task  - ' || p_EMAIL_INVALIDO ||
                                     ' format error');*\

      RAISE_APPLICATION_ERROR(-20053,
                              'Formato de Correo Invalido. ' ||
                              p_EMAIL_INVALIDO);
    \*elsif v_validateemail = 1 then
      WSXML_SFG.SFGTMPTRACE.TraceLog('Create Task',
                                     'Email Task  - ' || p_EMAIL_INVALIDO ||
                                     ' format OK');*\
    end if;*/
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.DETALLETAREA
       SET CODTAREA                = @p_CODTAREA,
           NOMDETALLETAREA         = @p_NOMDETALLETAREA,
           CODINFOEJECUCION        = @p_CODINFOEJECUCION,
           PARAMETRO               = @p_PARAMETRO,
           FECHAHORAMODIFICACION   = @p_FECHAHORAMODIFICACION,
           CODUSUARIOMODIFICACION  = @p_CODUSUARIOMODIFICACION,
           ACTIVE                  = @p_ACTIVE,
           TIENEPREDECESOR         = @p_TIENEPREDECESOR,
           ORDEN                   = @p_ORDEN,
           CODINFOEJECUCIONWARNING = @p_CODINFOEJECUCIONWARNING,
           CODINFOEJECUCIONERROR   = @p_CODINFOEJECUCIONERROR
     WHERE ID_DETALLETAREA = @pk_ID_DETALLETAREA;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    -- Make sure only one record is affected
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Deletes a record from the DETALLETAREA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_DeleteRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_DeleteRecord(@pk_ID_DETALLETAREA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    DELETE WSXML_SFG.DETALLETAREA WHERE ID_DETALLETAREA = @pk_ID_DETALLETAREA;
  END;
GO

  -- Deletes the set of rows from the DETALLETAREA table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.
  IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_DeleteRecords;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_DeleteRecords(@p_where_str NVARCHAR(2000), @p_num_deleted NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @l_where_str NVARCHAR(MAX);
    DECLARE @l_query_str NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    -- Initialize the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL BEGIN
      SET @l_where_str = ' WHERE ' + isnull(@p_where_str, '');
    END 

    SET @p_num_deleted = 0;

    -- Set up the query string
    SET @l_query_str = 'DELETE WSXML_SFG.DETALLETAREA ' + isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

  END;
GO

  -- Returns a specific record from the DETALLETAREA table.
  IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_GetRecord(@pk_ID_DETALLETAREA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.DETALLETAREA
     WHERE ID_DETALLETAREA = @pk_ID_DETALLETAREA;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 	
      SELECT ID_DETALLETAREA,
             CODTAREA,
             NOMDETALLETAREA,
             CODINFOEJECUCION,
             PARAMETRO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             TIENEPREDECESOR,
             ORDEN,
             CODINFOEJECUCIONWARNING,
             CODINFOEJECUCIONERROR
        FROM WSXML_SFG.DETALLETAREA
       WHERE ID_DETALLETAREA = @pk_ID_DETALLETAREA;
	;	   
  END;
GO

  -- Returns a query resultset from table DETALLETAREA
  -- given the search criteria and sorting condition.
  -- It will return a subset of the data based
  -- on the current page number and batch size.  Table joins can
  -- be performed if the join clause is specified.
  --
  -- If the resultset is not empty, it will return:
  --    1) The total number of rows which match the condition;
  --    2) The resultset in the current page
  -- If nothing matches the search condition, it will return:
  --    1) count is 0 ;
  --    2) empty resultset.
  IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_GetList(@p_join_str    NVARCHAR(2000),
                    @p_where_str   NVARCHAR(2000),
                    @p_sort_str    NVARCHAR(2000),
                    @p_page_number INTEGER,
                    @p_batch_size  INTEGER,
                   @p_total_size  INTEGER OUT) AS
 BEGIN
    DECLARE @l_query_from        VARCHAR(MAX);
    DECLARE @l_query_where       VARCHAR(MAX);
    DECLARE @l_query_cols        VARCHAR(MAX);
    DECLARE @l_from_str          VARCHAR(MAX);
    DECLARE @l_alias_str         VARCHAR(MAX);
    DECLARE @l_join_str          VARCHAR(MAX);
    DECLARE @l_sort_str          VARCHAR(MAX);
    DECLARE @l_where_str         VARCHAR(MAX);
    DECLARE @l_count_query       VARCHAR(MAX);
    DECLARE @l_end_gen_row_num   INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    -- Set up the from string as the base table.
    SET @l_from_str  = 'WSXML_SFG.DETALLETAREA DETALLETAREA_';
    SET @l_alias_str = 'DETALLETAREA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null BEGIN
      SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null BEGIN
      SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0 BEGIN
      SET @l_count_query = 'SELECT @p_total_size = count(*) ' + 'FROM ' + isnull(@l_from_str, '') + ' ' +
                       isnull(@l_join_str, '') + ' ' + isnull(@l_where_str, '') + ' ';

      -- Run the count query
      EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
        @p_total_size output;
    END 

    -- Set up column name variable(s)
    SET @l_query_cols = 'DETALLETAREA_.ID_DETALLETAREA,
            DETALLETAREA_.CODTAREA,
            DETALLETAREA_.NOMDETALLETAREA,
            DETALLETAREA_.CODINFOEJECUCION,
            DETALLETAREA_.PARAMETRO,
            DETALLETAREA_.FECHAHORAMODIFICACION,
            DETALLETAREA_.CODUSUARIOMODIFICACION,
            DETALLETAREA_.ACTIVE,
            DETALLETAREA_.TIENEPREDECESOR,
            DETALLETAREA_.ORDEN,
            DETALLETAREA_.CODINFOEJECUCIONWARNING,
            DETALLETAREA_.CODINFOEJECUCIONERROR';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0 BEGIN
      -- If the caller did not pass a sort string, use a default value
      IF @p_sort_str IS NOT NULL BEGIN
        SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
      END
      ELSE BEGIN
        SET @l_sort_str = 'ORDER BY DETALLETAREA_.ID_DETALLETAREA ASC ';

      END 

      -- Calculate the rows to be included in the list
      -- before geting the list.
      SET @l_end_gen_row_num   = @p_page_number * @p_batch_size;
      SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size - 1);

      -- Run the query
      SET @sql =  ' SELECT ' + isnull(@l_query_cols, '') + ' ' +
 'FROM ( SELECT ' + isnull(@l_query_cols, '') + ' ' +
 ' ' + ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER ' + 'FROM ( SELECT ' + isnull(@l_query_cols, '') + ' ' +
 ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' + isnull(@l_where_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + 'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' + 'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' + 'ORDER BY ISD_ROW_NUMBER; ';
      EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
      -- If page number and batch size are not valid numbers
      -- return an empty result set
      SET @sql =  ' SELECT ' + isnull(@l_query_cols, '') + ' ' +
 ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + 'WHERE 1=2; ';
      EXECUTE sp_executesql @sql;
    END 

  END;
GO

  -- Returns a query result from table DETALLETAREA
  -- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_DrillDown;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_DrillDown(@p_select_str   NVARCHAR(2000),
                      @p_is_distinct  INTEGER,
                      @p_select_str_b NVARCHAR(2000),
                      @p_join_str     NVARCHAR(2000),
                      @p_where_str    NVARCHAR(2000),
                      @p_sort_str     NVARCHAR(2000),
                      @p_page_number  INTEGER,
                      @p_batch_size   INTEGER,
                     @p_total_size   INTEGER OUT) AS
 BEGIN
    DECLARE @l_query_select      VARCHAR(MAX);
    DECLARE @l_query_select_b    VARCHAR(MAX);
    DECLARE @l_query_from        VARCHAR(MAX);
    DECLARE @l_query_where       VARCHAR(MAX);
    DECLARE @l_from_str          VARCHAR(MAX);
    DECLARE @l_alias_str         VARCHAR(MAX);
    DECLARE @l_join_str          VARCHAR(MAX);
    DECLARE @l_sort_str          VARCHAR(MAX);
    DECLARE @l_where_str         VARCHAR(MAX);
    DECLARE @l_count_query       VARCHAR(MAX);
    DECLARE @l_end_gen_row_num   INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    -- Set up the from string as the base table.
	SET @l_query_select = @p_select_str;
    SET @l_from_str     = 'WSXML_SFG.DETALLETAREA DETALLETAREA_';
    SET @l_alias_str    = 'DETALLETAREA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null BEGIN
      SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null BEGIN
      SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0 BEGIN
      IF @p_is_distinct = 0 BEGIN
        SET @l_count_query = 'SELECT @p_total_size = count(*) FROM ( SELECT ' + isnull(@p_select_str, '') + ' ' +
                         'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str + ' ' +
                         isnull(@l_where_str, '') + ' ) countAlias', '');
      END
      ELSE BEGIN
        SET @l_count_query = 'SELECT @l_count_query = COUNT(*) FROM ( SELECT DISTINCT ' +
                         isnull(@p_select_str, '') + ', 1 As count1  ' + 'FROM ' +
                         isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
                         isnull(@l_where_str, '') + ' ) pass1 ';
      END 
    END
    ELSE BEGIN
      SET @l_count_query = ' ';
    END 

    -- Run the count query
    EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
      @p_total_size output;

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0 BEGIN
      -- If the caller did not pass a sort string, use a default value
      IF @p_sort_str IS NOT NULL BEGIN
        SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
      END
      ELSE BEGIN
        SET @l_sort_str = 'ORDER BY ' + @l_query_select;
      END 

      -- Calculate the rows to be included in the list
      -- before geting the list.
      SET @l_end_gen_row_num   = @p_page_number * @p_batch_size;
      SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size - 1);

      IF @p_is_distinct = 0 BEGIN
        SET @l_query_select_b = @p_select_str_b;
      END
      ELSE BEGIN
        SET @l_query_select_b = 'DISTINCT ' + isnull(@p_select_str_b, '');
      END 

      -- Run the query
		SET @sql =  ' SELECT ' + isnull(@l_query_select, '') + ' ' + 'FROM ( SELECT ' + isnull(@l_query_select, '') + ' ' + ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER ' + 'FROM ( SELECT ' + isnull(@l_query_select_b, '') + ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' + isnull(@l_where_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + 'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' + 'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' + 'ORDER BY ISD_ROW_NUMBER; ';
		EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
      -- If page number and batch size are not valid numbers
      -- return an empty result set
	  SET @sql =  ' SELECT ' + isnull(@l_query_select, '') + ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + 'WHERE 1=2; ';
	  EXECUTE sp_executesql @sql;
    END 

  END;
GO

  -- Returns a query result from table DETALLETAREA
  -- given the search criteria and sorting condition.
  IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_GetStats;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_GetStats(@p_select_str  NVARCHAR(2000),
                     @p_join_str    NVARCHAR(2000),
                     @p_where_str   NVARCHAR(2000),
                     @p_sort_str    NVARCHAR(2000),
                     @p_page_number INTEGER,
                    @p_batch_size  INTEGER) AS
 BEGIN
    DECLARE @l_query_select      VARCHAR(MAX);
    DECLARE @l_query_from        VARCHAR(MAX);
    DECLARE @l_query_where       VARCHAR(MAX);
    DECLARE @l_from_str          VARCHAR(MAX);
    DECLARE @l_alias_str         VARCHAR(MAX);
    DECLARE @l_join_str          VARCHAR(MAX);
    DECLARE @l_sort_str          VARCHAR(MAX);
    DECLARE @l_where_str         VARCHAR(MAX);
    DECLARE @l_stat_col          VARCHAR(MAX);
    DECLARE @l_select_col        VARCHAR(MAX);
    DECLARE @l_end_gen_row_num   INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    -- Extract the col only that we need to run statistics on.
    -- First extract the content in the function call.
    SET @l_stat_col = @p_select_str;
    SET @l_stat_col = SUBSTRING(@l_stat_col,
                         CHARINDEX('(', @l_stat_col) + 1,
                         CHARINDEX(')', @l_stat_col) - CHARINDEX('(', @l_stat_col) - 1);

    -- Then extract the column from the distinct clause.
    SET @l_stat_col = LTRIM(RTRIM(@l_stat_col));
    IF CHARINDEX('DISTINCT ', UPPER(@l_stat_col)) = 1 BEGIN
      SET @l_stat_col = SUBSTRING(@l_stat_col,
                           CHARINDEX(' ', @l_stat_col) + 1,
                           LEN(@l_stat_col));
    END 

    -- Get the select column name without alias.
	SET @l_query_select = @l_stat_col;
	SET @l_select_col = @l_stat_col;
	IF CHARINDEX(' ', @l_stat_col) > 0
	BEGIN
		SET @l_stat_col = SUBSTRING(@l_stat_col, 0, CHARINDEX(' ', @l_stat_col));
		SET @l_select_col = @l_stat_col;
	END

    -- Set up the from string as the base table.

    SET @l_from_str     = 'WSXML_SFG.DETALLETAREA DETALLETAREA_';
    SET @l_alias_str    = 'DETALLETAREA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null BEGIN
      SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null BEGIN
      SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0 BEGIN
      -- If the caller did not pass a sort string, use a default value
      IF @p_sort_str IS NOT NULL BEGIN
        SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
      END
      ELSE BEGIN
        SET @l_sort_str = 'ORDER BY ' + @l_stat_col;
      END 

      -- Calculate the rows to be included in the list
      -- before geting the list.
      SET @l_end_gen_row_num   = @p_page_number * @p_batch_size;
      SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size - 1);

      -- Run the query
      SET @sql =  ' SELECT ' + isnull(@l_query_select, '') + ' ' + 'FROM ( SELECT ' + isnull(@l_stat_col, '') + ' ' + ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER ' + 'FROM ( SELECT ' + isnull(@l_select_col, '') + ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' + isnull(@l_where_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + 'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' + 'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' + 'ORDER BY ISD_ROW_NUMBER; ';
      EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
      -- If page number and batch size are not valid numbers
      -- return an empty result set
		SET @sql =  ' SELECT ' + isnull(@l_query_select, '') + ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + 'WHERE 1=2; ';
		EXECUTE sp_executesql @sql;
    END 

  END;
GO

  -- Returns the query result set in a CSV format
  -- so that the data can be exported to a CSV file
  IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_Export;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_Export(@p_separator_str NVARCHAR(2000),
                   @p_title_str     NVARCHAR(2000),
                   @p_select_str    NVARCHAR(2000),
                   @p_join_str      NVARCHAR(2000),
                   @p_where_str     NVARCHAR(2000),
                  @p_num_exported  INTEGER OUT) AS
 BEGIN
    DECLARE @l_title_str    VARCHAR(MAX);
    DECLARE @l_select_str   VARCHAR(MAX);
    DECLARE @l_from_str     VARCHAR(MAX);
    DECLARE @l_join_str     VARCHAR(MAX);
    DECLARE @l_where_str    VARCHAR(MAX);
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_union  VARCHAR(MAX);
    DECLARE @l_query_from   VARCHAR(MAX);
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    -- Set up the title string from the column names.  Excel
    -- will complain if the first column value is ID. So wrap
    -- the value with .
    SET @l_title_str = isnull(@p_title_str, '') + isnull(char(13), '');
    IF @p_title_str IS NULL BEGIN
      SET @l_title_str = 'XID_DETALLETAREA' + isnull(@p_separator_str, '') +
                     'CODTAREA' + isnull(@p_separator_str, '') +
                     'CODTAREA NOMTAREA' + isnull(@p_separator_str, '') +
                     'NOMDETALLETAREA' + isnull(@p_separator_str, '') +
                     'CODINFOEJECUCION' + isnull(@p_separator_str, '') +
                     'CODINFOEJECUCION NOMEJECUCION' +
                     isnull(@p_separator_str, '') + 'PARAMETRO' + isnull(@p_separator_str, '') +
                     'FECHAHORAMODIFICACION' + isnull(@p_separator_str, '') +
                     'CODUSUARIOMODIFICACION' + isnull(@p_separator_str, '') +
                     'ACTIVE' + isnull(@p_separator_str, '') + 'TIENEPREDECESOR' +
                     isnull(@p_separator_str, '') + 'ORDEN' + isnull(@p_separator_str, '') +
                     'CODINFOEJECUCIONWARNING' + isnull(@p_separator_str, '') +
                     'CODINFOEJECUCIONWARNING NOMEJECUCION' +
                     isnull(@p_separator_str, '') + 'CODINFOEJECUCIONERROR' +
                     isnull(@p_separator_str, '') +
                     'CODINFOEJECUCIONERROR NOMEJECUCION' + ' ';
    END 

    IF SUBSTRING(@l_title_str, 1, 2) = 'ID' BEGIN
      SET @l_title_str = '' +
                     ISNULL(SUBSTRING(@l_title_str, 1, CHARINDEX(',', @l_title_str) - 1), '') + '' +
                     ISNULL(SUBSTRING(@l_title_str,
                            CHARINDEX(',', @l_title_str),
                            LEN(@l_title_str)), '');
    END 

    -- Set up the select string
    SET @l_select_str = @p_select_str;
    IF @p_select_str IS NULL BEGIN
      SET @l_select_str = 'ISNULL(DETALLETAREA_.ID_DETALLETAREA, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(DETALLETAREA_.CODTAREA, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST( t0.NOMTAREA AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST(DETALLETAREA_.NOMDETALLETAREA AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(DETALLETAREA_.CODINFOEJECUCION, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST( t1.NOMEJECUCION AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST(DETALLETAREA_.PARAMETRO AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(dbo.ConvertFecha(DETALLETAREA_.FECHAHORAMODIFICACION), '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(DETALLETAREA_.CODUSUARIOMODIFICACION, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(DETALLETAREA_.ACTIVE, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(DETALLETAREA_.TIENEPREDECESOR, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(DETALLETAREA_.ORDEN, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(DETALLETAREA_.CODINFOEJECUCIONWARNING, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST( t2.NOMEJECUCION AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(DETALLETAREA_.CODINFOEJECUCIONERROR, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST( t3.NOMEJECUCION AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.DETALLETAREA DETALLETAREA_ LEFT OUTER JOIN WSXML_SFG.TAREA t0 ON (DETALLETAREA_.CODTAREA =  t0.ID_TAREA) LEFT OUTER JOIN WSXML_SFG.INFOEJECUCION t1 ON (DETALLETAREA_.CODINFOEJECUCION =  t1.ID_INFOEJECUCION) LEFT OUTER JOIN WSXML_SFG.INFOEJECUCION t2 ON (DETALLETAREA_.CODINFOEJECUCIONWARNING =  t2.ID_INFOEJECUCION) LEFT OUTER JOIN WSXML_SFG.INFOEJECUCION t3 ON (DETALLETAREA_.CODINFOEJECUCIONERROR =  t3.ID_INFOEJECUCION)';

    SET @l_join_str = @p_join_str;
    IF @p_join_str IS NULL BEGIN
      SET @l_join_str = ' ';
    END 

    -- Set up the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL BEGIN
      SET @l_where_str = isnull(@l_where_str, '') + 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Construct the query string.  Append the result set with the title.
    SET @l_query_select = 'SELECT ''';
    SET @l_query_union  = ''' UNION ALL ' + 'SELECT ';
    SET @l_query_from   = ' FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
                      isnull(@l_where_str, '');

    -- Run the query
    SET @sql =  (' '+isnull(@l_query_select, '') + isnull(@l_title_str, '') + isnull(@l_query_union, '') +
                    isnull(@l_select_str, '') + isnull(@l_query_from, '')+' ');
    EXECUTE sp_executesql @sql;

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLETAREA_ValidateEmail', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_ValidateEmail;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBDETALLETAREA_ValidateEmail(@p_PARAMETROS     NVARCHAR(2000),
                          @p_RESULTADO      NUMERIC(22,0) OUT,
                          @p_EMAIL_INVALIDO varchar(4000) OUT) as
 begin

   
  SET NOCOUNT ON;

	SET @p_RESULTADO = 0


	declare @p_cur_sin_pipe cursor, @p_cur_sin_puntocoma cursor,  @p_cur_email cursor

	SET  @p_cur_sin_pipe = CURSOR FORWARD_ONLY STATIC FOR  
	SELECT VALUE as sin_pipe FROM STRING_SPLIT(@p_PARAMETROS, '|') 
	where value like '%@%'
	OPEN @p_cur_sin_pipe

	declare @sin_pipe varchar(2000), @sin_puntocoma varchar(2000), @email VARCHAR(2000);
	FETCH NEXT FROM @p_cur_sin_pipe INTO @sin_pipe
        
			WHILE (@@FETCH_STATUS = 0)
			BEGIN

				SET  @p_cur_sin_puntocoma = CURSOR FORWARD_ONLY STATIC FOR 
					SELECT VALUE FROM STRING_SPLIT(@sin_pipe, ';')
				OPEN @p_cur_sin_puntocoma

				FETCH NEXT FROM @p_cur_sin_puntocoma INTO @sin_puntocoma

				 WHILE (@@FETCH_STATUS = 0)
				BEGIN
				
					SET @p_RESULTADO = dbo.fnIsValidEmail(@sin_puntocoma);
					IF( @p_RESULTADO = 0) BEGIN
						SET @p_EMAIL_INVALIDO = @sin_puntocoma
						BREAK
					END


				FETCH NEXT FROM @p_cur_sin_puntocoma INTO @sin_puntocoma
				END

				CLOSE @p_cur_sin_puntocoma
				DEALLOCATE @p_cur_sin_puntocoma

				IF (@p_RESULTADO = 0)
					BREAK

			 
				FETCH NEXT FROM @p_cur_sin_pipe INTO @sin_pipe
			END
        
	CLOSE @p_cur_sin_pipe
	DEALLOCATE @p_cur_sin_pipe
END
GO
