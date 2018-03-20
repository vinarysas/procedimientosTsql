USE SFGPRODU;
--  DDL for Package Body SFGCONCIWEBVW_DETALLE1_CONCILI
--------------------------------------------------------

  /* PACKAGE BODY SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI */ 

-- Creates a new record in the VW_DETALLE1_CONCILIADO_MANUAL table
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_AddRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_AddRecord(
    @p_RCPT_NMR_COMUN NUMERIC(22,0),
    @p_ALIADO_CRITERIO NUMERIC(22,0),
    @p_FECHA_ARCHIVO DATETIME,
    @p_FECHA_NEGOCIO DATETIME,
    @p_NOM_RAZON_NO_CONCI VARCHAR(4000),
    @p_CAMPOS_OK VARCHAR(4000),
    @p_CAMPOS_FALLO VARCHAR(4000),
    @p_ID_CAL_ARCH_ALI NUMERIC(22,0),
    @p_ID_CAL_ARCH_GTK NUMERIC(22,0),
    @p_ID_CON_NO_CONCILIA_ALI NUMERIC(22,0),
    @p_CODENTRADACONCILIAALI NUMERIC(22,0),
    @p_CODENTRADACONCILIAGTK NUMERIC(22,0),
    @p_BUS_DATE_ALI DATETIME,
    @p_RCPT_NMR_ALI VARCHAR(4000),
    @p_AMOUNT_ALI NUMERIC(22,0),
    @p_ANSWER_CODE_ALI VARCHAR(4000),
    @p_CONF_MARK_ALI VARCHAR(4000),
    @p_BUS_DATE_MODIFICADO_ALI NUMERIC(22,0),
    @p_CODREGISTROFACTREFERENCIA NUMERIC(22,0),
    @p_BUS_DATE_GTK DATETIME,
    @p_RCPT_NMR_GTK VARCHAR(4000),
    @p_AMOUNT_GTK NUMERIC(22,0),
    @p_ANSWER_CODE_GTK VARCHAR(4000),
    @p_ARRN_GTK VARCHAR(4000),
    @p_FECHA_HORA_TRANS_GTK DATETIME,
    @p_BUS_DATE_MODIFICADO_GTK NUMERIC(22,0),
    @p_ESTADO_SC_GTK NVARCHAR(2000),
    @p_TIPOTRANSACCION_SC_GTK NVARCHAR(2000),
    @p_CODRAZON_NO_CONCILIABLE_GTK NUMERIC(22,0),
    @p_CODPRODUCTO_CONCILIA NUMERIC(22,0),
    @p_CODALIADO NUMERIC(22,0),
    @p_NOM_PRODUCTOALIADO VARCHAR(4000),
    @p_NOMPRODUCTO_ALI VARCHAR(4000),
    @p_ID_PRODUCTO_GTK NUMERIC(22,0),
    @p_NOMPRODUCTO_GTK VARCHAR(4000),
    @p_CODALIADOESTRATEGICO_GTK NUMERIC(22,0),
    @p_NOMALIADOESTRATEGICO VARCHAR(4000),
    @p_ID_CALENDARIO_GRAL NUMERIC(22,0),
    @p_FECHA_HORA_CREACION DATETIME,
    @p_COD_USUARIO_CREADOR NUMERIC(22,0),
    @p_VR_AJUSTE_GTK NUMERIC(22,0),
    @p_VR_AJUSTE_ALIADO NUMERIC(22,0),
    @p_VR_AJUSTE_PDV NUMERIC(22,0),
    @p_COD_ESTADO_INVEST NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL
        (
            RCPT_NMR_COMUN,
            ALIADO_CRITERIO,
            FECHA_ARCHIVO,
            FECHA_NEGOCIO,
            NOM_RAZON_NO_CONCI,
            CAMPOS_OK,
            CAMPOS_FALLO,
            ID_CAL_ARCH_ALI,
            ID_CAL_ARCH_GTK,
            ID_CON_NO_CONCILIA_ALI,
            CODENTRADACONCILIAALI,
            CODENTRADACONCILIAGTK,
            BUS_DATE_ALI,
            RCPT_NMR_ALI,
            AMOUNT_ALI,
            ANSWER_CODE_ALI,
            CONF_MARK_ALI,
            BUS_DATE_MODIFICADO_ALI,
            CODREGISTROFACTREFERENCIA,
            BUS_DATE_GTK,
            RCPT_NMR_GTK,
            AMOUNT_GTK,
            ANSWER_CODE_GTK,
            ARRN_GTK,
            FECHA_HORA_TRANS_GTK,
            BUS_DATE_MODIFICADO_GTK,
            ESTADO_SC_GTK,
            TIPOTRANSACCION_SC_GTK,
            CODRAZON_NO_CONCILIABLE_GTK,
            CODPRODUCTO_CONCILIA,
            CODALIADO,
            NOM_PRODUCTOALIADO,
            NOMPRODUCTO_ALI,
            ID_PRODUCTO_GTK,
            NOMPRODUCTO_GTK,
            CODALIADOESTRATEGICO_GTK,
            NOMALIADOESTRATEGICO,
            ID_CALENDARIO_GRAL,
            FECHA_HORA_CREACION,
            COD_USUARIO_CREADOR,
            VR_AJUSTE_GTK,
            VR_AJUSTE_ALIADO,
            VR_AJUSTE_PDV,
            COD_ESTADO_INVEST
        )
    VALUES
        (
            @p_RCPT_NMR_COMUN,
            @p_ALIADO_CRITERIO,
            @p_FECHA_ARCHIVO,
            @p_FECHA_NEGOCIO,
            @p_NOM_RAZON_NO_CONCI,
            @p_CAMPOS_OK,
            @p_CAMPOS_FALLO,
            @p_ID_CAL_ARCH_ALI,
            @p_ID_CAL_ARCH_GTK,
            @p_ID_CON_NO_CONCILIA_ALI,
            @p_CODENTRADACONCILIAALI,
            @p_CODENTRADACONCILIAGTK,
            @p_BUS_DATE_ALI,
            @p_RCPT_NMR_ALI,
            @p_AMOUNT_ALI,
            @p_ANSWER_CODE_ALI,
            @p_CONF_MARK_ALI,
            @p_BUS_DATE_MODIFICADO_ALI,
            @p_CODREGISTROFACTREFERENCIA,
            @p_BUS_DATE_GTK,
            @p_RCPT_NMR_GTK,
            @p_AMOUNT_GTK,
            @p_ANSWER_CODE_GTK,
            @p_ARRN_GTK,
            @p_FECHA_HORA_TRANS_GTK,
            @p_BUS_DATE_MODIFICADO_GTK,
            @p_ESTADO_SC_GTK,
            @p_TIPOTRANSACCION_SC_GTK,
            @p_CODRAZON_NO_CONCILIABLE_GTK,
            @p_CODPRODUCTO_CONCILIA,
            @p_CODALIADO,
            @p_NOM_PRODUCTOALIADO,
            @p_NOMPRODUCTO_ALI,
            @p_ID_PRODUCTO_GTK,
            @p_NOMPRODUCTO_GTK,
            @p_CODALIADOESTRATEGICO_GTK,
            @p_NOMALIADOESTRATEGICO,
            @p_ID_CALENDARIO_GRAL,
            @p_FECHA_HORA_CREACION,
            @p_COD_USUARIO_CREADOR,
            @p_VR_AJUSTE_GTK,
            @p_VR_AJUSTE_ALIADO,
            @p_VR_AJUSTE_PDV,
            @p_COD_ESTADO_INVEST
        );

END;
GO

-- Updates a record in the VW_DETALLE1_CONCILIADO_MANUAL table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_UpdateRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_UpdateRecord(
        @p_RCPT_NMR_COMUN NUMERIC(22,0),
    @p_ALIADO_CRITERIO NUMERIC(22,0),
    @p_FECHA_ARCHIVO DATETIME,
    @p_FECHA_NEGOCIO DATETIME,
    @p_NOM_RAZON_NO_CONCI VARCHAR(4000),
    @p_CAMPOS_OK VARCHAR(4000),
    @p_CAMPOS_FALLO VARCHAR(4000),
    @p_ID_CAL_ARCH_ALI NUMERIC(22,0),
    @p_ID_CAL_ARCH_GTK NUMERIC(22,0),
    @p_ID_CON_NO_CONCILIA_ALI NUMERIC(22,0),
@pk_ID_CON_NO_CONCILIA_ALI NUMERIC(22,0),
    @p_CODENTRADACONCILIAALI NUMERIC(22,0),
    @p_CODENTRADACONCILIAGTK NUMERIC(22,0),
    @p_BUS_DATE_ALI DATETIME,
    @p_RCPT_NMR_ALI VARCHAR(4000),
    @p_AMOUNT_ALI NUMERIC(22,0),
    @p_ANSWER_CODE_ALI VARCHAR(4000),
    @p_CONF_MARK_ALI VARCHAR(4000),
    @p_BUS_DATE_MODIFICADO_ALI NUMERIC(22,0),
    @p_CODREGISTROFACTREFERENCIA NUMERIC(22,0),
    @p_BUS_DATE_GTK DATETIME,
    @p_RCPT_NMR_GTK VARCHAR(4000),
    @p_AMOUNT_GTK NUMERIC(22,0),
    @p_ANSWER_CODE_GTK VARCHAR(4000),
    @p_ARRN_GTK VARCHAR(4000),
    @p_FECHA_HORA_TRANS_GTK DATETIME,
    @p_BUS_DATE_MODIFICADO_GTK NUMERIC(22,0),
    @p_ESTADO_SC_GTK NVARCHAR(2000),
    @p_TIPOTRANSACCION_SC_GTK NVARCHAR(2000),
    @p_CODRAZON_NO_CONCILIABLE_GTK NUMERIC(22,0),
    @p_CODPRODUCTO_CONCILIA NUMERIC(22,0),
    @p_CODALIADO NUMERIC(22,0),
    @p_NOM_PRODUCTOALIADO VARCHAR(4000),
    @p_NOMPRODUCTO_ALI VARCHAR(4000),
    @p_ID_PRODUCTO_GTK NUMERIC(22,0),
    @p_NOMPRODUCTO_GTK VARCHAR(4000),
    @p_CODALIADOESTRATEGICO_GTK NUMERIC(22,0),
    @p_NOMALIADOESTRATEGICO VARCHAR(4000),
    @p_ID_CALENDARIO_GRAL NUMERIC(22,0),
    @p_FECHA_HORA_CREACION DATETIME,
    @p_COD_USUARIO_CREADOR NUMERIC(22,0),
    @p_VR_AJUSTE_GTK NUMERIC(22,0),
    @p_VR_AJUSTE_ALIADO NUMERIC(22,0),
    @p_VR_AJUSTE_PDV NUMERIC(22,0),
    @p_COD_ESTADO_INVEST NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL
    SET 
            RCPT_NMR_COMUN = @p_RCPT_NMR_COMUN,
            ALIADO_CRITERIO = @p_ALIADO_CRITERIO,
            FECHA_ARCHIVO = @p_FECHA_ARCHIVO,
            FECHA_NEGOCIO = @p_FECHA_NEGOCIO,
            NOM_RAZON_NO_CONCI = @p_NOM_RAZON_NO_CONCI,
            CAMPOS_OK = @p_CAMPOS_OK,
            CAMPOS_FALLO = @p_CAMPOS_FALLO,
            ID_CAL_ARCH_ALI = @p_ID_CAL_ARCH_ALI,
            ID_CAL_ARCH_GTK = @p_ID_CAL_ARCH_GTK,
            ID_CON_NO_CONCILIA_ALI = @p_ID_CON_NO_CONCILIA_ALI,
            CODENTRADACONCILIAALI = @p_CODENTRADACONCILIAALI,
            CODENTRADACONCILIAGTK = @p_CODENTRADACONCILIAGTK,
            BUS_DATE_ALI = @p_BUS_DATE_ALI,
            RCPT_NMR_ALI = @p_RCPT_NMR_ALI,
            AMOUNT_ALI = @p_AMOUNT_ALI,
            ANSWER_CODE_ALI = @p_ANSWER_CODE_ALI,
            CONF_MARK_ALI = @p_CONF_MARK_ALI,
            BUS_DATE_MODIFICADO_ALI = @p_BUS_DATE_MODIFICADO_ALI,
            CODREGISTROFACTREFERENCIA = @p_CODREGISTROFACTREFERENCIA,
            BUS_DATE_GTK = @p_BUS_DATE_GTK,
            RCPT_NMR_GTK = @p_RCPT_NMR_GTK,
            AMOUNT_GTK = @p_AMOUNT_GTK,
            ANSWER_CODE_GTK = @p_ANSWER_CODE_GTK,
            ARRN_GTK = @p_ARRN_GTK,
            FECHA_HORA_TRANS_GTK = @p_FECHA_HORA_TRANS_GTK,
            BUS_DATE_MODIFICADO_GTK = @p_BUS_DATE_MODIFICADO_GTK,
            ESTADO_SC_GTK = @p_ESTADO_SC_GTK,
            TIPOTRANSACCION_SC_GTK = @p_TIPOTRANSACCION_SC_GTK,
            CODRAZON_NO_CONCILIABLE_GTK = @p_CODRAZON_NO_CONCILIABLE_GTK,
            CODPRODUCTO_CONCILIA = @p_CODPRODUCTO_CONCILIA,
            CODALIADO = @p_CODALIADO,
            NOM_PRODUCTOALIADO = @p_NOM_PRODUCTOALIADO,
            NOMPRODUCTO_ALI = @p_NOMPRODUCTO_ALI,
            ID_PRODUCTO_GTK = @p_ID_PRODUCTO_GTK,
            NOMPRODUCTO_GTK = @p_NOMPRODUCTO_GTK,
            CODALIADOESTRATEGICO_GTK = @p_CODALIADOESTRATEGICO_GTK,
            NOMALIADOESTRATEGICO = @p_NOMALIADOESTRATEGICO,
            ID_CALENDARIO_GRAL = @p_ID_CALENDARIO_GRAL,
            FECHA_HORA_CREACION = @p_FECHA_HORA_CREACION,
            COD_USUARIO_CREADOR = @p_COD_USUARIO_CREADOR,
            VR_AJUSTE_GTK = @p_VR_AJUSTE_GTK,
            VR_AJUSTE_ALIADO = @p_VR_AJUSTE_ALIADO,
            VR_AJUSTE_PDV = @p_VR_AJUSTE_PDV,
            COD_ESTADO_INVEST = @p_COD_ESTADO_INVEST
    WHERE ID_CON_NO_CONCILIA_ALI = @pk_ID_CON_NO_CONCILIA_ALI;

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

-- Deletes a record from the VW_DETALLE1_CONCILIADO_MANUAL table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_DeleteRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_DeleteRecord(
    @pk_ID_CON_NO_CONCILIA_ALI NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL
    WHERE ID_CON_NO_CONCILIA_ALI = @pk_ID_CON_NO_CONCILIA_ALI;
END;
GO

-- Deletes the set of rows from the VW_DETALLE1_CONCILIADO_MANUAL table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_DeleteRecords;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_DeleteRecords(
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
'DELETE SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the VW_DETALLE1_CONCILIADO_MANUAL table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_GetRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_GetRecord(
   @pk_ID_CON_NO_CONCILIA_ALI NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure 
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL
    WHERE ID_CON_NO_CONCILIA_ALI = @pk_ID_CON_NO_CONCILIA_ALI;

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
        RCPT_NMR_COMUN,
        ALIADO_CRITERIO,
        FECHA_ARCHIVO,
        FECHA_NEGOCIO,
        NOM_RAZON_NO_CONCI,
        CAMPOS_OK,
        CAMPOS_FALLO,
        ID_CAL_ARCH_ALI,
        ID_CAL_ARCH_GTK,
        ID_CON_NO_CONCILIA_ALI,
        CODENTRADACONCILIAALI,
        CODENTRADACONCILIAGTK,
        BUS_DATE_ALI,
        RCPT_NMR_ALI,
        AMOUNT_ALI,
        ANSWER_CODE_ALI,
        CONF_MARK_ALI,
        BUS_DATE_MODIFICADO_ALI,
        CODREGISTROFACTREFERENCIA,
        BUS_DATE_GTK,
        RCPT_NMR_GTK,
        AMOUNT_GTK,
        ANSWER_CODE_GTK,
        ARRN_GTK,
        FECHA_HORA_TRANS_GTK,
        BUS_DATE_MODIFICADO_GTK,
        ESTADO_SC_GTK,
        TIPOTRANSACCION_SC_GTK,
        CODRAZON_NO_CONCILIABLE_GTK,
        CODPRODUCTO_CONCILIA,
        CODALIADO,
        NOM_PRODUCTOALIADO,
        NOMPRODUCTO_ALI,
        ID_PRODUCTO_GTK,
        NOMPRODUCTO_GTK,
        CODALIADOESTRATEGICO_GTK,
        NOMALIADOESTRATEGICO,
        ID_CALENDARIO_GRAL,
        FECHA_HORA_CREACION,
        COD_USUARIO_CREADOR,
        VR_AJUSTE_GTK,
        VR_AJUSTE_ALIADO,
        VR_AJUSTE_PDV,
        COD_ESTADO_INVEST
    FROM SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL
    WHERE ID_CON_NO_CONCILIA_ALI = @pk_ID_CON_NO_CONCILIA_ALI;  
END;
GO

-- Returns a query resultset from table VW_DETALLE1_CONCILIADO_MANUAL
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
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_GetList', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_GetList;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_GetList(
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
    SET @l_from_str = 'SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL VW_DETALLE1_CONCILIADO_MANUAL_';
    SET @l_alias_str = 'VW_DETALLE1_CONCILIADO_MANUAL_';

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
        'VW_DETALLE1_CONCILIADO_MANUAL_.RCPT_NMR_COMUN,
            VW_DETALLE1_CONCILIADO_MANUAL_.ALIADO_CRITERIO,
            VW_DETALLE1_CONCILIADO_MANUAL_.FECHA_ARCHIVO,
            VW_DETALLE1_CONCILIADO_MANUAL_.FECHA_NEGOCIO,
            VW_DETALLE1_CONCILIADO_MANUAL_.NOM_RAZON_NO_CONCI,
            VW_DETALLE1_CONCILIADO_MANUAL_.CAMPOS_OK,
            VW_DETALLE1_CONCILIADO_MANUAL_.CAMPOS_FALLO,
            VW_DETALLE1_CONCILIADO_MANUAL_.ID_CAL_ARCH_ALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.ID_CAL_ARCH_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.ID_CON_NO_CONCILIA_ALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.CODENTRADACONCILIAALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.CODENTRADACONCILIAGTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.BUS_DATE_ALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.RCPT_NMR_ALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.AMOUNT_ALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.ANSWER_CODE_ALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.CONF_MARK_ALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.BUS_DATE_MODIFICADO_ALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.CODREGISTROFACTREFERENCIA,
            VW_DETALLE1_CONCILIADO_MANUAL_.BUS_DATE_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.RCPT_NMR_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.AMOUNT_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.ANSWER_CODE_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.ARRN_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.FECHA_HORA_TRANS_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.BUS_DATE_MODIFICADO_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.ESTADO_SC_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.TIPOTRANSACCION_SC_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.CODRAZON_NO_CONCILIABLE_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.CODPRODUCTO_CONCILIA,
            VW_DETALLE1_CONCILIADO_MANUAL_.CODALIADO,
            VW_DETALLE1_CONCILIADO_MANUAL_.NOM_PRODUCTOALIADO,
            VW_DETALLE1_CONCILIADO_MANUAL_.NOMPRODUCTO_ALI,
            VW_DETALLE1_CONCILIADO_MANUAL_.ID_PRODUCTO_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.NOMPRODUCTO_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.CODALIADOESTRATEGICO_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.NOMALIADOESTRATEGICO,
            VW_DETALLE1_CONCILIADO_MANUAL_.ID_CALENDARIO_GRAL,
            VW_DETALLE1_CONCILIADO_MANUAL_.FECHA_HORA_CREACION,
            VW_DETALLE1_CONCILIADO_MANUAL_.COD_USUARIO_CREADOR,
            VW_DETALLE1_CONCILIADO_MANUAL_.VR_AJUSTE_GTK,
            VW_DETALLE1_CONCILIADO_MANUAL_.VR_AJUSTE_ALIADO,
            VW_DETALLE1_CONCILIADO_MANUAL_.VR_AJUSTE_PDV,
            VW_DETALLE1_CONCILIADO_MANUAL_.COD_ESTADO_INVEST';
    
    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY VW_DETALLE1_CONCILIADO_MANUAL_.ID_CON_NO_CONCILIA_ALI ASC ';

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

-- Returns a query result from table VW_DETALLE1_CONCILIADO_MANUAL
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_DrillDown;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_DrillDown(
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
    SET @l_from_str = 'SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL VW_DETALLE1_CONCILIADO_MANUAL_';
    SET @l_alias_str = 'VW_DETALLE1_CONCILIADO_MANUAL_';

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

-- Returns a query result from table VW_DETALLE1_CONCILIADO_MANUAL
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_GetStats;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_GetStats(
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

    SET @l_from_str = 'SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL VW_DETALLE1_CONCILIADO_MANUAL_';
    SET @l_alias_str = 'VW_DETALLE1_CONCILIADO_MANUAL_';

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
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_Export', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_Export;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBVW_DETALLE1_CONCILI_Export(
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
                'RCPT_NMR_COMUN' + isnull(@p_separator_str, '') +
                'ALIADO_CRITERIO' + isnull(@p_separator_str, '') +
                'FECHA_ARCHIVO' + isnull(@p_separator_str, '') +
                'FECHA_NEGOCIO' + isnull(@p_separator_str, '') +
                'NOM_RAZON_NO_CONCI' + isnull(@p_separator_str, '') +
                'CAMPOS_OK' + isnull(@p_separator_str, '') +
                'CAMPOS_FALLO' + isnull(@p_separator_str, '') +
                'XID_CAL_ARCH_ALI' + isnull(@p_separator_str, '') +
                'XID_CAL_ARCH_GTK' + isnull(@p_separator_str, '') +
                'XID_CON_NO_CONCILIA_ALI' + isnull(@p_separator_str, '') +
                'CODENTRADACONCILIAALI' + isnull(@p_separator_str, '') +
                'CODENTRADACONCILIAGTK' + isnull(@p_separator_str, '') +
                'BUS_DATE_ALI' + isnull(@p_separator_str, '') +
                'RCPT_NMR_ALI' + isnull(@p_separator_str, '') +
                'AMOUNT_ALI' + isnull(@p_separator_str, '') +
                'ANSWER_CODE_ALI' + isnull(@p_separator_str, '') +
                'CONF_MARK_ALI' + isnull(@p_separator_str, '') +
                'BUS_DATE_MODIFICADO_ALI' + isnull(@p_separator_str, '') +
                'CODREGISTROFACTREFERENCIA' + isnull(@p_separator_str, '') +
                'BUS_DATE_GTK' + isnull(@p_separator_str, '') +
                'RCPT_NMR_GTK' + isnull(@p_separator_str, '') +
                'AMOUNT_GTK' + isnull(@p_separator_str, '') +
                'ANSWER_CODE_GTK' + isnull(@p_separator_str, '') +
                'ARRN_GTK' + isnull(@p_separator_str, '') +
                'FECHA_HORA_TRANS_GTK' + isnull(@p_separator_str, '') +
                'BUS_DATE_MODIFICADO_GTK' + isnull(@p_separator_str, '') +
                'ESTADO_SC_GTK' + isnull(@p_separator_str, '') +
                'TIPOTRANSACCION_SC_GTK' + isnull(@p_separator_str, '') +
                'CODRAZON_NO_CONCILIABLE_GTK' + isnull(@p_separator_str, '') +
                'CODPRODUCTO_CONCILIA' + isnull(@p_separator_str, '') +
                'CODALIADO' + isnull(@p_separator_str, '') +
                'NOM_PRODUCTOALIADO' + isnull(@p_separator_str, '') +
                'NOMPRODUCTO_ALI' + isnull(@p_separator_str, '') +
                'XID_PRODUCTO_GTK' + isnull(@p_separator_str, '') +
                'NOMPRODUCTO_GTK' + isnull(@p_separator_str, '') +
                'CODALIADOESTRATEGICO_GTK' + isnull(@p_separator_str, '') +
                'NOMALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                'XID_CALENDARIO_GRAL' + isnull(@p_separator_str, '') +
                'FECHA_HORA_CREACION' + isnull(@p_separator_str, '') +
                'COD_USUARIO_CREADOR' + isnull(@p_separator_str, '') +
                'COD_USUARIO_CREADOR NOMUSUARIO' + isnull(@p_separator_str, '') +
                'VR_AJUSTE_GTK' + isnull(@p_separator_str, '') +
                'VR_AJUSTE_ALIADO' + isnull(@p_separator_str, '') +
                'VR_AJUSTE_PDV' + isnull(@p_separator_str, '') +
                'COD_ESTADO_INVEST' + isnull(@p_separator_str, '') +
                'COD_ESTADO_INVEST NOM_ESTADO_INVEST' + ' ';
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
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.RCPT_NMR_COMUN, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.ALIADO_CRITERIO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(dbo.ConvertFecha(VW_DETALLE1_CONCILIADO_MANUAL_.FECHA_ARCHIVO), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(dbo.ConvertFecha(VW_DETALLE1_CONCILIADO_MANUAL_.FECHA_NEGOCIO), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.NOM_RAZON_NO_CONCI, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.CAMPOS_OK, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.CAMPOS_FALLO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.ID_CAL_ARCH_ALI AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.ID_CAL_ARCH_GTK AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.ID_CON_NO_CONCILIA_ALI AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.CODENTRADACONCILIAALI AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.CODENTRADACONCILIAGTK AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.BUS_DATE_ALI, ''mm/dd/yyyy hh24:mi'', '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.RCPT_NMR_ALI, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.AMOUNT_ALI, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_DETALLE1_CONCILIADO_MANUAL_.ANSWER_CODE_ALI) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.CONF_MARK_ALI, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.BUS_DATE_MODIFICADO_ALI, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.CODREGISTROFACTREFERENCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.BUS_DATE_GTK, ''mm/dd/yyyy hh24:mi'', '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.RCPT_NMR_GTK, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.AMOUNT_GTK, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_DETALLE1_CONCILIADO_MANUAL_.ANSWER_CODE_GTK) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.ARRN_GTK, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(dbo.ConvertFecha(VW_DETALLE1_CONCILIADO_MANUAL_.FECHA_HORA_TRANS_GTK), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.BUS_DATE_MODIFICADO_GTK, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.ESTADO_SC_GTK, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.TIPOTRANSACCION_SC_GTK, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.CODRAZON_NO_CONCILIABLE_GTK AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.CODPRODUCTO_CONCILIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.CODALIADO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.NOM_PRODUCTOALIADO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.NOMPRODUCTO_ALI, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.ID_PRODUCTO_GTK AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.NOMPRODUCTO_GTK, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.CODALIADOESTRATEGICO_GTK AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(VW_DETALLE1_CONCILIADO_MANUAL_.NOMALIADOESTRATEGICO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.ID_CALENDARIO_GRAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(dbo.ConvertFecha(VW_DETALLE1_CONCILIADO_MANUAL_.FECHA_HORA_CREACION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.COD_USUARIO_CREADOR AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMUSUARIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.VR_AJUSTE_GTK, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.VR_AJUSTE_ALIADO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(VW_DETALLE1_CONCILIADO_MANUAL_.VR_AJUSTE_PDV, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(VW_DETALLE1_CONCILIADO_MANUAL_.COD_ESTADO_INVEST AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOM_ESTADO_INVEST, ''''), '''', '''') + ''''  + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'SFG_CONCILIACION.VW_DETALLE1_CONCILIADO_MANUAL VW_DETALLE1_CONCILIADO_MANUAL_ LEFT OUTER JOIN SFG_CONCILIACION.VW_USUARIO t0 ON (VW_DETALLE1_CONCILIADO_MANUAL_.COD_USUARIO_CREADOR =  t0.ID_USUARIO) LEFT OUTER JOIN SFG_CONCILIACION.CON_ESTADO_INVEST t1 ON (VW_DETALLE1_CONCILIADO_MANUAL_.COD_ESTADO_INVEST =  t1.ID_ESTADO_INVEST)';

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

