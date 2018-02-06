USE SFGPRODU;
--  DDL for Package Body SFGINF_RELDEP
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_RELDEP */ 

  -- Author  : SANDRA.ESLAVA
  -- Created : 16/04/2008 11:50 p.m.
  -- Purpose : Se creo procedimiento para informe RELDEP

  IF OBJECT_ID('WSXML_SFG.SFGINF_RELDEP_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_RELDEP_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_RELDEP_GetList(
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
              CASE WHEN MFC.REFERENCIAGTECH = '' OR MFC.REFERENCIAGTECH = ' ' OR MFC.REFERENCIAGTECH IS NULL  THEN MFC.REFERENCIAFIDUCIA ELSE MFC.REFERENCIAGTECH END AS REFERENCIA
              , MF.NUEVOSALDOENCONTRAGTECH AS ADEUDOS_GTECH
              , MF.NUEVOSALDOENCONTRAFIDUCIA AS ADEUDOS_FIDUCOLOMBIA
              --, SUM(PG.VALORPAGOGTECH)
              , 0 AS DEPOSITOS_GTECH
              --, SUM(PG.VALORPAGOFIDUCIA)
              , 0 as DEPOSITOS_FIDUCOLOMBIA
             -- , MF.NUEVOSALDOENCONTRAGTECH - SUM(PG.VALORPAGOGTECH)
              , 0 AS SALDO_GTECH
              --, MF.NUEVOSALDOENCONTRAFIDUCIA - SUM(PG.VALORPAGOFIDUCIA)
              , 0 AS SALDO_FIDUCOLOMBIA
              --, (MF.NUEVOSALDOENCONTRAGTECH - SUM(PG.VALORPAGOGTECH)) +(MF.NUEVOSALDOENCONTRAFIDUCIA - SUM(PG.VALORPAGOFIDUCIA))
              , 0 AS TOTAL
          from WSXML_SFG.maestrofacturacionpdv MF,
               WSXML_SFG.maestrofacturacioncompconsig MFC,
               WSXML_SFG.pagofacturacionpdv PG
               , WSXML_SFG.puntodeventa PV
               , WSXML_SFG.ciclofacturacionpdv CF
         where
               MFC.id_maestrofactcompconsig = MF.codmaestrofacturacioncompconsi
               and MF.id_maestrofacturacionpdv = PG.codmaestrofacturacionpdv
               and PV.id_puntodeventa = MF.codpuntodeventa
               and CF.id_ciclofacturacionpdv = MF.codciclofacturacionpdv
               and CF.id_ciclofacturacionpdv =
                         WSXML_SFG.ULTIMO_CICLOFACTURACION(@p_FECHAINICIO)
               --Filtro
               AND MFC.ACTIVE= CASE WHEN @p_ACTIVE = -1 THEN MFC.ACTIVE ELSE @p_ACTIVE END
               AND CF.fechaejecucion >=  @p_FECHAINICIO
               AND CF.fechaejecucion <= @p_FECHAFIN

        GROUP BY
              MFC.REFERENCIAGTECH
              , MFC.REFERENCIAFIDUCIA
              , MF.NUEVOSALDOENCONTRAGTECH
              , MF.NUEVOSALDOENCONTRAFIDUCIA;


  END;
GO





