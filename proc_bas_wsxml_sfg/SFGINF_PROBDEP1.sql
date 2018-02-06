USE SFGPRODU;
--  DDL for Package Body SFGINF_PROBDEP1
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_PROBDEP1 */ 

 IF OBJECT_ID('WSXML_SFG.SFGINF_PROBDEP1_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_PROBDEP1_GetList;
GO

CREATE   PROCEDURE WSXML_SFG.SFGINF_PROBDEP1_GetList(
                  @p_ACTIVE NUMERIC(22,0)
                  , @p_FECHAINICIO DATETIME
                  , @p_FECHAFIN DATETIME
                  , @P_CODCADENA NUMERIC(22,0)
                  , @p_ALI_ESTRATEGICO NVARCHAR(2000)
                  , @P_PRODUCTO NVARCHAR(2000)
                  , @p_SECUENCIA  NUMERIC(22,0)
                  , @p_LINEA  NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

	 -- No se encontro el objeto WSXML_SFG.maestrofacturacioncompconsig.REFERENCIAFIDUCIA
	 /*
      select
        case WHEN MFC.referenciagtech IS  NULL then MFC.referenciafiducia else MFC.referenciagtech end as  REFERENCIA
        , sum(MF.NUEVOSALDOAFAVORGTECH) as  ADEUDOS_GTECH
        , sum(MF.NUEVOSALDOAFAVORFIDUCIA) as  ADEUDOS_FIDUCOLOMBIA
        , sum(MF.SALDOANTERIORENCONTRAGTECH) as  SALDOS_GTECH
        , sum(MF.SALDOANTERIORENCONTRAFIDUCIA) as  SALDOS_FIDUCOLOMBIA
        , sum(MF.SALDOANTERIORENCONTRAGTECH)
          + sum(MF.SALDOANTERIORENCONTRAFIDUCIA) as  TOTAL
        , 0 AS OFNA
        , 1 AS DIA
       from WSXML_SFG.maestrofacturacionpdv MF,
               WSXML_SFG.maestrofacturacioncompconsig MFC,
               WSXML_SFG.pagofacturacionpdv PG
               , WSXML_SFG.puntodeventa PV
         where
               MFC.id_maestrofactcompconsig = MF.codmaestrofacturacioncompconsi
               and MF.id_maestrofacturacionpdv = PG.codmaestrofacturacionpdv
               and PV.id_puntodeventa = MF.codpuntodeventa
               and MF.CODCICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(@p_FECHAINICIO)

        group by MFC.referenciagtech
        --where falta secuencia
        */


  END;
GO





