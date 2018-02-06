USE SFGPRODU;
--  DDL for Package Body SFGPRODUCTO_L1SHRCLC
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPRODUCTO_L1SHRCLC */ 

  --Add Record in the table CONTROL_L1LIAB01
  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_L1SHRCLC_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_L1SHRCLC_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_L1SHRCLC_AddRecord(@p_CODCONTROL_L1SHRCLC       NUMERIC(22,0),
                      @p_NOMPRODUCTO               VARCHAR(4000),
                      @p_NUMEROS_GANADORES         VARCHAR(4000),
                      @p_VENTA_TOTAL               NUMERIC(22,0),
                      @p_IVA                       NUMERIC(22,0),
                      @p_VENTAS_BRUTAS             NUMERIC(22,0),
                      @p_POZO_PARA_PREMIOS         NUMERIC(22,0),
                      @p_PORCENT_POZO_PARA_PREMIOS VARCHAR(4000),
                      @p_FONDO_DE_RESERVA          NUMERIC(22,0),
                      @p_TOTAL_POZO_PREMIOS        NUMERIC(22,0),
                      @p_TOTAL_POZO_ANTERIOR       NUMERIC(22,0),
                      @p_TOTAL_AJUSTES             NUMERIC(22,0),
                      @p_TOTAL_POZO_TOTAL          NUMERIC(22,0),
                      @p_TOTAL_REDONDEO            NUMERIC(22,0),
                      @p_TOTAL_POZO_PAGOS          NUMERIC(22,0),
                      @p_TOTAL_GANADORAS           NUMERIC(22,0),
                      @p_FECHAHORAMODIFICACION     DATETIME,
                      @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                      @p_ACTIVE                    NUMERIC(22,0),
                      @p_ID_CONTROL_L1SHRCLC_out   NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    INSERT INTO WSXML_SFG.PRODUCTO_L1SHRCLC
      (CODCONTROL_L1SHRCLC,
       NOMPRODUCTO,
       NUMEROS_GANADORES,
       VENTA_TOTAL,
       IVA,
       VENTAS_BRUTAS,
       POZO_PARA_PREMIOS,
       FONDO_DE_RESERVA,
       TOTAL_POZO_PREMIOS,
       TOTAL_POZO_ANTERIOR,
       TOTAL_AJUSTES,
       TOTAL_POZO_TOTAL,
       TOTAL_REDONDEO,
       TOTAL_POZO_PAGOS,
       TOTAL_GANADORAS,
       FECHAHORAMODIFICACION,
       CODUSUARIOMODIFICACION,
       ACTIVE,
       PORCENT_POZO_PARA_PREMIOS)
    VALUES
      (@p_CODCONTROL_L1SHRCLC,
       @p_NOMPRODUCTO,
       @p_NUMEROS_GANADORES,
       @p_VENTA_TOTAL,
       @p_IVA,
       @p_VENTAS_BRUTAS,
       @p_POZO_PARA_PREMIOS,
       @p_FONDO_DE_RESERVA,
       @p_TOTAL_POZO_PREMIOS,
       @p_TOTAL_POZO_ANTERIOR,
       @p_TOTAL_AJUSTES,
       @p_TOTAL_POZO_TOTAL,
       @p_TOTAL_REDONDEO,
       @p_TOTAL_POZO_PAGOS,
       @p_TOTAL_GANADORAS,
       @p_FECHAHORAMODIFICACION,
       @p_CODUSUARIOMODIFICACION,
       @p_ACTIVE,
       @p_PORCENT_POZO_PARA_PREMIOS);
    SET @P_ID_CONTROL_L1SHRCLC_OUT = SCOPE_IDENTITY();

  END;
GO
  
  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_L1SHRCLC_AddProductoL1shrclc', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_L1SHRCLC_AddProductoL1shrclc;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_L1SHRCLC_AddProductoL1shrclc(@pCODCONTROL_L1SHRCLC NUMERIC(22,0),
                                @pNUMEROS_GANADORES varchar(4000),
                                @pVENTA_TOTAL NUMERIC(22,0),
                                @pIVA NUMERIC(22,0),
                                @pVENTAS_BRUTAS NUMERIC(22,0),
                                @pPOZO_PARA_PREMIOS NUMERIC(22,0),
                                @pFONDO_DE_RESERVA NUMERIC(22,0),
                                @pTOTAL_POZO_PREMIOS NUMERIC(22,0),
                                @pTOTAL_POZO_ANTERIOR NUMERIC(22,0),
                                @pTOTAL_AJUSTES NUMERIC(22,0),
                                @pTOTAL_POZO_TOTAL NUMERIC(22,0),
                                @pTOTAL_REDONDEO NUMERIC(22,0),
                                @pTOTAL_POZO_PAGOS NUMERIC(22,0),
                                @pTOTAL_GANADORAS NUMERIC(22,0),
                                @pFECHAHORAMODIFICACION DATETIME,
                                @pCODUSUARIOMODIFICACION NUMERIC(22,0),
                                @pACTIVE NUMERIC(22,0),
                                @pNOMPRODUCTO VARCHAR(4000),
                                @pPORCENT_POZO_PARA_PREMIOS VARCHAR(4000),
                                @pNUMEROSGANADORESMT2 VARCHAR(4000),
                                @pINGRESOAVANZADASSORTEO NUMERIC(22,0),
                                @pFONDORESERVAACUMULADON1 NUMERIC(22,0),
                                @pFONDORESERVAACUMULADOTOTAL NUMERIC(22,0),
                                @pPROBABILIDADCAIDAPRIMERPREMIO VARCHAR(4000),
                                @pPNOCAIDAN VARCHAR(4000),
                                @pPACUMULADONOCAIDAN1 VARCHAR(4000),
                                @pPACUMULADOCAIDAN VARCHAR(4000),
                                @pCANTAPUESTASREALIZADAS NUMERIC(22,0),
                                @pCANTAPESTASOTROSNUMEROS NUMERIC(22,0),
                                @pPACUMULADONOCAIDAN VARCHAR(4000),
                                @pPAGOPREMIOSTOTALSORTEO NUMERIC(22,0),
                                @pPORCENTPLANPREMIFONDORESERVA VARCHAR(4000),
                                @pPLANPREMIOSFONDORESERVA NUMERIC(22,0),
                                @pFONDOINICIALFONDORESERVA NUMERIC(22,0),
                                @pREDONDEOACUERDO05 NUMERIC(22,0),
                                @pID_PRODUCTO_L1SHRCLC_out NUMERIC(22,0) OUT) AS
 BEGIN
  
  DECLARE @vCODPRODUCTO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    --Consulta idproducto por nombre
    -- SFGPREMIOSL1LIAB.GetProductobyNombre(@pNOMPRODUCTO, @vCODPRODUCTO);
	EXEC WSXML_SFG.SFGPREMIOSL1LIAB$GetProductobyNombre @pNOMPRODUCTO, @vCODPRODUCTO;
    INSERT INTO WSXML_SFG.PRODUCTO_L1SHRCLC
                    (
                    CODCONTROL_L1SHRCLC,
                    CODPRODUCTO,
                    NUMEROS_GANADORES,
                    VENTA_TOTAL,
                    IVA,
                    VENTAS_BRUTAS,
                    POZO_PARA_PREMIOS,
                    FONDO_DE_RESERVA,
                    TOTAL_POZO_PREMIOS,
                    TOTAL_POZO_ANTERIOR,
                    TOTAL_AJUSTES,
                    TOTAL_POZO_TOTAL,
                    TOTAL_REDONDEO,
                    TOTAL_POZO_PAGOS,
                    TOTAL_GANADORAS,
                    FECHAHORAMODIFICACION,
                    CODUSUARIOMODIFICACION,
                    ACTIVE,
                    NOMPRODUCTO,
                    PORCENT_POZO_PARA_PREMIOS,
                    NUMEROSGANADORESMT2,
                    INGRESOAVANZADASSORTEO,
                    FONDORESERVAACUMULADON1,
                    FONDORESERVAACUMULADOTOTAL,
                    PROBABILIDADCAIDAPRIMERPREMIO,
                    PNOCAIDAN,
                    PACUMULADONOCAIDAN1,
                    PACUMULADOCAIDAN,
                    CANTAPUESTASREALIZADAS,
                    CANTAPESTASOTROSNUMEROS,
                    PACUMULADONOCAIDAN,
                    PAGOPREMIOSTOTALSORTEO,
                    PORCENTPLANPREMIFONDORESERVA,
                    PLANPREMIOSFONDORESERVA,
                    FONDOINICIALFONDORESERVA,
                    REDONDEOACUERDO05)
            VALUES (
                    @pCODCONTROL_L1SHRCLC,
                    @vCODPRODUCTO,
                    @pNUMEROS_GANADORES,
                    @pVENTA_TOTAL,
                    @pIVA,
                    @pVENTAS_BRUTAS,
                    @pPOZO_PARA_PREMIOS,
                    @pFONDO_DE_RESERVA,
                    @pTOTAL_POZO_PREMIOS,
                    @pTOTAL_POZO_ANTERIOR,
                    @pTOTAL_AJUSTES,
                    @pTOTAL_POZO_TOTAL,
                    @pTOTAL_REDONDEO,
                    @pTOTAL_POZO_PAGOS,
                    @pTOTAL_GANADORAS,
                    @pFECHAHORAMODIFICACION,
                    @pCODUSUARIOMODIFICACION,
                    @pACTIVE,
                    @pNOMPRODUCTO,
                    @pPORCENT_POZO_PARA_PREMIOS,
                    @pNUMEROSGANADORESMT2,
                    @pINGRESOAVANZADASSORTEO,
                    @pFONDORESERVAACUMULADON1,
                    @pFONDORESERVAACUMULADOTOTAL,
                    @pPROBABILIDADCAIDAPRIMERPREMIO,
                    @pPNOCAIDAN,
                    @pPACUMULADONOCAIDAN1,
                    @pPACUMULADOCAIDAN,
                    @pCANTAPUESTASREALIZADAS,
                    @pCANTAPESTASOTROSNUMEROS,
                    @pPACUMULADONOCAIDAN,
                    @pPAGOPREMIOSTOTALSORTEO,
                    @pPORCENTPLANPREMIFONDORESERVA,
                    @pPLANPREMIOSFONDORESERVA,
                    @pFONDOINICIALFONDORESERVA, 
                    @pREDONDEOACUERDO05);
    SET @pID_PRODUCTO_L1SHRCLC_out = SCOPE_IDENTITY();

  END;
GO






