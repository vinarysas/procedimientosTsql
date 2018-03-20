USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_LIQINDEPPRODVA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA */ 

-- Creates a new record in the VW_LIQINDEPPRODUCTOVALOR table
-- Creates a new record in the VW_LIQINDEPPRODUCTOVALOR table
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_AddRecord(
    @p_ID_LIQ_INDEPENDIENTE NUMERIC(22,0),
    @p_nombre  NVARCHAR(2000),
    @p_valor_ventas  NUMERIC(22,0),
    @p_valor_anulaciones NUMERIC(22,0),
    @p_NETO_VOL_GIROS NUMERIC(22,0),
    @p_valor_flete NUMERIC(22,0),
    @p_REVENUE_AJUSTES NUMERIC(22,0),
    @p_TOTAL_INGRESO NUMERIC(22,0),
    @p_TOTALAPAGAR NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.VW_LIQINDEPPRODUCTOVAL
        (
            ID_LIQ_INDEPENDIENTE,
            NOMBRE,
            VALOR_VENTAS,
            VALOR_ANULACIONES,
            NETO_VOL_GIROS,
            VALOR_FLETE,
            REVENUE_AJUSTES,
            TOTAL_INGRESO,
            TOTALAPAGAR
        )
    VALUES
        (
            @p_ID_LIQ_INDEPENDIENTE,
            @p_nombre,
            @p_valor_ventas,
            @p_valor_anulaciones,
            @p_NETO_VOL_GIROS,
            @p_valor_flete,
            @p_REVENUE_AJUSTES,
            @p_TOTAL_INGRESO,
            @p_TOTALAPAGAR
        );

END;
GO

-- Updates a record in the VW_LIQINDEPPRODUCTOVALOR table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_UpdateRecord(
        @pk_ID_LIQ_INDEPENDIENTE NUMERIC(22,0),
        @p_ID_LIQ_INDEPENDIENTE NUMERIC(22,0),
        @p_nombre  NVARCHAR(2000),
        @p_valor_ventas  NUMERIC(22,0),
        @p_valor_anulaciones NUMERIC(22,0),
        @p_NETO_VOL_GIROS NUMERIC(22,0),
        @p_valor_flete NUMERIC(22,0),
        @p_REVENUE_AJUSTES NUMERIC(22,0),
        @p_TOTAL_INGRESO NUMERIC(22,0),
        @p_TOTALAPAGAR NUMERIC(22,0)
        )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.VW_LIQINDEPPRODUCTOVAL
    SET
            ID_LIQ_INDEPENDIENTE = @p_ID_LIQ_INDEPENDIENTE,
            NOMBRE = @p_nombre,
            VALOR_VENTAS = @p_valor_ventas,
            VALOR_ANULACIONES = @p_valor_anulaciones,
            NETO_VOL_GIROS = @p_NETO_VOL_GIROS,
            VALOR_FLETE = @p_valor_flete,
            REVENUE_AJUSTES = @p_REVENUE_AJUSTES,
            TOTAL_INGRESO = @p_TOTAL_INGRESO,
            TOTALAPAGAR = @p_TOTALAPAGAR
    WHERE ID_LIQ_INDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE;

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

-- Deletes a record from the VW_LIQINDEPPRODUCTOVALOR table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_DeleteRecord(
    @pk_ID_LIQ_INDEPENDIENTE NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.VW_LIQINDEPPRODUCTOVAL
    WHERE ID_LIQ_INDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE;
END;
GO

-- Deletes the set of rows from the VW_LIQINDEPPRODUCTOVALOR table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_DeleteRecords(
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
'DELETE WSXML_SFG.VW_LIQINDEPPRODUCTOVAL' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the VW_LIQINDEPPRODUCTOVALOR table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_GetRecord(
   @pk_ID_LIQ_INDEPENDIENTE NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.VW_LIQINDEPPRODUCTOVAL
    WHERE ID_LIQ_INDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE;

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
       SELECT  ID_LIQ_INDEPENDIENTE,
            NOMBRE,
            VALOR_VENTAS,
            VALOR_ANULACIONES,
            NETO_VOL_GIROS,
            VALOR_FLETE,
            REVENUE_AJUSTES,
            TOTAL_INGRESO,
            TOTALAPAGAR
    FROM WSXML_SFG.VW_LIQINDEPPRODUCTOVAL
    WHERE ID_LIQ_INDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE;
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_LIQINDEPPRODUCTOVAL VW_LIQINDEPPRODUCTOVAL_';
    SET @l_alias_str = 'VW_LIQINDEPPRODUCTOVAL_';

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
       'VW_LIQINDEPPRODUCTOVAL_.ID_LIQ_INDEPENDIENTE,
        VW_LIQINDEPPRODUCTOVAL_.NOMBRE,
        VW_LIQINDEPPRODUCTOVAL_.VALOR_VENTAS,
        VW_LIQINDEPPRODUCTOVAL_.VALOR_ANULACIONES,
        VW_LIQINDEPPRODUCTOVAL_.NETO_VOL_GIROS,
        VW_LIQINDEPPRODUCTOVAL_.VALOR_FLETE,
        VW_LIQINDEPPRODUCTOVAL_.REVENUE_AJUSTES,
        VW_LIQINDEPPRODUCTOVAL_.TOTAL_INGRESO,
        VW_LIQINDEPPRODUCTOVAL_.TOTALAPAGAR';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY VW_LIQINDEPPRODUCTOVAL_.ID_LIQ_INDEPENDIENTE ASC ';

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

-- Returns a query result from table VW_LIQINDEPPRODUCTOVALOR
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_LIQINDEPPRODUCTOVAL VW_LIQINDEPPRODUCTOVAL_';
    SET @l_alias_str = 'VW_LIQINDEPPRODUCTOVAL_';

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

-- Returns a query result from table VW_LIQINDEPPRODUCTOVALOR
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_LIQINDEPPRODUCTOVAL VW_LIQINDEPPRODUCTOVAL_';
    SET @l_alias_str = 'VW_LIQINDEPPRODUCTOVAL_';

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
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_LIQINDEPPRODVA_Export(
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



                'XID_LIQ_INDEPENDIENTE' + isnull(@p_separator_str, '') +
                'NOMBRE ' + isnull(@p_separator_str, '') +
                'VALOR_VENTAS' + isnull(@p_separator_str, '') +
                'VALOR_ANULACIONES' + isnull(@p_separator_str, '') +
                'NETO_VOL_GIROS' + isnull(@p_separator_str, '') +
                'VALOR_FLETE' + isnull(@p_separator_str, '') +
                'REVENUE_AJUSTES' + isnull(@p_separator_str, '') +
                'TOTAL_INGRESO' + isnull(@p_separator_str, '') +
                'TOTALAPAGAR' + ' ';
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
                ' isnull(CAST(VW_LIQINDEPPRODUCTOVAL_.ID_LIQ_INDEPENDIENTE AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_LIQINDEPPRODUCTOVAL_.NOMBRE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_LIQINDEPPRODUCTOVAL_.VALOR_VENTAS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_LIQINDEPPRODUCTOVAL_.VALOR_ANULACIONES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_LIQINDEPPRODUCTOVAL_.NETO_VOL_GIROS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_LIQINDEPPRODUCTOVAL_.VALOR_FLETE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_LIQINDEPPRODUCTOVAL_.REVENUE_AJUSTES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_LIQINDEPPRODUCTOVAL_.TOTAL_INGRESO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_LIQINDEPPRODUCTOVAL_.TOTALAPAGAR, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_LIQINDEPPRODUCTOVAL VW_LIQINDEPPRODUCTOVAL_';

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
            'SELECT ''';
    SET @l_query_union =
            ''' FROM DUAL UNION ALL ' +
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






