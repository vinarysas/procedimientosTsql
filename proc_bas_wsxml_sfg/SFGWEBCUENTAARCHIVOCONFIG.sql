USE SFGPRODU;
--  DDL for Package Body SFGWEBCUENTAARCHIVOCONFIG
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG */ 

-- Creates a new record in the CUENTAARCHIVOCONFIG table
IF OBJECT_ID('WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_AddRecord(
    @p_CODCUENTA NUMERIC(22,0),
    @p_FECHADIAPOSICION NUMERIC(22,0),
    @p_FECHADIATAMANO NUMERIC(22,0),
    @p_FECHAMESPOSICION NUMERIC(22,0),
    @p_FECHAMESTAMANO NUMERIC(22,0),
    @p_FECHAANOPOSICION NUMERIC(22,0),
    @p_FECHAANOTAMANO NUMERIC(22,0),
    @p_VALORTRANSACCIONPOSICION NUMERIC(22,0),
    @p_VALORTRANSACCIONTAMANO NUMERIC(22,0),
    @p_REFERENCIAPOSICION NUMERIC(22,0),
    @p_REFERENCIATAMANO NUMERIC(22,0),
    @p_REFERENCIATAMANOMOVIMIENTO NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_PREFIJOARCHIVO NVARCHAR(2000),
    @p_ARCHIVOACUMULADO NUMERIC(22,0),
    @p_CODPERIODICIDADPAGO NUMERIC(22,0),
    @p_CABECERA NUMERIC(22,0),
    @p_VALORTRANSACCIONTAMANODEC NUMERIC(22,0),
    @p_CABFECHADIAPOSICION NUMERIC(22,0),
    @p_CABFECHADIATAMANO NUMERIC(22,0),
    @p_CABFECHAMESPOSICION NUMERIC(22,0),
    @p_CABFECHAMESTAMANO NUMERIC(22,0),
    @p_CABFECHAANOPOSICION NUMERIC(22,0),
    @p_CABFECHAANOTAMANO NUMERIC(22,0),
    @p_CABVALORCONTROLPOSICION NUMERIC(22,0),
    @p_CABVALORCONTROLTAMANO NUMERIC(22,0),
    @p_CABREGISTROSPOSICION NUMERIC(22,0),
    @p_CABREGISTROSTAMANO NUMERIC(22,0),
    @p_CABVALORCONTROLTAMANODEC NUMERIC(22,0),
    @p_ID_CUENTAARCHIVOCONFIG_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.CUENTAARCHIVOCONFIG
        (
            CODCUENTA,
            CODUSUARIOMODIFICACION,
            PREFIJOARCHIVO,
            CODPERIODICIDADPAGO
        )
    VALUES
        (
            @p_CODCUENTA,
            @p_CODUSUARIOMODIFICACION,
            @p_PREFIJOARCHIVO,
            @p_CODPERIODICIDADPAGO
        );
       SET
            @p_ID_CUENTAARCHIVOCONFIG_out = SCOPE_IDENTITY() ;

    -- Call UPDATE for fields that have database defaults
    IF @p_FECHADIAPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET FECHADIAPOSICION = @p_FECHADIAPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_FECHADIATAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET FECHADIATAMANO = @p_FECHADIATAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_FECHAMESPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET FECHAMESPOSICION = @p_FECHAMESPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_FECHAMESTAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET FECHAMESTAMANO = @p_FECHAMESTAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_FECHAANOPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET FECHAANOPOSICION = @p_FECHAANOPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_FECHAANOTAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET FECHAANOTAMANO = @p_FECHAANOTAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_VALORTRANSACCIONPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET VALORTRANSACCIONPOSICION = @p_VALORTRANSACCIONPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_VALORTRANSACCIONTAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET VALORTRANSACCIONTAMANO = @p_VALORTRANSACCIONTAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_REFERENCIAPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET REFERENCIAPOSICION = @p_REFERENCIAPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_REFERENCIATAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET REFERENCIATAMANO = @p_REFERENCIATAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_REFERENCIATAMANOMOVIMIENTO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET REFERENCIATAMANOMOVIMIENTO = @p_REFERENCIATAMANOMOVIMIENTO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_FECHAHORAMODIFICACION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_ACTIVE IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET ACTIVE = @p_ACTIVE WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_ARCHIVOACUMULADO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET ARCHIVOACUMULADO = @p_ARCHIVOACUMULADO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABECERA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABECERA = @p_CABECERA WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_VALORTRANSACCIONTAMANODEC IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET VALORTRANSACCIONTAMANODEC = @p_VALORTRANSACCIONTAMANODEC WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABFECHADIAPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABFECHADIAPOSICION = @p_CABFECHADIAPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABFECHADIATAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABFECHADIATAMANO = @p_CABFECHADIATAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABFECHAMESPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABFECHAMESPOSICION = @p_CABFECHAMESPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABFECHAMESTAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABFECHAMESTAMANO = @p_CABFECHAMESTAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABFECHAANOPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABFECHAANOPOSICION = @p_CABFECHAANOPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABFECHAANOTAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABFECHAANOTAMANO = @p_CABFECHAANOTAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABVALORCONTROLPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABVALORCONTROLPOSICION = @p_CABVALORCONTROLPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABVALORCONTROLTAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABVALORCONTROLTAMANO = @p_CABVALORCONTROLTAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABREGISTROSPOSICION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABREGISTROSPOSICION = @p_CABREGISTROSPOSICION WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABREGISTROSTAMANO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABREGISTROSTAMANO = @p_CABREGISTROSTAMANO WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
    IF @p_CABVALORCONTROLTAMANODEC IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG SET CABVALORCONTROLTAMANODEC = @p_CABVALORCONTROLTAMANODEC WHERE ID_CUENTAARCHIVOCONFIG = @p_ID_CUENTAARCHIVOCONFIG_out;
    END 
END;
GO

-- Updates a record in the CUENTAARCHIVOCONFIG table.
IF OBJECT_ID('WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_UpdateRecord(
    @pk_ID_CUENTAARCHIVOCONFIG NUMERIC(22,0),
    @p_CODCUENTA NUMERIC(22,0),
    @p_FECHADIAPOSICION NUMERIC(22,0),
    @p_FECHADIATAMANO NUMERIC(22,0),
    @p_FECHAMESPOSICION NUMERIC(22,0),
    @p_FECHAMESTAMANO NUMERIC(22,0),
    @p_FECHAANOPOSICION NUMERIC(22,0),
    @p_FECHAANOTAMANO NUMERIC(22,0),
    @p_VALORTRANSACCIONPOSICION NUMERIC(22,0),
    @p_VALORTRANSACCIONTAMANO NUMERIC(22,0),
    @p_REFERENCIAPOSICION NUMERIC(22,0),
    @p_REFERENCIATAMANO NUMERIC(22,0),
    @p_REFERENCIATAMANOMOVIMIENTO NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_PREFIJOARCHIVO NVARCHAR(2000),
    @p_ARCHIVOACUMULADO NUMERIC(22,0),
    @p_CODPERIODICIDADPAGO NUMERIC(22,0),
    @p_CABECERA NUMERIC(22,0),
    @p_VALORTRANSACCIONTAMANODEC NUMERIC(22,0),
    @p_CABFECHADIAPOSICION NUMERIC(22,0),
    @p_CABFECHADIATAMANO NUMERIC(22,0),
    @p_CABFECHAMESPOSICION NUMERIC(22,0),
    @p_CABFECHAMESTAMANO NUMERIC(22,0),
    @p_CABFECHAANOPOSICION NUMERIC(22,0),
    @p_CABFECHAANOTAMANO NUMERIC(22,0),
    @p_CABVALORCONTROLPOSICION NUMERIC(22,0),
    @p_CABVALORCONTROLTAMANO NUMERIC(22,0),
    @p_CABREGISTROSPOSICION NUMERIC(22,0),
    @p_CABREGISTROSTAMANO NUMERIC(22,0),
    @p_CABVALORCONTROLTAMANODEC NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.CUENTAARCHIVOCONFIG
    SET
            CODCUENTA = @p_CODCUENTA,
            FECHADIAPOSICION = @p_FECHADIAPOSICION,
            FECHADIATAMANO = @p_FECHADIATAMANO,
            FECHAMESPOSICION = @p_FECHAMESPOSICION,
            FECHAMESTAMANO = @p_FECHAMESTAMANO,
            FECHAANOPOSICION = @p_FECHAANOPOSICION,
            FECHAANOTAMANO = @p_FECHAANOTAMANO,
            VALORTRANSACCIONPOSICION = @p_VALORTRANSACCIONPOSICION,
            VALORTRANSACCIONTAMANO = @p_VALORTRANSACCIONTAMANO,
            REFERENCIAPOSICION = @p_REFERENCIAPOSICION,
            REFERENCIATAMANO = @p_REFERENCIATAMANO,
            REFERENCIATAMANOMOVIMIENTO = @p_REFERENCIATAMANOMOVIMIENTO,
            FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION,
            CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
            ACTIVE = @p_ACTIVE,
            PREFIJOARCHIVO = @p_PREFIJOARCHIVO,
            ARCHIVOACUMULADO = @p_ARCHIVOACUMULADO,
            CODPERIODICIDADPAGO = @p_CODPERIODICIDADPAGO,
            CABECERA = @p_CABECERA,
            VALORTRANSACCIONTAMANODEC = @p_VALORTRANSACCIONTAMANODEC,
            CABFECHADIAPOSICION = @p_CABFECHADIAPOSICION,
            CABFECHADIATAMANO = @p_CABFECHADIATAMANO,
            CABFECHAMESPOSICION = @p_CABFECHAMESPOSICION,
            CABFECHAMESTAMANO = @p_CABFECHAMESTAMANO,
            CABFECHAANOPOSICION = @p_CABFECHAANOPOSICION,
            CABFECHAANOTAMANO = @p_CABFECHAANOTAMANO,
            CABVALORCONTROLPOSICION = @p_CABVALORCONTROLPOSICION,
            CABVALORCONTROLTAMANO = @p_CABVALORCONTROLTAMANO,
            CABREGISTROSPOSICION = @p_CABREGISTROSPOSICION,
            CABREGISTROSTAMANO = @p_CABREGISTROSTAMANO,
            CABVALORCONTROLTAMANODEC = @p_CABVALORCONTROLTAMANODEC
    WHERE ID_CUENTAARCHIVOCONFIG = @pk_ID_CUENTAARCHIVOCONFIG;

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

-- Deletes a record from the CUENTAARCHIVOCONFIG table.
IF OBJECT_ID('WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_DeleteRecord(
    @pk_ID_CUENTAARCHIVOCONFIG NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.CUENTAARCHIVOCONFIG
    WHERE ID_CUENTAARCHIVOCONFIG = @pk_ID_CUENTAARCHIVOCONFIG;
END;
GO

-- Deletes the set of rows from the CUENTAARCHIVOCONFIG table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_DeleteRecords(
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
'DELETE WSXML_SFG.CUENTAARCHIVOCONFIG' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the CUENTAARCHIVOCONFIG table.
IF OBJECT_ID('WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_GetRecord(
   @pk_ID_CUENTAARCHIVOCONFIG NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.CUENTAARCHIVOCONFIG
    WHERE ID_CUENTAARCHIVOCONFIG = @pk_ID_CUENTAARCHIVOCONFIG;

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
        ID_CUENTAARCHIVOCONFIG,
        CODCUENTA,
        FECHADIAPOSICION,
        FECHADIATAMANO,
        FECHAMESPOSICION,
        FECHAMESTAMANO,
        FECHAANOPOSICION,
        FECHAANOTAMANO,
        VALORTRANSACCIONPOSICION,
        VALORTRANSACCIONTAMANO,
        REFERENCIAPOSICION,
        REFERENCIATAMANO,
        REFERENCIATAMANOMOVIMIENTO,
        FECHAHORAMODIFICACION,
        CODUSUARIOMODIFICACION,
        ACTIVE,
        PREFIJOARCHIVO,
        ARCHIVOACUMULADO,
        CODPERIODICIDADPAGO,
        CABECERA,
        VALORTRANSACCIONTAMANODEC,
        CABFECHADIAPOSICION,
        CABFECHADIATAMANO,
        CABFECHAMESPOSICION,
        CABFECHAMESTAMANO,
        CABFECHAANOPOSICION,
        CABFECHAANOTAMANO,
        CABVALORCONTROLPOSICION,
        CABVALORCONTROLTAMANO,
        CABREGISTROSPOSICION,
        CABREGISTROSTAMANO,
        CABVALORCONTROLTAMANODEC
    FROM WSXML_SFG.CUENTAARCHIVOCONFIG
    WHERE ID_CUENTAARCHIVOCONFIG = @pk_ID_CUENTAARCHIVOCONFIG;  
END;
GO

-- Returns a query resultset from table CUENTAARCHIVOCONFIG
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
IF OBJECT_ID('WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_GetList(
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
    SET @l_from_str = 'WSXML_SFG.CUENTAARCHIVOCONFIG CUENTAARCHIVOCONFIG_';
    SET @l_alias_str = 'CUENTAARCHIVOCONFIG_';

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
        'CUENTAARCHIVOCONFIG_.ID_CUENTAARCHIVOCONFIG,
            CUENTAARCHIVOCONFIG_.CODCUENTA,
            CUENTAARCHIVOCONFIG_.FECHADIAPOSICION,
            CUENTAARCHIVOCONFIG_.FECHADIATAMANO,
            CUENTAARCHIVOCONFIG_.FECHAMESPOSICION,
            CUENTAARCHIVOCONFIG_.FECHAMESTAMANO,
            CUENTAARCHIVOCONFIG_.FECHAANOPOSICION,
            CUENTAARCHIVOCONFIG_.FECHAANOTAMANO,
            CUENTAARCHIVOCONFIG_.VALORTRANSACCIONPOSICION,
            CUENTAARCHIVOCONFIG_.VALORTRANSACCIONTAMANO,
            CUENTAARCHIVOCONFIG_.REFERENCIAPOSICION,
            CUENTAARCHIVOCONFIG_.REFERENCIATAMANO,
            CUENTAARCHIVOCONFIG_.REFERENCIATAMANOMOVIMIENTO,
            CUENTAARCHIVOCONFIG_.FECHAHORAMODIFICACION,
            CUENTAARCHIVOCONFIG_.CODUSUARIOMODIFICACION,
            CUENTAARCHIVOCONFIG_.ACTIVE,
            CUENTAARCHIVOCONFIG_.PREFIJOARCHIVO,
            CUENTAARCHIVOCONFIG_.ARCHIVOACUMULADO,
            CUENTAARCHIVOCONFIG_.CODPERIODICIDADPAGO,
            CUENTAARCHIVOCONFIG_.CABECERA,
            CUENTAARCHIVOCONFIG_.VALORTRANSACCIONTAMANODEC,
            CUENTAARCHIVOCONFIG_.CABFECHADIAPOSICION,
            CUENTAARCHIVOCONFIG_.CABFECHADIATAMANO,
            CUENTAARCHIVOCONFIG_.CABFECHAMESPOSICION,
            CUENTAARCHIVOCONFIG_.CABFECHAMESTAMANO,
            CUENTAARCHIVOCONFIG_.CABFECHAANOPOSICION,
            CUENTAARCHIVOCONFIG_.CABFECHAANOTAMANO,
            CUENTAARCHIVOCONFIG_.CABVALORCONTROLPOSICION,
            CUENTAARCHIVOCONFIG_.CABVALORCONTROLTAMANO,
            CUENTAARCHIVOCONFIG_.CABREGISTROSPOSICION,
            CUENTAARCHIVOCONFIG_.CABREGISTROSTAMANO,
            CUENTAARCHIVOCONFIG_.CABVALORCONTROLTAMANODEC';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY CUENTAARCHIVOCONFIG_.ID_CUENTAARCHIVOCONFIG ASC ';

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

-- Returns a query result from table CUENTAARCHIVOCONFIG
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.CUENTAARCHIVOCONFIG CUENTAARCHIVOCONFIG_';
    SET @l_alias_str = 'CUENTAARCHIVOCONFIG_';

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

-- Returns a query result from table CUENTAARCHIVOCONFIG
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.CUENTAARCHIVOCONFIG CUENTAARCHIVOCONFIG_';
    SET @l_alias_str = 'CUENTAARCHIVOCONFIG_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBCUENTAARCHIVOCONFIG_Export(
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
                '''XID_CUENTAARCHIVOCONFIG' + isnull(@p_separator_str, '') +
                'CODCUENTA' + isnull(@p_separator_str, '') +
                'CODCUENTA NOMCUENTA' + isnull(@p_separator_str, '') +
                'FECHADIAPOSICION' + isnull(@p_separator_str, '') +
                'FECHADIATAMANO' + isnull(@p_separator_str, '') +
                'FECHAMESPOSICION' + isnull(@p_separator_str, '') +
                'FECHAMESTAMANO' + isnull(@p_separator_str, '') +
                'FECHAANOPOSICION' + isnull(@p_separator_str, '') +
                'FECHAANOTAMANO' + isnull(@p_separator_str, '') +
                'VALORTRANSACCIONPOSICION' + isnull(@p_separator_str, '') +
                'VALORTRANSACCIONTAMANO' + isnull(@p_separator_str, '') +
                'REFERENCIAPOSICION' + isnull(@p_separator_str, '') +
                'REFERENCIATAMANO' + isnull(@p_separator_str, '') +
                'REFERENCIATAMANOMOVIMIENTO' + isnull(@p_separator_str, '') +
                'FECHAHORAMODIFICACION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION NOMBRE' + isnull(@p_separator_str, '') +
                'ACTIVE' + isnull(@p_separator_str, '') +
                'PREFIJOARCHIVO' + isnull(@p_separator_str, '') +
                'ARCHIVOACUMULADO' + isnull(@p_separator_str, '') +
                'CODPERIODICIDADPAGO' + isnull(@p_separator_str, '') +
                'CODPERIODICIDADPAGO NOMPERIODICIDADPAGO' + isnull(@p_separator_str, '') +
                'CABECERA' + isnull(@p_separator_str, '') +
                'VALORTRANSACCIONTAMANODEC' + isnull(@p_separator_str, '') +
                'CABFECHADIAPOSICION' + isnull(@p_separator_str, '') +
                'CABFECHADIATAMANO' + isnull(@p_separator_str, '') +
                'CABFECHAMESPOSICION' + isnull(@p_separator_str, '') +
                'CABFECHAMESTAMANO' + isnull(@p_separator_str, '') +
                'CABFECHAANOPOSICION' + isnull(@p_separator_str, '') +
                'CABFECHAANOTAMANO' + isnull(@p_separator_str, '') +
                'CABVALORCONTROLPOSICION' + isnull(@p_separator_str, '') +
                'CABVALORCONTROLTAMANO' + isnull(@p_separator_str, '') +
                'CABREGISTROSPOSICION' + isnull(@p_separator_str, '') +
                'CABREGISTROSTAMANO' + isnull(@p_separator_str, '') +
                'CABVALORCONTROLTAMANODEC' + ' ''';
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
                ' isnull(CAST(CUENTAARCHIVOCONFIG_.ID_CUENTAARCHIVOCONFIG AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(CUENTAARCHIVOCONFIG_.CODCUENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMCUENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.FECHADIAPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.FECHADIATAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.FECHAMESPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.FECHAMESTAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.FECHAANOPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.FECHAANOTAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.VALORTRANSACCIONPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.VALORTRANSACCIONTAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.REFERENCIAPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.REFERENCIATAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.REFERENCIATAMANOMOVIMIENTO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(CUENTAARCHIVOCONFIG_.FECHAHORAMODIFICACION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(CUENTAARCHIVOCONFIG_.CODUSUARIOMODIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMBRE, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.ACTIVE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CUENTAARCHIVOCONFIG_.PREFIJOARCHIVO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.ARCHIVOACUMULADO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(CUENTAARCHIVOCONFIG_.CODPERIODICIDADPAGO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t2.NOMPERIODICIDADPAGO) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.CABECERA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.VALORTRANSACCIONTAMANODEC, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.CABFECHADIAPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.CABFECHADIATAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.CABFECHAMESPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.CABFECHAMESTAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.CABFECHAANOPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                'NVL(CUENTAARCHIVOCONFIG_.CABFECHAANOTAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.CABVALORCONTROLPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.CABVALORCONTROLTAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.CABREGISTROSPOSICION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.CABREGISTROSTAMANO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CUENTAARCHIVOCONFIG_.CABVALORCONTROLTAMANODEC, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.CUENTAARCHIVOCONFIG CUENTAARCHIVOCONFIG_ LEFT OUTER JOIN WSXML_SFG.CUENTA t0 ON (CUENTAARCHIVOCONFIG_.CODCUENTA =  t0.ID_CUENTA) LEFT OUTER JOIN WSXML_SFG.USUARIO t1 ON (CUENTAARCHIVOCONFIG_.CODUSUARIOMODIFICACION =  t1.ID_USUARIO) LEFT OUTER JOIN WSXML_SFG.PERIODICIDADPAGO t2 ON (CUENTAARCHIVOCONFIG_.CODPERIODICIDADPAGO =  t2.ID_PERIODICIDADPAGO)';

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






