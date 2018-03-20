USE SFGPRODU;
--  DDL for Package Body SFGCONCIWEBCON_CONF_ARCHIVOS
--------------------------------------------------------

  /* PACKAGE BODY SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS */ 

-- Creates a new record in the CON_CONF_ARCHIVOS table
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_AddRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_AddRecord(
    @p_NOM_CONFIGURACION VARCHAR(4000),
    @p_ARCHIVO VARCHAR(4000),
    @p_ID_ALIADOESTRATEGICO NUMERIC(22,0),
    @p_ID_USUARIO NUMERIC(22,0),
    @p_FECHAHORA_MOD DATETIME,
    @p_TIPO_ANCHO VARCHAR(4000),
    @p_TABLA_EXTERNA VARCHAR(4000),
    @p_TABLA_LOCAL VARCHAR(4000),
    @p_ACTIVO NUMERIC(22,0),
    @p_DIRECTORIO_ORACLE_ENTRADA VARCHAR(4000),
    @p_SEPARADOR VARCHAR(4000),
    @p_ID_CONF_ARCHIVOS_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO SFG_CONCILIACION.CON_CONF_ARCHIVOS
        (
            NOM_CONFIGURACION,
            ARCHIVO,
            ID_ALIADOESTRATEGICO,
            ID_USUARIO,
            TIPO_ANCHO,
            TABLA_EXTERNA,
            TABLA_LOCAL,
            ACTIVO,
            DIRECTORIO_ORACLE_ENTRADA,
            SEPARADOR
        )
    VALUES
        (
            @p_NOM_CONFIGURACION,
            @p_ARCHIVO,
            @p_ID_ALIADOESTRATEGICO,
            @p_ID_USUARIO,
            @p_TIPO_ANCHO,
            @p_TABLA_EXTERNA,
            @p_TABLA_LOCAL,
            @p_ACTIVO,
            @p_DIRECTORIO_ORACLE_ENTRADA,
            @p_SEPARADOR
        );
       SET
            @p_ID_CONF_ARCHIVOS_out = SCOPE_IDENTITY() ;

    -- Call UPDATE for fields that have database defaults
    IF @p_FECHAHORA_MOD IS NOT NULL
    BEGIN
        UPDATE SFG_CONCILIACION.CON_CONF_ARCHIVOS SET FECHAHORA_MOD = @p_FECHAHORA_MOD WHERE ID_CONF_ARCHIVOS = @p_ID_CONF_ARCHIVOS_out;
    END 
END;
GO

-- Updates a record in the CON_CONF_ARCHIVOS table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_UpdateRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_UpdateRecord(
    @pk_ID_CONF_ARCHIVOS NUMERIC(22,0),
    @p_NOM_CONFIGURACION VARCHAR(4000),
    @p_ARCHIVO VARCHAR(4000),
    @p_ID_ALIADOESTRATEGICO NUMERIC(22,0),
    @p_ID_USUARIO NUMERIC(22,0),
    @p_FECHAHORA_MOD DATETIME,
    @p_TIPO_ANCHO VARCHAR(4000),
    @p_TABLA_EXTERNA VARCHAR(4000),
    @p_TABLA_LOCAL VARCHAR(4000),
    @p_ACTIVO NUMERIC(22,0),
    @p_DIRECTORIO_ORACLE_ENTRADA VARCHAR(4000),
    @p_SEPARADOR VARCHAR(4000)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE SFG_CONCILIACION.CON_CONF_ARCHIVOS
    SET 
            NOM_CONFIGURACION = @p_NOM_CONFIGURACION,
            ARCHIVO = @p_ARCHIVO,
            ID_ALIADOESTRATEGICO = @p_ID_ALIADOESTRATEGICO,
            ID_USUARIO = @p_ID_USUARIO,
            FECHAHORA_MOD = @p_FECHAHORA_MOD,
            TIPO_ANCHO = @p_TIPO_ANCHO,
            TABLA_EXTERNA = @p_TABLA_EXTERNA,
            TABLA_LOCAL = @p_TABLA_LOCAL,
            ACTIVO = @p_ACTIVO,
            DIRECTORIO_ORACLE_ENTRADA = @p_DIRECTORIO_ORACLE_ENTRADA,
            SEPARADOR = @p_SEPARADOR
    WHERE ID_CONF_ARCHIVOS = @pk_ID_CONF_ARCHIVOS;

	DECLARE @ROWCOUNT NUMERIC(22,0) = @@ROWCOUNT
	
    -- Make sure only one record is affected
    IF @ROWCOUNT = 0
    BEGIN
        RAISERROR ('-20054 The record no longer exists.', 16, 1);
    END 
    IF @ROWCOUNT > 1
    BEGIN
        RAISERROR ('-20053 Duplicate object instances.', 16, 1);
    END 

END;
GO

-- Deletes a record from the CON_CONF_ARCHIVOS table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_DeleteRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_DeleteRecord(
    @pk_ID_CONF_ARCHIVOS NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE SFG_CONCILIACION.CON_CONF_ARCHIVOS
    WHERE ID_CONF_ARCHIVOS = @pk_ID_CONF_ARCHIVOS;
END;
GO

-- Deletes the set of rows from the CON_CONF_ARCHIVOS table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_DeleteRecords;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_DeleteRecords(
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
'DELETE SFG_CONCILIACION.CON_CONF_ARCHIVOS' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the CON_CONF_ARCHIVOS table.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_GetRecord;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_GetRecord(
   @pk_ID_CONF_ARCHIVOS NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure 
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM SFG_CONCILIACION.CON_CONF_ARCHIVOS
    WHERE ID_CONF_ARCHIVOS = @pk_ID_CONF_ARCHIVOS;

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
        ID_CONF_ARCHIVOS,
        NOM_CONFIGURACION,
        ARCHIVO,
        ID_ALIADOESTRATEGICO,
        ID_USUARIO,
        FECHAHORA_MOD,
        TIPO_ANCHO,
        TABLA_EXTERNA,
        TABLA_LOCAL,
        ACTIVO,
        DIRECTORIO_ORACLE_ENTRADA,
        SEPARADOR
    FROM SFG_CONCILIACION.CON_CONF_ARCHIVOS
    WHERE ID_CONF_ARCHIVOS = @pk_ID_CONF_ARCHIVOS;  
END;
GO

-- Returns a query resultset from table CON_CONF_ARCHIVOS
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
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_GetList', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_GetList;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_GetList(
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
    SET @l_from_str = 'SFG_CONCILIACION.CON_CONF_ARCHIVOS CON_CONF_ARCHIVOS_';
    SET @l_alias_str = 'CON_CONF_ARCHIVOS_';

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
        'CON_CONF_ARCHIVOS_.ID_CONF_ARCHIVOS,
            CON_CONF_ARCHIVOS_.NOM_CONFIGURACION,
            CON_CONF_ARCHIVOS_.ARCHIVO,
            CON_CONF_ARCHIVOS_.ID_ALIADOESTRATEGICO,
            CON_CONF_ARCHIVOS_.ID_USUARIO,
            CON_CONF_ARCHIVOS_.FECHAHORA_MOD,
            CON_CONF_ARCHIVOS_.TIPO_ANCHO,
            CON_CONF_ARCHIVOS_.TABLA_EXTERNA,
            CON_CONF_ARCHIVOS_.TABLA_LOCAL,
            CON_CONF_ARCHIVOS_.ACTIVO,
            CON_CONF_ARCHIVOS_.DIRECTORIO_ORACLE_ENTRADA,
            CON_CONF_ARCHIVOS_.SEPARADOR';
    
    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY CON_CONF_ARCHIVOS_.ID_CONF_ARCHIVOS ASC ';

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

-- Returns a query result from table CON_CONF_ARCHIVOS
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_DrillDown;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_DrillDown(
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
    SET @l_from_str = 'SFG_CONCILIACION.CON_CONF_ARCHIVOS CON_CONF_ARCHIVOS_';
    SET @l_alias_str = 'CON_CONF_ARCHIVOS_';

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

-- Returns a query result from table CON_CONF_ARCHIVOS
-- given the search criteria and sorting condition.
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_GetStats;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_GetStats(
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

    SET @l_from_str = 'SFG_CONCILIACION.CON_CONF_ARCHIVOS CON_CONF_ARCHIVOS_';
    SET @l_alias_str = 'CON_CONF_ARCHIVOS_';

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
IF OBJECT_ID('SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_Export', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_Export;
GO

CREATE PROCEDURE SFG_CONCILIACION.SFGCONCIWEBCON_CONF_ARCHIVOS_Export(
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
                '''XID_CONF_ARCHIVOS' + isnull(@p_separator_str, '') +
                'NOM_CONFIGURACION' + isnull(@p_separator_str, '') +
                'ARCHIVO' + isnull(@p_separator_str, '') +
                'XID_ALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                'XID_ALIADOESTRATEGICO NOMALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                'ID_USUARIO' + isnull(@p_separator_str, '') +
                'ID_USUARIO NOMUSUARIO' + isnull(@p_separator_str, '') +
                'FECHAHORA_MOD' + isnull(@p_separator_str, '') +
                'TIPO_ANCHO' + isnull(@p_separator_str, '') +
                'TABLA_EXTERNA' + isnull(@p_separator_str, '') +
                'TABLA_LOCAL' + isnull(@p_separator_str, '') +
                'ACTIVO' + isnull(@p_separator_str, '') +
                'DIRECTORIO_ORACLE_ENTRADA' + isnull(@p_separator_str, '') +
                'SEPARADOR' + ' ''';
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
                ' isnull(CAST(CON_CONF_ARCHIVOS_.ID_CONF_ARCHIVOS AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CON_CONF_ARCHIVOS_.NOM_CONFIGURACION, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CON_CONF_ARCHIVOS_.ARCHIVO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(CON_CONF_ARCHIVOS_.ID_ALIADOESTRATEGICO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMALIADOESTRATEGICO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CAST(CON_CONF_ARCHIVOS_.ID_USUARIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMUSUARIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(dbo.ConvertFecha(CON_CONF_ARCHIVOS_.FECHAHORA_MOD), '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CON_CONF_ARCHIVOS_.TIPO_ANCHO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CON_CONF_ARCHIVOS_.TABLA_EXTERNA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CON_CONF_ARCHIVOS_.TABLA_LOCAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ' isnull(CON_CONF_ARCHIVOS_.ACTIVO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CON_CONF_ARCHIVOS_.DIRECTORIO_ORACLE_ENTRADA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' + 
                ''''' + REPLACE( isnull(CON_CONF_ARCHIVOS_.SEPARADOR, ''''), '''', '''') + ''''  + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'SFG_CONCILIACION.CON_CONF_ARCHIVOS CON_CONF_ARCHIVOS_ LEFT OUTER JOIN WSXML_SFG.ALIADOESTRATEGICO t0 ON (CON_CONF_ARCHIVOS_.ID_ALIADOESTRATEGICO =  t0.ID_ALIADOESTRATEGICO) LEFT OUTER JOIN WSXML_SFG.USUARIO t1 ON (CON_CONF_ARCHIVOS_.ID_USUARIO =  t1.ID_USUARIO)';

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






