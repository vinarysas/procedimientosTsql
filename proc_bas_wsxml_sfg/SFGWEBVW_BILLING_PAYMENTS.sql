USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_BILLING_PAYMENTS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS */ 

-- Creates a new record in the VW_BILLING_PAYMENTS table


-- Deletes a record from the VW_BILLING_PAYMENTS table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_DeleteRecord(
    @pk_ID_BILLING_PAYMENT NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.VW_BILLING_PAYMENTS
    WHERE ID_BILLING_PAYMENT = @pk_ID_BILLING_PAYMENT;
END;
GO

-- Deletes the set of rows from the VW_BILLING_PAYMENTS table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_DeleteRecords(
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
'DELETE WSXML_SFG.VW_BILLING_PAYMENTS' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the VW_BILLING_PAYMENTS table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_GetRecord(
   @pk_ID_BILLING_PAYMENT NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.VW_BILLING_PAYMENTS
    WHERE ID_BILLING_PAYMENT = @pk_ID_BILLING_PAYMENT;

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
        ID_BILLING_PAYMENT,
        ID_CICLOFACTURACIONPDV,
        FECHAEJECUCION,
        ID_MAESTROFACTURACIONPDV,
        CODPUNTODEVENTA,
        CODLINEADENEGOCIO,
        CODIGOGTECHPUNTODEVENTA,
        NUMEROTERMINAL,
        NOMPUNTODEVENTA,
        CODCIUDAD,
        CODTIPONEGOCIO,
        CODRUTAPDV,
        CODREDPDV,
        CODREGIONAL,
        CODREGIMEN,
        ACTIVE,
        CODAGRUPACIONPUNTODEVENTA,
        CODIGOAGRUPACIONGTECH,
        CODTIPOPUNTODEVENTA,
        FACTURACIONGTECH,
        FACTURACIONFIDUCIA,
        DEUDASEMANAACTUALGTECH,
        DEUDASEMANAACTUALFIDUCIA,
        SALDOGTECH,
        SALDOFIDUCIA,
        NUMPAGOS,
        TOTALPAGOS,
        TOTALPAGOSGTECH,
        APLICADOGTECH,
        TOTALAJUSTESGTECH,
        APLICADOAJUSTEGTECH,
        TOTALPAGOSFIDUCIA,
        APLICADOFIDUCIA,
        TOTALAJUSTESFIDUCIA,
        APLICADOAJUSTEFIDUCIA
    FROM WSXML_SFG.VW_BILLING_PAYMENTS
    WHERE ID_BILLING_PAYMENT = @pk_ID_BILLING_PAYMENT;  
END;
GO

-- Returns a query resultset from table VW_BILLING_PAYMENTS
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_BILLING_PAYMENTS VW_BILLING_PAYMENTS_';
    SET @l_alias_str = 'VW_BILLING_PAYMENTS_';

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
        'VW_BILLING_PAYMENTS_.ID_BILLING_PAYMENT,
            VW_BILLING_PAYMENTS_.ID_CICLOFACTURACIONPDV,
            VW_BILLING_PAYMENTS_.FECHAEJECUCION,
            VW_BILLING_PAYMENTS_.ID_MAESTROFACTURACIONPDV,
            VW_BILLING_PAYMENTS_.CODPUNTODEVENTA,
            VW_BILLING_PAYMENTS_.CODLINEADENEGOCIO,
            VW_BILLING_PAYMENTS_.CODIGOGTECHPUNTODEVENTA,
            VW_BILLING_PAYMENTS_.NUMEROTERMINAL,
            VW_BILLING_PAYMENTS_.NOMPUNTODEVENTA,
            VW_BILLING_PAYMENTS_.CODCIUDAD,
            VW_BILLING_PAYMENTS_.CODTIPONEGOCIO,
            VW_BILLING_PAYMENTS_.CODRUTAPDV,
            VW_BILLING_PAYMENTS_.CODREDPDV,
            VW_BILLING_PAYMENTS_.CODREGIONAL,
            VW_BILLING_PAYMENTS_.CODREGIMEN,
            VW_BILLING_PAYMENTS_.ACTIVE,
            VW_BILLING_PAYMENTS_.CODAGRUPACIONPUNTODEVENTA,
            VW_BILLING_PAYMENTS_.CODIGOAGRUPACIONGTECH,
            VW_BILLING_PAYMENTS_.CODTIPOPUNTODEVENTA,
            VW_BILLING_PAYMENTS_.FACTURACIONGTECH,
            VW_BILLING_PAYMENTS_.FACTURACIONFIDUCIA,
            VW_BILLING_PAYMENTS_.DEUDASEMANAACTUALGTECH,
            VW_BILLING_PAYMENTS_.DEUDASEMANAACTUALFIDUCIA,
            VW_BILLING_PAYMENTS_.SALDOGTECH,
            VW_BILLING_PAYMENTS_.SALDOFIDUCIA,
            VW_BILLING_PAYMENTS_.NUMPAGOS,
            VW_BILLING_PAYMENTS_.TOTALPAGOS,
            VW_BILLING_PAYMENTS_.TOTALPAGOSGTECH,
            VW_BILLING_PAYMENTS_.APLICADOGTECH,
            VW_BILLING_PAYMENTS_.TOTALAJUSTESGTECH,
            VW_BILLING_PAYMENTS_.APLICADOAJUSTEGTECH,
            VW_BILLING_PAYMENTS_.TOTALPAGOSFIDUCIA,
            VW_BILLING_PAYMENTS_.APLICADOFIDUCIA,
            VW_BILLING_PAYMENTS_.TOTALAJUSTESFIDUCIA,
            VW_BILLING_PAYMENTS_.APLICADOAJUSTEFIDUCIA';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY VW_BILLING_PAYMENTS_.ID_BILLING_PAYMENT ASC ';

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
            'WHERE ID_BILLING_PAYMENT = 0';
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
            'WHERE ID_BILLING_PAYMENT = 0';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table VW_BILLING_PAYMENTS
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_BILLING_PAYMENTS VW_BILLING_PAYMENTS_';
    SET @l_alias_str = 'VW_BILLING_PAYMENTS_';

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

-- Returns a query result from table VW_BILLING_PAYMENTS
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_BILLING_PAYMENTS VW_BILLING_PAYMENTS_';
    SET @l_alias_str = 'VW_BILLING_PAYMENTS_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_BILLING_PAYMENTS_Export(
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
                '''XID_BILLING_PAYMENT' + isnull(@p_separator_str, '') +
                'XID_CICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'XID_CICLOFACTURACIONPDV NOMCICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'FECHAEJECUCION' + isnull(@p_separator_str, '') +
                'ID_MAESTROFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA NOMPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO NOMLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'NUMEROTERMINAL' + isnull(@p_separator_str, '') +
                'NOMPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODCIUDAD' + isnull(@p_separator_str, '') +
                'CODCIUDAD NOMCIUDAD' + isnull(@p_separator_str, '') +
                'CODTIPONEGOCIO' + isnull(@p_separator_str, '') +
                'CODTIPONEGOCIO NOMTIPONEGOCIO' + isnull(@p_separator_str, '') +
                'CODRUTAPDV' + isnull(@p_separator_str, '') +
                'CODRUTAPDV NOMRUTAPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV NOMREDPDV' + isnull(@p_separator_str, '') +
                'CODREGIONAL' + isnull(@p_separator_str, '') +
                'CODREGIONAL NOMREGIONAL' + isnull(@p_separator_str, '') +
                'CODREGIMEN' + isnull(@p_separator_str, '') +
                'CODREGIMEN NOMREGIMEN' + isnull(@p_separator_str, '') +
                'ACTIVE' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODIGOAGRUPACIONGTECH' + isnull(@p_separator_str, '') +
                'CODTIPOPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODTIPOPUNTODEVENTA NOMTIPOPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'FACTURACIONGTECH' + isnull(@p_separator_str, '') +
                'FACTURACIONFIDUCIA' + isnull(@p_separator_str, '') +
                'DEUDASEMANAACTUALGTECH' + isnull(@p_separator_str, '') +
                'DEUDASEMANAACTUALFIDUCIA' + isnull(@p_separator_str, '') +
                'SALDOGTECH' + isnull(@p_separator_str, '') +
                'SALDOFIDUCIA' + isnull(@p_separator_str, '') +
                'NUMPAGOS' + isnull(@p_separator_str, '') +
                'TOTALPAGOS' + isnull(@p_separator_str, '') +
                'TOTALPAGOSGTECH' + isnull(@p_separator_str, '') +
                'APLICADOGTECH' + isnull(@p_separator_str, '') +
                'TOTALAJUSTESGTECH' + isnull(@p_separator_str, '') +
                'APLICADOAJUSTEGTECH' + isnull(@p_separator_str, '') +
                'TOTALPAGOSFIDUCIA' + isnull(@p_separator_str, '') +
                'APLICADOFIDUCIA' + isnull(@p_separator_str, '') +
                'TOTALAJUSTESFIDUCIA' + isnull(@p_separator_str, '') +
                'APLICADOAJUSTEFIDUCIA' + ' ''';
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
                ' isnull(CAST(VW_BILLING_PAYMENTS_.ID_BILLING_PAYMENT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.ID_CICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMCICLOFACTURACIONPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(VW_BILLING_PAYMENTS_.FECHAEJECUCION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.ID_MAESTROFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODLINEADENEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMLINEADENEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_BILLING_PAYMENTS_.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_BILLING_PAYMENTS_.NUMEROTERMINAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_BILLING_PAYMENTS_.NOMPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODCIUDAD AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMCIUDAD, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODTIPONEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t4.NOMTIPONEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODRUTAPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t5.NOMRUTAPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODREDPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t6.NOMREDPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODREGIONAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t7.NOMREGIONAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODREGIMEN AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t8.NOMREGIMEN, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.ACTIVE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODAGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t9.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_BILLING_PAYMENTS_.CODIGOAGRUPACIONGTECH) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.CODTIPOPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t10.NOMTIPOPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.FACTURACIONGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.FACTURACIONFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.DEUDASEMANAACTUALGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.DEUDASEMANAACTUALFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.SALDOGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.SALDOFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.NUMPAGOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.TOTALPAGOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.TOTALPAGOSGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.APLICADOGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.TOTALAJUSTESGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_BILLING_PAYMENTS_.APLICADOAJUSTEGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.TOTALPAGOSFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.APLICADOFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.TOTALAJUSTESFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_BILLING_PAYMENTS_.APLICADOAJUSTEFIDUCIA AS VARCHAR(MAX)), '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_BILLING_PAYMENTS VW_BILLING_PAYMENTS_ LEFT OUTER JOIN WSXML_SFG.VWC_CICLOFACTURACION t0 ON (VW_BILLING_PAYMENTS_.ID_CICLOFACTURACIONPDV =  t0.ID_CICLOFACTURACIONPDV) LEFT OUTER JOIN WSXML_SFG.VWC_PUNTODEVENTA t1 ON (VW_BILLING_PAYMENTS_.CODPUNTODEVENTA =  t1.ID_PUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO t2 ON (VW_BILLING_PAYMENTS_.CODLINEADENEGOCIO =  t2.ID_LINEADENEGOCIO) LEFT OUTER JOIN WSXML_SFG.CIUDAD t3 ON (VW_BILLING_PAYMENTS_.CODCIUDAD =  t3.ID_CIUDAD) LEFT OUTER JOIN WSXML_SFG.TIPONEGOCIO t4 ON (VW_BILLING_PAYMENTS_.CODTIPONEGOCIO =  t4.ID_TIPONEGOCIO) LEFT OUTER JOIN WSXML_SFG.RUTAPDV t5 ON (VW_BILLING_PAYMENTS_.CODRUTAPDV =  t5.ID_RUTAPDV) LEFT OUTER JOIN WSXML_SFG.REDPDV t6 ON (VW_BILLING_PAYMENTS_.CODREDPDV =  t6.ID_REDPDV) LEFT OUTER JOIN WSXML_SFG.REGIONAL t7 ON (VW_BILLING_PAYMENTS_.CODREGIONAL =  t7.ID_REGIONAL) LEFT OUTER JOIN WSXML_SFG.REGIMEN t8 ON (VW_BILLING_PAYMENTS_.CODREGIMEN =  t8.ID_REGIMEN) LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA t9 ON (VW_BILLING_PAYMENTS_.CODAGRUPACIONPUNTODEVENTA =  t9.ID_AGRUPACIONPUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.TIPOPUNTODEVENTA t10 ON (VW_BILLING_PAYMENTS_.CODTIPOPUNTODEVENTA =  t10.ID_TIPOPUNTODEVENTA)';

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






