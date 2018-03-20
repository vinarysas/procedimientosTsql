USE SFGPRODU;
--  DDL for Package Body SFGWEBORDENDECOMPRA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBORDENDECOMPRA */ 

  IF OBJECT_ID('WSXML_SFG.SFGWEBORDENDECOMPRA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_AddRecord(@p_CODALIADOESTRATEGICO NUMERIC(22,0),
                      @p_FECHAEMISION         DATETIME,
                      @p_CONSECUTIVO          VARCHAR(4000),
                      @p_CODCOMPANIA          NUMERIC(22,0),
                      @p_CODUSUARIOSOLICITUD  NUMERIC(22,0),
                      @p_FECHAHORASOLICITUD   DATETIME,
                      @p_ESTADOAPROBACION     CHAR,
                      @p_COMENTARIOAPROBACION NVARCHAR(2000),
                      @p_CODUSUARIOAPROBACION NUMERIC(22,0),
                      @p_FECHAHORAAPROBACION  DATETIME,
                      @p_TOTALORDENDECOMPRA   FLOAT,
                      @p_FACTURADO            CHAR,
                      @p_CODFACTURACIONALIADO NUMERIC(22,0),
                      @p_RECIBIDO             CHAR,
                      @p_FECHAHORARECIBIDO    DATETIME,
                      @p_ID_ORDENDECOMPRA_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xExistingCount       NUMERIC(22,0);
    DECLARE @xAliadoOrdenDeCompra VARCHAR(4000) /* Use -meta option ALIADOESTRATEGICO.NOMALIADOESTRATEGICO%TYPE */;
    DECLARE @xUsuarioSolicitud VARCHAR(4000)    /* Use -meta option USUARIO.NOMBRE%TYPE */;
   
  SET NOCOUNT ON;
    SELECT @xExistingCount = COUNT(1)
      FROM WSXML_SFG.ORDENDECOMPRA
     WHERE CONSECUTIVO = @p_CONSECUTIVO;
    IF @xExistingCount > 0 BEGIN
		DECLARE @msglog varchar(2000) = '-20011 Ya existe una orden de compra con el consecutivo ' +ISNULL(@p_CONSECUTIVO, '')
		RAISERROR(@msglog, 16, 1);
    END 
    INSERT INTO WSXML_SFG.ORDENDECOMPRA
      (
       CODALIADOESTRATEGICO,
       CONSECUTIVO,
       CODCOMPANIA,
       FECHAEMISION,
       CODUSUARIOSOLICITUD,
       FECHAHORASOLICITUD,
       TOTALORDENDECOMPRA)
    VALUES
      (
       @p_CODALIADOESTRATEGICO,
       @p_CONSECUTIVO,
       @p_CODCOMPANIA,
       @p_FECHAEMISION,
       @p_CODUSUARIOSOLICITUD,
       GETDATE(),
       @p_TOTALORDENDECOMPRA);
    SET @p_ID_ORDENDECOMPRA_out = SCOPE_IDENTITY();

    EXEC WSXML_SFG.SFGPARAMETRO_SetOrReplaceParameter 'ConsecutivoOrdenDeCompra',@p_CONSECUTIVO;
	
    SELECT @xUsuarioSolicitud = NOMBRE
      FROM WSXML_SFG.USUARIO
     WHERE ID_USUARIO = @p_CODUSUARIOSOLICITUD;
	 
    SELECT @xAliadoOrdenDeCompra = NOMALIADOESTRATEGICO
      FROM WSXML_SFG.ALIADOESTRATEGICO
     WHERE ID_ALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO;
    --SFGALERTA.GenerarAlerta(SFGALERTA.TIPOINFORMATIVO, 'ORDENDECOMPRA', 'Se ha creado la orden de compra ' || p_CONSECUTIVO || ' (' || xUsuarioSolicitud || ') en el sistema para el proveedor ' || xAliadoOrdenDeCompra || ' por ' || SFG_PACKAGE.CurrencyFormat(NVL(p_TOTALORDENDECOMPRA, 0)) || ' y esta en espera de aprobacion.', 2);
  END;
GO

  -- Updates a record in the ORDENDECOMPRA table.
  IF OBJECT_ID('WSXML_SFG.SFGWEBORDENDECOMPRA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_UpdateRecord(@pk_ID_ORDENDECOMPRA    NUMERIC(22,0),
                         @p_CODALIADOESTRATEGICO NUMERIC(22,0),
                         @p_FECHAEMISION         DATETIME,
                         @p_CONSECUTIVO          VARCHAR(4000),
                         @p_CODCOMPANIA          NUMERIC(22,0),
                         @p_CODUSUARIOSOLICITUD  NUMERIC(22,0),
                         @p_FECHAHORASOLICITUD   DATETIME,
                         @p_ESTADOAPROBACION     CHAR,
                         @p_COMENTARIOAPROBACION NVARCHAR(2000),
                         @p_CODUSUARIOAPROBACION NUMERIC(22,0),
                         @p_FECHAHORAAPROBACION  DATETIME,
                         @p_TOTALORDENDECOMPRA   FLOAT,
                         @p_FACTURADO            CHAR,
                         @p_CODFACTURACIONALIADO NUMERIC(22,0),
                         @p_RECIBIDO             CHAR,
                         @p_FECHAHORARECIBIDO    DATETIME) AS
 BEGIN
    DECLARE @xCurrentState CHAR;
   
  SET NOCOUNT ON;
    SELECT @xCurrentState = ESTADOAPROBACION FROM WSXML_SFG.ORDENDECOMPRA WHERE ID_ORDENDECOMPRA = @pk_ID_ORDENDECOMPRA;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.ORDENDECOMPRA
       SET CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO,
           FECHAEMISION         = @p_FECHAEMISION,
           CONSECUTIVO          = @p_CONSECUTIVO,
           CODCOMPANIA          = @p_CODCOMPANIA,
           CODUSUARIOSOLICITUD  = @p_CODUSUARIOSOLICITUD,
           FECHAHORASOLICITUD   = @p_FECHAHORASOLICITUD,
           ESTADOAPROBACION     = @p_ESTADOAPROBACION,
           COMENTARIOAPROBACION = @p_COMENTARIOAPROBACION,
           CODUSUARIOAPROBACION = @p_CODUSUARIOAPROBACION,
           FECHAHORAAPROBACION  = @p_FECHAHORAAPROBACION,
           TOTALORDENDECOMPRA   = @p_TOTALORDENDECOMPRA,
           FACTURADO            = @p_FACTURADO,
           CODFACTURACIONALIADO = @p_CODFACTURACIONALIADO,
           RECIBIDO             = @p_RECIBIDO,
           FECHAHORARECIBIDO    = @p_FECHAHORARECIBIDO
     WHERE ID_ORDENDECOMPRA = @pk_ID_ORDENDECOMPRA;
	
	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;	
	 -- Make sure only one record is affected
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
	  RETURN 0;
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
	  RETURN 0;
    END 
	
    IF @xCurrentState = 'I' AND @p_ESTADOAPROBACION = 'A' BEGIN
        DECLARE @xUsuarioAprobacion VARCHAR(4000)   /* Use -meta option USUARIO.NOMUSUARIO%TYPE */;
        DECLARE @xAliadoOrdenDeCompra VARCHAR(4000) /* Use -meta option ALIADOESTRATEGICO.NOMALIADOESTRATEGICO%TYPE */;
      BEGIN
        SELECT @xUsuarioAprobacion = NOMBRE FROM WSXML_SFG.USUARIO WHERE ID_USUARIO = @p_CODUSUARIOAPROBACION;
        SELECT @xAliadoOrdenDeCompra = NOMALIADOESTRATEGICO FROM WSXML_SFG.ALIADOESTRATEGICO WHERE ID_ALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO;
        --SFGALERTA.GenerarAlerta(SFGALERTA.TIPOINFORMATIVO, 'ORDENDECOMPRA', 'Se ha aprobado la orden de compra ' || p_CODCOMPANIA || ' (' || xUsuarioAprobacion || ') en el sistema para el proveedor ' || xAliadoOrdenDeCompra || ' por ' || SFG_PACKAGE.CurrencyFormat(NVL(p_TOTALORDENDECOMPRA, 0)) || '.', 2);
      END;

    END 
    
  END;
GO

  -- Deletes a record from the ORDENDECOMPRA table.
  IF OBJECT_ID('WSXML_SFG.SFGWEBORDENDECOMPRA_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_DeleteRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_DeleteRecord(@pk_ID_ORDENDECOMPRA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    DELETE WSXML_SFG.ORDENDECOMPRA WHERE ID_ORDENDECOMPRA = @pk_ID_ORDENDECOMPRA;
  END;
GO

  -- Deletes the set of rows from the ORDENDECOMPRA table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.
  IF OBJECT_ID('WSXML_SFG.SFGWEBORDENDECOMPRA_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_DeleteRecords;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_DeleteRecords(@p_where_str NVARCHAR(2000), @p_num_deleted NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @l_where_str NVARCHAR(MAX);
    DECLARE @l_query_str NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    -- Initialize the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL BEGIN
      SET @l_where_str = ' WHERE ' + isnull(@p_where_str, '');
    END 

    SET @p_num_deleted = 0;

    -- Set up the query string
    SET @l_query_str = 'DELETE WSXML_SFG.ORDENDECOMPRA ' + isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

  END;
GO

  -- Returns a specific record from the ORDENDECOMPRA table.
  IF OBJECT_ID('WSXML_SFG.SFGWEBORDENDECOMPRA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_GetRecord(@pk_ID_ORDENDECOMPRA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.ORDENDECOMPRA
     WHERE ID_ORDENDECOMPRA = @pk_ID_ORDENDECOMPRA;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 
      SELECT ID_ORDENDECOMPRA,
             CODALIADOESTRATEGICO,
             FECHAEMISION,
             CONSECUTIVO,
             CODCOMPANIA,
             CODUSUARIOSOLICITUD,
             FECHAHORASOLICITUD,
             ESTADOAPROBACION,
             COMENTARIOAPROBACION,
             CODUSUARIOAPROBACION,
             FECHAHORAAPROBACION,
             TOTALORDENDECOMPRA,
             FACTURADO,
             CODFACTURACIONALIADO,
             RECIBIDO,
             FECHAHORARECIBIDO
        FROM WSXML_SFG.ORDENDECOMPRA
       WHERE ID_ORDENDECOMPRA = @pk_ID_ORDENDECOMPRA;
	;	   
  END;
GO

  -- Returns a query resultset from table ORDENDECOMPRA
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
  IF OBJECT_ID('WSXML_SFG.SFGWEBORDENDECOMPRA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_GetList(@p_join_str    NVARCHAR(2000),
                    @p_where_str   NVARCHAR(2000),
                    @p_sort_str    NVARCHAR(2000),
                    @p_page_number INTEGER,
                    @p_batch_size  INTEGER,
                   @p_total_size  INTEGER OUT) AS
 BEGIN
    DECLARE @l_query_from        VARCHAR(MAX);
    DECLARE @l_query_where       VARCHAR(MAX);
    DECLARE @l_query_cols        VARCHAR(MAX);
    DECLARE @l_from_str          VARCHAR(MAX);
    DECLARE @l_alias_str         VARCHAR(MAX);
    DECLARE @l_join_str          VARCHAR(MAX);
    DECLARE @l_sort_str          VARCHAR(MAX);
    DECLARE @l_where_str         VARCHAR(MAX);
    DECLARE @l_count_query       VARCHAR(MAX);
    DECLARE @l_end_gen_row_num   INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    -- Set up the from string as the base table.
    SET @l_from_str  = 'WSXML_SFG.ORDENDECOMPRA ORDENDECOMPRA_';
    SET @l_alias_str = 'ORDENDECOMPRA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null BEGIN
      SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null BEGIN
      SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0 BEGIN
      SET @l_count_query = 'SELECT count(*) ' + 'FROM ' + isnull(@l_from_str, '') + ' ' +
                       isnull(@l_join_str, '') + ' ' + isnull(@l_where_str, '') + ' ';

      -- Run the count query
      EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
        @p_total_size output;
    END 

    -- Set up column name variable(s)
    SET @l_query_cols = 'ORDENDECOMPRA_.ID_ORDENDECOMPRA,
            ORDENDECOMPRA_.CODALIADOESTRATEGICO,
            ORDENDECOMPRA_.FECHAEMISION,
            ORDENDECOMPRA_.CONSECUTIVO,
            ORDENDECOMPRA_.CODCOMPANIA,
            ORDENDECOMPRA_.CODUSUARIOSOLICITUD,
            ORDENDECOMPRA_.FECHAHORASOLICITUD,
            ORDENDECOMPRA_.ESTADOAPROBACION,
            ORDENDECOMPRA_.COMENTARIOAPROBACION,
            ORDENDECOMPRA_.CODUSUARIOAPROBACION,
            ORDENDECOMPRA_.FECHAHORAAPROBACION,
            ORDENDECOMPRA_.TOTALORDENDECOMPRA,
            ORDENDECOMPRA_.FACTURADO,
            ORDENDECOMPRA_.CODFACTURACIONALIADO,
            ORDENDECOMPRA_.RECIBIDO,
            ORDENDECOMPRA_.FECHAHORARECIBIDO';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0 BEGIN
      -- If the caller did not pass a sort string, use a default value
      IF @p_sort_str IS NOT NULL BEGIN
        SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
      END
      ELSE BEGIN
        SET @l_sort_str = 'ORDER BY ORDENDECOMPRA_.ID_ORDENDECOMPRA ASC ';

      END 

      -- Calculate the rows to be included in the list
      -- before geting the list.
      SET @l_end_gen_row_num   = @p_page_number * @p_batch_size;
      SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size - 1);

      -- Run the query
      SET @sql =  ' SELECT ' + isnull(@l_query_cols, '') + ' ' +
 'FROM ( SELECT ' + isnull(@l_query_cols, '') + ' ' +
 ' ' + ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER ' + 'FROM ( SELECT ' + isnull(@l_query_cols, '') + ' ' +
 ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' + isnull(@l_where_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + 'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' + 'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' + 'ORDER BY ISD_ROW_NUMBER; ';
      EXECUTE sp_executesql @sql,N'@l_start_gen_row_num INT, @l_end_gen_row_num INT',@l_start_gen_row_num, @l_end_gen_row_num
    END
    ELSE BEGIN
      -- If page number and batch size are not valid numbers
      -- return an empty result set
      SET @sql =  ' SELECT ' + isnull(@l_query_cols, '') + ' ' +
 ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + 'WHERE 1=2 ';
      EXECUTE sp_executesql @sql
    END 

  END;
GO

  -- Returns a query result from table ORDENDECOMPRA
  -- given the search criteria and sorting condition.
  IF OBJECT_ID('WSXML_SFG.SFGWEBORDENDECOMPRA_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_DrillDown;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_DrillDown(@p_select_str   NVARCHAR(2000),
                      @p_is_distinct  INTEGER,
                      @p_select_str_b NVARCHAR(2000),
                      @p_join_str     NVARCHAR(2000),
                      @p_where_str    NVARCHAR(2000),
                      @p_sort_str     NVARCHAR(2000),
                      @p_page_number  INTEGER,
                      @p_batch_size   INTEGER,
                     @p_total_size   INTEGER OUT) AS
 BEGIN
    DECLARE @l_query_select      VARCHAR(MAX);
    DECLARE @l_query_select_b    VARCHAR(MAX);
    DECLARE @l_query_from        VARCHAR(MAX);
    DECLARE @l_query_where       VARCHAR(MAX);
    DECLARE @l_from_str          VARCHAR(MAX);
    DECLARE @l_alias_str         VARCHAR(MAX);
    DECLARE @l_join_str          VARCHAR(MAX);
    DECLARE @l_sort_str          VARCHAR(MAX);
    DECLARE @l_where_str         VARCHAR(MAX);
    DECLARE @l_count_query       VARCHAR(MAX);
    DECLARE @l_end_gen_row_num   INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    -- Set up the from string as the base table.
	SET @l_query_select = @p_select_str;
    SET @l_from_str     = 'WSXML_SFG.ORDENDECOMPRA ORDENDECOMPRA_';
    SET @l_alias_str    = 'ORDENDECOMPRA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null BEGIN
      SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null BEGIN
      SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0 BEGIN
      IF @p_is_distinct = 0 BEGIN
        SET @l_count_query = 'SELECT @p_total_size = count(*) FROM ( SELECT ' + isnull(@p_select_str, '') + ' ' +
                         'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str + ' ' +
                         isnull(@l_where_str, '') + ' ) countAlias', '');
      END
      ELSE BEGIN
        SET @l_count_query = 'SELECT @p_total_size = COUNT(*) FROM ( SELECT DISTINCT ' +
                         isnull(@p_select_str, '') + ', 1 As count1  ' + 'FROM ' +
                         isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
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
    IF @p_page_number > 0 AND @p_batch_size > 0 BEGIN
      -- If the caller did not pass a sort string, use a default value
      IF @p_sort_str IS NOT NULL BEGIN
        SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
      END
      ELSE BEGIN
        SET @l_sort_str = 'ORDER BY ' + @l_query_select;
      END 

      -- Calculate the rows to be included in the list
      -- before geting the list.
      SET @l_end_gen_row_num   = @p_page_number * @p_batch_size;
      SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size - 1);

      IF @p_is_distinct = 0 BEGIN
        SET @l_query_select_b = @p_select_str_b;
      END
      ELSE BEGIN
        SET @l_query_select_b = 'DISTINCT ' + isnull(@p_select_str_b, '');
      END 

      -- Run the query
		SET @sql =  ' SELECT ' + isnull(@l_query_select, '') + ' ' + 'FROM ( SELECT ' + isnull(@l_query_select, '') + ' ' + ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER ' + 'FROM ( SELECT ' + isnull(@l_query_select_b, '') + ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' + isnull(@l_where_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + 'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' + 'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' + 'ORDER BY ISD_ROW_NUMBER; ';
		EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
      -- If page number and batch size are not valid numbers
      -- return an empty result set
	  SET @sql =  ' SELECT ' + isnull(@l_query_select, '') + ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + 'WHERE 1=2; ';
	  EXECUTE sp_executesql @sql;
    END 

  END;
GO

  -- Returns a query result from table ORDENDECOMPRA
  -- given the search criteria and sorting condition.
  IF OBJECT_ID('WSXML_SFG.SFGWEBORDENDECOMPRA_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_GetStats;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_GetStats(@p_select_str  NVARCHAR(2000),
                     @p_join_str    NVARCHAR(2000),
                     @p_where_str   NVARCHAR(2000),
                     @p_sort_str    NVARCHAR(2000),
                     @p_page_number INTEGER,
                    @p_batch_size  INTEGER) AS
 BEGIN
    DECLARE @l_query_select      VARCHAR(MAX);
    DECLARE @l_query_from        VARCHAR(MAX);
    DECLARE @l_query_where       VARCHAR(MAX);
    DECLARE @l_from_str          VARCHAR(MAX);
    DECLARE @l_alias_str         VARCHAR(MAX);
    DECLARE @l_join_str          VARCHAR(MAX);
    DECLARE @l_sort_str          VARCHAR(MAX);
    DECLARE @l_where_str         VARCHAR(MAX);
    DECLARE @l_stat_col          VARCHAR(MAX);
    DECLARE @l_select_col        VARCHAR(MAX);
    DECLARE @l_end_gen_row_num   INTEGER;
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
    IF CHARINDEX('DISTINCT ', UPPER(@l_stat_col)) = 1 BEGIN
      SET @l_stat_col = SUBSTRING(@l_stat_col,
                           CHARINDEX(' ', @l_stat_col) + 1,
                           LEN(@l_stat_col));
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

    SET @l_from_str     = 'WSXML_SFG.ORDENDECOMPRA ORDENDECOMPRA_';
    SET @l_alias_str    = 'ORDENDECOMPRA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null BEGIN
      SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null BEGIN
      SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0 BEGIN
      -- If the caller did not pass a sort string, use a default value
      IF @p_sort_str IS NOT NULL BEGIN
        SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
      END
      ELSE BEGIN
        SET @l_sort_str = 'ORDER BY ' + @l_stat_col;
      END 

      -- Calculate the rows to be included in the list
      -- before geting the list.
      SET @l_end_gen_row_num   = @p_page_number * @p_batch_size;
      SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size - 1);

      -- Run the query
      SET @sql =  ' SELECT ' + isnull(@l_query_select, '') + ' ' + 'FROM ( SELECT ' + isnull(@l_stat_col, '') + ' ' + ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER ' + 'FROM ( SELECT ' + isnull(@l_select_col, '') + ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' + isnull(@l_where_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + ') ' + isnull(@l_alias_str, '') + ' ' + 'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' + 'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' + 'ORDER BY ISD_ROW_NUMBER; ';
      EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
      -- If page number and batch size are not valid numbers
      -- return an empty result set
		SET @sql =  ' SELECT ' + isnull(@l_query_select, '') + ' ' + 'FROM ' + isnull(@l_from_str, '') + ' ' + 'WHERE 1=2; ';
		EXECUTE sp_executesql @sql;
    END 

  END;
GO

  -- Returns the query result set in a CSV format
  -- so that the data can be exported to a CSV file
  IF OBJECT_ID('WSXML_SFG.SFGWEBORDENDECOMPRA_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_Export;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEBORDENDECOMPRA_Export(@p_separator_str NVARCHAR(2000),
                   @p_title_str     NVARCHAR(2000),
                   @p_select_str    NVARCHAR(2000),
                   @p_join_str      NVARCHAR(2000),
                   @p_where_str     NVARCHAR(2000),
                  @p_num_exported  INTEGER OUT) AS
 BEGIN
    DECLARE @l_title_str    VARCHAR(MAX);
    DECLARE @l_select_str   VARCHAR(MAX);
    DECLARE @l_from_str     VARCHAR(MAX);
    DECLARE @l_join_str     VARCHAR(MAX);
    DECLARE @l_where_str    VARCHAR(MAX);
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_union  VARCHAR(MAX);
    DECLARE @l_query_from   VARCHAR(MAX);
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    -- Set up the title string from the column names.  Excel
    -- will complain if the first column value is ID. So wrap
    -- the value with .
    SET @l_title_str = isnull(@p_title_str, '') + isnull(char(13), '');
    IF @p_title_str IS NULL BEGIN
      SET @l_title_str = 'XID_ORDENDECOMPRA' + isnull(@p_separator_str, '') +
                     'CODALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                     'CODALIADOESTRATEGICO NOMALIADOESTRATEGICO' +
                     isnull(@p_separator_str, '') + 'FECHAEMISION' + isnull(@p_separator_str, '') +
                     'CONSECUTIVO' + isnull(@p_separator_str, '') + 'CODCOMPANIA' +
                     isnull(@p_separator_str, '') + 'CODCOMPANIA NOMCOMPANIA' +
                     isnull(@p_separator_str, '') + 'CODUSUARIOSOLICITUD' +
                     isnull(@p_separator_str, '') + 'CODUSUARIOSOLICITUD NOMBRE' +
                     isnull(@p_separator_str, '') + 'FECHAHORASOLICITUD' +
                     isnull(@p_separator_str, '') + 'ESTADOAPROBACION' +
                     isnull(@p_separator_str, '') + 'COMENTARIOAPROBACION' +
                     isnull(@p_separator_str, '') + 'CODUSUARIOAPROBACION' +
                     isnull(@p_separator_str, '') + 'CODUSUARIOAPROBACION NOMBRE' +
                     isnull(@p_separator_str, '') + 'FECHAHORAAPROBACION' +
                     isnull(@p_separator_str, '') + 'TOTALORDENDECOMPRA' +
                     isnull(@p_separator_str, '') + 'FACTURADO' + isnull(@p_separator_str, '') +
                     'CODFACTURACIONALIADO' + isnull(@p_separator_str, '') +
                     'CODFACTURACIONALIADO FACTURACIONACOBRAR' +
                     isnull(@p_separator_str, '') + 'RECIBIDO' + isnull(@p_separator_str, '') +
                     'FECHAHORARECIBIDO' + ' ';
    END 

    IF SUBSTRING(@l_title_str, 1, 2) = 'ID' BEGIN
      SET @l_title_str = '' +
                     ISNULL(SUBSTRING(@l_title_str, 1, CHARINDEX(',', @l_title_str) - 1), '') + '' +
                     ISNULL(SUBSTRING(@l_title_str,
                            CHARINDEX(',', @l_title_str),
                            LEN(@l_title_str)), '');
    END 

    -- Set up the select string
    SET @l_select_str = @p_select_str;
    IF @p_select_str IS NULL BEGIN
      SET @l_select_str = 'ISNULL(ORDENDECOMPRA_.ID_ORDENDECOMPRA, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(ORDENDECOMPRA_.CODALIADOESTRATEGICO, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST( t0.NOMALIADOESTRATEGICO AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(dbo.ConvertFecha(ORDENDECOMPRA_.FECHAEMISION), '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST(ORDENDECOMPRA_.CONSECUTIVO AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(ORDENDECOMPRA_.CODCOMPANIA, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST( t1.NOMCOMPANIA AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(ORDENDECOMPRA_.CODUSUARIOSOLICITUD, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST( t2.NOMBRE AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(dbo.ConvertFecha(ORDENDECOMPRA_.FECHAHORASOLICITUD), '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST(ORDENDECOMPRA_.ESTADOAPROBACION AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST(ORDENDECOMPRA_.COMENTARIOAPROBACION AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(ORDENDECOMPRA_.CODUSUARIOAPROBACION, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST( t3.NOMBRE  AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(dbo.ConvertFecha(ORDENDECOMPRA_.FECHAHORAAPROBACION), '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(ORDENDECOMPRA_.TOTALORDENDECOMPRA, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST(ORDENDECOMPRA_.FACTURADO AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(ORDENDECOMPRA_.CODFACTURACIONALIADO, '''') + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST( t4.FACTURACIONACOBRAR  AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      ''''' + REPLACE(ISNULL(CAST(ORDENDECOMPRA_.RECIBIDO AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' +
                      isnull(@p_separator_str, '') + ''' +' +
                      'ISNULL(dbo.ConvertFecha(ORDENDECOMPRA_.FECHAHORARECIBIDO), '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.ORDENDECOMPRA ORDENDECOMPRA_ LEFT OUTER JOIN WSXML_SFG.ALIADOESTRATEGICO t0 ON (ORDENDECOMPRA_.CODALIADOESTRATEGICO =  t0.ID_ALIADOESTRATEGICO) LEFT OUTER JOIN WSXML_SFG.COMPANIA t1 ON (ORDENDECOMPRA_.CODCOMPANIA =  t1.ID_COMPANIA) LEFT OUTER JOIN WSXML_SFG.USUARIO t2 ON (ORDENDECOMPRA_.CODUSUARIOSOLICITUD =  t2.ID_USUARIO) LEFT OUTER JOIN WSXML_SFG.USUARIO t3 ON (ORDENDECOMPRA_.CODUSUARIOAPROBACION =  t3.ID_USUARIO) LEFT OUTER JOIN WSXML_SFG.FACTURACIONALIADO t4 ON (ORDENDECOMPRA_.CODFACTURACIONALIADO =  t4.ID_FACTURACIONALIADO)';

    SET @l_join_str = @p_join_str;
    IF @p_join_str IS NULL BEGIN
      SET @l_join_str = ' ';
    END 

    -- Set up the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL BEGIN
      SET @l_where_str = isnull(@l_where_str, '') + 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Construct the query string.  Append the result set with the title.
    SET @l_query_select = 'SELECT ''';
    SET @l_query_union  = ''' UNION ALL ' + 'SELECT ';
    SET @l_query_from   = ' FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
                      isnull(@l_where_str, '');

    -- Run the query
    SET @sql = 
    (' '+isnull(@l_query_select, '') + isnull(@l_title_str, '') + isnull(@l_query_union, '') + isnull(@l_select_str, '')+ isnull(@l_query_from, '')+' ');
    EXECUTE sp_executesql @sql;

  END;
GO






