USE SFGPRODU;
--  DDL for Package Body SFGCONCIWEBCOM_CADENA_DESCONTA
--------------------------------------------------------

  /* PACKAGE BODY SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA */ 

-- Creates a new record in the COM_CADENA_DESCONTAR table
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_AddRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_AddRecord(
    @p_COD_REGISTROFACTURACION NUMERIC(22,0),
    @p_CODPUNTODEVENTA NUMERIC(22,0),
    @p_COD_ALIADO NUMERIC(22,0),
    @p_COD_PRODUCTO NUMERIC(22,0),
    @p_CODTIPOREGISTRO NUMERIC(22,0),
    @p_FECHA_VENCIMIENTO DATETIME,
    @p_VALOR_TX NUMERIC(22,0),
    @p_CANTIDAD_TX NUMERIC(22,0),
    @p_DEBE_HABER VARCHAR(4000),
    @p_FECHA_RECAUDO DATETIME,
    @p_ID_CADENA_DESCONTAR_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO SFG_CONCILIACION.COM_CADENA_DESCONTAR
        (
            COD_REGISTROFACTURACION,
            CODPUNTODEVENTA,
            COD_ALIADO,
            COD_PRODUCTO,
            CODTIPOREGISTRO,
            FECHA_VENCIMIENTO,
            VALOR_TX,
            CANTIDAD_TX,
            DEBE_HABER,
            FECHA_RECAUDO
        )
    VALUES
        (
            @p_COD_REGISTROFACTURACION,
            @p_CODPUNTODEVENTA,
            @p_COD_ALIADO,
            @p_COD_PRODUCTO,
            @p_CODTIPOREGISTRO,
            @p_FECHA_VENCIMIENTO,
            @p_VALOR_TX,
            @p_CANTIDAD_TX,
            @p_DEBE_HABER,
            @p_FECHA_RECAUDO
        );
       SET
            @p_ID_CADENA_DESCONTAR_out = SCOPE_IDENTITY() ;

END;
GO

-- Updates a record in the COM_CADENA_DESCONTAR table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_UpdateRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_UpdateRecord(
    @pk_ID_CADENA_DESCONTAR NUMERIC(22,0),
    @p_COD_REGISTROFACTURACION NUMERIC(22,0),
    @p_CODPUNTODEVENTA NUMERIC(22,0),
    @p_COD_ALIADO NUMERIC(22,0),
    @p_COD_PRODUCTO NUMERIC(22,0),
    @p_CODTIPOREGISTRO NUMERIC(22,0),
    @p_FECHA_VENCIMIENTO DATETIME,
    @p_VALOR_TX NUMERIC(22,0),
    @p_CANTIDAD_TX NUMERIC(22,0),
    @p_DEBE_HABER VARCHAR(4000),
    @p_FECHA_RECAUDO DATETIME
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE SFG_CONCILIACION.COM_CADENA_DESCONTAR
    SET 
            COD_REGISTROFACTURACION = @p_COD_REGISTROFACTURACION,
            CODPUNTODEVENTA = @p_CODPUNTODEVENTA,
            COD_ALIADO = @p_COD_ALIADO,
            COD_PRODUCTO = @p_COD_PRODUCTO,
            CODTIPOREGISTRO = @p_CODTIPOREGISTRO,
            FECHA_VENCIMIENTO = @p_FECHA_VENCIMIENTO,
            VALOR_TX = @p_VALOR_TX,
            CANTIDAD_TX = @p_CANTIDAD_TX,
            DEBE_HABER = @p_DEBE_HABER,
            FECHA_RECAUDO = @p_FECHA_RECAUDO
    WHERE ID_CADENA_DESCONTAR = @pk_ID_CADENA_DESCONTAR;

    -- Make sure only one record is affected
    IF @@rowcount = 0
    BEGIN
        RAISERROR ('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1
    BEGIN
        RAISERROR ('-20053 Duplicate object instances.', 16, 1);
    END 

END;
GO

-- Deletes a record from the COM_CADENA_DESCONTAR table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_DeleteRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_DeleteRecord(
    @pk_ID_CADENA_DESCONTAR NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE SFG_CONCILIACION.COM_CADENA_DESCONTAR
    WHERE ID_CADENA_DESCONTAR = @pk_ID_CADENA_DESCONTAR;
END;
GO

-- Deletes the set of rows from the COM_CADENA_DESCONTAR table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_DeleteRecords;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_DeleteRecords(
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
'DELETE SFG_CONCILIACION.COM_CADENA_DESCONTAR' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the COM_CADENA_DESCONTAR table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_GetRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_GetRecord(
   @pk_ID_CADENA_DESCONTAR NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure 
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM SFG_CONCILIACION.COM_CADENA_DESCONTAR
    WHERE ID_CADENA_DESCONTAR = @pk_ID_CADENA_DESCONTAR;

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
        ID_CADENA_DESCONTAR,
        COD_REGISTROFACTURACION,
        CODPUNTODEVENTA,
        COD_ALIADO,
        COD_PRODUCTO,
        CODTIPOREGISTRO,
        FECHA_VENCIMIENTO,
        VALOR_TX,
        CANTIDAD_TX,
        DEBE_HABER,
        FECHA_RECAUDO
    FROM SFG_CONCILIACION.COM_CADENA_DESCONTAR
    WHERE ID_CADENA_DESCONTAR = @pk_ID_CADENA_DESCONTAR;  
END;
GO

-- Returns a query resultset from table COM_CADENA_DESCONTAR
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
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_GetList;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_GetList(
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
    SET @l_from_str = 'SFG_CONCILIACION.COM_CADENA_DESCONTAR COM_CADENA_DESCONTAR_';
    SET @l_alias_str = 'COM_CADENA_DESCONTAR_';

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
        'COM_CADENA_DESCONTAR_.ID_CADENA_DESCONTAR,
            COM_CADENA_DESCONTAR_.COD_REGISTROFACTURACION,
            COM_CADENA_DESCONTAR_.CODPUNTODEVENTA,
            COM_CADENA_DESCONTAR_.COD_ALIADO,
            COM_CADENA_DESCONTAR_.COD_PRODUCTO,
            COM_CADENA_DESCONTAR_.CODTIPOREGISTRO,
            COM_CADENA_DESCONTAR_.FECHA_VENCIMIENTO,
            COM_CADENA_DESCONTAR_.VALOR_TX,
            COM_CADENA_DESCONTAR_.CANTIDAD_TX,
            COM_CADENA_DESCONTAR_.DEBE_HABER,
            COM_CADENA_DESCONTAR_.FECHA_RECAUDO';
    
    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY COM_CADENA_DESCONTAR_.ID_CADENA_DESCONTAR ASC ';

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

-- Returns a query result from table COM_CADENA_DESCONTAR
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_DrillDown;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_DrillDown(
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
    SET @l_from_str = 'SFG_CONCILIACION.COM_CADENA_DESCONTAR COM_CADENA_DESCONTAR_';
    SET @l_alias_str = 'COM_CADENA_DESCONTAR_';

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

-- Returns a query result from table COM_CADENA_DESCONTAR
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_GetStats;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_GetStats(
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

    SET @l_from_str = 'SFG_CONCILIACION.COM_CADENA_DESCONTAR COM_CADENA_DESCONTAR_';
    SET @l_alias_str = 'COM_CADENA_DESCONTAR_';

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
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_Export', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_Export;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCOM_CADENA_DESCONTA_Export(
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
                '''XID_CADENA_DESCONTAR' + isnull(@p_separator_str, '') +
                'COD_REGISTROFACTURACION' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'COD_ALIADO' + isnull(@p_separator_str, '') +
                'COD_ALIADO NOMALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                'COD_PRODUCTO' + isnull(@p_separator_str, '') +
                'CODTIPOREGISTRO' + isnull(@p_separator_str, '') +
                'CODTIPOREGISTRO NOMTIPOREGISTRO' + isnull(@p_separator_str, '') +
                'FECHA_VENCIMIENTO' + isnull(@p_separator_str, '') +
                'VALOR_TX' + isnull(@p_separator_str, '') +
                'CANTIDAD_TX' + isnull(@p_separator_str, '') +
                'DEBE_HABER' + isnull(@p_separator_str, '') +
                'FECHA_RECAUDO' + ' ''';
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
                ' isnull(CAST(COM_CADENA_DESCONTAR_.ID_CADENA_DESCONTAR AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(COM_CADENA_DESCONTAR_.COD_REGISTROFACTURACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(COM_CADENA_DESCONTAR_.CODPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t0.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(COM_CADENA_DESCONTAR_.COD_ALIADO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMALIADOESTRATEGICO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(COM_CADENA_DESCONTAR_.COD_PRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(COM_CADENA_DESCONTAR_.CODTIPOREGISTRO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMTIPOREGISTRO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(dbo.ConvertFecha(COM_CADENA_DESCONTAR_.FECHA_VENCIMIENTO), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(COM_CADENA_DESCONTAR_.VALOR_TX, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(COM_CADENA_DESCONTAR_.CANTIDAD_TX AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(COM_CADENA_DESCONTAR_.DEBE_HABER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(dbo.ConvertFecha(COM_CADENA_DESCONTAR_.FECHA_RECAUDO), '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'SFG_CONCILIACION.COM_CADENA_DESCONTAR COM_CADENA_DESCONTAR_ LEFT OUTER JOIN SFG_CONCILIACION.PUNTODEVENTA t0 ON (COM_CADENA_DESCONTAR_.CODPUNTODEVENTA =  t0.ID_PUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.ALIADOESTRATEGICO t1 ON (COM_CADENA_DESCONTAR_.COD_ALIADO =  t1.ID_ALIADOESTRATEGICO) LEFT OUTER JOIN SFG_CONCILIACION.TIPOREGISTRO t2 ON (COM_CADENA_DESCONTAR_.CODTIPOREGISTRO =  t2.ID_TIPOREGISTRO)';

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






