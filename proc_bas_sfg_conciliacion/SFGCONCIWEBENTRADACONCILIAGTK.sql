USE SFGPRODU;
--  DDL for Package Body SFGCONCIWEBENTRADACONCILIAGTK
--------------------------------------------------------

  /* PACKAGE BODY SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK */ 

-- Creates a new record in the ENTRADACONCILIAGTK table
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_AddRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_AddRecord(
    @p_CODREGISTROFACTREFERENCIA NUMERIC(22,0),
    @p_CONCILIADO_CON NUMERIC(22,0),
    @p_BUS_DATE DATETIME,
    @p_RCPT_NMR VARCHAR(4000),
    @p_AMOUNT NUMERIC(22,0),
    @p_ANSWER_CODE VARCHAR(4000),
    @p_ARRN VARCHAR(4000),
    @p_ESTADO_CONCILIA NUMERIC(22,0),
    @p_CONCILIABLE NUMERIC(22,0),
    @p_FECHA_HORA_TRANS DATETIME,
    @p_BUS_DATE_MODIFICADO NUMERIC(22,0),
    @p_CODRAZON_NO_CONCILIABLE NUMERIC(22,0),
    @p_ESTADO_SC NVARCHAR(2000),
    @p_TIPOTRANSACCION_SC NVARCHAR(2000),
    @p_CODCON_CONTROL_PROC NUMERIC(22,0),
    @p_FECHA_ARCHIVO DATETIME,
    @p_SPRN_Y_BUS_DATE NUMERIC(22,0),
    @p_ID_ENTRADACONCILIAGTK_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO SFG_CONCILIACION.ENTRADACONCILIAGTK
        (
            CODREGISTROFACTREFERENCIA,
            CONCILIADO_CON,
            BUS_DATE,
            RCPT_NMR,
            AMOUNT,
            ANSWER_CODE,
            ARRN,
            FECHA_HORA_TRANS,
            BUS_DATE_MODIFICADO,
            CODRAZON_NO_CONCILIABLE,
            CODCON_CONTROL_PROC,
            FECHA_ARCHIVO,
            SPRN_Y_BUS_DATE
        )
    VALUES
        (
            @p_CODREGISTROFACTREFERENCIA,
            @p_CONCILIADO_CON,
            @p_BUS_DATE,
            @p_RCPT_NMR,
            @p_AMOUNT,
            @p_ANSWER_CODE,
            @p_ARRN,
            @p_FECHA_HORA_TRANS,
            @p_BUS_DATE_MODIFICADO,
            @p_CODRAZON_NO_CONCILIABLE,
            @p_CODCON_CONTROL_PROC,
            @p_FECHA_ARCHIVO,
            @p_SPRN_Y_BUS_DATE
        );
       SET
            @p_ID_ENTRADACONCILIAGTK_out = SCOPE_IDENTITY() ;

    -- Call UPDATE for fields that have database defaults
    IF @p_ESTADO_CONCILIA IS NOT NULL
    BEGIN
        UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK SET ESTADO_CONCILIA = @p_ESTADO_CONCILIA WHERE ID_ENTRADACONCILIAGTK = @p_ID_ENTRADACONCILIAGTK_out;
    END 
    IF @p_CONCILIABLE IS NOT NULL
    BEGIN
        UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK SET CONCILIABLE = @p_CONCILIABLE WHERE ID_ENTRADACONCILIAGTK = @p_ID_ENTRADACONCILIAGTK_out;
    END 
    IF @p_ESTADO_SC IS NOT NULL
    BEGIN
        UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK SET ESTADO_SC = @p_ESTADO_SC WHERE ID_ENTRADACONCILIAGTK = @p_ID_ENTRADACONCILIAGTK_out;
    END 
    IF @p_TIPOTRANSACCION_SC IS NOT NULL
    BEGIN
        UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK SET TIPOTRANSACCION_SC = @p_TIPOTRANSACCION_SC WHERE ID_ENTRADACONCILIAGTK = @p_ID_ENTRADACONCILIAGTK_out;
    END 
END;
GO

-- Updates a record in the ENTRADACONCILIAGTK table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_UpdateRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_UpdateRecord(
    @pk_ID_ENTRADACONCILIAGTK NUMERIC(22,0),
    @p_CODREGISTROFACTREFERENCIA NUMERIC(22,0),
    @p_CONCILIADO_CON NUMERIC(22,0),
    @p_BUS_DATE DATETIME,
    @p_RCPT_NMR VARCHAR(4000),
    @p_AMOUNT NUMERIC(22,0),
    @p_ANSWER_CODE VARCHAR(4000),
    @p_ARRN VARCHAR(4000),
    @p_ESTADO_CONCILIA NUMERIC(22,0),
    @p_CONCILIABLE NUMERIC(22,0),
    @p_FECHA_HORA_TRANS DATETIME,
    @p_BUS_DATE_MODIFICADO NUMERIC(22,0),
    @p_CODRAZON_NO_CONCILIABLE NUMERIC(22,0),
    @p_ESTADO_SC NVARCHAR(2000),
    @p_TIPOTRANSACCION_SC NVARCHAR(2000),
    @p_CODCON_CONTROL_PROC NUMERIC(22,0),
    @p_FECHA_ARCHIVO DATETIME,
    @p_SPRN_Y_BUS_DATE NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK
    SET 
            CODREGISTROFACTREFERENCIA = @p_CODREGISTROFACTREFERENCIA,
            CONCILIADO_CON = @p_CONCILIADO_CON,
            BUS_DATE = @p_BUS_DATE,
            RCPT_NMR = @p_RCPT_NMR,
            AMOUNT = @p_AMOUNT,
            ANSWER_CODE = @p_ANSWER_CODE,
            ARRN = @p_ARRN,
            ESTADO_CONCILIA = @p_ESTADO_CONCILIA,
            CONCILIABLE = @p_CONCILIABLE,
            FECHA_HORA_TRANS = @p_FECHA_HORA_TRANS,
            BUS_DATE_MODIFICADO = @p_BUS_DATE_MODIFICADO,
            CODRAZON_NO_CONCILIABLE = @p_CODRAZON_NO_CONCILIABLE,
            ESTADO_SC = @p_ESTADO_SC,
            TIPOTRANSACCION_SC = @p_TIPOTRANSACCION_SC,
            CODCON_CONTROL_PROC = @p_CODCON_CONTROL_PROC,
            FECHA_ARCHIVO = @p_FECHA_ARCHIVO,
            SPRN_Y_BUS_DATE = @p_SPRN_Y_BUS_DATE
    WHERE ID_ENTRADACONCILIAGTK = @pk_ID_ENTRADACONCILIAGTK;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
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

-- Deletes a record from the ENTRADACONCILIAGTK table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_DeleteRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_DeleteRecord(
    @pk_ID_ENTRADACONCILIAGTK NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE SFG_CONCILIACION.ENTRADACONCILIAGTK
    WHERE ID_ENTRADACONCILIAGTK = @pk_ID_ENTRADACONCILIAGTK;
END;
GO

-- Deletes the set of rows from the ENTRADACONCILIAGTK table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_DeleteRecords;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_DeleteRecords(
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
'DELETE SFG_CONCILIACION.ENTRADACONCILIAGTK' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the ENTRADACONCILIAGTK table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_GetRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_GetRecord(
   @pk_ID_ENTRADACONCILIAGTK NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure 
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM SFG_CONCILIACION.ENTRADACONCILIAGTK
    WHERE ID_ENTRADACONCILIAGTK = @pk_ID_ENTRADACONCILIAGTK;

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
        ID_ENTRADACONCILIAGTK,
        CODREGISTROFACTREFERENCIA,
        CONCILIADO_CON,
        BUS_DATE,
        RCPT_NMR,
        AMOUNT,
        ANSWER_CODE,
        ARRN,
        ESTADO_CONCILIA,
        CONCILIABLE,
        FECHA_HORA_TRANS,
        BUS_DATE_MODIFICADO,
        CODRAZON_NO_CONCILIABLE,
        ESTADO_SC,
        TIPOTRANSACCION_SC,
        CODCON_CONTROL_PROC,
        FECHA_ARCHIVO,
        SPRN_Y_BUS_DATE
    FROM SFG_CONCILIACION.ENTRADACONCILIAGTK
    WHERE ID_ENTRADACONCILIAGTK = @pk_ID_ENTRADACONCILIAGTK;  
END;
GO

-- Returns a query resultset from table ENTRADACONCILIAGTK
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
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_GetList', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_GetList;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_GetList(
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
    SET @l_from_str = 'SFG_CONCILIACION.ENTRADACONCILIAGTK ENTRADACONCILIAGTK_';
    SET @l_alias_str = 'ENTRADACONCILIAGTK_';

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
        'ENTRADACONCILIAGTK_.ID_ENTRADACONCILIAGTK,
            ENTRADACONCILIAGTK_.CODREGISTROFACTREFERENCIA,
            ENTRADACONCILIAGTK_.CONCILIADO_CON,
            ENTRADACONCILIAGTK_.BUS_DATE,
            ENTRADACONCILIAGTK_.RCPT_NMR,
            ENTRADACONCILIAGTK_.AMOUNT,
            ENTRADACONCILIAGTK_.ANSWER_CODE,
            ENTRADACONCILIAGTK_.ARRN,
            ENTRADACONCILIAGTK_.ESTADO_CONCILIA,
            ENTRADACONCILIAGTK_.CONCILIABLE,
            ENTRADACONCILIAGTK_.FECHA_HORA_TRANS,
            ENTRADACONCILIAGTK_.BUS_DATE_MODIFICADO,
            ENTRADACONCILIAGTK_.CODRAZON_NO_CONCILIABLE,
            ENTRADACONCILIAGTK_.ESTADO_SC,
            ENTRADACONCILIAGTK_.TIPOTRANSACCION_SC,
            ENTRADACONCILIAGTK_.CODCON_CONTROL_PROC,
            ENTRADACONCILIAGTK_.FECHA_ARCHIVO,
            ENTRADACONCILIAGTK_.SPRN_Y_BUS_DATE';
    
    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY ENTRADACONCILIAGTK_.ID_ENTRADACONCILIAGTK ASC ';

        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        -- Run the query
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
            'FROM ( SELECT ' +
                isnull(@l_query_cols, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
                    isnull(@l_query_cols, '') + ' ' +
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
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table ENTRADACONCILIAGTK
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_DrillDown;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_DrillDown(
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
    SET @l_from_str = 'SFG_CONCILIACION.ENTRADACONCILIAGTK ENTRADACONCILIAGTK_';
    SET @l_alias_str = 'ENTRADACONCILIAGTK_';

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

-- Returns a query result from table ENTRADACONCILIAGTK
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_GetStats;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_GetStats(
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

    SET @l_from_str = 'SFG_CONCILIACION.ENTRADACONCILIAGTK ENTRADACONCILIAGTK_';
    SET @l_alias_str = 'ENTRADACONCILIAGTK_';

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
        'SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_Export', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_Export;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIAGTK_Export(
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
                '''XID_ENTRADACONCILIAGTK' + isnull(@p_separator_str, '') +
                'CODREGISTROFACTREFERENCIA' + isnull(@p_separator_str, '') +
                'CODREGISTROFACTREFERENCIA ESTADO' + isnull(@p_separator_str, '') +
                'CONCILIADO_CON' + isnull(@p_separator_str, '') +
                'BUS_DATE' + isnull(@p_separator_str, '') +
                'RCPT_NMR' + isnull(@p_separator_str, '') +
                'AMOUNT' + isnull(@p_separator_str, '') +
                'ANSWER_CODE' + isnull(@p_separator_str, '') +
                'ARRN' + isnull(@p_separator_str, '') +
                'ESTADO_CONCILIA' + isnull(@p_separator_str, '') +
                'ESTADO_CONCILIA NOMESTADO_CONCILIA' + isnull(@p_separator_str, '') +
                'CONCILIABLE' + isnull(@p_separator_str, '') +
                'FECHA_HORA_TRANS' + isnull(@p_separator_str, '') +
                'BUS_DATE_MODIFICADO' + isnull(@p_separator_str, '') +
                'CODRAZON_NO_CONCILIABLE' + isnull(@p_separator_str, '') +
                'CODRAZON_NO_CONCILIABLE NOMRAZON_NO_CONCILIABLE' + isnull(@p_separator_str, '') +
                'ESTADO_SC' + isnull(@p_separator_str, '') +
                'TIPOTRANSACCION_SC' + isnull(@p_separator_str, '') +
                'CODCON_CONTROL_PROC' + isnull(@p_separator_str, '') +
                'CODCON_CONTROL_PROC COD_TIPOCONCILIA' + isnull(@p_separator_str, '') +
                'FECHA_ARCHIVO' + isnull(@p_separator_str, '') +
                'SPRN_Y_BUS_DATE' + ' ''';
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
                ' isnull(CAST(ENTRADACONCILIAGTK_.ID_ENTRADACONCILIAGTK AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(ENTRADACONCILIAGTK_.CODREGISTROFACTREFERENCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.ESTADO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIAGTK_.CONCILIADO_CON, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIAGTK_.BUS_DATE, ''mm/dd/yyyy hh24:mi'', '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIAGTK_.RCPT_NMR, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIAGTK_.AMOUNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(ENTRADACONCILIAGTK_.ANSWER_CODE) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIAGTK_.ARRN, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIAGTK_.ESTADO_CONCILIA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMESTADO_CONCILIA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIAGTK_.CONCILIABLE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(dbo.ConvertFecha(ENTRADACONCILIAGTK_.FECHA_HORA_TRANS), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIAGTK_.BUS_DATE_MODIFICADO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(ENTRADACONCILIAGTK_.CODRAZON_NO_CONCILIABLE AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMRAZON_NO_CONCILIABLE, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIAGTK_.ESTADO_SC, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIAGTK_.TIPOTRANSACCION_SC, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(ENTRADACONCILIAGTK_.CODCON_CONTROL_PROC AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t3.COD_TIPOCONCILIA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(dbo.ConvertFecha(ENTRADACONCILIAGTK_.FECHA_ARCHIVO), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIAGTK_.SPRN_Y_BUS_DATE, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'SFG_CONCILIACION.ENTRADACONCILIAGTK ENTRADACONCILIAGTK_ LEFT OUTER JOIN SFG_CONCILIACION.REGISTROFACTREFERENCIA t0 ON (ENTRADACONCILIAGTK_.CODREGISTROFACTREFERENCIA =  t0.ID_REGISTROFACTREFERENCIA) LEFT OUTER JOIN SFG_CONCILIACION.CON_ESTADO_CONCILIA t1 ON (ENTRADACONCILIAGTK_.ESTADO_CONCILIA =  t1.ID_ESTADO_CONCILIA) LEFT OUTER JOIN SFG_CONCILIACION.CON_RAZON_NO_CONCILIABLE t2 ON (ENTRADACONCILIAGTK_.CODRAZON_NO_CONCILIABLE =  t2.ID_RAZON_NO_CONCILIABLE) LEFT OUTER JOIN SFG_CONCILIACION.CON_CONTROL_PROC_CONCIL t3 ON (ENTRADACONCILIAGTK_.CODCON_CONTROL_PROC =  t3.ID_CON_CONTROL_PROC)';

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






