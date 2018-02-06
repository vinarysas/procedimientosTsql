USE SFGPRODU;
--  DDL for Package Body SFGINF_DETALLERANGOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_DETALLERANGOS */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_DETALLERANGOS_GetProductHeaders', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_DETALLERANGOS_GetProductHeaders;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_DETALLERANGOS_GetProductHeaders(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT CAST(ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO AS NUMERIC(38,0))                 AS ORDEN,
             substring(ALIADOESTRATEGICO.NOMALIADOESTRATEGICO,1,30)                       AS NOMBRE,
             'SFGINF_DETALLERANGOS.GetDetailedTransactions' AS PROCEDURENAME,
             @p_CODCICLOFACTURACIONPDV                       AS ID_CICLOFACTURACIONPDV,
--             CODIGOGTECHPRODUCTO                            AS PRODUCTO,
             ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO                   AS ALIADO
      FROM WSXML_SFG.PRODUCTO
      INNER JOIN WSXML_SFG.ALIADOESTRATEGICO ON (PRODUCTO.CODALIADOESTRATEGICO = ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO)
      INNER JOIN WSXML_SFG.PRODUCTOCONTRATO  ON (CODPRODUCTO      = ID_PRODUCTO)
      INNER JOIN WSXML_SFG.RANGOCOMISION     ON (CODRANGOCOMISION = ID_RANGOCOMISION)
      WHERE CODTIPOCOMISION IN (4, 5, 6)
      GROUP BY      CAST(ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO AS NUMERIC(38,0))      ,
                    substring(ALIADOESTRATEGICO.NOMALIADOESTRATEGICO,1,30),
                    ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO  ;
      
      

      
  END;
  GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_DETALLERANGOS_GetDetailedTransactions', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_DETALLERANGOS_GetDetailedTransactions;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_DETALLERANGOS_GetDetailedTransactions(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
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
      SELECT CTR.FECHAARCHIVO               AS FECHAARCHIVO,
             PRD.CODIGOGTECHPRODUCTO        AS CODIGOGTECHPRODUCTO,
             PRD.NOMPRODUCTO                AS NOMPRODUCTO,
             RFR.FECHAHORATRANSACCION       AS FECHAHORATRANSACCION,
             TPR.NOMTIPOREGISTRO            AS NOMTIPOREGISTRO,
             RFR.NUMEROREFERENCIA           AS NUMEROREFERENCIA,
             ISNULL(RFR.VALORTRANSACCION, 0)   AS VALORTRANSACCION,
             ISNULL(RCD.RANGOINICIAL, 0)       AS RANGOINICIAL,
             ISNULL(RCD.RANGOFINAL, 0)         AS RANGOFINAL,
             ISNULL(RCD.VALORPORCENTUAL, 0)    AS VALORPORCENTUAL,
             ISNULL(RCD.VALORTRANSACCIONAL, 0) AS VALORTRANSACCIONAL,
             ISNULL(RVT.REVENUE, 0)            AS REVENUE
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.REGISTROFACTURACION             REG ON (REG.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL)
      INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA          RFR ON (RFR.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
      INNER JOIN WSXML_SFG.PRODUCTO                        PRD ON (PRD.ID_PRODUCTO               = REG.CODPRODUCTO)
      INNER JOIN WSXML_SFG.PRODUCTOCONTRATO                PRC ON (PRC.CODPRODUCTO               = PRD.ID_PRODUCTO)
      INNER JOIN WSXML_SFG.RANGOCOMISION                   RCM ON (PRC.CODRANGOCOMISION          = RCM.ID_RANGOCOMISION)
      INNER JOIN WSXML_SFG.TIPOREGISTRO                    TPR ON (TPR.ID_TIPOREGISTRO           = REG.CODTIPOREGISTRO)
      LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE            REV ON (REV.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                     AND REV.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
      LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUETRANSACCION RVT ON (RVT.CODREGISTROREVENUE        = REV.ID_REGISTROREVENUE
                                                     AND RVT.CODREGISTROFACTREFERENCIA = RFR.ID_REGISTROFACTREFERENCIA)
      LEFT OUTER JOIN WSXML_SFG.RANGOCOMISIONDETALLE       RCD ON (RCD.ID_RANGOCOMISIONDETALLE   = RVT.CODRANGOCOMISIONDETALLE)
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
        AND CTR.TIPOARCHIVO = 1
        AND RCM.CODTIPOCOMISION IN (4, 5, 6)
        --AND TO_NUMBER(PRD.CODIGOGTECHPRODUCTO) = TO_NUMBER(pg_PRODUCTO) 
        AND PRD.CODALIADOESTRATEGICO = CAST(@pg_ALIADOESTRATEGICO AS NUMERIC(38,0))        
        AND REG.CODTIPOREGISTRO IN (1, 2)
      ORDER BY CTR.FECHAARCHIVO, RFR.FECHAHORATRANSACCION;
  END;



GO

