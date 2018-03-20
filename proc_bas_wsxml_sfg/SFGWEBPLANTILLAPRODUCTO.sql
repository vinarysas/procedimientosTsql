USE SFGPRODU;
--  DDL for Package Body SFGWEBPLANTILLAPRODUCTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBPLANTILLAPRODUCTO */ 

-- Creates a new record in the PLANTILLAPRODUCTO table
IF OBJECT_ID('WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_AddRecord(
    @p_NOMPLANTILLAPRODUCTO NVARCHAR(2000),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_CODREDPDV NUMERIC(22,0),
    @p_CODCIUDAD NUMERIC(22,0),
    @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_CODLINEADENEGOCIO NUMERIC(22,0),
    @p_MASTERPLANTILLA NUMERIC(22,0),
    @p_ID_PLANTILLAPRODUCTO_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.PLANTILLAPRODUCTO
        (
            NOMPLANTILLAPRODUCTO,
            CODUSUARIOMODIFICACION,
            CODREDPDV,
            CODCIUDAD,
            CODAGRUPACIONPUNTODEVENTA,
            CODLINEADENEGOCIO
        )
    VALUES
        (
            @p_NOMPLANTILLAPRODUCTO,
            @p_CODUSUARIOMODIFICACION,
            @p_CODREDPDV,
            @p_CODCIUDAD,
            @p_CODAGRUPACIONPUNTODEVENTA,
            @p_CODLINEADENEGOCIO
        );
       SET
            @p_ID_PLANTILLAPRODUCTO_out = SCOPE_IDENTITY() ;

    -- Call UPDATE for fields that have database defaults
    IF @p_FECHAHORAMODIFICACION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.PLANTILLAPRODUCTO SET FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION WHERE ID_PLANTILLAPRODUCTO = @p_ID_PLANTILLAPRODUCTO_out;
    END 
    IF @p_ACTIVE IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.PLANTILLAPRODUCTO SET ACTIVE = @p_ACTIVE WHERE ID_PLANTILLAPRODUCTO = @p_ID_PLANTILLAPRODUCTO_out;
    END 
    IF @p_MASTERPLANTILLA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.PLANTILLAPRODUCTO SET MASTERPLANTILLA = @p_MASTERPLANTILLA WHERE ID_PLANTILLAPRODUCTO = @p_ID_PLANTILLAPRODUCTO_out;
    END 
      DECLARE @lstPUNTOSASIGNACION LONGNUMBERARRAY;
      DECLARE @msg VARCHAR(MAX);
      DECLARE @thisID_PLANTILLAPRODUCTO      NUMERIC(22,0) = @p_ID_PLANTILLAPRODUCTO_out;
      DECLARE @thisCODUSUARIOMODIFICACION    NUMERIC(22,0) = @p_CODUSUARIOMODIFICACION;
      DECLARE @thisMASTERPLANTILLA           NUMERIC(22,0) = @p_MASTERPLANTILLA;
      DECLARE @thisCODCIUDAD                 NUMERIC(22,0) = @p_CODCIUDAD;
      DECLARE @thisCODAGRUPACIONPUNTODEVENTA NUMERIC(22,0) = @p_CODAGRUPACIONPUNTODEVENTA;
      DECLARE @thisCODREDPDV                 NUMERIC(22,0) = @p_CODREDPDV;
      DECLARE @thisCODLINEADENEGOCIO         NUMERIC(22,0) = @p_CODLINEADENEGOCIO;
    BEGIN
		BEGIN TRY
      -- Se cargan los puntos de venta: una igualdad en reglas significa que se transladan
      -- a la nueva plantilla y se envia una alerta
      --SET @lstPUNTOSASIGNACION = LONGNUMBERARRAY();
			IF @thisMASTERPLANTILLA = 0 AND (@thisCODCIUDAD IS NOT NULL OR @thisCODAGRUPACIONPUNTODEVENTA IS NOT NULL OR @thisCODREDPDV IS NOT NULL) BEGIN
				IF @thisCODCIUDAD IS NOT NULL AND @thisCODAGRUPACIONPUNTODEVENTA IS NOT NULL AND @thisCODREDPDV IS NOT NULL BEGIN
				  -- Criterio 1. Ciudad, Cadena y Red: Se asigna a todos los que cumplan la regla
				  INSERT INTO @lstPUNTOSASIGNACION
				  SELECT ID_PUNTODEVENTA  
				  FROM WSXML_SFG.PUNTODEVENTA
				  WHERE CODCIUDAD = @thisCODCIUDAD
				  AND CODAGRUPACIONPUNTODEVENTA = @thisCODAGRUPACIONPUNTODEVENTA
				  AND CODREDPDV = @thisCODREDPDV;
				END
				ELSE IF @thisCODAGRUPACIONPUNTODEVENTA IS NOT NULL AND @thisCODREDPDV IS NOT NULL BEGIN
				  -- Criterio 2. Cadena y Red
				  INSERT INTO @lstPUNTOSASIGNACION 
				  SELECT ID_PUNTODEVENTA
				  FROM WSXML_SFG.PUNTODEVENTA
				  WHERE CODAGRUPACIONPUNTODEVENTA = @thisCODAGRUPACIONPUNTODEVENTA
				  AND CODREDPDV = @thisCODREDPDV;
				END
				ELSE IF @thisCODAGRUPACIONPUNTODEVENTA IS NOT NULL BEGIN
				  -- Criterio 3. Cadena
				  INSERT INTO @lstPUNTOSASIGNACION
				  SELECT ID_PUNTODEVENTA FROM WSXML_SFG.PUNTODEVENTA
				  WHERE CODAGRUPACIONPUNTODEVENTA = @thisCODAGRUPACIONPUNTODEVENTA;
				END
				ELSE IF @thisCODREDPDV IS NOT NULL BEGIN
				  -- Criterio 4. Red
				  INSERT INTO @lstPUNTOSASIGNACION
				  SELECT ID_PUNTODEVENTA  FROM WSXML_SFG.PUNTODEVENTA
				  WHERE CODREDPDV = @thisCODREDPDV;
				END

					

				IF (SELECT COUNT(*) FROM @lstPUNTOSASIGNACION)  > 0 BEGIN
					DECLARE ix CURSOR FOR SELECT IDVALUE FROM @lstPUNTOSASIGNACION
					OPEN ix
					
					DECLARE @asgmnt_out NUMERIC(22,0), @id_lstPUNTOSASIGNACION NUMERIC(22,0), @out_ID_PUNTODEVENTAPLANTILLA_out NUMERIC(38,0);
					
					FETCH NEXT FROM ix INTO @id_lstPUNTOSASIGNACION  
					WHILE (@@FETCH_STATUS = 0)         
					BEGIN
					  -- Desactivar
					  EXEC WSXML_SFG.SFGPUNTODEVENTAPLANTILLA_DeactivateRecordByData @id_lstPUNTOSASIGNACION,
																	  @thisCODLINEADENEGOCIO,
																	  @thisCODUSUARIOMODIFICACION
					  -- Insertar Registros
					  EXEC WXML_SFG.SFGPUNTODEVENTAPLANTILLA_AddRecord @id_lstPUNTOSASIGNACION,
														 @thisID_PLANTILLAPRODUCTO,
														 NULL,
														 NULL,
														 NULL,
														 @thisCODUSUARIOMODIFICACION,
														 @out_ID_PUNTODEVENTAPLANTILLA_out OUT


						FETCH NEXT FROM ix INTO @id_lstPUNTOSASIGNACION 
					END;

					CLOSE ix;
					DEALLOCATE ix;
				END 
			END 
			
		END TRY
		BEGIN CATCH
		  SET @msg = ERROR_MESSAGE()  
		  EXEC WSXML_SFG.SFGTMPTRACE_TraceLog_1 @msg, 'AUTOMATIC_TEMPLATE_ASSIGNATION'
		END CATCH
    END;
END;
GO

-- Updates a record in the PLANTILLAPRODUCTO table.
IF OBJECT_ID('WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_UpdateRecord(
    @pk_ID_PLANTILLAPRODUCTO NUMERIC(22,0),
    @p_NOMPLANTILLAPRODUCTO NVARCHAR(2000),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_ACTIVE NUMERIC(22,0),
    @p_CODREDPDV NUMERIC(22,0),
    @p_CODCIUDAD NUMERIC(22,0),
    @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_CODLINEADENEGOCIO NUMERIC(22,0),
    @p_MASTERPLANTILLA NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.PLANTILLAPRODUCTO
    SET
            NOMPLANTILLAPRODUCTO = @p_NOMPLANTILLAPRODUCTO,
            FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION,
            CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
            ACTIVE = @p_ACTIVE,
            CODREDPDV = @p_CODREDPDV,
            CODCIUDAD = @p_CODCIUDAD,
            CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA,
            CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO,
            MASTERPLANTILLA = @p_MASTERPLANTILLA
    WHERE ID_PLANTILLAPRODUCTO = @pk_ID_PLANTILLAPRODUCTO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
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

-- Deletes a record from the PLANTILLAPRODUCTO table.
IF OBJECT_ID('WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_DeleteRecord(
    @pk_ID_PLANTILLAPRODUCTO NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.PLANTILLAPRODUCTO
    WHERE ID_PLANTILLAPRODUCTO = @pk_ID_PLANTILLAPRODUCTO;
END;
GO

-- Deletes the set of rows from the PLANTILLAPRODUCTO table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_DeleteRecords(
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
'DELETE WSXML_SFG.PLANTILLAPRODUCTO' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the PLANTILLAPRODUCTO table.
IF OBJECT_ID('WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_GetRecord(
   @pk_ID_PLANTILLAPRODUCTO NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.PLANTILLAPRODUCTO
    WHERE ID_PLANTILLAPRODUCTO = @pk_ID_PLANTILLAPRODUCTO;

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
        ID_PLANTILLAPRODUCTO,
        NOMPLANTILLAPRODUCTO,
        FECHAHORAMODIFICACION,
        CODUSUARIOMODIFICACION,
        ACTIVE,
        CODREDPDV,
        CODCIUDAD,
        CODAGRUPACIONPUNTODEVENTA,
        CODLINEADENEGOCIO,
        MASTERPLANTILLA
    FROM WSXML_SFG.PLANTILLAPRODUCTO
    WHERE ID_PLANTILLAPRODUCTO = @pk_ID_PLANTILLAPRODUCTO;  
END;
GO

-- Returns a query resultset from table PLANTILLAPRODUCTO
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
IF OBJECT_ID('WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_GetList(
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
    SET @l_from_str = 'WSXML_SFG.PLANTILLAPRODUCTO PLANTILLAPRODUCTO_';
    SET @l_alias_str = 'PLANTILLAPRODUCTO_';

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
        'PLANTILLAPRODUCTO_.ID_PLANTILLAPRODUCTO,
            PLANTILLAPRODUCTO_.NOMPLANTILLAPRODUCTO,
            PLANTILLAPRODUCTO_.FECHAHORAMODIFICACION,
            PLANTILLAPRODUCTO_.CODUSUARIOMODIFICACION,
            PLANTILLAPRODUCTO_.ACTIVE,
            PLANTILLAPRODUCTO_.CODREDPDV,
            PLANTILLAPRODUCTO_.CODCIUDAD,
            PLANTILLAPRODUCTO_.CODAGRUPACIONPUNTODEVENTA,
            PLANTILLAPRODUCTO_.CODLINEADENEGOCIO,
            PLANTILLAPRODUCTO_.MASTERPLANTILLA';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY PLANTILLAPRODUCTO_.ID_PLANTILLAPRODUCTO ASC ';

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

-- Returns a query result from table PLANTILLAPRODUCTO
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.PLANTILLAPRODUCTO PLANTILLAPRODUCTO_';
    SET @l_alias_str = 'PLANTILLAPRODUCTO_';

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

-- Returns a query result from table PLANTILLAPRODUCTO
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.PLANTILLAPRODUCTO PLANTILLAPRODUCTO_';
    SET @l_alias_str = 'PLANTILLAPRODUCTO_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBPLANTILLAPRODUCTO_Export(
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
                '''XID_PLANTILLAPRODUCTO' + isnull(@p_separator_str, '') +
                'NOMPLANTILLAPRODUCTO' + isnull(@p_separator_str, '') +
                'FECHAHORAMODIFICACION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION NOMBRE' + isnull(@p_separator_str, '') +
                'ACTIVE' + isnull(@p_separator_str, '') +
                'CODREDPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV NOMREDPDV' + isnull(@p_separator_str, '') +
                'CODCIUDAD' + isnull(@p_separator_str, '') +
                'CODCIUDAD NOMCIUDAD' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO NOMLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'MASTERPLANTILLA' + ' ''';
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
                ' isnull(CAST(PLANTILLAPRODUCTO_.ID_PLANTILLAPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(PLANTILLAPRODUCTO_.NOMPLANTILLAPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(PLANTILLAPRODUCTO_.FECHAHORAMODIFICACION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PLANTILLAPRODUCTO_.CODUSUARIOMODIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMBRE, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(PLANTILLAPRODUCTO_.ACTIVE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PLANTILLAPRODUCTO_.CODREDPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMREDPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PLANTILLAPRODUCTO_.CODCIUDAD AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMCIUDAD, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PLANTILLAPRODUCTO_.CODAGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(PLANTILLAPRODUCTO_.CODLINEADENEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t4.NOMLINEADENEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(PLANTILLAPRODUCTO_.MASTERPLANTILLA, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.PLANTILLAPRODUCTO PLANTILLAPRODUCTO_ LEFT OUTER JOIN WSXML_SFG.USUARIO t0 ON (PLANTILLAPRODUCTO_.CODUSUARIOMODIFICACION =  t0.ID_USUARIO) LEFT OUTER JOIN WSXML_SFG.REDPDV t1 ON (PLANTILLAPRODUCTO_.CODREDPDV =  t1.ID_REDPDV) LEFT OUTER JOIN WSXML_SFG.CIUDAD t2 ON (PLANTILLAPRODUCTO_.CODCIUDAD =  t2.ID_CIUDAD) LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA t3 ON (PLANTILLAPRODUCTO_.CODAGRUPACIONPUNTODEVENTA =  t3.ID_AGRUPACIONPUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO t4 ON (PLANTILLAPRODUCTO_.CODLINEADENEGOCIO =  t4.ID_LINEADENEGOCIO)';

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






