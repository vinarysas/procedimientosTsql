USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_SHOWDSLIPITEMCHAIN
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN */ 

-- Deletes a record from the VW_SHOWDSLIPITEMCHAIN table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_DeleteRecord(
    @pk_ID_CICLOFACTURACIONPDV NUMERIC(22,0),
    @pk_ID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.VW_SHOWDSLIPITEMCHAIN
    WHERE ID_CICLOFACTURACIONPDV = @pk_ID_CICLOFACTURACIONPDV
    AND ID_AGRUPACIONPUNTODEVENTA = @pk_ID_AGRUPACIONPUNTODEVENTA;
END;
GO

-- Deletes the set of rows from the VW_SHOWDSLIPITEMCHAIN table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_DeleteRecords(
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
'DELETE WSXML_SFG.VW_SHOWDSLIPITEMCHAIN' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the VW_SHOWDSLIPITEMCHAIN table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_GetRecord(
    @pk_ID_CICLOFACTURACIONPDV NUMERIC(22,0),
	@pk_ID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.VW_SHOWDSLIPITEMCHAIN
    WHERE ID_CICLOFACTURACIONPDV = @pk_ID_CICLOFACTURACIONPDV AND ID_AGRUPACIONPUNTODEVENTA = @pk_ID_AGRUPACIONPUNTODEVENTA;

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
        BILLINGDATE,
        CHAINNUMBER,
        REFERENCENUMBER,
        GTECHBANKACCOUNTNUMBER,
        FIDUCIABANKACCOUNTNUMBER,
        GTECHBARCODE,
        FIDUCIABARCODE,
        GPREVIOUSBALANCELOTTERY,
        GPREVIOUSBALANCEPREPAID,
        GPREVIOUSBALANCEBILLPAY,
        GPREVIOUSBALANCEWITHDRW,
        GPREVIOUSBALANCETOTAL,
        FPREVIOUSBALANCELOTTERY,
        FPREVIOUSBALANCETOTAL,
        PREVIOUSBALANCETOTAL,
        GTOTALBILLINGLOTTERY,
        GTOTALBILLINGPREPAID,
        GTOTALBILLINGBILLPAY,
        GTOTALBILLINGWITHDRW,
        GTOTALBILLINGTOTAL,
        FTOTALBILLINGLOTTERY,
        FTOTALBILLINGTOTAL,
        TOTALBILLINGTOTAL,
        GCURRENTBALANCELOTTERY,
        GCURRENTBALANCEPREPAID,
        GCURRENTBALANCEBILLPAY,
        GCURRENTBALANCEWITHDRW,
        GCURRENTBALANCETOTAL,
        FCURRENTBALANCELOTTERY,
        FCURRENTBALANCETOTAL,
        CURRENTBALANCETOTAL,
        SALESQUANTITY,
        SALESAMOUNT,
        ANNULMENTQUANTITY,
        ANNULMENTAMOUNT,
        FREETKQUANTITY,
        FREETKAMOUNT,
        AWARDPAIDQUANTITY,
        AWARDPAIDAMOUNT,
        AWARDTAXDISCOUNT,
        GROSSSALES,
        GROSSCOMMISSION,
        VATCOMMISSION,
        FINALCOMMISSION,
        GCURRENTWEEK,
        FCURRENTWEEK,
        TOTALCURRENTWEEK,
        GCURRENTBALANCE,
        FCURRENTBALANCE,
        NUMEROPAGOS,
        PAGOSAPLICADOS,
        ID_CICLOFACTURACIONPDV,
        ID_AGRUPACIONPUNTODEVENTA,
        CODTIPOPUNTODEVENTA,
        CODPUNTODEVENTACABEZA,
        GPREVIOUSBALANCEINSTALL,
        GTOTALBILLINGINSTALL,
        GCURRENTBALANCEINSTALL
    FROM WSXML_SFG.VW_SHOWDSLIPITEMCHAIN
    WHERE ID_CICLOFACTURACIONPDV = @pk_ID_CICLOFACTURACIONPDV AND ID_AGRUPACIONPUNTODEVENTA = @pk_ID_AGRUPACIONPUNTODEVENTA;  
END;
GO

-- Returns a query resultset from table VW_SHOWDSLIPITEMCHAIN
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOWDSLIPITEMCHAIN VW_SHOWDSLIPITEMCHAIN_';
    SET @l_alias_str = 'VW_SHOWDSLIPITEMCHAIN_';

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
        'VW_SHOWDSLIPITEMCHAIN_.BILLINGDATE,
            VW_SHOWDSLIPITEMCHAIN_.CHAINNUMBER,
            VW_SHOWDSLIPITEMCHAIN_.REFERENCENUMBER,
            VW_SHOWDSLIPITEMCHAIN_.GTECHBANKACCOUNTNUMBER,
            VW_SHOWDSLIPITEMCHAIN_.FIDUCIABANKACCOUNTNUMBER,
            VW_SHOWDSLIPITEMCHAIN_.GTECHBARCODE,
            VW_SHOWDSLIPITEMCHAIN_.FIDUCIABARCODE,
            VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCELOTTERY,
            VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCEPREPAID,
            VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCEBILLPAY,
            VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCEWITHDRW,
            VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCETOTAL,
            VW_SHOWDSLIPITEMCHAIN_.FPREVIOUSBALANCELOTTERY,
            VW_SHOWDSLIPITEMCHAIN_.FPREVIOUSBALANCETOTAL,
            VW_SHOWDSLIPITEMCHAIN_.PREVIOUSBALANCETOTAL,
            VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGLOTTERY,
            VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGPREPAID,
            VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGBILLPAY,
            VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGWITHDRW,
            VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGTOTAL,
            VW_SHOWDSLIPITEMCHAIN_.FTOTALBILLINGLOTTERY,
            VW_SHOWDSLIPITEMCHAIN_.FTOTALBILLINGTOTAL,
            VW_SHOWDSLIPITEMCHAIN_.TOTALBILLINGTOTAL,
            VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCELOTTERY,
            VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCEPREPAID,
            VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCEBILLPAY,
            VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCEWITHDRW,
            VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCETOTAL,
            VW_SHOWDSLIPITEMCHAIN_.FCURRENTBALANCELOTTERY,
            VW_SHOWDSLIPITEMCHAIN_.FCURRENTBALANCETOTAL,
            VW_SHOWDSLIPITEMCHAIN_.CURRENTBALANCETOTAL,
            VW_SHOWDSLIPITEMCHAIN_.SALESQUANTITY,
            VW_SHOWDSLIPITEMCHAIN_.SALESAMOUNT,
            VW_SHOWDSLIPITEMCHAIN_.ANNULMENTQUANTITY,
            VW_SHOWDSLIPITEMCHAIN_.ANNULMENTAMOUNT,
            VW_SHOWDSLIPITEMCHAIN_.FREETKQUANTITY,
            VW_SHOWDSLIPITEMCHAIN_.FREETKAMOUNT,
            VW_SHOWDSLIPITEMCHAIN_.AWARDPAIDQUANTITY,
            VW_SHOWDSLIPITEMCHAIN_.AWARDPAIDAMOUNT,
            VW_SHOWDSLIPITEMCHAIN_.AWARDTAXDISCOUNT,
            VW_SHOWDSLIPITEMCHAIN_.GROSSSALES,
            VW_SHOWDSLIPITEMCHAIN_.GROSSCOMMISSION,
            VW_SHOWDSLIPITEMCHAIN_.VATCOMMISSION,
            VW_SHOWDSLIPITEMCHAIN_.FINALCOMMISSION,
            VW_SHOWDSLIPITEMCHAIN_.GCURRENTWEEK,
            VW_SHOWDSLIPITEMCHAIN_.FCURRENTWEEK,
            VW_SHOWDSLIPITEMCHAIN_.TOTALCURRENTWEEK,
            VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCE,
            VW_SHOWDSLIPITEMCHAIN_.FCURRENTBALANCE,
            VW_SHOWDSLIPITEMCHAIN_.NUMEROPAGOS,
            VW_SHOWDSLIPITEMCHAIN_.PAGOSAPLICADOS,
            VW_SHOWDSLIPITEMCHAIN_.ID_CICLOFACTURACIONPDV,
            VW_SHOWDSLIPITEMCHAIN_.ID_AGRUPACIONPUNTODEVENTA,
            VW_SHOWDSLIPITEMCHAIN_.CODTIPOPUNTODEVENTA,
            VW_SHOWDSLIPITEMCHAIN_.CODPUNTODEVENTACABEZA,
            VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCEINSTALL,
            VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGINSTALL,
            VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCEINSTALL';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY VW_SHOWDSLIPITEMCHAIN_.ID_CICLOFACTURACIONPDV,VW_SHOWDSLIPITEMCHAIN_.ID_AGRUPACIONPUNTODEVENTA ASC ';

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

-- Returns a query result from table VW_SHOWDSLIPITEMCHAIN
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOWDSLIPITEMCHAIN VW_SHOWDSLIPITEMCHAIN_';
    SET @l_alias_str = 'VW_SHOWDSLIPITEMCHAIN_';

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

-- Returns a query result from table VW_SHOWDSLIPITEMCHAIN
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_SHOWDSLIPITEMCHAIN VW_SHOWDSLIPITEMCHAIN_';
    SET @l_alias_str = 'VW_SHOWDSLIPITEMCHAIN_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPITEMCHAIN_Export(
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
                'BILLINGDATE' + isnull(@p_separator_str, '') +
                'CHAINNUMBER' + isnull(@p_separator_str, '') +
                'REFERENCENUMBER' + isnull(@p_separator_str, '') +
                'GTECHBANKACCOUNTNUMBER' + isnull(@p_separator_str, '') +
                'FIDUCIABANKACCOUNTNUMBER' + isnull(@p_separator_str, '') +
                'GTECHBARCODE' + isnull(@p_separator_str, '') +
                'FIDUCIABARCODE' + isnull(@p_separator_str, '') +
                'GPREVIOUSBALANCELOTTERY' + isnull(@p_separator_str, '') +
                'GPREVIOUSBALANCEPREPAID' + isnull(@p_separator_str, '') +
                'GPREVIOUSBALANCEBILLPAY' + isnull(@p_separator_str, '') +
                'GPREVIOUSBALANCEWITHDRW' + isnull(@p_separator_str, '') +
                'GPREVIOUSBALANCETOTAL' + isnull(@p_separator_str, '') +
                'FPREVIOUSBALANCELOTTERY' + isnull(@p_separator_str, '') +
                'FPREVIOUSBALANCETOTAL' + isnull(@p_separator_str, '') +
                'PREVIOUSBALANCETOTAL' + isnull(@p_separator_str, '') +
                'GTOTALBILLINGLOTTERY' + isnull(@p_separator_str, '') +
                'GTOTALBILLINGPREPAID' + isnull(@p_separator_str, '') +
                'GTOTALBILLINGBILLPAY' + isnull(@p_separator_str, '') +
                'GTOTALBILLINGWITHDRW' + isnull(@p_separator_str, '') +
                'GTOTALBILLINGTOTAL' + isnull(@p_separator_str, '') +
                'FTOTALBILLINGLOTTERY' + isnull(@p_separator_str, '') +
                'FTOTALBILLINGTOTAL' + isnull(@p_separator_str, '') +
                'TOTALBILLINGTOTAL' + isnull(@p_separator_str, '') +
                'GCURRENTBALANCELOTTERY' + isnull(@p_separator_str, '') +
                'GCURRENTBALANCEPREPAID' + isnull(@p_separator_str, '') +
                'GCURRENTBALANCEBILLPAY' + isnull(@p_separator_str, '') +
                'GCURRENTBALANCEWITHDRW' + isnull(@p_separator_str, '') +
                'GCURRENTBALANCETOTAL' + isnull(@p_separator_str, '') +
                'FCURRENTBALANCELOTTERY' + isnull(@p_separator_str, '') +
                'FCURRENTBALANCETOTAL' + isnull(@p_separator_str, '') +
                'CURRENTBALANCETOTAL' + isnull(@p_separator_str, '') +
                'SALESQUANTITY' + isnull(@p_separator_str, '') +
                'SALESAMOUNT' + isnull(@p_separator_str, '') +
                'ANNULMENTQUANTITY' + isnull(@p_separator_str, '') +
                'ANNULMENTAMOUNT' + isnull(@p_separator_str, '') +
                'FREETKQUANTITY' + isnull(@p_separator_str, '') +
                'FREETKAMOUNT' + isnull(@p_separator_str, '') +
                'AWARDPAIDQUANTITY' + isnull(@p_separator_str, '') +
                'AWARDPAIDAMOUNT' + isnull(@p_separator_str, '') +
                'AWARDTAXDISCOUNT' + isnull(@p_separator_str, '') +
                'GROSSSALES' + isnull(@p_separator_str, '') +
                'GROSSCOMMISSION' + isnull(@p_separator_str, '') +
                'VATCOMMISSION' + isnull(@p_separator_str, '') +
                'FINALCOMMISSION' + isnull(@p_separator_str, '') +
                'GCURRENTWEEK' + isnull(@p_separator_str, '') +
                'FCURRENTWEEK' + isnull(@p_separator_str, '') +
                'TOTALCURRENTWEEK' + isnull(@p_separator_str, '') +
                'GCURRENTBALANCE' + isnull(@p_separator_str, '') +
                'FCURRENTBALANCE' + isnull(@p_separator_str, '') +
                'NUMEROPAGOS' + isnull(@p_separator_str, '') +
                'PAGOSAPLICADOS' + isnull(@p_separator_str, '') +
                'XID_CICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'XID_CICLOFACTURACIONPDV NOMCICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'ID_AGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'ID_AGRUPACIONPUNTODEVENTA NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODTIPOPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTACABEZA' + isnull(@p_separator_str, '') +
                'GPREVIOUSBALANCEINSTALL' + isnull(@p_separator_str, '') +
                'GTOTALBILLINGINSTALL' + isnull(@p_separator_str, '') +
                'GCURRENTBALANCEINSTALL' + ' ';
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
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.BILLINGDATE, ''mm/dd/yyyy hh24:mi'', '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOWDSLIPITEMCHAIN_.CHAINNUMBER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOWDSLIPITEMCHAIN_.REFERENCENUMBER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOWDSLIPITEMCHAIN_.GTECHBANKACCOUNTNUMBER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOWDSLIPITEMCHAIN_.FIDUCIABANKACCOUNTNUMBER) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOWDSLIPITEMCHAIN_.GTECHBARCODE) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOWDSLIPITEMCHAIN_.FIDUCIABARCODE) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCELOTTERY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCEPREPAID AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCEBILLPAY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCEWITHDRW, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCETOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FPREVIOUSBALANCELOTTERY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FPREVIOUSBALANCETOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.PREVIOUSBALANCETOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGLOTTERY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGPREPAID AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGBILLPAY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGWITHDRW, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGTOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FTOTALBILLINGLOTTERY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FTOTALBILLINGTOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.TOTALBILLINGTOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCELOTTERY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCEPREPAID AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCEBILLPAY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCEWITHDRW, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCETOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FCURRENTBALANCELOTTERY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FCURRENTBALANCETOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.CURRENTBALANCETOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.SALESQUANTITY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.SALESAMOUNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.ANNULMENTQUANTITY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.ANNULMENTAMOUNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FREETKQUANTITY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FREETKAMOUNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPITEMCHAIN_.AWARDPAIDQUANTITY AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPITEMCHAIN_.AWARDPAIDAMOUNT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.AWARDTAXDISCOUNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GROSSSALES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GROSSCOMMISSION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.VATCOMMISSION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FINALCOMMISSION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GCURRENTWEEK, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FCURRENTWEEK, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.TOTALCURRENTWEEK, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.FCURRENTBALANCE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.NUMEROPAGOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.PAGOSAPLICADOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPITEMCHAIN_.ID_CICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMCICLOFACTURACIONPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPITEMCHAIN_.ID_AGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPITEMCHAIN_.CODTIPOPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPITEMCHAIN_.CODPUNTODEVENTACABEZA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GPREVIOUSBALANCEINSTALL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GTOTALBILLINGINSTALL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPITEMCHAIN_.GCURRENTBALANCEINSTALL, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_SHOWDSLIPITEMCHAIN VW_SHOWDSLIPITEMCHAIN_ LEFT OUTER JOIN WSXML_SFG.VWC_CICLOFACTURACION t0 ON (VW_SHOWDSLIPITEMCHAIN_.ID_CICLOFACTURACIONPDV =  t0.ID_CICLOFACTURACIONPDV) LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA t1 ON (VW_SHOWDSLIPITEMCHAIN_.ID_AGRUPACIONPUNTODEVENTA =  t1.ID_AGRUPACIONPUNTODEVENTA)';

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






