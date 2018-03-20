USE SFGPRODU;
--  DDL for Package Body SFGWEBALERTA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBALERTA */ 

-- Creates a new record in the ALERTA table
IF OBJECT_ID('WSXML_SFG.SFGWEBALERTA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBALERTA_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBALERTA_AddRecord(
    @p_CODTIPOALERTA NUMERIC(22,0),
    @p_CONTENIDO NVARCHAR(2000),
    @p_CODPROCESO NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_CODESTADOALERTA NUMERIC(22,0),
    @p_CODUSUARIODESTINO NUMERIC(22,0),
    @p_MENSAJEDETALLADO NVARCHAR(2000),
    @p_ID_ALERTA_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.ALERTA
        (
            CODTIPOALERTA,
            CONTENIDO,
            CODPROCESO,
            CODUSUARIOMODIFICACION,
            CODESTADOALERTA,
            CODUSUARIODESTINO,
            MENSAJEDETALLADO
        )
    VALUES
        (
            @p_CODTIPOALERTA,
            @p_CONTENIDO,
            @p_CODPROCESO,
            @p_CODUSUARIOMODIFICACION,
            @p_CODESTADOALERTA,
            @p_CODUSUARIODESTINO,
            @p_MENSAJEDETALLADO
        );
       SET
            @p_ID_ALERTA_out = SCOPE_IDENTITY() ;

    -- Call UPDATE for fields that have database defaults
    IF @p_FECHAHORAMODIFICACION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.ALERTA SET FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION WHERE ID_ALERTA = @p_ID_ALERTA_out;
    END 
    IF @p_ACTIVE IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.ALERTA SET ACTIVE = @p_ACTIVE WHERE ID_ALERTA = @p_ID_ALERTA_out;
    END 
END;
GO

-- Updates a record in the ALERTA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBALERTA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBALERTA_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBALERTA_UpdateRecord(
    @pk_ID_ALERTA NUMERIC(22,0),
    @p_CODTIPOALERTA NUMERIC(22,0),
    @p_CONTENIDO NVARCHAR(2000),
    @p_CODPROCESO NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_CODESTADOALERTA NUMERIC(22,0),
    @p_CODUSUARIODESTINO NUMERIC(22,0),
    @p_MENSAJEDETALLADO NVARCHAR(2000)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.ALERTA
    SET
            CODTIPOALERTA = @p_CODTIPOALERTA,
            CONTENIDO = @p_CONTENIDO,
            CODPROCESO = @p_CODPROCESO,
            FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION,
            CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
            ACTIVE = @p_ACTIVE,
            CODESTADOALERTA = @p_CODESTADOALERTA,
            CODUSUARIODESTINO = @p_CODUSUARIODESTINO,
            MENSAJEDETALLADO = @p_MENSAJEDETALLADO
    WHERE ID_ALERTA = @pk_ID_ALERTA;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    -- Make sure only one record is affected
    IF @rowcount = 0
    BEGIN
        RAISERROR ('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1
    BEGIN
        RAISERROR ('-20053 Duplicate object instances.', 16, 1);
    END 

END;
GO

-- Deletes a record from the ALERTA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBALERTA_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBALERTA_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBALERTA_DeleteRecord(
    @pk_ID_ALERTA NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.ALERTA
    WHERE ID_ALERTA = @pk_ID_ALERTA;
END;
GO

-- Deletes the set of rows from the ALERTA table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBALERTA_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBALERTA_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBALERTA_DeleteRecords(
    @p_where_str NVARCHAR(2000),
    @p_num_deleted NUMERIC(22,0) OUT
    )
AS
BEGIN
    DECLARE @l_where_str NVARCHAR(MAX);
    DECLARE @l_query_str NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Initialize the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL
    BEGIN
        SET @l_where_str = ' WHERE ' + isnull(@p_where_str, '');
    END 

    SET @p_num_deleted = 0;

    -- Set up the query string
    SET @l_query_str =
'DELETE WSXML_SFG.ALERTA' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the ALERTA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBALERTA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBALERTA_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBALERTA_GetRecord(
   @pk_ID_ALERTA NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.ALERTA
    WHERE ID_ALERTA = @pk_ID_ALERTA;

    IF @l_count = 0
    BEGIN
        RAISERROR ('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1
    BEGIN
        RAISERROR ('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
         SELECT
        ID_ALERTA,
        CODTIPOALERTA,
        CONTENIDO,
        CODPROCESO,
        FECHAHORAMODIFICACION,
        CODUSUARIOMODIFICACION,
        ACTIVE,
        CODESTADOALERTA,
        CODUSUARIODESTINO,
        MENSAJEDETALLADO
    FROM WSXML_SFG.ALERTA
    WHERE ID_ALERTA = @pk_ID_ALERTA;  
END;
GO

-- Returns a query resultset from table ALERTA
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
IF OBJECT_ID('WSXML_SFG.SFGWEBALERTA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBALERTA_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBALERTA_GetList(
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
    @p_sort_str NVARCHAR(2000),
    @p_page_number INTEGER,
    @p_batch_size INTEGER,
   @p_total_size INTEGER OUT

    )
AS
BEGIN
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @l_query_where VARCHAR(MAX);
    DECLARE @l_query_cols VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_alias_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_sort_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_count_query NVARCHAR(MAX);
    DECLARE @l_end_gen_row_num INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Set up the from string as the base table.
    SET @l_from_str = 'WSXML_SFG.ALERTA ALERTA_';
    SET @l_alias_str = 'ALERTA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
        IF @p_where_str is not null
    BEGIN
        SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0
    BEGIN
        SET @l_count_query =
            'SELECT @p_total_size = count(*) ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
            isnull(@l_where_str, '') + ' ';

        -- Run the count query
        EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
        @p_total_size output;
    END 

    -- Set up column name variable(s)
    SET @l_query_cols =
        'ALERTA_.ID_ALERTA,
            ALERTA_.CODTIPOALERTA,
            ALERTA_.CONTENIDO,
            ALERTA_.CODPROCESO,
            ALERTA_.FECHAHORAMODIFICACION,
            ALERTA_.CODUSUARIOMODIFICACION,
            ALERTA_.ACTIVE,
            ALERTA_.CODESTADOALERTA,
            ALERTA_.CODUSUARIODESTINO,
            ALERTA_.MENSAJEDETALLADO';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY ALERTA_.ID_ALERTA ASC ';

        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        -- Run the query
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ( SELECT ' +
                isnull(@l_query_cols, '') + ' ' +
 ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
                    isnull(@l_query_cols, '') + ' ' +
 ' ' +
                    'FROM ' +
                        isnull(@l_from_str, '') + ' ' +
                        isnull(@l_join_str, '') + ' ' +
                        isnull(@l_where_str, '') + ' ' +
                ') ' + isnull(@l_alias_str, '') + ' ' +
            ') ' + isnull(@l_alias_str, '') + ' ' +
            'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' +
            'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' +
            'ORDER BY ISD_ROW_NUMBER; ';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table ALERTA
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBALERTA_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBALERTA_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBALERTA_DrillDown(
    @p_select_str NVARCHAR(2000),
    @p_is_distinct INTEGER,
    @p_select_str_b NVARCHAR(2000),
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
    @p_sort_str NVARCHAR(2000),
    @p_page_number INTEGER,
    @p_batch_size INTEGER,
   @p_total_size INTEGER OUT

    )
AS
BEGIN
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_select_b VARCHAR(MAX);
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @l_query_where VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_alias_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_sort_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_count_query NVARCHAR(MAX);
    DECLARE @l_end_gen_row_num INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Set up the from string as the base table.
	SET @l_query_select = @p_select_str;
    SET @l_from_str = 'WSXML_SFG.ALERTA ALERTA_';
    SET @l_alias_str = 'ALERTA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null
    BEGIN
        SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0
    BEGIN
        IF @p_is_distinct = 0
        BEGIN
            SET @l_count_query =
                'SELECT @p_total_size = count(*) FROM ( SELECT ' + isnull(@p_select_str, '') + ' ' +
                'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str + ' ' +
                isnull(@l_where_str, '') + ' ) countAlias', '');
        END
        ELSE BEGIN
            SET @l_count_query =
                'SELECT @p_total_size = COUNT(*) FROM ( SELECT DISTINCT ' + isnull(@p_select_str, '') + ', 1 As count1  ' +
                'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
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
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY ' + @l_query_select;
        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        IF @p_is_distinct = 0
        BEGIN
            SET @l_query_select_b = @p_select_str_b;
        END
        ELSE BEGIN
            SET @l_query_select_b = 'DISTINCT ' + isnull(@p_select_str_b, '');
        END 

        -- Run the query
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ( SELECT ' +
                isnull(@l_query_select, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
                    isnull(@l_query_select_b, '') + ' ' +
                    'FROM ' +
                        isnull(@l_from_str, '') + ' ' +
                        isnull(@l_join_str, '') + ' ' +
                        isnull(@l_where_str, '') + ' ' +
                ') ' + isnull(@l_alias_str, '') + ' ' +
            ') ' + isnull(@l_alias_str, '') + ' ' +
            'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' +
            'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' +
            'ORDER BY ISD_ROW_NUMBER; ';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table ALERTA
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBALERTA_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBALERTA_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBALERTA_GetStats(
    @p_select_str NVARCHAR(2000),
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
    @p_sort_str NVARCHAR(2000),
    @p_page_number INTEGER,
   @p_batch_size INTEGER

    )
AS
BEGIN
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @l_query_where VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_alias_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_sort_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_stat_col VARCHAR(MAX);
    DECLARE @l_select_col VARCHAR(MAX);
    DECLARE @l_end_gen_row_num INTEGER;
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
    IF CHARINDEX('DISTINCT ', UPPER(@l_stat_col)) = 1
    BEGIN
        SET @l_stat_col = SUBSTRING(@l_stat_col, CHARINDEX(' ', @l_stat_col) + 1, LEN(@l_stat_col));
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

    SET @l_from_str = 'WSXML_SFG.ALERTA ALERTA_';
    SET @l_alias_str = 'ALERTA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null
    BEGIN
        SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY ' + @l_stat_col;
        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        -- Run the query
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ( SELECT ' +
                isnull(@l_stat_col, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
                    isnull(@l_select_col, '') + ' ' +
                    'FROM ' +
                        isnull(@l_from_str, '') + ' ' +
                        isnull(@l_join_str, '') + ' ' +
                        isnull(@l_where_str, '') + ' ' +
                ') ' + isnull(@l_alias_str, '') + ' ' +
            ') ' + isnull(@l_alias_str, '') + ' ' +
            'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' +
            'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' +
            'ORDER BY ISD_ROW_NUMBER; ';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2 ';
        EXECUTE sp_executesql @sql;;
    END 

END;
GO

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file
IF OBJECT_ID('WSXML_SFG.SFGWEBALERTA_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBALERTA_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBALERTA_Export(
    @p_separator_str NVARCHAR(2000),
    @p_title_str NVARCHAR(2000),
    @p_select_str NVARCHAR(2000),
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
   @p_num_exported INTEGER OUT

    )
AS
BEGIN
    DECLARE @l_title_str VARCHAR(MAX);
    DECLARE @l_select_str VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_union VARCHAR(MAX);
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Set up the title string from the column names.  Excel
    -- will complain if the first column value is ID. So wrap
    -- the value with .
    SET @l_title_str = isnull(@p_title_str, '') + isnull(char(13), '');
    IF @p_title_str IS NULL
    BEGIN
        SET @l_title_str =
                '''XID_ALERTA' + isnull(@p_separator_str, '') +
                'CODTIPOALERTA' + isnull(@p_separator_str, '') +
                'CODTIPOALERTA NOMTIPOALERTA' + isnull(@p_separator_str, '') +
                'CONTENIDO' + isnull(@p_separator_str, '') +
                'CODPROCESO' + isnull(@p_separator_str, '') +
                'CODPROCESO NOMPROCESO' + isnull(@p_separator_str, '') +
                'FECHAHORAMODIFICACION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION NOMUSUARIO' + isnull(@p_separator_str, '') +
                'ACTIVE' + isnull(@p_separator_str, '') +
                'CODESTADOALERTA' + isnull(@p_separator_str, '') +
                'CODESTADOALERTA NOMESTADOALERTA' + isnull(@p_separator_str, '') +
                'CODUSUARIODESTINO' + isnull(@p_separator_str, '') +
                'CODUSUARIODESTINO NOMBRE' + isnull(@p_separator_str, '') +
                'MENSAJEDETALLADO' + ' ''';
    END 

    IF SUBSTRING(@l_title_str, 1, 2) = 'ID'
    BEGIN
        SET @l_title_str =
            '' +
            ISNULL(SUBSTRING(@l_title_str, 1, CHARINDEX(',', @l_title_str)-1), '') +
            '' +
            ISNULL(SUBSTRING(@l_title_str, CHARINDEX(',', @l_title_str), LEN(@l_title_str)), '');
    END 

    -- Set up the select string
    SET @l_select_str = @p_select_str;
    IF @p_select_str IS NULL
    BEGIN
        SET @l_select_str =
                ' isnull(CAST(ALERTA_.ID_ALERTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(ALERTA_.CODTIPOALERTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMTIPOALERTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(ALERTA_.CONTENIDO) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(ALERTA_.CODPROCESO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMPROCESO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(ALERTA_.FECHAHORAMODIFICACION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(ALERTA_.CODUSUARIOMODIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMUSUARIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(ALERTA_.ACTIVE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(ALERTA_.CODESTADOALERTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMESTADOALERTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(ALERTA_.CODUSUARIODESTINO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t4.NOMBRE, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(ALERTA_.MENSAJEDETALLADO, ''''), '''', '''') + ''''  + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.ALERTA ALERTA_ LEFT OUTER JOIN WSXML_SFG.TIPOALERTA t0 ON (ALERTA_.CODTIPOALERTA =  t0.ID_TIPOALERTA) LEFT OUTER JOIN WSXML_SFG.PROCESO t1 ON (ALERTA_.CODPROCESO =  t1.ID_PROCESO) LEFT OUTER JOIN WSXML_SFG.USUARIO t2 ON (ALERTA_.CODUSUARIOMODIFICACION =  t2.ID_USUARIO) LEFT OUTER JOIN WSXML_SFG.ESTADOALERTA t3 ON (ALERTA_.CODESTADOALERTA =  t3.ID_ESTADOALERTA) LEFT OUTER JOIN WSXML_SFG.USUARIO t4 ON (ALERTA_.CODUSUARIODESTINO =  t4.ID_USUARIO)';

    SET @l_join_str = @p_join_str;
    IF @p_join_str IS NULL
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL
    BEGIN
        SET @l_where_str = isnull(@l_where_str, '') + 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Construct the query string.  Append the result set with the title.
    SET @l_query_select =
'SELECT ';
    SET @l_query_union =
' UNION ALL ' +
            'SELECT ';
    SET @l_query_from =
            ' FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
            isnull(@l_where_str, '');

    -- Run the query
    SET @sql = 
    (' '+isnull(@l_query_select, '') + isnull(@l_title_str, '') + isnull(@l_query_union, '') + isnull(@l_select_str, '')+ isnull(@l_query_from, '')+' ');
    EXECUTE sp_executesql @sql;

END;
GO






