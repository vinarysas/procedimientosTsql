USE SFGPRODU;
--  DDL for Package Body SFGCONCIWEBMAESTROFACTURACIONP
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP */ 

-- Creates a new record in the MAESTROFACTURACIONPDV table
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_AddRecord(
    @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
    @p_CODMAESTROFACTURACIONCOMPCO2 NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_CODLINEADENEGOCIO NUMERIC(22,0),
    @p_CODPUNTODEVENTA NUMERIC(22,0),
    @p_SALDOANTERIORENCONTRAGTECH FLOAT,
    @p_SALDOANTERIORENCONTRAFIDUCIA FLOAT,
    @p_SALDOANTERIORAFAVORGTECH FLOAT,
    @p_SALDOANTERIORAFAVORFIDUCIA FLOAT,
    @p_NUEVOSALDOENCONTRAGTECH FLOAT,
    @p_NUEVOSALDOENCONTRAFIDUCIA FLOAT,
    @p_NUEVOSALDOAFAVORGTECH FLOAT,
    @p_NUEVOSALDOAFAVORFIDUCIA FLOAT,
    @p_PAGOCOMPLETOGTECH NUMERIC(22,0),
    @p_PAGOCOMPLETOFIDUCIA NUMERIC(22,0),
    @p_PAGOPARCIALGTECH NUMERIC(22,0),
    @p_PAGOPARCIALFIDUCIA NUMERIC(22,0),
    @p_PAGOCOMPLETO NUMERIC(22,0),
    @p_CODMAESTROFACTURACIONTIRILLA NUMERIC(22,0),
    @p_TOTALCOMISION FLOAT,
    @p_CODLINEADENEGOCIODESCUENTO NUMERIC(22,0),
    @p_ID_MAESTROFACTURACIONPDV_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.MAESTROFACTURACIONPDV
        (
            CODCICLOFACTURACIONPDV,
            CODMAESTROFACTURACIONCOMPCONSI,
            CODUSUARIOMODIFICACION,
            CODLINEADENEGOCIO,
            CODPUNTODEVENTA,
            CODMAESTROFACTURACIONTIRILLA,
            CODLINEADENEGOCIODESCUENTO
        )
    VALUES
        (
            @p_CODCICLOFACTURACIONPDV,
            @p_CODMAESTROFACTURACIONCOMPCO2,
            @p_CODUSUARIOMODIFICACION,
            @p_CODLINEADENEGOCIO,
            @p_CODPUNTODEVENTA,
            @p_CODMAESTROFACTURACIONTIRILLA,
            @p_CODLINEADENEGOCIODESCUENTO
        );
       SET
            @p_ID_MAESTROFACTURACIONPDV_out = SCOPE_IDENTITY() ;

    -- Call UPDATE for fields that have database defaults
    IF @p_FECHAHORAMODIFICACION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_ACTIVE IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET ACTIVE = @p_ACTIVE WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_SALDOANTERIORENCONTRAGTECH IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET SALDOANTERIORENCONTRAGTECH = @p_SALDOANTERIORENCONTRAGTECH WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_SALDOANTERIORENCONTRAFIDUCIA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET SALDOANTERIORENCONTRAFIDUCIA = @p_SALDOANTERIORENCONTRAFIDUCIA WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_SALDOANTERIORAFAVORGTECH IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET SALDOANTERIORAFAVORGTECH = @p_SALDOANTERIORAFAVORGTECH WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_SALDOANTERIORAFAVORFIDUCIA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET SALDOANTERIORAFAVORFIDUCIA = @p_SALDOANTERIORAFAVORFIDUCIA WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_NUEVOSALDOENCONTRAGTECH IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET NUEVOSALDOENCONTRAGTECH = @p_NUEVOSALDOENCONTRAGTECH WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_NUEVOSALDOENCONTRAFIDUCIA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET NUEVOSALDOENCONTRAFIDUCIA = @p_NUEVOSALDOENCONTRAFIDUCIA WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_NUEVOSALDOAFAVORGTECH IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET NUEVOSALDOAFAVORGTECH = @p_NUEVOSALDOAFAVORGTECH WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_NUEVOSALDOAFAVORFIDUCIA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET NUEVOSALDOAFAVORFIDUCIA = @p_NUEVOSALDOAFAVORFIDUCIA WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_PAGOCOMPLETOGTECH IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET PAGOCOMPLETOGTECH = @p_PAGOCOMPLETOGTECH WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_PAGOCOMPLETOFIDUCIA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET PAGOCOMPLETOFIDUCIA = @p_PAGOCOMPLETOFIDUCIA WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_PAGOPARCIALGTECH IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET PAGOPARCIALGTECH = @p_PAGOPARCIALGTECH WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_PAGOPARCIALFIDUCIA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET PAGOPARCIALFIDUCIA = @p_PAGOPARCIALFIDUCIA WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_PAGOCOMPLETO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET PAGOCOMPLETO = @p_PAGOCOMPLETO WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
    IF @p_TOTALCOMISION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.MAESTROFACTURACIONPDV SET TOTALCOMISION = @p_TOTALCOMISION WHERE ID_MAESTROFACTURACIONPDV = @p_ID_MAESTROFACTURACIONPDV_out;
    END 
END;
GO

-- Updates a record in the MAESTROFACTURACIONPDV table.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_UpdateRecord(
    @pk_ID_MAESTROFACTURACIONPDV NUMERIC(22,0),
    @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
    @p_CODMAESTROFACTURACIONCOMPCO2 NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_CODLINEADENEGOCIO NUMERIC(22,0),
    @p_CODPUNTODEVENTA NUMERIC(22,0),
    @p_SALDOANTERIORENCONTRAGTECH FLOAT,
    @p_SALDOANTERIORENCONTRAFIDUCIA FLOAT,
    @p_SALDOANTERIORAFAVORGTECH FLOAT,
    @p_SALDOANTERIORAFAVORFIDUCIA FLOAT,
    @p_NUEVOSALDOENCONTRAGTECH FLOAT,
    @p_NUEVOSALDOENCONTRAFIDUCIA FLOAT,
    @p_NUEVOSALDOAFAVORGTECH FLOAT,
    @p_NUEVOSALDOAFAVORFIDUCIA FLOAT,
    @p_PAGOCOMPLETOGTECH NUMERIC(22,0),
    @p_PAGOCOMPLETOFIDUCIA NUMERIC(22,0),
    @p_PAGOPARCIALGTECH NUMERIC(22,0),
    @p_PAGOPARCIALFIDUCIA NUMERIC(22,0),
    @p_PAGOCOMPLETO NUMERIC(22,0),
    @p_CODMAESTROFACTURACIONTIRILLA NUMERIC(22,0),
    @p_TOTALCOMISION FLOAT,
    @p_CODLINEADENEGOCIODESCUENTO NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.MAESTROFACTURACIONPDV
    SET
            CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV,
            CODMAESTROFACTURACIONCOMPCONSI = @p_CODMAESTROFACTURACIONCOMPCO2,
            FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION,
            CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
            ACTIVE = @p_ACTIVE,
            CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO,
            CODPUNTODEVENTA = @p_CODPUNTODEVENTA,
            SALDOANTERIORENCONTRAGTECH = @p_SALDOANTERIORENCONTRAGTECH,
            SALDOANTERIORENCONTRAFIDUCIA = @p_SALDOANTERIORENCONTRAFIDUCIA,
            SALDOANTERIORAFAVORGTECH = @p_SALDOANTERIORAFAVORGTECH,
            SALDOANTERIORAFAVORFIDUCIA = @p_SALDOANTERIORAFAVORFIDUCIA,
            NUEVOSALDOENCONTRAGTECH = @p_NUEVOSALDOENCONTRAGTECH,
            NUEVOSALDOENCONTRAFIDUCIA = @p_NUEVOSALDOENCONTRAFIDUCIA,
            NUEVOSALDOAFAVORGTECH = @p_NUEVOSALDOAFAVORGTECH,
            NUEVOSALDOAFAVORFIDUCIA = @p_NUEVOSALDOAFAVORFIDUCIA,
            PAGOCOMPLETOGTECH = @p_PAGOCOMPLETOGTECH,
            PAGOCOMPLETOFIDUCIA = @p_PAGOCOMPLETOFIDUCIA,
            PAGOPARCIALGTECH = @p_PAGOPARCIALGTECH,
            PAGOPARCIALFIDUCIA = @p_PAGOPARCIALFIDUCIA,
            PAGOCOMPLETO = @p_PAGOCOMPLETO,
            CODMAESTROFACTURACIONTIRILLA = @p_CODMAESTROFACTURACIONTIRILLA,
            TOTALCOMISION = @p_TOTALCOMISION,
            CODLINEADENEGOCIODESCUENTO = @p_CODLINEADENEGOCIODESCUENTO
    WHERE ID_MAESTROFACTURACIONPDV = @pk_ID_MAESTROFACTURACIONPDV;

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

-- Deletes a record from the MAESTROFACTURACIONPDV table.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_DeleteRecord(
    @pk_ID_MAESTROFACTURACIONPDV NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.MAESTROFACTURACIONPDV
    WHERE ID_MAESTROFACTURACIONPDV = @pk_ID_MAESTROFACTURACIONPDV;
END;
GO

-- Deletes the set of rows from the MAESTROFACTURACIONPDV table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_DeleteRecords(
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
'DELETE WSXML_SFG.MAESTROFACTURACIONPDV' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the MAESTROFACTURACIONPDV table.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_GetRecord(
   @pk_ID_MAESTROFACTURACIONPDV NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.MAESTROFACTURACIONPDV
    WHERE ID_MAESTROFACTURACIONPDV = @pk_ID_MAESTROFACTURACIONPDV;

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
        ID_MAESTROFACTURACIONPDV,
        CODCICLOFACTURACIONPDV,
        CODMAESTROFACTURACIONCOMPCONSI,
        FECHAHORAMODIFICACION,
        CODUSUARIOMODIFICACION,
        ACTIVE,
        CODLINEADENEGOCIO,
        CODPUNTODEVENTA,
        SALDOANTERIORENCONTRAGTECH,
        SALDOANTERIORENCONTRAFIDUCIA,
        SALDOANTERIORAFAVORGTECH,
        SALDOANTERIORAFAVORFIDUCIA,
        NUEVOSALDOENCONTRAGTECH,
        NUEVOSALDOENCONTRAFIDUCIA,
        NUEVOSALDOAFAVORGTECH,
        NUEVOSALDOAFAVORFIDUCIA,
        PAGOCOMPLETOGTECH,
        PAGOCOMPLETOFIDUCIA,
        PAGOPARCIALGTECH,
        PAGOPARCIALFIDUCIA,
        PAGOCOMPLETO,
        CODMAESTROFACTURACIONTIRILLA,
        TOTALCOMISION,
        CODLINEADENEGOCIODESCUENTO
    FROM WSXML_SFG.MAESTROFACTURACIONPDV
    WHERE ID_MAESTROFACTURACIONPDV = @pk_ID_MAESTROFACTURACIONPDV;  
END;
GO

-- Returns a query resultset from table MAESTROFACTURACIONPDV
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
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_GetList(
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
    SET @l_from_str = 'WSXML_SFG.MAESTROFACTURACIONPDV MAESTROFACTURACIONPDV_';
    SET @l_alias_str = 'MAESTROFACTURACIONPDV_';

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
        'MAESTROFACTURACIONPDV_.ID_MAESTROFACTURACIONPDV,
            MAESTROFACTURACIONPDV_.CODCICLOFACTURACIONPDV,
            MAESTROFACTURACIONPDV_.CODMAESTROFACTURACIONCOMPCONSI,
            MAESTROFACTURACIONPDV_.FECHAHORAMODIFICACION,
            MAESTROFACTURACIONPDV_.CODUSUARIOMODIFICACION,
            MAESTROFACTURACIONPDV_.ACTIVE,
            MAESTROFACTURACIONPDV_.CODLINEADENEGOCIO,
            MAESTROFACTURACIONPDV_.CODPUNTODEVENTA,
            MAESTROFACTURACIONPDV_.SALDOANTERIORENCONTRAGTECH,
            MAESTROFACTURACIONPDV_.SALDOANTERIORENCONTRAFIDUCIA,
            MAESTROFACTURACIONPDV_.SALDOANTERIORAFAVORGTECH,
            MAESTROFACTURACIONPDV_.SALDOANTERIORAFAVORFIDUCIA,
            MAESTROFACTURACIONPDV_.NUEVOSALDOENCONTRAGTECH,
            MAESTROFACTURACIONPDV_.NUEVOSALDOENCONTRAFIDUCIA,
            MAESTROFACTURACIONPDV_.NUEVOSALDOAFAVORGTECH,
            MAESTROFACTURACIONPDV_.NUEVOSALDOAFAVORFIDUCIA,
            MAESTROFACTURACIONPDV_.PAGOCOMPLETOGTECH,
            MAESTROFACTURACIONPDV_.PAGOCOMPLETOFIDUCIA,
            MAESTROFACTURACIONPDV_.PAGOPARCIALGTECH,
            MAESTROFACTURACIONPDV_.PAGOPARCIALFIDUCIA,
            MAESTROFACTURACIONPDV_.PAGOCOMPLETO,
            MAESTROFACTURACIONPDV_.CODMAESTROFACTURACIONTIRILLA,
            MAESTROFACTURACIONPDV_.TOTALCOMISION,
            MAESTROFACTURACIONPDV_.CODLINEADENEGOCIODESCUENTO';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY MAESTROFACTURACIONPDV_.ID_MAESTROFACTURACIONPDV ASC ';

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

-- Returns a query result from table MAESTROFACTURACIONPDV
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.MAESTROFACTURACIONPDV MAESTROFACTURACIONPDV_';
    SET @l_alias_str = 'MAESTROFACTURACIONPDV_';

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

-- Returns a query result from table MAESTROFACTURACIONPDV
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.MAESTROFACTURACIONPDV MAESTROFACTURACIONPDV_';
    SET @l_alias_str = 'MAESTROFACTURACIONPDV_';

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
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBMAESTROFACTURACIONP_Export(
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
                '''XID_MAESTROFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'CODCICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'CODMAESTROFACTURACIONCOMPCONSI' + isnull(@p_separator_str, '') +
                'CODMAESTROFACTURACIONCOMPCONSI REFERENCIAGTECH' + isnull(@p_separator_str, '') +
                'FECHAHORAMODIFICACION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION' + isnull(@p_separator_str, '') +
                'ACTIVE' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO NOMLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'SALDOANTERIORENCONTRAGTECH' + isnull(@p_separator_str, '') +
                'SALDOANTERIORENCONTRAFIDUCIA' + isnull(@p_separator_str, '') +
                'SALDOANTERIORAFAVORGTECH' + isnull(@p_separator_str, '') +
                'SALDOANTERIORAFAVORFIDUCIA' + isnull(@p_separator_str, '') +
                'NUEVOSALDOENCONTRAGTECH' + isnull(@p_separator_str, '') +
                'NUEVOSALDOENCONTRAFIDUCIA' + isnull(@p_separator_str, '') +
                'NUEVOSALDOAFAVORGTECH' + isnull(@p_separator_str, '') +
                'NUEVOSALDOAFAVORFIDUCIA' + isnull(@p_separator_str, '') +
                'PAGOCOMPLETOGTECH' + isnull(@p_separator_str, '') +
                'PAGOCOMPLETOFIDUCIA' + isnull(@p_separator_str, '') +
                'PAGOPARCIALGTECH' + isnull(@p_separator_str, '') +
                'PAGOPARCIALFIDUCIA' + isnull(@p_separator_str, '') +
                'PAGOCOMPLETO' + isnull(@p_separator_str, '') +
                'CODMAESTROFACTURACIONTIRILLA' + isnull(@p_separator_str, '') +
                'CODMAESTROFACTURACIONTIRILLA RUTAGENERADO' + isnull(@p_separator_str, '') +
                'TOTALCOMISION' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIODESCUENTO' + ' ''';
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
                ' isnull(CAST(MAESTROFACTURACIONPDV_.ID_MAESTROFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.CODCICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.CODMAESTROFACTURACIONCOMPCONSI AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.REFERENCIAGTECH, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(MAESTROFACTURACIONPDV_.FECHAHORAMODIFICACION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.CODUSUARIOMODIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(MAESTROFACTURACIONPDV_.ACTIVE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.CODLINEADENEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMLINEADENEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.CODPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t2.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(MAESTROFACTURACIONPDV_.SALDOANTERIORENCONTRAGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.SALDOANTERIORENCONTRAFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(MAESTROFACTURACIONPDV_.SALDOANTERIORAFAVORGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.SALDOANTERIORAFAVORFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(MAESTROFACTURACIONPDV_.NUEVOSALDOENCONTRAGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.NUEVOSALDOENCONTRAFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(MAESTROFACTURACIONPDV_.NUEVOSALDOAFAVORGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.NUEVOSALDOAFAVORFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(MAESTROFACTURACIONPDV_.PAGOCOMPLETOGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.PAGOCOMPLETOFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(MAESTROFACTURACIONPDV_.PAGOPARCIALGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.PAGOPARCIALFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(MAESTROFACTURACIONPDV_.PAGOCOMPLETO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.CODMAESTROFACTURACIONTIRILLA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.RUTAGENERADO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(MAESTROFACTURACIONPDV_.TOTALCOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(MAESTROFACTURACIONPDV_.CODLINEADENEGOCIODESCUENTO AS VARCHAR(MAX)), '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.MAESTROFACTURACIONPDV MAESTROFACTURACIONPDV_ LEFT OUTER JOIN WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG t0 ON (MAESTROFACTURACIONPDV_.CODMAESTROFACTURACIONCOMPCONSI =  t0.ID_MAESTROFACTCOMPCONSIG) LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO t1 ON (MAESTROFACTURACIONPDV_.CODLINEADENEGOCIO =  t1.ID_LINEADENEGOCIO) LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA t2 ON (MAESTROFACTURACIONPDV_.CODPUNTODEVENTA =  t2.ID_PUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.MAESTROFACTURACIONTIRILLA t3 ON (MAESTROFACTURACIONPDV_.CODMAESTROFACTURACIONTIRILLA =  t3.ID_MAESTROFACTURACIONTIRILLA)';

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






