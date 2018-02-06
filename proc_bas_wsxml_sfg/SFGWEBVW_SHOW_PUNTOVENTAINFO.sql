USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_SHOW_PUNTOVENTAINFO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO */ 


-- Deletes a record from the VW_SHOW_PUNTOVENTAINFO table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_DeleteRecord(
    @pk_ID_PUNTODEVENTA NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.VW_SHOW_PUNTOVENTAINFO
    WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;
END;
GO

-- Deletes the set of rows from the VW_SHOW_PUNTOVENTAINFO table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_DeleteRecords(
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
'DELETE WSXML_SFG.VW_SHOW_PUNTOVENTAINFO' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the VW_SHOW_PUNTOVENTAINFO table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_GetRecord(
   @pk_ID_PUNTODEVENTA NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.VW_SHOW_PUNTOVENTAINFO
    WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;

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
        ID_PUNTODEVENTA,
        CODIGOGTECHPUNTODEVENTA,
        NUMEROTERMINAL,
        NOMPUNTODEVENTA,
        CODCIUDAD,
        CODDEPARTAMENTO,
        CODTIPONEGOCIO,
        CODRUTAPDV,
        CODFMR,
        CODREDPDV,
        CODREGIONAL,
        CODJEFEDISTRITO,
        CODESTADOPDV,
        NUMEROCONTRATO,
        NOMBREORAZONSOCIAL,
        IDENTIFICACION,
        DIGITOVERIFICACION,
        TELEFONOCONTACTO,
        DIRECCIONCONTACTO,
        NOMBRECONTACTO,
        EMAILCONTACTO,
        FECHAINSTALACION,
        CODCIUDADCONTACTO,
        CODREGIMEN,
        NOMBREREPRESENTANTELEGAL,
        IDENTIFICACIONREPLEG,
        CODAGRUPACIONPUNTODEVENTA,
        CODIGOAGRUPACIONGTECH,
        CODTIPOPUNTODEVENTA,
        ACTIVE,
        CABEZACADENA
    FROM WSXML_SFG.VW_SHOW_PUNTOVENTAINFO
    WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;  
END;
GO

-- Returns a query resultset from table VW_SHOW_PUNTOVENTAINFO
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOW_PUNTOVENTAINFO VW_SHOW_PUNTOVENTAINFO_';
    SET @l_alias_str = 'VW_SHOW_PUNTOVENTAINFO_';

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
         IF @l_where_str <> 'WHERE (1 = 2)' BEGIN
          EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
          @p_total_size output;
        END
        ELSE BEGIN
           SET @p_total_size=1;
        END 
    END 

    -- Set up column name variable(s)
    SET @l_query_cols =
        'VW_SHOW_PUNTOVENTAINFO_.ID_PUNTODEVENTA,
            VW_SHOW_PUNTOVENTAINFO_.CODIGOGTECHPUNTODEVENTA,
            VW_SHOW_PUNTOVENTAINFO_.NUMEROTERMINAL,
            VW_SHOW_PUNTOVENTAINFO_.NOMPUNTODEVENTA,
            VW_SHOW_PUNTOVENTAINFO_.CODCIUDAD,
            VW_SHOW_PUNTOVENTAINFO_.CODDEPARTAMENTO,
            VW_SHOW_PUNTOVENTAINFO_.CODTIPONEGOCIO,
            VW_SHOW_PUNTOVENTAINFO_.CODRUTAPDV,
            VW_SHOW_PUNTOVENTAINFO_.CODFMR,
            VW_SHOW_PUNTOVENTAINFO_.CODREDPDV,
            VW_SHOW_PUNTOVENTAINFO_.CODREGIONAL,
            VW_SHOW_PUNTOVENTAINFO_.CODJEFEDISTRITO,
            VW_SHOW_PUNTOVENTAINFO_.CODESTADOPDV,
            VW_SHOW_PUNTOVENTAINFO_.NUMEROCONTRATO,
            VW_SHOW_PUNTOVENTAINFO_.NOMBREORAZONSOCIAL,
            VW_SHOW_PUNTOVENTAINFO_.IDENTIFICACION,
            VW_SHOW_PUNTOVENTAINFO_.DIGITOVERIFICACION,
            VW_SHOW_PUNTOVENTAINFO_.TELEFONOCONTACTO,
            VW_SHOW_PUNTOVENTAINFO_.DIRECCIONCONTACTO,
            VW_SHOW_PUNTOVENTAINFO_.NOMBRECONTACTO,
            VW_SHOW_PUNTOVENTAINFO_.EMAILCONTACTO,
            VW_SHOW_PUNTOVENTAINFO_.FECHAINSTALACION,
            VW_SHOW_PUNTOVENTAINFO_.CODCIUDADCONTACTO,
            VW_SHOW_PUNTOVENTAINFO_.CODREGIMEN,
            VW_SHOW_PUNTOVENTAINFO_.NOMBREREPRESENTANTELEGAL,
            VW_SHOW_PUNTOVENTAINFO_.IDENTIFICACIONREPLEG,
            VW_SHOW_PUNTOVENTAINFO_.CODAGRUPACIONPUNTODEVENTA,
            VW_SHOW_PUNTOVENTAINFO_.CODIGOAGRUPACIONGTECH,
            VW_SHOW_PUNTOVENTAINFO_.CODTIPOPUNTODEVENTA,
            VW_SHOW_PUNTOVENTAINFO_.ACTIVE,
            VW_SHOW_PUNTOVENTAINFO_.CABEZACADENA';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY VW_SHOW_PUNTOVENTAINFO_.ID_PUNTODEVENTA ASC ';

        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        -- Run the query
        IF @l_where_str <> 'WHERE (1 = 2)' BEGIN
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
            SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE ID_PUNTODEVENTA=0';
            EXECUTE sp_executesql @sql;
          END 
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        'SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE ID_PUNTODEVENTA = 0';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table VW_SHOW_PUNTOVENTAINFO
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOW_PUNTOVENTAINFO VW_SHOW_PUNTOVENTAINFO_';
    SET @l_alias_str = 'VW_SHOW_PUNTOVENTAINFO_';

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

-- Returns a query result from table VW_SHOW_PUNTOVENTAINFO
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_SHOW_PUNTOVENTAINFO VW_SHOW_PUNTOVENTAINFO_';
    SET @l_alias_str = 'VW_SHOW_PUNTOVENTAINFO_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PUNTOVENTAINFO_Export(
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
                '''XID_PUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'NUMEROTERMINAL' + isnull(@p_separator_str, '') +
                'NOMPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODCIUDAD' + isnull(@p_separator_str, '') +
                'CODCIUDAD NOMCIUDAD' + isnull(@p_separator_str, '') +
                'CODDEPARTAMENTO' + isnull(@p_separator_str, '') +
                'CODDEPARTAMENTO NOMDEPARTAMENTO' + isnull(@p_separator_str, '') +
                'CODTIPONEGOCIO' + isnull(@p_separator_str, '') +
                'CODTIPONEGOCIO NOMTIPONEGOCIO' + isnull(@p_separator_str, '') +
                'CODRUTAPDV' + isnull(@p_separator_str, '') +
                'CODRUTAPDV NOMRUTAPDV' + isnull(@p_separator_str, '') +
                'CODFMR' + isnull(@p_separator_str, '') +
                'CODFMR NOMBRE' + isnull(@p_separator_str, '') +
                'CODREDPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV NOMREDPDV' + isnull(@p_separator_str, '') +
                'CODREGIONAL' + isnull(@p_separator_str, '') +
                'CODREGIONAL NOMREGIONAL' + isnull(@p_separator_str, '') +
                'CODJEFEDISTRITO' + isnull(@p_separator_str, '') +
                'CODJEFEDISTRITO NOMBRE' + isnull(@p_separator_str, '') +
                'CODESTADOPDV' + isnull(@p_separator_str, '') +
                'CODESTADOPDV NOMESTADOPDV' + isnull(@p_separator_str, '') +
                'NUMEROCONTRATO' + isnull(@p_separator_str, '') +
                'NOMBREORAZONSOCIAL' + isnull(@p_separator_str, '') +
                'IDENTIFICACION' + isnull(@p_separator_str, '') +
                'DIGITOVERIFICACION' + isnull(@p_separator_str, '') +
                'TELEFONOCONTACTO' + isnull(@p_separator_str, '') +
                'DIRECCIONCONTACTO' + isnull(@p_separator_str, '') +
                'NOMBRECONTACTO' + isnull(@p_separator_str, '') +
                'EMAILCONTACTO' + isnull(@p_separator_str, '') +
                'FECHAINSTALACION' + isnull(@p_separator_str, '') +
                'CODCIUDADCONTACTO' + isnull(@p_separator_str, '') +
                'CODCIUDADCONTACTO NOMCIUDAD' + isnull(@p_separator_str, '') +
                'CODREGIMEN' + isnull(@p_separator_str, '') +
                'CODREGIMEN NOMREGIMEN' + isnull(@p_separator_str, '') +
                'NOMBREREPRESENTANTELEGAL' + isnull(@p_separator_str, '') +
                'IDENTIFICACIONREPLEG' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODIGOAGRUPACIONGTECH' + isnull(@p_separator_str, '') +
                'CODTIPOPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODTIPOPUNTODEVENTA NOMTIPOPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'ACTIVE' + isnull(@p_separator_str, '') +
                'CABEZACADENA' + ' ''';
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
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.ID_PUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOW_PUNTOVENTAINFO_.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOW_PUNTOVENTAINFO_.NUMEROTERMINAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOW_PUNTOVENTAINFO_.NOMPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODCIUDAD AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMCIUDAD, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODDEPARTAMENTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMDEPARTAMENTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODTIPONEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMTIPONEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODRUTAPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMRUTAPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODFMR AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t4.NOMBRE, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODREDPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t5.NOMREDPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODREGIONAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t6.NOMREGIONAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODJEFEDISTRITO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t7.NOMBRE, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODESTADOPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t8.NOMESTADOPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOW_PUNTOVENTAINFO_.NUMEROCONTRATO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOW_PUNTOVENTAINFO_.NOMBREORAZONSOCIAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.IDENTIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PUNTOVENTAINFO_.DIGITOVERIFICACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOW_PUNTOVENTAINFO_.TELEFONOCONTACTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOW_PUNTOVENTAINFO_.DIRECCIONCONTACTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOW_PUNTOVENTAINFO_.NOMBRECONTACTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOW_PUNTOVENTAINFO_.EMAILCONTACTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(VW_SHOW_PUNTOVENTAINFO_.FECHAINSTALACION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODCIUDADCONTACTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t9.NOMCIUDAD, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODREGIMEN AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t10.NOMREGIMEN, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOW_PUNTOVENTAINFO_.NOMBREREPRESENTANTELEGAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOW_PUNTOVENTAINFO_.IDENTIFICACIONREPLEG) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODAGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t11.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOW_PUNTOVENTAINFO_.CODIGOAGRUPACIONGTECH) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PUNTOVENTAINFO_.CODTIPOPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t12.NOMTIPOPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PUNTOVENTAINFO_.ACTIVE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PUNTOVENTAINFO_.CABEZACADENA, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_SHOW_PUNTOVENTAINFO VW_SHOW_PUNTOVENTAINFO_ LEFT OUTER JOIN WSXML_SFG.CIUDAD t0 ON (VW_SHOW_PUNTOVENTAINFO_.CODCIUDAD =  t0.ID_CIUDAD) LEFT OUTER JOIN WSXML_SFG.DEPARTAMENTO t1 ON (VW_SHOW_PUNTOVENTAINFO_.CODDEPARTAMENTO =  t1.ID_DEPARTAMENTO) LEFT OUTER JOIN WSXML_SFG.TIPONEGOCIO t2 ON (VW_SHOW_PUNTOVENTAINFO_.CODTIPONEGOCIO =  t2.ID_TIPONEGOCIO) LEFT OUTER JOIN WSXML_SFG.RUTAPDV t3 ON (VW_SHOW_PUNTOVENTAINFO_.CODRUTAPDV =  t3.ID_RUTAPDV) LEFT OUTER JOIN WSXML_SFG.USUARIO t4 ON (VW_SHOW_PUNTOVENTAINFO_.CODFMR =  t4.ID_USUARIO) LEFT OUTER JOIN WSXML_SFG.REDPDV t5 ON (VW_SHOW_PUNTOVENTAINFO_.CODREDPDV =  t5.ID_REDPDV) LEFT OUTER JOIN WSXML_SFG.REGIONAL t6 ON (VW_SHOW_PUNTOVENTAINFO_.CODREGIONAL =  t6.ID_REGIONAL) LEFT OUTER JOIN WSXML_SFG.USUARIO t7 ON (VW_SHOW_PUNTOVENTAINFO_.CODJEFEDISTRITO =  t7.ID_USUARIO) LEFT OUTER JOIN WSXML_SFG.ESTADOPDV t8 ON (VW_SHOW_PUNTOVENTAINFO_.CODESTADOPDV =  t8.ID_ESTADOPDV) LEFT OUTER JOIN WSXML_SFG.CIUDAD t9 ON (VW_SHOW_PUNTOVENTAINFO_.CODCIUDADCONTACTO =  t9.ID_CIUDAD) LEFT OUTER JOIN WSXML_SFG.REGIMEN t10 ON (VW_SHOW_PUNTOVENTAINFO_.CODREGIMEN =  t10.ID_REGIMEN) LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA t11 ON (VW_SHOW_PUNTOVENTAINFO_.CODAGRUPACIONPUNTODEVENTA =  t11.ID_AGRUPACIONPUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.TIPOPUNTODEVENTA t12 ON (VW_SHOW_PUNTOVENTAINFO_.CODTIPOPUNTODEVENTA =  t12.ID_TIPOPUNTODEVENTA)';

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

