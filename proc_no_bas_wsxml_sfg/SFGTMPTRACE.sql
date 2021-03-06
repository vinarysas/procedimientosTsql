USE SFGPRODU;
--  DDL for Package Body SFGTMPTRACE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTMPTRACE */ 

IF OBJECT_ID('WSXML_SFG.SFGTMPTRACE_TraceLog', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTMPTRACE_TraceLog;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTMPTRACE_TraceLog(@p_CONTENIDO NVARCHAR(2000)) AS
BEGIN
  SET NOCOUNT ON;
	BEGIN TRY
		INSERT INTO WSXML_SFG.TMPTRACE ( DESCRIPCION) VALUES ( @p_CONTENIDO);
	END TRY
	BEGIN CATCH
		--EXCEPTION WHEN OTHERS THEN
		DECLARE @msg NVARCHAR(1000);
		BEGIN TRY
			SET @msg = ERROR_MESSAGE(); --SQLERRM;
			INSERT INTO WSXML_SFG.TMPTRACE ( DESCRIPCION) VALUES ( @msg);
		END TRY
		BEGIN CATCH
			--EXCEPTION WHEN OTHERS THEN NULL;
			SELECT NULL;
		END CATCH
	END CATCH
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGTMPTRACE_TraceLog_1', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTMPTRACE_TraceLog_1;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTMPTRACE_TraceLog_1(@p_CONTENIDO NVARCHAR(2000), @p_PROCESO NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
	BEGIN TRY
		INSERT INTO WSXML_SFG.TMPTRACE ( DESCRIPCION) VALUES ( ISNULL(@p_PROCESO, '') + ': ' + ISNULL(@p_CONTENIDO, ''));
	END TRY
	BEGIN CATCH
		-- EXCEPTION WHEN OTHERS THEN
		DECLARE @msg NVARCHAR(1000);
	    BEGIN TRY
			SET @msg = ERROR_MESSAGE();--SQLERRM;
			INSERT INTO WSXML_SFG.TMPTRACE ( DESCRIPCION ) VALUES ( @msg );
		END TRY
		BEGIN CATCH
			--EXCEPTION WHEN OTHERS THEN NULL;
			SELECT NULL;
		END CATCH
	END CATCH
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGTMPTRACE_Templates', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTMPTRACE_Templates;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTMPTRACE_Templates(@p_CODLINEADENEGOCIO NUMERIC(22,0), @p_cur varchar(8000)  OUTPUT) AS
    DECLARE @strMAXCOLMNVAL VARCHAR(MAX) = '';
    DECLARE @strPRODCOLUMNS VARCHAR(MAX) = '';
    DECLARE @strSQLINSTRUCT VARCHAR(MAX) = '';
    DECLARE @strWHERECLAUSE VARCHAR(MAX) = '';
    DECLARE @lstCOLUMNNAMES TABLE (COLUMNNAMES VARCHAR(300))
	DECLARE @sql NVARCHAR(MAX);
    
  BEGIN
    
    DECLARE tPRODUCT CURSOR FOR SELECT ID_PRODUCTO, CODIGOGTECHPRODUCTO, NOMPRODUCTO FROM WSXML_SFG.PRODUCTO
                     INNER JOIN WSXML_SFG.TIPOPRODUCTO ON (CODTIPOPRODUCTO = ID_TIPOPRODUCTO)
                     WHERE CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                       AND PRODUCTO.ACTIVE = 1
                     ORDER BY CODIGOGTECHPRODUCTO; OPEN tPRODUCT;

	DECLARE @tPRODUCT__ID_PRODUCTO NUMERIC(38,0), @tPRODUCT__CODIGOGTECHPRODUCTO NUMERIC(38,0), @tPRODUCT__NOMPRODUCTO VARCHAR(256)

	 FETCH NEXT FROM tPRODUCT INTO @tPRODUCT__ID_PRODUCTO, @tPRODUCT__CODIGOGTECHPRODUCTO, @tPRODUCT__NOMPRODUCTO;
	 WHILE @@FETCH_STATUS=0
	 BEGIN
        DECLARE @thisCOLUMNNAME VARCHAR(50);
        DECLARE @existsINLIST NUMERIC(22,0) = 0;
		BEGIN
        IF (SELECT COUNT(*) FROM @lstCOLUMNNAMES) > 0 BEGIN
          DECLARE ix CURSOR FOR SELECT COLUMNNAMES, ROW_NUMBER() OVER(order by COLUMNNAMES asc)  AS ROWID FROM @lstCOLUMNNAMES
		  OPEN ix

			DECLARE @ix__COLUMNNAMES varchar(300), @ix__ROWID AS NUMERIC(38,0)
		
			FETCH NEXT FROM ix INTO @ix__COLUMNNAMES,@ix__ROWID
        
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF (@ix__COLUMNNAMES = '"' + ISNULL(@tPRODUCT__CODIGOGTECHPRODUCTO, '') + '.' + ISNULL(CASE WHEN LEN(@tPRODUCT__NOMPRODUCTO) > 20 THEN SUBSTRING(@tPRODUCT__NOMPRODUCTO, 0, 20) ELSE @tPRODUCT__NOMPRODUCTO END, '') + '"') BEGIN
				  SET @existsINLIST = 1;
				END 
				FETCH NEXT FROM ix INTO @ix__COLUMNNAMES,@ix__ROWID
			END;
			CLOSE ix;
			DEALLOCATE ix;
        END 
        IF @existsINLIST = 0 BEGIN
          SET @thisCOLUMNNAME = CONVERT(VARCHAR, '"' + ISNULL(@tPRODUCT__CODIGOGTECHPRODUCTO, '') + '.' + ISNULL(CASE WHEN LEN(@tPRODUCT__NOMPRODUCTO) > 20 THEN SUBSTRING(@tPRODUCT__NOMPRODUCTO, 0, 20) ELSE @tPRODUCT__NOMPRODUCTO END, '') + '"');

          INSERT INTO @lstCOLUMNNAMES VALUES(@thisCOLUMNNAME)
          SET @strPRODCOLUMNS = ISNULL(@strPRODCOLUMNS, '') + ', CASE WHEN PPD.CODPRODUCTO = ' + ISNULL(@tPRODUCT__ID_PRODUCTO, '') + ' THEN RCM.NOMRANGOCOMISION ELSE NULL END AS ' + ISNULL(@thisCOLUMNNAME, '');
          SET @strMAXCOLMNVAL = ISNULL(@strMAXCOLMNVAL, '') + ', MAX(' + ISNULL(@thisCOLUMNNAME, '') + ') AS ' + ISNULL(@thisCOLUMNNAME, '') + ' ';
        END 
      END;
		FETCH NEXT FROM tPRODUCT INTO @tPRODUCT__ID_PRODUCTO, @tPRODUCT__CODIGOGTECHPRODUCTO, @tPRODUCT__NOMPRODUCTO;
	 END;
     CLOSE tPRODUCT;
     DEALLOCATE tPRODUCT;

    SET @strSQLINSTRUCT = 'SELECT PPR.CODAGRUPACIONPUNTODEVENTA, PPR.NOMPLANTILLAPRODUCTO';
    SET @strWHERECLAUSE = 'FROM PLANTILLAPRODUCTO PPR ' +
                      'INNER JOIN PLANTILLAPRODUCTODETALLE PPD ON (PPR.ID_PLANTILLAPRODUCTO = PPD.CODPLANTILLAPRODUCTO) ' +
                      'INNER JOIN RANGOCOMISION RCM ON (PPD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION) ' +
                      'WHERE PPR.CODLINEADENEGOCIO = ' + ISNULL(@p_CODLINEADENEGOCIO, '') + ' ' +
                      '  AND PPR.MASTERPLANTILLA = 0';

--    DBMS_OUTPUT.put_line(strSQLINSTRUCT || ' ' || strPRODCOLUMNS || strWHERECLAUSE);
    SET @sql = 
      'SELECT NOMPLANTILLAPRODUCTO AS "Plantilla Diferencial", CODIGOAGRUPACIONGTECH AS "Cadena"' + ISNULL(@strMAXCOLMNVAL, '') +
      'FROM (' + ISNULL(@strSQLINSTRUCT, '') + ' ' + ISNULL(@strPRODCOLUMNS, '') + ISNULL(@strWHERECLAUSE, '') + ') ' +
      'INNER JOIN AGRUPACIONPUNTODEVENTA ON (CODAGRUPACIONPUNTODEVENTA = ID_AGRUPACIONPUNTODEVENTA) ' +
      'GROUP BY CODIGOAGRUPACIONGTECH, NOMPLANTILLAPRODUCTO';
    EXECUTE sp_executesql @sql;
  END;

GO
