USE SFGPRODU;
--  DDL for Package Body SFGDETALLE_L1SHRCLC
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLE_L1SHRCLC */ 

  --Add Record in the table CONTROL_L1LIAB01
  IF OBJECT_ID('WSXML_SFG.SFGDETALLE_L1SHRCLC_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLE_L1SHRCLC_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLE_L1SHRCLC_AddRecord(@p_CODPRODUCTO_L1SHRCLC         NUMERIC(22,0),
                      @p_CODCATEGORIA_ACIERTOS_L1LIAB NUMERIC(22,0),
                      @p_PORCENTAJE_FIJO              NUMERIC(22,0),
                      @p_POZO_PREMIOS                 NUMERIC(22,0),
                      @p_POZO_ANTERIOR                NUMERIC(22,0),
                      @p_AJUSTES                      NUMERIC(22,0),
                      @p_POZO_TOTAL                   NUMERIC(22,0),
                      @p_REDONDEO                     NUMERIC(22,0),
                      @p_POZO_PAGOS                   NUMERIC(22,0),
                      @p_GANADORAS                    NUMERIC(22,0),
                      @p_PREMIO_INDIVIDUAL            NUMERIC(22,0),
                      @p_RETEFUENTE                   NUMERIC(22,0),
                      @p_IMPUESTO_INDIVIDUAL_POR_PREM NUMERIC(22,0),
                      @p_FECHAHORAMODIFICACION        DATETIME,
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ACTIVE                       NUMERIC(22,0),
                      @p_ID_DETALLE_L1SHRCLC_out      NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    INSERT INTO WSXML_SFG.DETALLE_L1SHRCLC
      (CODPRODUCTO_L1SHRCLC,
       CODCATEGORIA_ACIERTOS_L1LIAB01,
       PORCENTAJE_FIJO,
       POZO_PREMIOS,
       POZO_ANTERIOR,
       AJUSTES,
       POZO_TOTAL,
       REDONDEO,
       POZO_PAGOS,
       GANADORAS,
       PREMIO_INDIVIDUAL,
       RETEFUENTE,
       IMPUESTO_INDIVIDUAL_POR_PREMIO,
       FECHAHORAMODIFICACION,
       CODUSUARIOMODIFICACION,
       ACTIVE)
    VALUES
      (@p_CODPRODUCTO_L1SHRCLC,
       @p_CODCATEGORIA_ACIERTOS_L1LIAB,
       @p_PORCENTAJE_FIJO,
       @p_POZO_PREMIOS,
       @p_POZO_ANTERIOR,
       @p_AJUSTES,
       @p_POZO_TOTAL,
       @p_REDONDEO,
       @p_POZO_PAGOS,
       @p_GANADORAS,
       @p_PREMIO_INDIVIDUAL,
       @p_RETEFUENTE,
       @p_IMPUESTO_INDIVIDUAL_POR_PREM,
       @p_FECHAHORAMODIFICACION,
       @p_CODUSUARIOMODIFICACION,
       @p_ACTIVE);
    SET @p_ID_DETALLE_L1SHRCLC_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLE_L1SHRCLC_AddDetalleL1shrclc', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLE_L1SHRCLC_AddDetalleL1shrclc;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLE_L1SHRCLC_AddDetalleL1shrclc(@pCODCPRODUCTOL1SHRCLC  NUMERIC(22,0),
                      @pDIVISIONCATEGORIA            varchar(4000),
                      @pGANADORAS                    NUMERIC(22,0),
                      @pPORCENTAJE_FIJO              NUMERIC(22,0),
                      @pPOZO_PREMIOS                 NUMERIC(22,0),
                      @pPOZO_ANTERIOR                NUMERIC(22,0),
                      @pAJUSTES                      NUMERIC(22,0),
                      @pPOZO_TOTAL                   NUMERIC(22,0),
                      @pREDONDEO                     NUMERIC(22,0),
                      @pPOZO_PAGOS                   NUMERIC(22,0),
                      @pPREMIO_INDIVIDUAL            NUMERIC(22,0),
                      @pRETEFUENTE                   NUMERIC(22,0),
                      @pIMPUESTO_INDIVIDUAL_POR_PREM NUMERIC(22,0),
                      @pREDONDEOACUERDO05            NUMERIC(22,0),
                      @pPREMIOTEORICOPORGANADOR      NUMERIC(22,0),
                      @pFECHAHORAMODIFICACION        DATETIME,
                      @pCODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @pACTIVE                       NUMERIC(22,0),
                      @p_ID_DETALLE_L1SHRCLC_out     NUMERIC(22,0) OUT) AS
 BEGIN
  --Declara variables
  DECLARE @vCODCATEGORIA NUMERIC(22,0);
   
  SET NOCOUNT ON;

    EXEC WSXML_SFG.SFGPREMIOSL1LIAB_GetCategoriabyDivision @pDIVISIONCATEGORIA, @vCODCATEGORIA OUT

    INSERT INTO WSXML_SFG.DETALLE_L1SHRCLC
      (
      CODPRODUCTO_L1SHRCLC,
      PORCENTAJE_FIJO,
      POZO_PREMIOS,
      POZO_ANTERIOR,
      AJUSTES,
      POZO_TOTAL,
      REDONDEO,
      POZO_PAGOS,
      GANADORAS,
      PREMIO_INDIVIDUAL,
      RETEFUENTE,
      IMPUESTO_INDIVIDUAL_POR_PREMIO,
      FECHAHORAMODIFICACION,
      CODUSUARIOMODIFICACION,
      ACTIVE,
      CODCATEGORIASORTEOS,
      PREMIOTEORICOPORGANADOR,
      REDONDEOACUERDO05)
    VALUES
      (
       @pCODCPRODUCTOL1SHRCLC,
       @pPORCENTAJE_FIJO,
       @pPOZO_PREMIOS,
       @pPOZO_ANTERIOR,
       @pAJUSTES,
       @pPOZO_TOTAL,
       @pREDONDEO,
       @pPOZO_PAGOS,
       @pGANADORAS,
       @pPREMIO_INDIVIDUAL,
       @pRETEFUENTE,
       @pIMPUESTO_INDIVIDUAL_POR_PREM,
       @pFECHAHORAMODIFICACION,
       @pCODUSUARIOMODIFICACION,
       @pACTIVE,
       @vCODCATEGORIA,
       @pPREMIOTEORICOPORGANADOR, @pREDONDEOACUERDO05);
    SET @p_ID_DETALLE_L1SHRCLC_out = SCOPE_IDENTITY();
  END;
