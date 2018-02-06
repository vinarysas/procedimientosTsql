USE SFGPRODU;
--  DDL for Package Body SFGVISTA_PDVFACTURADOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGVISTA_PDVFACTURADOS */ 

  -- Author  : DAMN IT '<DAMIAN>
  -- Created : 14/01/2009 03:19:43 p.m.
  -- Purpose : VISTA PDV FACTURADOS

  IF OBJECT_ID('WSXML_SFG.SFGVISTA_PDVFACTURADOS_GetPDVFacturados', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGVISTA_PDVFACTURADOS_GetPDVFacturados;
GO

CREATE     PROCEDURE WSXML_SFG.SFGVISTA_PDVFACTURADOS_GetPDVFacturados( -- NECESARIOS SON ID
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
      DECLARE @STR_QUERY_OUT VARCHAR(MAX) = '';
      DECLARE @STR_QUERY_INT_SIZE VARCHAR(MAX) = '';
      DECLARE @HigerBound   INTEGER ;
      DECLARE @LowerBound   INTEGER ;
       
      SET NOCOUNT ON;


       SET @STR_QUERY_INT =
       'SELECT  CFP.ID_CICLOFACTURACIONPDV,
                 MFP.CODLINEADENEGOCIO, ';

       IF @P_PDV IS NOT NULL BEGIN
          SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' PDV.ID_PUNTODEVENTA, ';
       END 

       IF @P_RED IS NOT NULL BEGIN
          SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' PDV.CODREDPDV, ';
       END 

       IF @P_CADENA IS NOT NULL BEGIN
            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AGR.ID_AGRUPACIONPUNTODEVENTA, ';
       END 

       IF @P_TIPO_PRD IS NOT NULL BEGIN
            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' PRD.CODTIPOPRODUCTO, ';
       END 

       IF @P_PRODUCTO IS NOT NULL BEGIN
            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' PRD.ID_PRODUCTO, ';
       END 

       SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') +
               'SUM(PDV.ACTIVE) AS PDV_REGISTRADO,
                SUM(CASE WHEN REG.FACTURADO = 1     THEN 1 ELSE 0 END) AS PDV_FACTURADO,
                SUM(CASE WHEN REG.FACTURADO = 0     THEN 1 ELSE 0 END) AS PDV_NO_FACTURADO,
                CASE WHEN MIN(REG.FACTURADO) = 1    THEN 1 ELSE 0 END AS FACTURADO_OK
           FROM WSXML_SFG.PUNTODEVENTA PDV
           INNER  JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFP
                ON PDV.ID_PUNTODEVENTA = MFP.CODPUNTODEVENTA
                AND PDV.ACTIVE = 1';

           IF @P_RED IS NOT NULL AND @P_RED <> -1 BEGIN
                 SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND PDV.CODREDPDV = ' + ISNULL(@P_RED, '') ;
           END 

           IF @P_PDV IS NOT NULL AND @P_PDV <> -1 BEGIN
                 SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND PDV.ID_PUNTODEVENTA = ' + ISNULL(@P_PDV, '') ;
           END 

           SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + '
           INNER  JOIN WSXML_SFG.REGISTROFACTURACION REG
                ON  REG.CODPUNTODEVENTA = MFP.CODPUNTODEVENTA
                AND LINEADENEGOCIO_PRODUCTO_F(REG.CODPRODUCTO) = MFP.CODLINEADENEGOCIO
                AND REG.CODTIPOREGISTRO <> 5';
           IF @P_LINEA IS NOT NULL AND @P_LINEA <> -1 BEGIN
                 SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND MFP.CODLINEADENEGOCIO = ' + ISNULL(@P_LINEA, '') ;
           END 


           SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + '
           INNER  JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
                  ON  CTR.CODCICLOFACTURACIONPDV = MFP.CODCICLOFACTURACIONPDV
                  AND CTR.ID_ENTRADAARCHIVOCONTROL = REG.CODENTRADAARCHIVOCONTROL
           INNER  JOIN WSXML_SFG.CICLOFACTURACIONPDV CFP
                ON MFP.CODCICLOFACTURACIONPDV = CFP.ID_CICLOFACTURACIONPDV';

           IF @P_CICLO IS NOT NULL AND @P_CICLO <> -1 BEGIN
                 SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND CFP.ID_CICLOFACTURACIONPDV = ' + ISNULL(@P_CICLO, '') ;
           END 

           SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + '
           INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA AGR
                 ON AGR.ID_AGRUPACIONPUNTODEVENTA = PDV.CODAGRUPACIONPUNTODEVENTA';
           IF @P_CADENA IS NOT NULL AND @P_CADENA <> -1 BEGIN
                 SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND AGR.ID_AGRUPACIONPUNTODEVENTA = ' + ISNULL(@P_CADENA, '') ;
           END 

           SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + '
           INNER JOIN WSXML_SFG.PRODUCTO PRD
                 ON PRD.ID_PRODUCTO = REG.CODPRODUCTO';
           IF @P_PRODUCTO IS NOT NULL AND @P_PRODUCTO <> -1 BEGIN
                 SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND PRD.ID_PRODUCTO = ' + ISNULL(@P_PRODUCTO, '') ;
           END 

           IF @P_TIPO_PRD IS NOT NULL AND @P_TIPO_PRD <> -1 BEGIN
                 SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' AND PRD.CODTIPOPRODUCTO = ' + ISNULL(@P_TIPO_PRD, '') ;
           END 

           SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + '
           GROUP BY CFP.ID_CICLOFACTURACIONPDV, MFP.CODLINEADENEGOCIO ';

       IF @P_PDV IS NOT NULL BEGIN
          SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' ,PDV.ID_PUNTODEVENTA ';
       END 

       IF @P_RED IS NOT NULL BEGIN
          SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' ,PDV.CODREDPDV ';
       END 

       IF @P_CADENA IS NOT NULL BEGIN
            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' ,AGR.ID_AGRUPACIONPUNTODEVENTA ';
       END 

       IF @P_TIPO_PRD IS NOT NULL BEGIN
            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' ,PRD.CODTIPOPRODUCTO ';
       END 

       IF @P_PRODUCTO IS NOT NULL BEGIN
            SET @STR_QUERY_INT = ISNULL(@STR_QUERY_INT, '') + ' ,PRD.ID_PRODUCTO ';
       END 

      PRINT ISNULL(@STR_QUERY_INT, '') + ';';

      -- PAGINACION

      SET @HigerBound = @p_page_number * @p_batch_size;
      SET @LowerBound = @HigerBound - (@p_batch_size-1);

      SET @STR_QUERY_INT_SIZE = 'SELECT COUNT(1) FROM ( ' + ISNULL(@STR_QUERY_INT, '') + ')';
      PRINT ISNULL(@STR_QUERY_INT_SIZE, '') + ';';

      SET @STR_QUERY_OUT =
      'SELECT *
      FROM ( SELECT QUERY.*, ROW_NUMBER() OVER(ORDER BY ID_CICLOFACTURACIONPDV ASC) r
             FROM ( ' + ISNULL(@STR_QUERY_INT, '')  + ' ) QUERY
             WHERE ROWNUM <= '+ ISNULL(@HigerBound, '') +')
      WHERE r >= '+ISNULL(@LowerBound, '');
      PRINT ISNULL(@STR_QUERY_OUT, '') + ';';

	  
	  BEGIN TRY
		EXECUTE sp_executesql @STR_QUERY_INT_SIZE, N'@p_total_size output', @p_total_size output;

	      EXECUTE (@STR_QUERY_OUT);
	  END TRY
	  BEGIN CATCH
		PRINT @STR_QUERY_OUT;
	  END CATCH

            


  END;

GO
--END SFGVISTA_PDVFACTURADOS;


