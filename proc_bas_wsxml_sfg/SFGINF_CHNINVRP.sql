USE SFGPRODU;
--  DDL for Package Body SFGINF_CHNINVRP
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_CHNINVRP */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_CHNINVRP_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CHNINVRP_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CHNINVRP_GetList(@p_ACTIVE NUMERIC(22,0)
                  , @p_FECHAINICIO DATETIME
                  , @p_FECHAFIN DATETIME
                  , @P_CODCADENA NUMERIC(22,0)
                  , @p_ALI_ESTRATEGICO NVARCHAR(2000)
                  , @P_PRODUCTO NVARCHAR(2000)
                  , @p_SECUENCIA  NUMERIC(22,0)
                  , @p_LINEA  NUMERIC(22,0)
                  
                  ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT APV.CODTIPOPUNTODEVENTA
           , APV.CODIGOAGRUPACIONGTECH AS CODIGO_AGRUPACION
           , APV.ID_AGRUPACIONPUNTODEVENTA
           , APV.NOMAGRUPACIONPUNTODEVENTA AS NOMBRE_AGRUPACION
           , PV.CODIGOGTECHPUNTODEVENTA AS PTOVTA
           , PV.NUMEROTERMINAL AS TERM
           , SUM(isnull(VPVF.VALORVENTA, 0)) AS INGRESOS
           , SUM(isnull(VPVF.VALORANULACION,0)) AS ANULACION
           , 0 AS TOTAL_A_DEBER
           , SUM(VPVF.IMPUESTO_IVA)AS IVA
           , SUM(VPVF.VALORVENTABRUTA) AS INGRESO_BRUTO
           , SUM(isnull(VPVF.VALORPREMIOPAGO,0)) AS PAGOS_REALIZADOS
           , SUM(isnull(VPVF.VALORCOMISIONBRUTA,0)) AS COMISIONES_BRUTAS
           , SUM(VPVF.RETENCION_RENTA) AS IMPS_RENTA
           , SUM(VPVF.RETENCION_RETEICA) AS IMPS_INDCOMEC
           , SUM(VPVF.RETENCION_RETEIVA) AS IMPS_IVA
           , SUM(VPVF.VALORCOMISIONNETA) AS COMISIONES_NETAS
           , 0 AS AJUSTES
           , 0 AS BALANCE_GTECH
           , 0 AS BALANCE_FIDUCIA
           , 0 AS TOTAL_DEBER_GTECH
           , 0 AS TOTAL_DEBER_FIDUCIA
           , SUM(isnull(VPVF.RETENCIONPREMIOSPAGADOS,0)) AS RETEFUENTE

      FROM
       WSXML_SFG.vw_show_pdvfacturacion VPVF
      inner join PUNTODEVENTA PV on PV.id_puntodeventa= VPVF.ID_PUNTODEVENTA
      INNER JOIN AGRUPACIONPUNTODEVENTA APV ON APV.ID_AGRUPACIONPUNTODEVENTA = VPVF.CODAGRUPACIONPUNTODEVENTA

      WHERE VPVF.ID_CICLOFACTURACIONPDV =
             WSXML_SFG.ULTIMO_CICLOFACTURACION(@p_FECHAINICIO)
             and VPVF.CODLINEADENEGOCIO = @p_LINEA
             and pv.codagrupacionpuntodeventa <> WSXML_SFG.AGRUPACION_F(0)
      GROUP BY
             APV.CODTIPOPUNTODEVENTA
             , APV.CODIGOAGRUPACIONGTECH
             , APV.ID_AGRUPACIONPUNTODEVENTA
             , APV.NOMAGRUPACIONPUNTODEVENTA
             , PV.CODIGOGTECHPUNTODEVENTA
             , PV.NUMEROTERMINAL

      ORDER BY
             APV.CODTIPOPUNTODEVENTA
             , APV.CODIGOAGRUPACIONGTECH
             , APV.ID_AGRUPACIONPUNTODEVENTA
             , APV.NOMAGRUPACIONPUNTODEVENTA
             , PV.CODIGOGTECHPUNTODEVENTA
             , PV.NUMEROTERMINAL;

  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_CHNINVRP_GetResultado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CHNINVRP_GetResultado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CHNINVRP_GetResultado(
                  @p_ACTIVE NUMERIC(22,0)
                  , @p_FECHAINICIO DATETIME
                  , @p_FECHAFIN DATETIME
                  , @P_CODCADENA NUMERIC(22,0)
                  , @p_ALI_ESTRATEGICO NVARCHAR(2000)
                  , @P_PRODUCTO NVARCHAR(2000)
                  , @p_SECUENCIA  NUMERIC(22,0)
                  , @p_LINEA  NUMERIC(22,0)
                  
                  ) AS
  BEGIN
  SET NOCOUNT ON;



    select
              APV.CODTIPOPUNTODEVENTA
              , APV.ID_AGRUPACIONPUNTODEVENTA
              , APV.NOMAGRUPACIONPUNTODEVENTA
              , PV.CODIGOGTECHPUNTODEVENTA AS PTOVTA
              , PV.NUMEROTERMINAL AS TERM
              , SUM(isnull(VPVF.VALORVENTA,0)) AS INGRESOS
              , SUM(isnull(VPVF.VALORANULACION,0)) AS ANULACION
              , 0 AS TOTAL_A_DEBER
              , SUM(VPVF.IMPUESTO_IVA) AS IVA
              , SUM(VPVF.VALORVENTABRUTA) AS INGRESO_BRUTO
              , SUM(isnull(VPVF.VALORPREMIOPAGO,0)) AS PAGOS_REALIZADOS
              , SUM(isnull(VPVF.VALORCOMISIONBRUTA,0)) AS COMISIONES_BRUTAS
              , SUM(VPVF.RETENCION_RENTA) AS IMPS_RENTA
              , SUM(VPVF.RETENCION_RETEICA) AS IMPS_INDCOMEC
              , SUM(VPVF.RETENCION_RETEIVA) AS IMPS_IVA
              , SUM(VPVF.VALORCOMISIONNETA) AS COMISIONES_NETAS
              , 0 AS AJUSTES
              , 0 AS BALANCE_GTECH
               , 0 AS BALANCE_FIDUCIA
               , 0 AS TOTAL_DEBER_GTECH
               , 0 AS TOTAL_DEBER_FIDUCIA
               , 0 AS RETEFUENTE

         FROM
            WSXML_SFG.vw_show_pdvfacturacion VPVF
            inner join WSXML_SFG.PUNTODEVENTA PV on PV.id_puntodeventa= VPVF.ID_PUNTODEVENTA
            INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA APV ON APV.ID_AGRUPACIONPUNTODEVENTA = VPVF.CODAGRUPACIONPUNTODEVENTA
            and VPVF.CODLINEADENEGOCIO = @p_LINEA
         WHERE VPVF.ID_CICLOFACTURACIONPDV =
             WSXML_SFG.ULTIMO_CICLOFACTURACION(@p_FECHAINICIO)
             and pv.codagrupacionpuntodeventa <> WSXML_SFG.AGRUPACION_F(0)
      GROUP BY
              APV.CODTIPOPUNTODEVENTA
              , APV.ID_AGRUPACIONPUNTODEVENTA
              , APV.NOMAGRUPACIONPUNTODEVENTA
              , PV.CODIGOGTECHPUNTODEVENTA
              , PV.NUMEROTERMINAL

      ORDER BY
              APV.CODTIPOPUNTODEVENTA
              , APV.ID_AGRUPACIONPUNTODEVENTA
              , APV.NOMAGRUPACIONPUNTODEVENTA
              , PV.CODIGOGTECHPUNTODEVENTA
              , PV.NUMEROTERMINAL
              ;


  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_CHNINVRP_GetEnc', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CHNINVRP_GetEnc;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CHNINVRP_GetEnc(
                  @p_ACTIVE NUMERIC(22,0)
                  , @p_FECHAINICIO DATETIME
                  , @p_FECHAFIN DATETIME
                  , @P_CODCADENA NUMERIC(22,0)
                  , @p_ALI_ESTRATEGICO NVARCHAR(2000)
                  , @P_PRODUCTO NVARCHAR(2000)
                  , @p_SECUENCIA  NUMERIC(22,0)
                  , @p_LINEA  NUMERIC(22,0)
                  
                  ) AS
  BEGIN
  SET NOCOUNT ON;



    select
              'CADENA' AS CADENA,
              APV.CODTIPOPUNTODEVENTA
              , APV.CODIGOAGRUPACIONGTECH AS CODIGO_AGRUPACION
              , APV.ID_AGRUPACIONPUNTODEVENTA
              , APV.NOMAGRUPACIONPUNTODEVENTA AS NOMBRE_AGRUPACION

         FROM WSXML_SFG.agrupacionpuntodeventa APV

      --Filtro
      WHERE
      ID_AGRUPACIONPUNTODEVENTA = CASE WHEN @P_CODCADENA = -1 THEN ID_AGRUPACIONPUNTODEVENTA ELSE @P_CODCADENA END
      and ID_AGRUPACIONPUNTODEVENTA <> WSXML_SFG.AGRUPACION_F(0)
      ORDER BY
              APV.CODTIPOPUNTODEVENTA
              , APV.ID_AGRUPACIONPUNTODEVENTA
              , APV.NOMAGRUPACIONPUNTODEVENTA;


  END;
GO