GO
  --
  IF OBJECT_ID('WSXML_SFG.SFGDETALLE_L1SHRCLC_GetNumGanadoPremioMayorBaloto', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGDETALLE_L1SHRCLC_GetNumGanadoPremioMayorBaloto;
GO

CREATE     FUNCTION WSXML_SFG.SFGDETALLE_L1SHRCLC_GetNumGanadoPremioMayorBaloto(@pNumeroSorteo VARCHAR(4000) /* Use -meta option control_l1shrclc.sorteo%TYPE */) RETURNS NUMERIC(22,0) AS
 BEGIN
    --
    DECLARE @xNumeroGanadores  NUMERIC(22,0) ;
    --
     
      --
      -- Consulta de entrega de premio mayor 
      SELECT @xNumeroGanadores = ganadoras
        FROM WSXML_SFG.detalle_l1shrclc                                      DL1
       INNER JOIN WSXML_SFG.producto_l1shrclc                                PL1
          ON PL1.ID_PRODUCTO_L1SHRCLC   = DL1.CODPRODUCTO_L1SHRCLC
       INNER JOIN WSXML_SFG.control_l1shrclc                                 CL1
          ON CL1.ID_CONTROL_L1SHRCLC    = PL1.CODCONTROL_L1SHRCLC 
       WHERE PL1.CODPRODUCTO            = 155 -- Baloto
         AND DL1.CODCATEGORIASORTEOS    = 1   -- Premio Mayor
         AND CL1.SORTEO                 = @pNumeroSorteo;
      --
      RETURN @xNumeroGanadores;
      --
    END;
GO





