USE SFGPRODU;
--  DDL for Package Body SFGINF_GTECHPV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_GTECHPV */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_GTECHPV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_GTECHPV_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_GTECHPV_GetList(
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
          '800150280' AS NIT_FIDUCIA
          , FORMAT(getdate(),'ddMMyyyy') as FECHA
          , SUM(MF.NUEVOSALDOAFAVORGTECH) AS SALDO_A_GTECH
          , 'SALD' AS SALD
          , MFC.REFERENCIAGTECH AS NUMEROFACTURA
          , (
            SELECT SUM(MF3.NUEVOSALDOAFAVORGTECH) FROM WSXML_SFG.maestrofacturacionpdv MF3 WHERE MF3.CODPUNTODEVENTA=PV.ID_PUNTODEVENTA
          ) AS ACUM_SALDO

        from WSXML_SFG.puntodeventa PV,
             WSXML_SFG.maestrofacturacionpdv MF,
             WSXML_SFG.maestrofacturacioncompconsig MFC
       where PV.id_puntodeventa = MF.codpuntodeventa
             and MFC.id_maestrofactcompconsig = MF.codmaestrofacturacioncompconsi
             and MF.CODCICLOFACTURACIONPDV =
                 WSXML_SFG.ULTIMO_CICLOFACTURACION(@p_FECHAINICIO)
               --Filtro Parametros
              AND PV.ACTIVE= CASE WHEN @p_ACTIVE = -1 THEN PV.ACTIVE ELSE @p_ACTIVE END


      GROUP BY

            MFC.REFERENCIAGTECH
            , PV.ID_PUNTODEVENTA

      ORDER BY
           MFC.REFERENCIAGTECH;


  END;
GO





