USE SFGPRODU;
--  DDL for Package Body SFGWEBPUNTODEVENTA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBPUNTODEVENTA */ 

-- Creates a new record in the PUNTODEVENTA table
IF OBJECT_ID('WSXML_SFG.SFGWEBPUNTODEVENTA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_AddRecord(
    @p_ID_PUNTODEVENTA NUMERIC(22,0),
    @p_CODIGOGTECHPUNTODEVENTA NVARCHAR(2000),
    @p_NUMEROTERMINAL NVARCHAR(2000),
    @p_NOMPUNTODEVENTA NVARCHAR(2000),
    @p_CODCIUDAD NUMERIC(22,0),
    @p_TELEFONO NVARCHAR(2000),
    @p_DIRECCION NVARCHAR(2000),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_NUMEROLINEA NVARCHAR(2000),
    @p_NUMERODROP NVARCHAR(2000),
    @p_CODTIPOESTACION NUMERIC(22,0),
    @p_CODPUERTOTERMINAL NUMERIC(22,0),
    @p_CODTIPONEGOCIO NUMERIC(22,0),
    @p_CODRUTAPDV NUMERIC(22,0),
    @p_CODREDPDV NUMERIC(22,0),
    @p_CUPOINICIAL FLOAT,
    @p_CODTIPOTERMINAL NUMERIC(22,0),
    @p_NOMBRENODO NVARCHAR(2000),
    @p_ADDRESSNODO NVARCHAR(2000),
    @p_CODREGIONAL NUMERIC(22,0),
    @p_SLIPXML NUMERIC(22,0),
    @p_PUERTOESTACION NVARCHAR(2000),
    @p_CODREGIMEN NUMERIC(22,0),
    @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_IDENTIFICACION NUMERIC(22,0),
    @p_DIGITOVERIFICACION NUMERIC(22,0),
    @p_CODRAZONSOCIAL NUMERIC(22,0),
    @p_BARRIO NVARCHAR(2000)
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.PUNTODEVENTA
        (
            --ID_PUNTODEVENTA,
            CODIGOGTECHPUNTODEVENTA,
            NUMEROTERMINAL,
            NOMPUNTODEVENTA,
            CODCIUDAD,
            TELEFONO,
            DIRECCION,
            CODUSUARIOMODIFICACION,
            NUMEROLINEA,
            NUMERODROP,
            CODTIPOESTACION,
            CODPUERTOTERMINAL,
            CODTIPONEGOCIO,
            CODRUTAPDV,
            CODREDPDV,
            CODTIPOTERMINAL,
            NOMBRENODO,
            ADDRESSNODO,
            CODREGIONAL,
            PUERTOESTACION,
            CODREGIMEN,
            CODAGRUPACIONPUNTODEVENTA,
            IDENTIFICACION,
            DIGITOVERIFICACION,
            CODRAZONSOCIAL,
            BARRIO
        )
    VALUES
        (
            --@p_ID_PUNTODEVENTA,
            @p_CODIGOGTECHPUNTODEVENTA,
            @p_NUMEROTERMINAL,
            @p_NOMPUNTODEVENTA,
            @p_CODCIUDAD,
            @p_TELEFONO,
            @p_DIRECCION,
            @p_CODUSUARIOMODIFICACION,
            @p_NUMEROLINEA,
            @p_NUMERODROP,
            @p_CODTIPOESTACION,
            @p_CODPUERTOTERMINAL,
            @p_CODTIPONEGOCIO,
            @p_CODRUTAPDV,
            @p_CODREDPDV,
            @p_CODTIPOTERMINAL,
            @p_NOMBRENODO,
            @p_ADDRESSNODO,
            @p_CODREGIONAL,
            @p_PUERTOESTACION,
            @p_CODREGIMEN,
            @p_CODAGRUPACIONPUNTODEVENTA,
            @p_IDENTIFICACION,
            @p_DIGITOVERIFICACION,
            @p_CODRAZONSOCIAL,
            @p_BARRIO
        );

    -- Call UPDATE for fields that have database defaults
    IF @p_FECHAHORAMODIFICACION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.PUNTODEVENTA SET FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION WHERE ID_PUNTODEVENTA = @p_ID_PUNTODEVENTA;
    END 
    IF @p_ACTIVE IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.PUNTODEVENTA SET ACTIVE = @p_ACTIVE WHERE ID_PUNTODEVENTA = @p_ID_PUNTODEVENTA;
    END 
    IF @p_CUPOINICIAL IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.PUNTODEVENTA SET CUPOINICIAL = @p_CUPOINICIAL WHERE ID_PUNTODEVENTA = @p_ID_PUNTODEVENTA;
    END 
    IF @p_SLIPXML IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.PUNTODEVENTA SET SLIPXML = @p_SLIPXML WHERE ID_PUNTODEVENTA = @p_ID_PUNTODEVENTA;
    END 
END;
GO

-- Updates a record in the PUNTODEVENTA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBPUNTODEVENTA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_UpdateRecord(
        @p_ID_PUNTODEVENTA NUMERIC(22,0),
@pk_ID_PUNTODEVENTA NUMERIC(22,0),
    @p_CODIGOGTECHPUNTODEVENTA NVARCHAR(2000),
    @p_NUMEROTERMINAL NVARCHAR(2000),
    @p_NOMPUNTODEVENTA NVARCHAR(2000),
    @p_CODCIUDAD NUMERIC(22,0),
    @p_TELEFONO NVARCHAR(2000),
    @p_DIRECCION NVARCHAR(2000),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_NUMEROLINEA NVARCHAR(2000),
    @p_NUMERODROP NVARCHAR(2000),
    @p_CODTIPOESTACION NUMERIC(22,0),
    @p_CODPUERTOTERMINAL NUMERIC(22,0),
    @p_CODTIPONEGOCIO NUMERIC(22,0),
    @p_CODRUTAPDV NUMERIC(22,0),
    @p_CODREDPDV NUMERIC(22,0),
    @p_CUPOINICIAL FLOAT,
    @p_CODTIPOTERMINAL NUMERIC(22,0),
    @p_NOMBRENODO NVARCHAR(2000),
    @p_ADDRESSNODO NVARCHAR(2000),
    @p_CODREGIONAL NUMERIC(22,0),
    @p_SLIPXML NUMERIC(22,0),
    @p_PUERTOESTACION NVARCHAR(2000),
    @p_CODREGIMEN NUMERIC(22,0),
    @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_IDENTIFICACION NUMERIC(22,0),
    @p_DIGITOVERIFICACION NUMERIC(22,0),
    @p_CODRAZONSOCIAL NUMERIC(22,0),
    @p_BARRIO NVARCHAR(2000)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.PUNTODEVENTA
    SET
           -- ID_PUNTODEVENTA = @p_ID_PUNTODEVENTA,
            CODIGOGTECHPUNTODEVENTA = @p_CODIGOGTECHPUNTODEVENTA,
            NUMEROTERMINAL = @p_NUMEROTERMINAL,
            NOMPUNTODEVENTA = @p_NOMPUNTODEVENTA,
            CODCIUDAD = @p_CODCIUDAD,
            TELEFONO = @p_TELEFONO,
            DIRECCION = @p_DIRECCION,
            FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION,
            CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
            ACTIVE = @p_ACTIVE,
            NUMEROLINEA = @p_NUMEROLINEA,
            NUMERODROP = @p_NUMERODROP,
            CODTIPOESTACION = @p_CODTIPOESTACION,
            CODPUERTOTERMINAL = @p_CODPUERTOTERMINAL,
            CODTIPONEGOCIO = @p_CODTIPONEGOCIO,
            CODRUTAPDV = @p_CODRUTAPDV,
            CODREDPDV = @p_CODREDPDV,
            CUPOINICIAL = @p_CUPOINICIAL,
            CODTIPOTERMINAL = @p_CODTIPOTERMINAL,
            NOMBRENODO = @p_NOMBRENODO,
            ADDRESSNODO = @p_ADDRESSNODO,
            CODREGIONAL = @p_CODREGIONAL,
            SLIPXML = @p_SLIPXML,
            PUERTOESTACION = @p_PUERTOESTACION,
            CODREGIMEN = @p_CODREGIMEN,
            CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA,
            IDENTIFICACION = @p_IDENTIFICACION,
            DIGITOVERIFICACION = @p_DIGITOVERIFICACION,
            CODRAZONSOCIAL = @p_CODRAZONSOCIAL,
            BARRIO = @p_BARRIO
    WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;

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

-- Deletes a record from the PUNTODEVENTA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBPUNTODEVENTA_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_DeleteRecord(
    @pk_ID_PUNTODEVENTA NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.PUNTODEVENTA
    WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;
END;
GO

-- Deletes the set of rows from the PUNTODEVENTA table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBPUNTODEVENTA_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_DeleteRecords(
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
'DELETE WSXML_SFG.PUNTODEVENTA' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the PUNTODEVENTA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBPUNTODEVENTA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_GetRecord(
   @pk_ID_PUNTODEVENTA NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.PUNTODEVENTA
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
        TELEFONO,
        DIRECCION,
        FECHAHORAMODIFICACION,
        CODUSUARIOMODIFICACION,
        ACTIVE,
        NUMEROLINEA,
        NUMERODROP,
        CODTIPOESTACION,
        CODPUERTOTERMINAL,
        CODTIPONEGOCIO,
        CODRUTAPDV,
        CODREDPDV,
        CUPOINICIAL,
        CODTIPOTERMINAL,
        NOMBRENODO,
        ADDRESSNODO,
        CODREGIONAL,
        SLIPXML,
        PUERTOESTACION,
        CODREGIMEN,
        CODAGRUPACIONPUNTODEVENTA,
        IDENTIFICACION,
        DIGITOVERIFICACION,
        CODRAZONSOCIAL,
        BARRIO
    FROM WSXML_SFG.PUNTODEVENTA
    WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;  
END;
GO

-- Returns a query resultset from table PUNTODEVENTA
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
IF OBJECT_ID('WSXML_SFG.SFGWEBPUNTODEVENTA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_GetList(
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
    SET @l_from_str = 'WSXML_SFG.PUNTODEVENTA PUNTODEVENTA_';
    SET @l_alias_str = 'PUNTODEVENTA_';

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
        'PUNTODEVENTA_.ID_PUNTODEVENTA,
            PUNTODEVENTA_.CODIGOGTECHPUNTODEVENTA,
            PUNTODEVENTA_.NUMEROTERMINAL,
            PUNTODEVENTA_.NOMPUNTODEVENTA,
            PUNTODEVENTA_.CODCIUDAD,
            PUNTODEVENTA_.TELEFONO,
            PUNTODEVENTA_.DIRECCION,
            PUNTODEVENTA_.FECHAHORAMODIFICACION,
            PUNTODEVENTA_.CODUSUARIOMODIFICACION,
            PUNTODEVENTA_.ACTIVE,
            PUNTODEVENTA_.NUMEROLINEA,
            PUNTODEVENTA_.NUMERODROP,
            PUNTODEVENTA_.CODTIPOESTACION,
            PUNTODEVENTA_.CODPUERTOTERMINAL,
            PUNTODEVENTA_.CODTIPONEGOCIO,
            PUNTODEVENTA_.CODRUTAPDV,
            PUNTODEVENTA_.CODREDPDV,
            PUNTODEVENTA_.CUPOINICIAL,
            PUNTODEVENTA_.CODTIPOTERMINAL,
            PUNTODEVENTA_.NOMBRENODO,
            PUNTODEVENTA_.ADDRESSNODO,
            PUNTODEVENTA_.CODREGIONAL,
            PUNTODEVENTA_.SLIPXML,
            PUNTODEVENTA_.PUERTOESTACION,
            PUNTODEVENTA_.CODREGIMEN,
            PUNTODEVENTA_.CODAGRUPACIONPUNTODEVENTA,
            PUNTODEVENTA_.IDENTIFICACION,
            PUNTODEVENTA_.DIGITOVERIFICACION,
            PUNTODEVENTA_.CODRAZONSOCIAL,
            PUNTODEVENTA_.BARRIO';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY PUNTODEVENTA_.ID_PUNTODEVENTA ASC ';

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

-- Returns a query result from table PUNTODEVENTA
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBPUNTODEVENTA_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.PUNTODEVENTA PUNTODEVENTA_';
    SET @l_alias_str = 'PUNTODEVENTA_';

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

-- Returns a query result from table PUNTODEVENTA
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBPUNTODEVENTA_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.PUNTODEVENTA PUNTODEVENTA_';
    SET @l_alias_str = 'PUNTODEVENTA_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBPUNTODEVENTA_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPUNTODEVENTA_Export(
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
                'TELEFONO' + isnull(@p_separator_str, '') +
                'DIRECCION' + isnull(@p_separator_str, '') +
                'FECHAHORAMODIFICACION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION' + isnull(@p_separator_str, '') +
                'ACTIVE' + isnull(@p_separator_str, '') +
                'NUMEROLINEA' + isnull(@p_separator_str, '') +
                'NUMERODROP' + isnull(@p_separator_str, '') +
                'CODTIPOESTACION' + isnull(@p_separator_str, '') +
                'CODTIPOESTACION NOMTIPOESTACION' + isnull(@p_separator_str, '') +
                'CODPUERTOTERMINAL' + isnull(@p_separator_str, '') +
                'CODPUERTOTERMINAL NOMPUERTOTERMINAL' + isnull(@p_separator_str, '') +
                'CODTIPONEGOCIO' + isnull(@p_separator_str, '') +
                'CODTIPONEGOCIO NOMTIPONEGOCIO' + isnull(@p_separator_str, '') +
                'CODRUTAPDV' + isnull(@p_separator_str, '') +
                'CODRUTAPDV NOMRUTAPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV NOMREDPDV' + isnull(@p_separator_str, '') +
                'CUPOINICIAL' + isnull(@p_separator_str, '') +
                'CODTIPOTERMINAL' + isnull(@p_separator_str, '') +
                'CODTIPOTERMINAL NOMTIPOTERMINAL' + isnull(@p_separator_str, '') +
                'NOMBRENODO' + isnull(@p_separator_str, '') +
                'ADDRESSNODO' + isnull(@p_separator_str, '') +
                'CODREGIONAL' + isnull(@p_separator_str, '') +
                'CODREGIONAL NOMREGIONAL' + isnull(@p_separator_str, '') +
                'SLIPXML' + isnull(@p_separator_str, '') +
                'PUERTOESTACION' + isnull(@p_separator_str, '') +
                'CODREGIMEN' + isnull(@p_separator_str, '') +
                'CODREGIMEN NOMREGIMEN' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'IDENTIFICACION' + isnull(@p_separator_str, '') +
                'DIGITOVERIFICACION' + isnull(@p_separator_str, '') +
                'CODRAZONSOCIAL' + isnull(@p_separator_str, '') +
                'CODRAZONSOCIAL NOMRAZONSOCIAL' + isnull(@p_separator_str, '') +
                'BARRIO' + ' ''';
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
                ' isnull(CAST(PUNTODEVENTA_.ID_PUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(PUNTODEVENTA_.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.NUMEROTERMINAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.NOMPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODCIUDAD AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMCIUDAD, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.TELEFONO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.DIRECCION, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(PUNTODEVENTA_.FECHAHORAMODIFICACION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODUSUARIOMODIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(PUNTODEVENTA_.ACTIVE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.NUMEROLINEA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.NUMERODROP, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODTIPOESTACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMTIPOESTACION, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODPUERTOTERMINAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMPUERTOTERMINAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODTIPONEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMTIPONEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODRUTAPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t4.NOMRUTAPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODREDPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t5.NOMREDPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(PUNTODEVENTA_.CUPOINICIAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODTIPOTERMINAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t6.NOMTIPOTERMINAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.NOMBRENODO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.ADDRESSNODO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODREGIONAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t7.NOMREGIONAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(PUNTODEVENTA_.SLIPXML, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.PUERTOESTACION, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODREGIMEN AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t8.NOMREGIMEN, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODAGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t9.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.IDENTIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(PUNTODEVENTA_.DIGITOVERIFICACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PUNTODEVENTA_.CODRAZONSOCIAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t10.NOMRAZONSOCIAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PUNTODEVENTA_.BARRIO, ''''), '''', '''') + ''''  + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.PUNTODEVENTA PUNTODEVENTA_ LEFT OUTER JOIN WSXML_SFG.CIUDAD t0 ON (PUNTODEVENTA_.CODCIUDAD =  t0.ID_CIUDAD) LEFT OUTER JOIN WSXML_SFG.TIPOESTACION t1 ON (PUNTODEVENTA_.CODTIPOESTACION =  t1.ID_TIPOESTACION) LEFT OUTER JOIN WSXML_SFG.PUERTOTERMINAL t2 ON (PUNTODEVENTA_.CODPUERTOTERMINAL =  t2.ID_PUERTOTERMINAL) LEFT OUTER JOIN WSXML_SFG.TIPONEGOCIO t3 ON (PUNTODEVENTA_.CODTIPONEGOCIO =  t3.ID_TIPONEGOCIO) LEFT OUTER JOIN WSXML_SFG.RUTAPDV t4 ON (PUNTODEVENTA_.CODRUTAPDV =  t4.ID_RUTAPDV) LEFT OUTER JOIN WSXML_SFG.REDPDV t5 ON (PUNTODEVENTA_.CODREDPDV =  t5.ID_REDPDV) LEFT OUTER JOIN WSXML_SFG.TIPOTERMINAL t6 ON (PUNTODEVENTA_.CODTIPOTERMINAL =  t6.ID_TIPOTERMINAL) LEFT OUTER JOIN WSXML_SFG.REGIONAL t7 ON (PUNTODEVENTA_.CODREGIONAL =  t7.ID_REGIONAL) LEFT OUTER JOIN WSXML_SFG.REGIMEN t8 ON (PUNTODEVENTA_.CODREGIMEN =  t8.ID_REGIMEN) LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA t9 ON (PUNTODEVENTA_.CODAGRUPACIONPUNTODEVENTA =  t9.ID_AGRUPACIONPUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.RAZONSOCIAL t10 ON (PUNTODEVENTA_.CODRAZONSOCIAL =  t10.ID_RAZONSOCIAL)';

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






