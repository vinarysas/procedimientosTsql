USE SFGPRODU;
--  DDL for Package Body SFGVISTA_REGISTROS_FACTURADOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGVISTA_REGISTROS_FACTURADOS */ 

  -- Author  : DAMN IT '<DAMIAN>
  -- Created : 14/01/2009 03:19:43 p.m.
  -- Purpose : VISTA PDV FACTURADOS

IF OBJECT_ID('WSXML_SFG.SFGVISTA_REGISTROS_FACTURADOS_GetPDVFacturados', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGVISTA_REGISTROS_FACTURADOS_GetPDVFacturados;
GO

CREATE     PROCEDURE WSXML_SFG.SFGVISTA_REGISTROS_FACTURADOS_GetPDVFacturados( -- NECESARIOS SON ID
                               @P_CICLO               NUMERIC(22,0),
                               @P_LINEA               NUMERIC(22,0),
                              -- OPCIONALES
                                @P_RED                 NUMERIC(22,0),
                                @P_CADENA              NUMERIC(22,0),
                                @P_TIPO_PRD            NUMERIC(22,0),
                                @P_PRODUCTO            NUMERIC(22,0),
                                @P_PDV                 NUMERIC(22,0),
                              -- PAGINACION
                                @p_page_number         INTEGER,
                                @p_batch_size          INTEGER,
                               @p_total_size          INTEGER OUT) AS
 BEGIN

      DECLARE @STR_QUERY_INT VARCHAR(MAX) = '';
      DECLARE @STR_QUERY_EXT VARCHAR(MAX) = '';
      DECLARE @HigerBound   INTEGER ;
      DECLARE @LowerBound   INTEGER ;
	  DECLARE @l_count_query NVARCHAR(MAX);
      DECLARE @sql NVARCHAR(MAX);
       
      SET NOCOUNT ON;

       SET @STR_QUERY_INT =
       'SELECT  CFP.ID_CICLOFACTURACIONPDV AS CICLO,
                MFP.CODLINEADENEGOCIO AS LINEA, 
				ROW_NUMBER() OVER(ORDER BY ID_CICLOFACTURACIONPDV ASC) ROW_NUMBER,
				';

       IF @P_PDV IS NOT NULL BEGIN
          SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' ID_PUNTODEVENTA AS PDV, ';
       END 

       IF @P_RED IS NOT NULL BEGIN
          SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' CODREDPDV AS RED, ';
       END 

       IF @P_CADENA IS NOT NULL BEGIN
            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' ID_AGRUPACIONPUNTODEVENTA AS CADENA, ';
       END 

       IF @P_TIPO_PRD IS NOT NULL BEGIN
            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' CODTIPOPRODUCTO AS TIPO, ';
       END 

       IF @P_PRODUCTO IS NOT NULL BEGIN
            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' ID_PRODUCTO AS PRODUCTO, ';
       END 

       SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') +'
                (SELECT SUM(PAL.ACTIVE) AS PDV_REGISTRADO FROM PUNTODEVENTA PAL) AS PDV_ACTIVOS,
                SUM(CASE WHEN PDV.ACTIVE = 1 THEN 1 ELSE 0 END) AS PDV_FACTURADO,
                SUM(CASE WHEN PDV.ACTIVE = 0 THEN 1 ELSE 0 END) AS PDV_NO_FACTURADO,
                SUM(REGISTROS_FACTURADOS) AS REGISTROS_FACTURADOS,
                SUM(REGISTROS_NO_FACTURADOS) AS REGISTROS_NO_FACTURADOS,
                MIN(FACTURADO_OK) AS FACTURADO_OK
                FROM WSXML_SFG.CICLOFACTURACIONPDV CFP
                INNER JOIN WSXML_SFG.PUNTODEVENTA PDV ON 1 = 1';
                IF @P_RED IS NOT NULL AND @P_RED <> -1 BEGIN
                  SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND PDV.CODREDPDV = ' + ISNULL(@P_RED, '');
                END 

                IF @P_PDV IS NOT NULL AND @P_PDV <> -1 BEGIN
                  SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND PDV.ID_PUNTODEVENTA = ' + ISNULL(@P_PDV, '');
                END 

                IF @P_CICLO IS NOT NULL AND @P_CICLO <> -1 BEGIN
                  SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND CFP.ID_CICLOFACTURACIONPDV = ' + ISNULL(@P_CICLO, '') ;
                END 

                SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + '
                INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFP
                      ON  MFP.CODCICLOFACTURACIONPDV = CFP.ID_CICLOFACTURACIONPDV
                      AND MFP.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA';
                      IF @P_LINEA IS NOT NULL AND @P_LINEA <> -1 BEGIN
                        SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND MFP.CODLINEADENEGOCIO = ' + ISNULL(@P_LINEA, '') ;
                      END 

                SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + '
                INNER JOIN (SELECT CTR.CODCICLOFACTURACIONPDV, REG.CODPUNTODEVENTA, TPR.CODLINEADENEGOCIO,
                                   SUM(CASE WHEN REG.FACTURADO = 1 THEN 1 ELSE 0 END) AS REGISTROS_FACTURADOS,
                                   SUM(CASE WHEN REG.FACTURADO = 0 THEN 1 ELSE 0 END) AS REGISTROS_NO_FACTURADOS,
                                   CASE WHEN MIN(REG.FACTURADO) = 1 THEN 1 ELSE 0 END AS FACTURADO_OK';
                                   IF @P_TIPO_PRD IS NOT NULL BEGIN
                                        SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' , CODTIPOPRODUCTO';
                                   END 
                                   IF @P_PRODUCTO IS NOT NULL BEGIN
                                        SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ', ID_PRODUCTO';
                                   END 
                            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + '
                            FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
                            INNER JOIN WSXML_SFG.REGISTROFACTURACION REG
                                  ON REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL
                                  AND REG.CODTIPOREGISTRO <> 5
                            INNER JOIN WSXML_SFG.PRODUCTO PRD
                                  ON PRD.ID_PRODUCTO = REG.CODPRODUCTO';
                                  IF @P_TIPO_PRD IS NOT NULL AND @P_TIPO_PRD <> -1 BEGIN
                                    SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND PRD.CODTIPOPRODUCTO = ' + ISNULL(@P_TIPO_PRD, '') ;
                                  END 
                                  IF @P_PRODUCTO IS NOT NULL AND @P_PRODUCTO <> -1 BEGIN
                                    SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND PRD.ID_PRODUCTO = ' + ISNULL(@P_PRODUCTO, '') ;
                                  END 
                SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + '
                            INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                                  ON TPR.ID_TIPOPRODUCTO = PRD.CODTIPOPRODUCTO
                            GROUP BY CTR.CODCICLOFACTURACIONPDV, REG.CODPUNTODEVENTA, TPR.CODLINEADENEGOCIO';
                            IF @P_TIPO_PRD IS NOT NULL BEGIN
                                SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + ' , CODTIPOPRODUCTO';
                            END 
                            IF @P_PRODUCTO IS NOT NULL BEGIN
                                SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + ', ID_PRODUCTO';
                            END 

                SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + ') TRN
                      ON TRN.CODCICLOFACTURACIONPDV = CFP.ID_CICLOFACTURACIONPDV
                      AND TRN.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA
                      AND TRN.CODLINEADENEGOCIO = MFP.CODLINEADENEGOCIO
                INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA AGR
                      ON AGR.ID_AGRUPACIONPUNTODEVENTA = PDV.CODAGRUPACIONPUNTODEVENTA';
                      IF @P_CADENA IS NOT NULL AND @P_CADENA <> -1 BEGIN
                        SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + ' AND AGR.ID_AGRUPACIONPUNTODEVENTA = ' + ISNULL(@P_CADENA, '') ;
                      END 

                     SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + '
                     GROUP BY CFP.ID_CICLOFACTURACIONPDV, MFP.CODLINEADENEGOCIO ';

                     IF @P_PDV IS NOT NULL BEGIN
                        SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + ' ,ID_PUNTODEVENTA ';
                     END 

                     IF @P_RED IS NOT NULL BEGIN
                        SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + ' ,CODREDPDV ';
                     END 

                     IF @P_CADENA IS NOT NULL BEGIN
                          SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + ' ,ID_AGRUPACIONPUNTODEVENTA ';
                     END 

                     IF @P_TIPO_PRD IS NOT NULL BEGIN
                          SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + ' ,CODTIPOPRODUCTO ';
                     END 

                     IF @P_PRODUCTO IS NOT NULL BEGIN
                          SET @STR_QUERY_EXT = ISNULL(@STR_QUERY_EXT, '') + ' ,ID_PRODUCTO ';
                     END 

      PRINT @STR_QUERY_INT;
      PRINT ISNULL(@STR_QUERY_EXT, '') + ';';

      -- PAGINACION

      SET @HigerBound = @p_page_number * @p_batch_size;
      SET @LowerBound = @HigerBound - (@p_batch_size-1);

--      DBMS_OUTPUT.put_line('SELECT COUNT(1) FROM ( ' || STR_QUERY_INT || ')');

	BEGIN TRY
		SET @l_count_query = 'SELECT @p_total_size = COUNT(1) FROM ( ' + ISNULL(@STR_QUERY_INT, '')  + ISNULL(@STR_QUERY_EXT, '') + ')';
		EXECUTE sp_executesql @l_count_query, N'@p_total_size INT OUTPUT',@p_total_size output;

		SET @sql = 
			  'SELECT *
			  FROM ( SELECT QUERY.*
					 FROM ( ' + ISNULL(@STR_QUERY_INT, '')  + ISNULL(@STR_QUERY_EXT, '') + ' ) QUERY
					 WHERE ROW_NUMBER <= '+ ISNULL(@HigerBound, '') +')
			  WHERE ROW_NUMBER >= '+ISNULL(@LowerBound, '');
		EXECUTE sp_executesql @sql;
	END TRY
	BEGIN CATCH
--      DBMS_OUTPUT.put_line( STR_QUERY_INT || ';');
        PRINT @STR_QUERY_INT;
        PRINT ISNULL(@STR_QUERY_EXT, '') + ';';
	END CATCH
END;
GO




GO


