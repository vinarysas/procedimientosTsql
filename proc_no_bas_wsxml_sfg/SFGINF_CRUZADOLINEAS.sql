USE SFGPRODU;
--  DDL for Package Body SFGINF_CRUZADOLINEAS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_CRUZADOLINEAS */ 


  IF OBJECT_ID('WSXML_SFG.SFGINF_CRUZADOLINEAS_GetMonthlyHeaders', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetMonthlyHeaders;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetMonthlyHeaders(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                              @p_cur varchar(8000)  OUTPUT) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
    DECLARE @xFECHAFRST DATETIME;
    DECLARE @xFECHASCND DATETIME;
    DECLARE @xFECHALAST DATETIME;
    DECLARE @lstCICLOSFACTURACION WSXML_SFG.CICLOINFO;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    /* Reporte a partir de prefacturacion + facturacion. Obtener fechas de mes a partir del ciclo seleccionado */
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT
    /* Obtener identificadores de ciclos abarcados por el rango de fechas */
    INSERT INTO @lstCICLOSFACTURACION
	SELECT ID_CICLOFACTURACIONPDV, SECUENCIA, FECHAINICIO, FECHAEJECUCION
    FROM (SELECT ID_CICLOFACTURACIONPDV, SECUENCIA, NULL AS FECHAINICIO, FECHAEJECUCION FROM CICLOFACTURACIONPDV WHERE ACTIVE = 1 AND CONVERT(DATETIME, CONVERT(VARCHAR(7), FECHAEJECUCION, 120) + '-01') = CONVERT(DATETIME, CONVERT(VARCHAR(7), @sFECHACCLO, 120) + '-01'))t-- ORDER BY SECUENCIA)

    IF @@ROWCOUNT = 0 BEGIN
      RAISERROR('-20085 No existen ciclos de facturacion a la fecha estipulada', 16, 1);
    END 
    /* Sobreescribir fechas para cada ciclo, y obtener fechas generales de lista */

    DECLARE ix CURSOR FOR SELECT ID_CICLOFACTURACIONPDV,SECUENCIA,FECHAINICIO,FECHAFIN 
	FROM @lstCICLOSFACTURACION--.First..lstCICLOSFACTURACION.Last LOOP
	OPEN ix
	
	DECLARE  @ix__ID_CICLOFACTURACIONPDV NUMERIC(38,0),@ix__SECUENCIA NUMERIC(38,0),@ix__FECHAINICIO DATETIME,@ix__FECHAFIN DATETIME;

	DECLARE  @ix__ID_CICLOFACTURACIONPDV_FIRSTS NUMERIC(38,0),@ix__SECUENCIA_FIRSTS NUMERIC(38,0),@ix__FECHAINICIO_FIRSTS DATETIME,@ix__FECHAFIN_FIRSTS DATETIME;
	
	SET @ix__ID_CICLOFACTURACIONPDV_FIRSTS = @ix__ID_CICLOFACTURACIONPDV
	SET @ix__SECUENCIA_FIRSTS = @ix__SECUENCIA
	SET @ix__FECHAINICIO_FIRSTS = @ix__FECHAINICIO
	SET @ix__FECHAFIN_FIRSTS = @ix__FECHAFIN


	fetch next from ix into @ix__ID_CICLOFACTURACIONPDV, @ix__SECUENCIA, @ix__FECHAINICIO, @ix__FECHAFIN;
	
	DECLARE @FILA NUMERIC(38,0) = 1
	DECLARE @TOTALFILAS NUMERIC(38,0) = @@CURSOR_ROWS 

    while @@fetch_status=0
    begin

        DECLARE @iniDATE DATETIME;
        DECLARE @endDATE DATETIME;
		BEGIN
        
			EXEC WSXML_SFG.SFGCICLOFACTURACIONPDV_GetCicloDateRangeFromID @ix__ID_CICLOFACTURACIONPDV, @iniDATE OUT, @endDATE OUT
        
			SET @ix__FECHAINICIO  = @iniDATE;
			SET @ix__FECHAFIN   = @endDATE;
        
			IF @FILA = 1 BEGIN
			  SET @xFECHAFRST = @iniDATE;
			  SET @xFECHASCND = @endDATE;
			END 
        
			IF @FILA = @TOTALFILAS BEGIN
			  SET @xFECHALAST = @endDATE;
			END 

		END;
		SET @FILA = @FILA + 1
    fetch next from ix into @ix__ID_CICLOFACTURACIONPDV, @ix__SECUENCIA, @ix__FECHAINICIO, @ix__FECHAFIN;
    END;
    CLOSE ix;
    DEALLOCATE ix;

    /* Los encabezados de este reporte son: 1 por ciclo dentro de la lista + 2 de corte de mes */
    IF @xFECHAFRST < @sFECHAFRST AND @xFECHALAST < @sFECHALAST BEGIN
        SELECT 1 AS ORDEN,
               WSXML_SFG.SFG_PACKAGE_StringShortRangoDeFechas(@sFECHAFRST, @xFECHASCND)                 AS NOMBRE,
               'WSXML_SFG.SFGINF_CRUZADOLINEAS_GetDifferentialOpeningData()'                                   AS PROCEDURENAME,
               @ix__ID_CICLOFACTURACIONPDV_FIRSTS AS ID_CICLOFACTURACIONPDV
        UNION ALL
        SELECT SECUENCIA AS ORDEN,
               '(' + ISNULL(WSXML_SFG.SFG_PACKAGE_GetYearNumber(FECHAFIN), '') + '-' + ISNULL(WSXML_SFG.SFG_PACKAGE_GetWeekNumber(FECHAFIN), '') + ') ' +
               ISNULL(WSXML_SFG.SFG_PACKAGE_StringShortRangoDeFechas(FECHAINICIO, FECHAFIN), '') AS NOMBRE,
               'SFGINF_CRUZADOLINEAS.GetWeeklyData'                   AS PROCEDURENAME,
               ID_CICLOFACTURACIONPDV                                 AS ID_CICLOFACTURACIONPDV
        FROM @lstCICLOSFACTURACION
        UNION
        SELECT 999999999 AS ORDEN,
               WSXML_SFG.SFG_PACKAGE_StringShortRangoDeFechas(@xFECHALAST + 1, @sFECHALAST)             AS NOMBRE,
               'SFGINF_CRUZADOLINEAS.GetClosureData'                                   AS PROCEDURENAME,
               @ix__ID_CICLOFACTURACIONPDV  AS ID_CICLOFACTURACIONPDV
        ORDER BY ORDEN DESC;
    END
    ELSE IF @xFECHAFRST < @sFECHAFRST AND @xFECHALAST = @sFECHALAST BEGIN
        SELECT 1 AS ORDEN,
               WSXML_SFG.SFG_PACKAGE_StringShortRangoDeFechas(@sFECHAFRST, @xFECHASCND)                 AS NOMBRE,
               'WSXML_SFG.SFGINF_CRUZADOLINEAS_GetDifferentialOpeningData()'                                     AS PROCEDURENAME,
               @ix__ID_CICLOFACTURACIONPDV AS ID_CICLOFACTURACIONPDV

        UNION ALL
        SELECT SECUENCIA AS ORDEN,
               '(' + ISNULL(WSXML_SFG.SFG_PACKAGE_GetYearNumber(FECHAFIN), '') + '-' + ISNULL(WSXML_SFG.SFG_PACKAGE_GetWeekNumber(FECHAFIN), '') + ') ' +
               ISNULL(WSXML_SFG.SFG_PACKAGE_StringShortRangoDeFechas(FECHAINICIO, FECHAFIN), '') AS NOMBRE,
               'SFGINF_CRUZADOLINEAS.GetWeeklyData'                   AS PROCEDURENAME,
               ID_CICLOFACTURACIONPDV                                 AS ID_CICLOFACTURACIONPDV
        FROM @lstCICLOSFACTURACION
        ORDER BY ORDEN DESC;
    END
    ELSE IF @xFECHAFRST = @sFECHAFRST AND @xFECHALAST < @sFECHALAST BEGIN
        SELECT SECUENCIA AS ORDEN,
               '(' + ISNULL(WSXML_SFG.SFG_PACKAGE_GetYearNumber(FECHAFIN), '') + '-' + ISNULL(WSXML_SFG.SFG_PACKAGE_GetWeekNumber(FECHAFIN), '') + ') ' +
               ISNULL(WSXML_SFG.SFG_PACKAGE_StringShortRangoDeFechas(FECHAINICIO, FECHAFIN), '') AS NOMBRE,
               'WSXML_SFG.SFGINF_CRUZADOLINEAS_GetWeeklyData()'                   AS PROCEDURENAME,
               ID_CICLOFACTURACIONPDV                                 AS ID_CICLOFACTURACIONPDV
        FROM @lstCICLOSFACTURACION
        UNION ALL
        SELECT 999999999 AS ORDEN,
               WSXML_SFG.SFG_PACKAGE_StringShortRangoDeFechas(@xFECHALAST + 1, @sFECHALAST)             AS NOMBRE,
               'WSXML_SFG.SFGINF_CRUZADOLINEAS_GetClosureData()'                                   AS PROCEDURENAME,
               @ix__ID_CICLOFACTURACIONPDV  AS ID_CICLOFACTURACIONPDV
        ORDER BY ORDEN DESC;
    END
    ELSE BEGIN
        SELECT SECUENCIA AS ORDEN,
               '(' + ISNULL(WSXML_SFG.SFG_PACKAGE_GetYearNumber(FECHAFIN), '') + '-' + ISNULL(WSXML_SFG.SFG_PACKAGE_GetWeekNumber(FECHAFIN), '') + ') ' +
               ISNULL(WSXML_SFG.SFG_PACKAGE_StringShortRangoDeFechas(FECHAINICIO, FECHAFIN), '') AS NOMBRE,
               'WSXML_SFG.SFGINF_CRUZADOLINEAS_GetWeeklyData()'                   AS PROCEDURENAME,
               ID_CICLOFACTURACIONPDV                                 AS ID_CICLOFACTURACIONPDV
        FROM @lstCICLOSFACTURACION
        ORDER BY ORDEN DESC;
    END 
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_CRUZADOLINEAS_GetOpeningData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetOpeningData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetOpeningData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                           @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                           @pg_CADENA                NVARCHAR(2000),
                           @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                           @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT
      SELECT LINEA,
             INGRESOSBRUTOS + IVAPRODUCTO AS INGRESOS,
             IVAPRODUCTO,
             INGRESOSBRUTOS,
             COMISION,
             COMISIONANTICIPO,
             TOTALCOMISION,
             IVACOMISION,
             TOTALCOMISION + IVACOMISION AS COMISIONBRUTA,
             RETEFUENTE,
             RETEIVA,
             RETEICA,
             RETECREE,
             TOTALCOMISION + IVACOMISION - RETEFUENTE - RETEIVA - RETEICA - RETECREE AS COMISIONNETA,
             PREMIOSPAGADOS,
             TOTALAPAGAR
      FROM (-- GTECH
            SELECT LDN.NOMLINEADENEGOCIO                                                                                                  AS LINEA,
                   LDN.CODLINEADENEGOCIO                                                                                                  AS CODLINEADENEGOCIO,
                   LDN.FIDUCIA                                                                                                            AS FIDUCIA,
                   SUM(ISNULL(IVAPRODUCTO, 0))                                                                                               AS IVAPRODUCTO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE INGRESOSBRUTOS END, 0))                                        AS INGRESOSBRUTOS,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISION - COMISIONESTANDAR ELSE COMISION END, 0))                    AS COMISION,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE COMISIONANTICIPO END, 0))                                      AS COMISIONANTICIPO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISION - COMISIONESTANDAR ELSE COMISION + COMISIONANTICIPO END, 0)) AS TOTALCOMISION,
                   SUM(ISNULL(IVACOMISION, 0))                                                                                               AS IVACOMISION,
                   SUM(ISNULL(RETEFUENTE + RETEUVT, 0))                                                                                      AS RETEFUENTE,
                   SUM(ISNULL(RETEIVA, 0))                                                                                                   AS RETEIVA,
                   SUM(ISNULL(RETEICA, 0))                                                                                                   AS RETEICA,
                   SUM(ISNULL(RETECREE, 0))                                                                                                  AS RETECREE,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE PREMIOSPAGADOS END, 0))                                        AS PREMIOSPAGADOS,
                   SUM(ISNULL(VALORAPAGARGTECH, 0))                                                                                          AS TOTALAPAGAR
            FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
            INNER JOIN WSXML_SFG.TIPOPRODUCTO                  TPR ON (TPR.CODLINEADENEGOCIO = LDN.CODLINEADENEGOCIO)
            INNER JOIN WSXML_SFG.PRODUCTO                      PRD ON (PRD.CODTIPOPRODUCTO   = TPR.ID_TIPOPRODUCTO)
            INNER JOIN WSXML_SFG.VWKPRODUCTDAILYBILLING        PRF ON (PRD.ID_PRODUCTO       = PRF.CODPRODUCTO
                                                         AND PRF.FECHAARCHIVO      BETWEEN @sFECHAFRST AND @sFECHACCLO)
            WHERE LDN.FIDUCIA = 0
            GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO
            UNION
            -- Fiducia
            SELECT LDN.NOMLINEADENEGOCIO                                                             AS LINEA,
                   LDN.CODLINEADENEGOCIO                                                             AS CODLINEADENEGOCIO,
                   LDN.FIDUCIA                                                                       AS FIDUCIA,
                   0                                                                                 AS IVAPRODUCTO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN INGRESOSBRUTOS ELSE 0 END, 0))   AS INGRESOSBRUTOS,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISIONESTANDAR ELSE 0 END, 0)) AS COMISION,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISIONANTICIPO ELSE 0 END, 0)) AS COMISIONANTICIPO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISIONESTANDAR ELSE 0 END, 0)) AS TOTALCOMISION,
                   0                                                                                 AS IVACOMISION,
                   0                                                                                 AS RETEFUENTE,
                   0                                                                                 AS RETEIVA,
                   0                                                                                 AS RETEICA,
                   0                                                                                 AS RETECREE,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN PREMIOSPAGADOS ELSE 0 END, 0))   AS PREMIOSPAGADOS,
                   SUM(ISNULL(VALORAPAGARFIDUCIA, 0))                                                   AS TOTALAPAGAR
            FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
            INNER JOIN WSXML_SFG.TIPOPRODUCTO                  TPR ON (TPR.CODLINEADENEGOCIO = LDN.CODLINEADENEGOCIO)
            INNER JOIN WSXML_SFG.PRODUCTO                      PRD ON (PRD.CODTIPOPRODUCTO   = TPR.ID_TIPOPRODUCTO)
            INNER JOIN WSXML_SFG.VWKPRODUCTDAILYBILLING        PRF ON (PRD.ID_PRODUCTO       = PRF.CODPRODUCTO
                                                         AND PRF.FECHAARCHIVO      BETWEEN @sFECHAFRST AND @sFECHACCLO)
            WHERE LDN.FIDUCIA = 1
            GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO) s
      ORDER BY CODLINEADENEGOCIO, FIDUCIA;
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_CRUZADOLINEAS_GetDifferentialOpeningData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetDifferentialOpeningData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetDifferentialOpeningData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                       @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                       @pg_CADENA                NVARCHAR(2000),
                                       @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @prvCICLOID NUMERIC(22,0);
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @prvCICLOID = ID_CICLOFACTURACIONPDV FROM WSXML_SFG.CICLOFACTURACIONPDV
    WHERE ACTIVE = 1 AND SECUENCIA = (SELECT SECUENCIA - 1 FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV);
    SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @prvCICLOID;
    
	EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT

      SELECT WEK.LINEA                                                                       AS LINEA,
             (WEK.INGRESOSBRUTOS + WEK.IVAPRODUCTO) - (CLO.INGRESOSBRUTOS + CLO.IVAPRODUCTO) AS INGRESOS,
             WEK.IVAPRODUCTO - CLO.IVAPRODUCTO                                               AS IVAPRODUCTO,
             WEK.INGRESOSBRUTOS - CLO.INGRESOSBRUTOS                                         AS INGRESOSBRUTOS,
             WEK.COMISION - CLO.COMISION                                                     AS COMISION,
             WEK.COMISIONANTICIPO - CLO.COMISIONANTICIPO                                     AS COMISIONANTICIPO,
             WEK.TOTALCOMISION - CLO.TOTALCOMISION                                           AS TOTALCOMISION,
             WEK.IVACOMISION - CLO.IVACOMISION                                               AS IVACOMISION,
             (WEK.TOTALCOMISION + WEK.IVACOMISION) - (CLO.TOTALCOMISION + CLO.IVACOMISION)   AS COMISIONBRUTA,
             WEK.RETEFUENTE - CLO.RETEFUENTE                                                 AS RETEFUENTE,
             WEK.RETEIVA - CLO.RETEIVA                                                       AS RETEIVA,
             WEK.RETEICA - CLO.RETEICA                                                       AS RETEICA,
             WEK.RETECREE - CLO.RETECREE                                                     AS RETECREE,
             (WEK.TOTALCOMISION + WEK.IVACOMISION - WEK.RETEFUENTE - WEK.RETEIVA - WEK.RETEICA) -
             (CLO.TOTALCOMISION + CLO.IVACOMISION - CLO.RETEFUENTE - CLO.RETEIVA - CLO.RETEICA) AS COMISIONNETA,
             WEK.PREMIOSPAGADOS - CLO.PREMIOSPAGADOS                                         AS PREMIOSPAGADOS,
             WEK.TOTALAPAGAR - CLO.TOTALAPAGAR                                               AS TOTALAPAGAR
      FROM (-- GTECH
            SELECT LDN.NOMLINEADENEGOCIO                                                                                                  AS LINEA,
                   LDN.CODLINEADENEGOCIO                                                                                                  AS CODLINEADENEGOCIO,
                   LDN.FIDUCIA                                                                                                            AS FIDUCIA,
                   SUM(ISNULL(IVAPRODUCTO, 0))                                                                                               AS IVAPRODUCTO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE INGRESOSBRUTOS END, 0))                                        AS INGRESOSBRUTOS,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISION - COMISIONESTANDAR ELSE COMISION END, 0))                    AS COMISION,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE COMISIONANTICIPO END, 0))                                      AS COMISIONANTICIPO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISION - COMISIONESTANDAR ELSE COMISION + COMISIONANTICIPO END, 0)) AS TOTALCOMISION,
                   SUM(ISNULL(IVACOMISION, 0))                                                                                               AS IVACOMISION,
                   SUM(ISNULL(RETEFUENTE + RETEUVT, 0))                                                                                      AS RETEFUENTE,
                   SUM(ISNULL(RETEIVA, 0))                                                                                                   AS RETEIVA,
                   SUM(ISNULL(RETEICA, 0))                                                                                                   AS RETEICA,
                   SUM(ISNULL(RETECREE, 0))                                                                                                  AS RETECREE,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE PREMIOSPAGADOS END, 0))                                        AS PREMIOSPAGADOS,
                   SUM(ISNULL(VALORAPAGARGTECH, 0))                                                                                          AS TOTALAPAGAR
            FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
            INNER JOIN WSXML_SFG.TIPOPRODUCTO                  TPR ON (TPR.CODLINEADENEGOCIO = LDN.CODLINEADENEGOCIO)
            INNER JOIN WSXML_SFG.PRODUCTO                      PRD ON (PRD.CODTIPOPRODUCTO   = TPR.ID_TIPOPRODUCTO)
            INNER JOIN WSXML_SFG.VWKPRODUCTDAILYBILLING        PRF ON (PRD.ID_PRODUCTO       = PRF.CODPRODUCTO
                                                         AND PRF.FECHAARCHIVO      BETWEEN @sFECHACCLO + 1 AND @sFECHALAST)
            WHERE LDN.FIDUCIA = 0
            GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO
            UNION
            -- Fiducia
            SELECT LDN.NOMLINEADENEGOCIO                                                             AS LINEA,
                   LDN.CODLINEADENEGOCIO                                                             AS CODLINEADENEGOCIO,
                   LDN.FIDUCIA                                                                       AS FIDUCIA,
                   0                                                                                 AS IVAPRODUCTO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN INGRESOSBRUTOS ELSE 0 END, 0))   AS INGRESOSBRUTOS,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISIONESTANDAR ELSE 0 END, 0)) AS COMISION,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISIONANTICIPO ELSE 0 END, 0)) AS COMISIONANTICIPO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISIONESTANDAR ELSE 0 END, 0)) AS TOTALCOMISION,
                   0                                                                                 AS IVACOMISION,
                   0                                                                                 AS RETEFUENTE,
                   0                                                                                 AS RETEIVA,
                   0                                                                                 AS RETEICA,
                   0                                                                                 AS RETECREE,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN PREMIOSPAGADOS ELSE 0 END, 0))   AS PREMIOSPAGADOS,
                   SUM(ISNULL(VALORAPAGARFIDUCIA, 0))                                                   AS TOTALAPAGAR
            FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
            INNER JOIN WSXML_SFG.TIPOPRODUCTO                  TPR ON (TPR.CODLINEADENEGOCIO = LDN.CODLINEADENEGOCIO)
            INNER JOIN WSXML_SFG.PRODUCTO                      PRD ON (PRD.CODTIPOPRODUCTO   = TPR.ID_TIPOPRODUCTO)
            INNER JOIN WSXML_SFG.VWKPRODUCTDAILYBILLING        PRF ON (PRD.ID_PRODUCTO       = PRF.CODPRODUCTO
                                                         AND PRF.FECHAARCHIVO      BETWEEN @sFECHACCLO + 1 AND @sFECHALAST)
            WHERE LDN.FIDUCIA = 1
            GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO) CLO
      INNER JOIN (-- GTECH
                  SELECT LDN.NOMLINEADENEGOCIO                                                                                                                                  AS LINEA,
                         LDN.CODLINEADENEGOCIO                                                                                                                                  AS CODLINEADENEGOCIO,
                         LDN.FIDUCIA                                                                                                                                            AS FIDUCIA,
                         SUM(ISNULL(IMPUESTO_IVA, 0))                                                                                                                              AS IVAPRODUCTO,
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE VALORVENTABRUTA END, 0))                                                                       AS INGRESOSBRUTOS,
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONNORMAL - VALORCOMISIONESTANDAR ELSE VALORCOMISIONNORMAL END, 0))                         AS COMISION,
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE VALORCOMISIONANTICIPO END, 0))                                                                 AS COMISIONANTICIPO,
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONNORMAL - VALORCOMISIONESTANDAR ELSE VALORCOMISIONNORMAL + VALORCOMISIONANTICIPO END, 0)) AS TOTALCOMISION,
                         SUM(ISNULL(VATCOMISION, 0))                                                                                                                               AS IVACOMISION,
                         SUM(ISNULL(RETENCION_RENTA, 0))                                                                                                                           AS RETEFUENTE,
                         SUM(ISNULL(RETENCION_RETEIVA, 0))                                                                                                                         AS RETEIVA,
                         SUM(ISNULL(RETENCION_RETEICA, 0))                                                                                                                         AS RETEICA,
                         SUM(ISNULL(RETENCION_RETECREE, 0))                                                                                                                        AS RETECREE,
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE VALORPREMIOPAGO END, 0))                                                                       AS PREMIOSPAGADOS,
                         SUM(ISNULL(PRF.FACTURADOENCONTRAGTECH - PRF.FACTURADOAFAVORGTECH, 0))                                                                                     AS TOTALAPAGAR
                  FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
                  INNER JOIN WSXML_SFG.TIPOPRODUCTO                TPR ON (TPR.CODLINEADENEGOCIO      = LDN.CODLINEADENEGOCIO)
                  INNER JOIN WSXML_SFG.PRODUCTO                    PRD ON (PRD.CODTIPOPRODUCTO        = TPR.ID_TIPOPRODUCTO)
                  INNER JOIN WSXML_SFG.VW_SHOW_PRDFACTURACION      PRF ON (PRD.ID_PRODUCTO            = PRF.CODPRODUCTO
                                                             AND PRF.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV)
                  WHERE LDN.FIDUCIA = 0
                  GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO
                  UNION
                  -- Fiducia
                  SELECT LDN.NOMLINEADENEGOCIO                                                                    AS LINEA,
                         LDN.CODLINEADENEGOCIO                                                                    AS CODLINEADENEGOCIO,
                         LDN.FIDUCIA                                                                              AS FIDUCIA,
                         0                                                                                        AS IVAPRODUCTO,
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORVENTABRUTA ELSE 0 END, 0))         AS INGRESOSBRUTOS,
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONESTANDAR ELSE 0 END, 0))   AS COMISION, -- 8% Baloto
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONANTICIPO ELSE 0 END, 0))   AS COMISIONANTICIPO,
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONESTANDAR ELSE 0 END, 0))   AS TOTALCOMISION,
                         0                                                                                        AS IVACOMISION,
                         0                                                                                        AS RETEFUENTE,
                         0                                                                                        AS RETEIVA,
                         0                                                                                        AS RETEICA,
                         0                                                                                        AS RETECREE,
                         SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORPREMIOPAGO ELSE 0 END, 0))         AS PREMIOSPAGADOS,
                         SUM(ISNULL(PRF.FACTURADOENCONTRAFIDUCIA - PRF.FACTURADOAFAVORFIDUCIA, 0))                   AS TOTALAPAGAR
                  FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
                  INNER JOIN WSXML_SFG.TIPOPRODUCTO                TPR ON (TPR.CODLINEADENEGOCIO      = LDN.CODLINEADENEGOCIO)
                  INNER JOIN WSXML_SFG.PRODUCTO                    PRD ON (PRD.CODTIPOPRODUCTO        = TPR.ID_TIPOPRODUCTO)
                  INNER JOIN WSXML_SFG.VW_SHOW_PRDFACTURACION      PRF ON (PRD.ID_PRODUCTO            = PRF.CODPRODUCTO
                                                             AND PRF.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV)
                  WHERE LDN.FIDUCIA = 1
                  GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO) WEK ON (WEK.CODLINEADENEGOCIO = CLO.CODLINEADENEGOCIO AND WEK.FIDUCIA = CLO.FIDUCIA)
      ORDER BY WEK.CODLINEADENEGOCIO, WEK.FIDUCIA;
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_CRUZADOLINEAS_GetClosureData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetClosureData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetClosureData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                           @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                           @pg_CADENA                NVARCHAR(2000),
                           @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                           @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT
      SELECT LINEA,
             INGRESOSBRUTOS + IVAPRODUCTO AS INGRESOS,
             IVAPRODUCTO,
             INGRESOSBRUTOS,
             COMISION,
             COMISIONANTICIPO,
             TOTALCOMISION,
             IVACOMISION,
             TOTALCOMISION + IVACOMISION AS COMISIONBRUTA,
             RETEFUENTE,
             RETEIVA,
             RETEICA,
             RETECREE,
             TOTALCOMISION + IVACOMISION - RETEFUENTE - RETEIVA - RETEICA AS COMISIONNETA,
             PREMIOSPAGADOS,
             TOTALAPAGAR
      FROM (-- GTECH
            SELECT LDN.NOMLINEADENEGOCIO                                                                                                  AS LINEA,
                   LDN.CODLINEADENEGOCIO                                                                                                  AS CODLINEADENEGOCIO,
                   LDN.FIDUCIA                                                                                                            AS FIDUCIA,
                   SUM(ISNULL(IVAPRODUCTO, 0))                                                                                               AS IVAPRODUCTO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE INGRESOSBRUTOS END, 0))                                        AS INGRESOSBRUTOS,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISION - COMISIONESTANDAR ELSE COMISION END, 0))                    AS COMISION,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE COMISIONANTICIPO END, 0))                                      AS COMISIONANTICIPO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISION - COMISIONESTANDAR ELSE COMISION + COMISIONANTICIPO END, 0)) AS TOTALCOMISION,
                   SUM(ISNULL(IVACOMISION, 0))                                                                                               AS IVACOMISION,
                   SUM(ISNULL(RETEFUENTE + RETEUVT, 0))                                                                                      AS RETEFUENTE,
                   SUM(ISNULL(RETEIVA, 0))                                                                                                   AS RETEIVA,
                   SUM(ISNULL(RETEICA, 0))                                                                                                   AS RETEICA,
                   SUM(ISNULL(RETECREE, 0))                                                                                                  AS RETECREE,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE PREMIOSPAGADOS END, 0))                                        AS PREMIOSPAGADOS,
                   SUM(ISNULL(VALORAPAGARGTECH, 0))                                                                                          AS TOTALAPAGAR
            FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
            INNER JOIN WSXML_SFG.TIPOPRODUCTO                  TPR ON (TPR.CODLINEADENEGOCIO = LDN.CODLINEADENEGOCIO)
            INNER JOIN WSXML_SFG.PRODUCTO                      PRD ON (PRD.CODTIPOPRODUCTO   = TPR.ID_TIPOPRODUCTO)
            INNER JOIN WSXML_SFG.VWKPRODUCTDAILYBILLING        PRF ON (PRD.ID_PRODUCTO       = PRF.CODPRODUCTO
                                                         AND PRF.FECHAARCHIVO      BETWEEN @sFECHACCLO + 1 AND @sFECHALAST)
            WHERE LDN.FIDUCIA = 0
            GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO
            UNION
            -- Fiducia
            SELECT LDN.NOMLINEADENEGOCIO                                                             AS LINEA,
                   LDN.CODLINEADENEGOCIO                                                             AS CODLINEADENEGOCIO,
                   LDN.FIDUCIA                                                                       AS FIDUCIA,
                   0                                                                                 AS IVAPRODUCTO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN INGRESOSBRUTOS ELSE 0 END, 0))   AS INGRESOSBRUTOS,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISIONESTANDAR ELSE 0 END, 0)) AS COMISION,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISIONANTICIPO ELSE 0 END, 0)) AS COMISIONANTICIPO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN COMISIONESTANDAR ELSE 0 END, 0)) AS TOTALCOMISION,
                   0                                                                                 AS IVACOMISION,
                   0                                                                                 AS RETEFUENTE,
                   0                                                                                 AS RETEIVA,
                   0                                                                                 AS RETEICA,
                   0                                                                                 AS RETECREE,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN PREMIOSPAGADOS ELSE 0 END, 0))   AS PREMIOSPAGADOS,
                   SUM(ISNULL(VALORAPAGARFIDUCIA, 0))                                                   AS TOTALAPAGAR
            FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
            INNER JOIN WSXML_SFG.TIPOPRODUCTO                  TPR ON (TPR.CODLINEADENEGOCIO = LDN.CODLINEADENEGOCIO)
            INNER JOIN WSXML_SFG.PRODUCTO                      PRD ON (PRD.CODTIPOPRODUCTO   = TPR.ID_TIPOPRODUCTO)
            INNER JOIN WSXML_SFG.VWKPRODUCTDAILYBILLING        PRF ON (PRD.ID_PRODUCTO       = PRF.CODPRODUCTO
                                                         AND PRF.FECHAARCHIVO      BETWEEN @sFECHACCLO + 1 AND @sFECHALAST)
            WHERE LDN.FIDUCIA = 1
            GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO) s
      ORDER BY CODLINEADENEGOCIO, FIDUCIA;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_CRUZADOLINEAS_GetWeeklyData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetWeeklyData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CRUZADOLINEAS_GetWeeklyData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                          @pg_CADENA                NVARCHAR(2000),
                          @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                          @pg_PRODUCTO              NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT LINEA,
             round(INGRESOSBRUTOS + IVAPRODUCTO,19) AS INGRESOS,
             round(IVAPRODUCTO,19) AS IVAPRODUCTO,
             round(INGRESOSBRUTOS,19) AS INGRESOSBRUTOS,
             round(COMISION,19) AS COMISION,
             round(COMISIONANTICIPO,19) AS COMISIONANTICIPO,
             round(TOTALCOMISION,19) AS TOTALCOMISION,
             round(IVACOMISION,19) AS IVACOMISION,
             round(TOTALCOMISION + IVACOMISION,19) AS COMISIONBRUTA,
             round(RETEFUENTE,19) AS RETEFUENTE,
             round(RETEIVA,19) AS RETEIVA,
             round(RETEICA,19) AS RETEICA,
             round(RETECREE,19) AS RETECREE,
             round(TOTALCOMISION + IVACOMISION - RETEFUENTE - RETEIVA - RETEICA,19) AS COMISIONNETA,
             round(PREMIOSPAGADOS,19) AS PREMIOSPAGADOS,
             round(TOTALAPAGAR,19) AS TOTALAPAGAR
      FROM (-- GTECH
            SELECT LDN.NOMLINEADENEGOCIO                                                                                                                                  AS LINEA,
                   LDN.CODLINEADENEGOCIO                                                                                                                                  AS CODLINEADENEGOCIO,
                   LDN.FIDUCIA                                                                                                                                            AS FIDUCIA,
                   SUM(ISNULL(IMPUESTO_IVA, 0))                                                                                                                              AS IVAPRODUCTO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE VALORVENTABRUTA END, 0))                                                                       AS INGRESOSBRUTOS,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONNORMAL - VALORCOMISIONESTANDAR ELSE VALORCOMISIONNORMAL END, 0))                         AS COMISION,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE VALORCOMISIONANTICIPO END, 0))                                                                 AS COMISIONANTICIPO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONNORMAL - VALORCOMISIONESTANDAR ELSE VALORCOMISIONNORMAL + VALORCOMISIONANTICIPO END, 0)) AS TOTALCOMISION,
                   SUM(ISNULL(VATCOMISION, 0))                                                                                                                               AS IVACOMISION,
                   SUM(ISNULL(RETENCION_RENTA, 0))                                                                                                                           AS RETEFUENTE,
                   SUM(ISNULL(RETENCION_RETEIVA, 0))                                                                                                                         AS RETEIVA,
                   SUM(ISNULL(RETENCION_RETEICA, 0))                                                                                                                         AS RETEICA,
                   SUM(ISNULL(RETENCION_RETECREE, 0))                                                                                                                        AS RETECREE,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN 0 ELSE VALORPREMIOPAGO END, 0))                                                                       AS PREMIOSPAGADOS,
                   SUM(ISNULL(PRF.FACTURADOENCONTRAGTECH - PRF.FACTURADOAFAVORGTECH, 0))                                                                                     AS TOTALAPAGAR
            FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
            INNER JOIN WSXML_SFG.TIPOPRODUCTO                TPR ON (TPR.CODLINEADENEGOCIO      = LDN.CODLINEADENEGOCIO)
            INNER JOIN WSXML_SFG.PRODUCTO                    PRD ON (PRD.CODTIPOPRODUCTO        = TPR.ID_TIPOPRODUCTO)
            INNER JOIN WSXML_SFG.VWKPRODUCTWEEKLYBILLING     PRF ON (PRD.ID_PRODUCTO            = PRF.CODPRODUCTO
                                                       AND PRF.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV)
            WHERE LDN.FIDUCIA = 0
            GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO
            UNION
            -- Fiducia
            SELECT LDN.NOMLINEADENEGOCIO                                                                    AS LINEA,
                   LDN.CODLINEADENEGOCIO                                                                    AS CODLINEADENEGOCIO,
                   LDN.FIDUCIA                                                                              AS FIDUCIA,
                   0                                                                                        AS IVAPRODUCTO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORVENTABRUTA ELSE 0 END, 0))         AS INGRESOSBRUTOS,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONESTANDAR ELSE 0 END, 0))   AS COMISION, -- 8% Baloto
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONANTICIPO ELSE 0 END, 0))   AS COMISIONANTICIPO,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORCOMISIONESTANDAR ELSE 0 END, 0))   AS TOTALCOMISION,
                   0                                                                                        AS IVACOMISION,
                   0                                                                                        AS RETEFUENTE,
                   0                                                                                        AS RETEIVA,
                   0                                                                                        AS RETEICA,
                   0                                                                                        AS RETECREE,
                   SUM(ISNULL(CASE WHEN PRF.PORCENTAJEFIDUCIA > 0 THEN VALORPREMIOPAGO ELSE 0 END, 0))         AS PREMIOSPAGADOS,
                   SUM(ISNULL(PRF.FACTURADOENCONTRAFIDUCIA - PRF.FACTURADOAFAVORFIDUCIA, 0))                   AS TOTALAPAGAR
            FROM WSXML_SFG.SFGLINEADENEGOCIO_GetNormalizedLines() LDN
            INNER JOIN WSXML_SFG.TIPOPRODUCTO                TPR ON (TPR.CODLINEADENEGOCIO      = LDN.CODLINEADENEGOCIO)
            INNER JOIN WSXML_SFG.PRODUCTO                    PRD ON (PRD.CODTIPOPRODUCTO        = TPR.ID_TIPOPRODUCTO)
            INNER JOIN WSXML_SFG.VWKPRODUCTWEEKLYBILLING     PRF ON (PRD.ID_PRODUCTO            = PRF.CODPRODUCTO
                                                       AND PRF.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV)
            WHERE LDN.FIDUCIA = 1
            GROUP BY LDN.CODLINEADENEGOCIO, LDN.FIDUCIA, LDN.NOMLINEADENEGOCIO) s
      ORDER BY CODLINEADENEGOCIO, FIDUCIA;
  END;
GO

