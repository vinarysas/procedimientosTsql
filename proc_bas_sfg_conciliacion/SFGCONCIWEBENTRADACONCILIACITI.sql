USE SFGPRODU;
--  DDL for Package Body SFGCONCIWEBENTRADACONCILIACITI
--------------------------------------------------------

  /* PACKAGE BODY SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI */ 

-- Creates a new record in the ENTRADACONCILIACITI table
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_AddRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_AddRecord(
    @p_CIT_03_REC_TYPE NUMERIC(22,0),
    @p_CIT_03_BUS_DATE DATETIME,
    @p_CIT_03_TRML_NMBR VARCHAR(4000),
    @p_CIT_03_TRANS_CODE VARCHAR(4000),
    @p_CIT_03_TRANS_NMBR NUMERIC(22,0),
    @p_CIT_03_TRANS_DATE DATETIME,
    @p_CIT_03_PROD_BIN NUMERIC(22,0),
    @p_CIT_03_BRAN_NMBR NUMERIC(22,0),
    @p_CIT_03_ACCN_NMBR NUMERIC(22,0),
    @p_CIT_03_CARD_NMBR NUMERIC(22,0),
    @p_CIT_03_MNBR_NMBR NUMERIC(22,0),
    @p_CIT_03_DSTN_ACCN NUMERIC(22,0),
    @p_CIT_03_TRANS_VALUE NUMERIC(22,0),
    @p_CIT_03_AUTH_MTHD VARCHAR(4000),
    @p_CIT_03_CITI_ERR VARCHAR(4000),
    @p_CIT_03_CONF_MARK VARCHAR(4000),
    @p_CIT_03_AUTH_NMBR NUMERIC(22,0),
    @p_CIT_03_TRML_SECN VARCHAR(4000),
    @p_CIT_03_TRML_DESC VARCHAR(4000),
    @p_CIT_03_ISO_ERR NUMERIC(22,0),
    @p_CIT_03_REVS NUMERIC(22,0),
    @p_CIT_03_PART_REVS NUMERIC(22,0),
    @p_CIT_03_AUTH_SWTH NUMERIC(22,0),
    @p_CIT_03_SERVICE VARCHAR(4000),
    @p_CIT_03_REVS_VALUE NUMERIC(22,0),
    @p_CIT_03_COSTO_TRANS NUMERIC(22,0),
    @p_CIT_03_P37_RETRVL_REF NUMERIC(22,0),
    @p_CIT_03_TRANS_FIN_ASOC VARCHAR(4000),
    @p_CODENTRADACONCILIAALI NUMERIC(22,0),
    @p_ID_ENTRADACONCILIACITI_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO SFG_CONCILIACION.ENTRADACONCILIACITI
        (
            CIT_03_REC_TYPE,
            CIT_03_BUS_DATE,
            CIT_03_TRML_NMBR,
            CIT_03_TRANS_CODE,
            CIT_03_TRANS_NMBR,
            CIT_03_TRANS_DATE,
            CIT_03_PROD_BIN,
            CIT_03_BRAN_NMBR,
            CIT_03_ACCN_NMBR,
            CIT_03_CARD_NMBR,
            CIT_03_MNBR_NMBR,
            CIT_03_DSTN_ACCN,
            CIT_03_TRANS_VALUE,
            CIT_03_AUTH_MTHD,
            CIT_03_CITI_ERR,
            CIT_03_CONF_MARK,
            CIT_03_AUTH_NMBR,
            CIT_03_TRML_SECN,
            CIT_03_TRML_DESC,
            CIT_03_ISO_ERR,
            CIT_03_REVS,
            CIT_03_PART_REVS,
            CIT_03_AUTH_SWTH,
            CIT_03_SERVICE,
            CIT_03_REVS_VALUE,
            CIT_03_COSTO_TRANS,
            CIT_03_P37_RETRVL_REF,
            CIT_03_TRANS_FIN_ASOC,
            CODENTRADACONCILIAALI
        )
    VALUES
        (
            @p_CIT_03_REC_TYPE,
            @p_CIT_03_BUS_DATE,
            @p_CIT_03_TRML_NMBR,
            @p_CIT_03_TRANS_CODE,
            @p_CIT_03_TRANS_NMBR,
            @p_CIT_03_TRANS_DATE,
            @p_CIT_03_PROD_BIN,
            @p_CIT_03_BRAN_NMBR,
            @p_CIT_03_ACCN_NMBR,
            @p_CIT_03_CARD_NMBR,
            @p_CIT_03_MNBR_NMBR,
            @p_CIT_03_DSTN_ACCN,
            @p_CIT_03_TRANS_VALUE,
            @p_CIT_03_AUTH_MTHD,
            @p_CIT_03_CITI_ERR,
            @p_CIT_03_CONF_MARK,
            @p_CIT_03_AUTH_NMBR,
            @p_CIT_03_TRML_SECN,
            @p_CIT_03_TRML_DESC,
            @p_CIT_03_ISO_ERR,
            @p_CIT_03_REVS,
            @p_CIT_03_PART_REVS,
            @p_CIT_03_AUTH_SWTH,
            @p_CIT_03_SERVICE,
            @p_CIT_03_REVS_VALUE,
            @p_CIT_03_COSTO_TRANS,
            @p_CIT_03_P37_RETRVL_REF,
            @p_CIT_03_TRANS_FIN_ASOC,
            @p_CODENTRADACONCILIAALI
        );
       SET
            @p_ID_ENTRADACONCILIACITI_out = SCOPE_IDENTITY() ;

END;
GO

-- Updates a record in the ENTRADACONCILIACITI table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_UpdateRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_UpdateRecord(
    @pk_ID_ENTRADACONCILIACITI NUMERIC(22,0),
    @p_CIT_03_REC_TYPE NUMERIC(22,0),
    @p_CIT_03_BUS_DATE DATETIME,
    @p_CIT_03_TRML_NMBR VARCHAR(4000),
    @p_CIT_03_TRANS_CODE VARCHAR(4000),
    @p_CIT_03_TRANS_NMBR NUMERIC(22,0),
    @p_CIT_03_TRANS_DATE DATETIME,
    @p_CIT_03_PROD_BIN NUMERIC(22,0),
    @p_CIT_03_BRAN_NMBR NUMERIC(22,0),
    @p_CIT_03_ACCN_NMBR NUMERIC(22,0),
    @p_CIT_03_CARD_NMBR NUMERIC(22,0),
    @p_CIT_03_MNBR_NMBR NUMERIC(22,0),
    @p_CIT_03_DSTN_ACCN NUMERIC(22,0),
    @p_CIT_03_TRANS_VALUE NUMERIC(22,0),
    @p_CIT_03_AUTH_MTHD VARCHAR(4000),
    @p_CIT_03_CITI_ERR VARCHAR(4000),
    @p_CIT_03_CONF_MARK VARCHAR(4000),
    @p_CIT_03_AUTH_NMBR NUMERIC(22,0),
    @p_CIT_03_TRML_SECN VARCHAR(4000),
    @p_CIT_03_TRML_DESC VARCHAR(4000),
    @p_CIT_03_ISO_ERR NUMERIC(22,0),
    @p_CIT_03_REVS NUMERIC(22,0),
    @p_CIT_03_PART_REVS NUMERIC(22,0),
    @p_CIT_03_AUTH_SWTH NUMERIC(22,0),
    @p_CIT_03_SERVICE VARCHAR(4000),
    @p_CIT_03_REVS_VALUE NUMERIC(22,0),
    @p_CIT_03_COSTO_TRANS NUMERIC(22,0),
    @p_CIT_03_P37_RETRVL_REF NUMERIC(22,0),
    @p_CIT_03_TRANS_FIN_ASOC VARCHAR(4000),
    @p_CODENTRADACONCILIAALI NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE SFG_CONCILIACION.ENTRADACONCILIACITI
    SET 
            CIT_03_REC_TYPE = @p_CIT_03_REC_TYPE,
            CIT_03_BUS_DATE = @p_CIT_03_BUS_DATE,
            CIT_03_TRML_NMBR = @p_CIT_03_TRML_NMBR,
            CIT_03_TRANS_CODE = @p_CIT_03_TRANS_CODE,
            CIT_03_TRANS_NMBR = @p_CIT_03_TRANS_NMBR,
            CIT_03_TRANS_DATE = @p_CIT_03_TRANS_DATE,
            CIT_03_PROD_BIN = @p_CIT_03_PROD_BIN,
            CIT_03_BRAN_NMBR = @p_CIT_03_BRAN_NMBR,
            CIT_03_ACCN_NMBR = @p_CIT_03_ACCN_NMBR,
            CIT_03_CARD_NMBR = @p_CIT_03_CARD_NMBR,
            CIT_03_MNBR_NMBR = @p_CIT_03_MNBR_NMBR,
            CIT_03_DSTN_ACCN = @p_CIT_03_DSTN_ACCN,
            CIT_03_TRANS_VALUE = @p_CIT_03_TRANS_VALUE,
            CIT_03_AUTH_MTHD = @p_CIT_03_AUTH_MTHD,
            CIT_03_CITI_ERR = @p_CIT_03_CITI_ERR,
            CIT_03_CONF_MARK = @p_CIT_03_CONF_MARK,
            CIT_03_AUTH_NMBR = @p_CIT_03_AUTH_NMBR,
            CIT_03_TRML_SECN = @p_CIT_03_TRML_SECN,
            CIT_03_TRML_DESC = @p_CIT_03_TRML_DESC,
            CIT_03_ISO_ERR = @p_CIT_03_ISO_ERR,
            CIT_03_REVS = @p_CIT_03_REVS,
            CIT_03_PART_REVS = @p_CIT_03_PART_REVS,
            CIT_03_AUTH_SWTH = @p_CIT_03_AUTH_SWTH,
            CIT_03_SERVICE = @p_CIT_03_SERVICE,
            CIT_03_REVS_VALUE = @p_CIT_03_REVS_VALUE,
            CIT_03_COSTO_TRANS = @p_CIT_03_COSTO_TRANS,
            CIT_03_P37_RETRVL_REF = @p_CIT_03_P37_RETRVL_REF,
            CIT_03_TRANS_FIN_ASOC = @p_CIT_03_TRANS_FIN_ASOC,
            CODENTRADACONCILIAALI = @p_CODENTRADACONCILIAALI
    WHERE ID_ENTRADACONCILIACITI = @pk_ID_ENTRADACONCILIACITI;

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

-- Deletes a record from the ENTRADACONCILIACITI table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_DeleteRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_DeleteRecord(
    @pk_ID_ENTRADACONCILIACITI NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE SFG_CONCILIACION.ENTRADACONCILIACITI
    WHERE ID_ENTRADACONCILIACITI = @pk_ID_ENTRADACONCILIACITI;
END;
GO

-- Deletes the set of rows from the ENTRADACONCILIACITI table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_DeleteRecords;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_DeleteRecords(
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
'DELETE SFG_CONCILIACION.ENTRADACONCILIACITI' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the ENTRADACONCILIACITI table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_GetRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_GetRecord(
   @pk_ID_ENTRADACONCILIACITI NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure 
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM SFG_CONCILIACION.ENTRADACONCILIACITI
    WHERE ID_ENTRADACONCILIACITI = @pk_ID_ENTRADACONCILIACITI;

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
        ID_ENTRADACONCILIACITI,
        CIT_03_REC_TYPE,
        CIT_03_BUS_DATE,
        CIT_03_TRML_NMBR,
        CIT_03_TRANS_CODE,
        CIT_03_TRANS_NMBR,
        CIT_03_TRANS_DATE,
        CIT_03_PROD_BIN,
        CIT_03_BRAN_NMBR,
        CIT_03_ACCN_NMBR,
        CIT_03_CARD_NMBR,
        CIT_03_MNBR_NMBR,
        CIT_03_DSTN_ACCN,
        CIT_03_TRANS_VALUE,
        CIT_03_AUTH_MTHD,
        CIT_03_CITI_ERR,
        CIT_03_CONF_MARK,
        CIT_03_AUTH_NMBR,
        CIT_03_TRML_SECN,
        CIT_03_TRML_DESC,
        CIT_03_ISO_ERR,
        CIT_03_REVS,
        CIT_03_PART_REVS,
        CIT_03_AUTH_SWTH,
        CIT_03_SERVICE,
        CIT_03_REVS_VALUE,
        CIT_03_COSTO_TRANS,
        CIT_03_P37_RETRVL_REF,
        CIT_03_TRANS_FIN_ASOC,
        CODENTRADACONCILIAALI
    FROM SFG_CONCILIACION.ENTRADACONCILIACITI
    WHERE ID_ENTRADACONCILIACITI = @pk_ID_ENTRADACONCILIACITI;  
END;
GO

-- Returns a query resultset from table ENTRADACONCILIACITI
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
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_GetList', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_GetList;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_GetList(
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
    SET @l_from_str = 'SFG_CONCILIACION.ENTRADACONCILIACITI ENTRADACONCILIACITI_';
    SET @l_alias_str = 'ENTRADACONCILIACITI_';

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
        'ENTRADACONCILIACITI_.ID_ENTRADACONCILIACITI,
            ENTRADACONCILIACITI_.CIT_03_REC_TYPE,
            ENTRADACONCILIACITI_.CIT_03_BUS_DATE,
            ENTRADACONCILIACITI_.CIT_03_TRML_NMBR,
            ENTRADACONCILIACITI_.CIT_03_TRANS_CODE,
            ENTRADACONCILIACITI_.CIT_03_TRANS_NMBR,
            ENTRADACONCILIACITI_.CIT_03_TRANS_DATE,
            ENTRADACONCILIACITI_.CIT_03_PROD_BIN,
            ENTRADACONCILIACITI_.CIT_03_BRAN_NMBR,
            ENTRADACONCILIACITI_.CIT_03_ACCN_NMBR,
            ENTRADACONCILIACITI_.CIT_03_CARD_NMBR,
            ENTRADACONCILIACITI_.CIT_03_MNBR_NMBR,
            ENTRADACONCILIACITI_.CIT_03_DSTN_ACCN,
            ENTRADACONCILIACITI_.CIT_03_TRANS_VALUE,
            ENTRADACONCILIACITI_.CIT_03_AUTH_MTHD,
            ENTRADACONCILIACITI_.CIT_03_CITI_ERR,
            ENTRADACONCILIACITI_.CIT_03_CONF_MARK,
            ENTRADACONCILIACITI_.CIT_03_AUTH_NMBR,
            ENTRADACONCILIACITI_.CIT_03_TRML_SECN,
            ENTRADACONCILIACITI_.CIT_03_TRML_DESC,
            ENTRADACONCILIACITI_.CIT_03_ISO_ERR,
            ENTRADACONCILIACITI_.CIT_03_REVS,
            ENTRADACONCILIACITI_.CIT_03_PART_REVS,
            ENTRADACONCILIACITI_.CIT_03_AUTH_SWTH,
            ENTRADACONCILIACITI_.CIT_03_SERVICE,
            ENTRADACONCILIACITI_.CIT_03_REVS_VALUE,
            ENTRADACONCILIACITI_.CIT_03_COSTO_TRANS,
            ENTRADACONCILIACITI_.CIT_03_P37_RETRVL_REF,
            ENTRADACONCILIACITI_.CIT_03_TRANS_FIN_ASOC,
            ENTRADACONCILIACITI_.CODENTRADACONCILIAALI';
    
    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY ENTRADACONCILIACITI_.ID_ENTRADACONCILIACITI ASC ';

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

-- Returns a query result from table ENTRADACONCILIACITI
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_DrillDown;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_DrillDown(
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
    SET @l_from_str = 'SFG_CONCILIACION.ENTRADACONCILIACITI ENTRADACONCILIACITI_';
    SET @l_alias_str = 'ENTRADACONCILIACITI_';

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

-- Returns a query result from table ENTRADACONCILIACITI
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_GetStats;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_GetStats(
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

    SET @l_from_str = 'SFG_CONCILIACION.ENTRADACONCILIACITI ENTRADACONCILIACITI_';
    SET @l_alias_str = 'ENTRADACONCILIACITI_';

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
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_Export', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_Export;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBENTRADACONCILIACITI_Export(
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
                '''XID_ENTRADACONCILIACITI' + isnull(@p_separator_str, '') +
                'CIT_03_REC_TYPE' + isnull(@p_separator_str, '') +
                'CIT_03_BUS_DATE' + isnull(@p_separator_str, '') +
                'CIT_03_TRML_NMBR' + isnull(@p_separator_str, '') +
                'CIT_03_TRANS_CODE' + isnull(@p_separator_str, '') +
                'CIT_03_TRANS_NMBR' + isnull(@p_separator_str, '') +
                'CIT_03_TRANS_DATE' + isnull(@p_separator_str, '') +
                'CIT_03_PROD_BIN' + isnull(@p_separator_str, '') +
                'CIT_03_BRAN_NMBR' + isnull(@p_separator_str, '') +
                'CIT_03_ACCN_NMBR' + isnull(@p_separator_str, '') +
                'CIT_03_CARD_NMBR' + isnull(@p_separator_str, '') +
                'CIT_03_MNBR_NMBR' + isnull(@p_separator_str, '') +
                'CIT_03_DSTN_ACCN' + isnull(@p_separator_str, '') +
                'CIT_03_TRANS_VALUE' + isnull(@p_separator_str, '') +
                'CIT_03_AUTH_MTHD' + isnull(@p_separator_str, '') +
                'CIT_03_CITI_ERR' + isnull(@p_separator_str, '') +
                'CIT_03_CONF_MARK' + isnull(@p_separator_str, '') +
                'CIT_03_AUTH_NMBR' + isnull(@p_separator_str, '') +
                'CIT_03_TRML_SECN' + isnull(@p_separator_str, '') +
                'CIT_03_TRML_DESC' + isnull(@p_separator_str, '') +
                'CIT_03_ISO_ERR' + isnull(@p_separator_str, '') +
                'CIT_03_REVS' + isnull(@p_separator_str, '') +
                'CIT_03_PART_REVS' + isnull(@p_separator_str, '') +
                'CIT_03_AUTH_SWTH' + isnull(@p_separator_str, '') +
                'CIT_03_SERVICE' + isnull(@p_separator_str, '') +
                'CIT_03_REVS_VALUE' + isnull(@p_separator_str, '') +
                'CIT_03_COSTO_TRANS' + isnull(@p_separator_str, '') +
                'CIT_03_P37_RETRVL_REF' + isnull(@p_separator_str, '') +
                'CIT_03_TRANS_FIN_ASOC' + isnull(@p_separator_str, '') +
                'CODENTRADACONCILIAALI' + isnull(@p_separator_str, '') +
                'CODENTRADACONCILIAALI RCPT_NMR' + ' ''';
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
                ' isnull(CAST(ENTRADACONCILIACITI_.ID_ENTRADACONCILIACITI AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_REC_TYPE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_BUS_DATE, ''mm/dd/yyyy hh24:mi'', '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIACITI_.CIT_03_TRML_NMBR, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(ENTRADACONCILIACITI_.CIT_03_TRANS_CODE) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_TRANS_NMBR, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_TRANS_DATE, ''mm/dd/yyyy hh24:mi'', '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_PROD_BIN, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_BRAN_NMBR, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_ACCN_NMBR, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_CARD_NMBR, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_MNBR_NMBR, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_DSTN_ACCN, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_TRANS_VALUE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIACITI_.CIT_03_AUTH_MTHD, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIACITI_.CIT_03_CITI_ERR, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIACITI_.CIT_03_CONF_MARK, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_AUTH_NMBR, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIACITI_.CIT_03_TRML_SECN, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIACITI_.CIT_03_TRML_DESC, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_ISO_ERR, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_REVS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_PART_REVS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_AUTH_SWTH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIACITI_.CIT_03_SERVICE, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_REVS_VALUE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_COSTO_TRANS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(ENTRADACONCILIACITI_.CIT_03_P37_RETRVL_REF, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(ENTRADACONCILIACITI_.CIT_03_TRANS_FIN_ASOC, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(ENTRADACONCILIACITI_.CODENTRADACONCILIAALI AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.RCPT_NMR, ''''), '''', '''') + ''''  + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'SFG_CONCILIACION.ENTRADACONCILIACITI ENTRADACONCILIACITI_ LEFT OUTER JOIN SFG_CONCILIACION.ENTRADACONCILIAALI t0 ON (ENTRADACONCILIACITI_.CODENTRADACONCILIAALI =  t0.ID_ENTRADACONCILIAALI)';

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






