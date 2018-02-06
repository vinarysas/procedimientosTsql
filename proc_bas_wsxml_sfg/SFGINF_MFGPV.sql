USE SFGPRODU;
--  DDL for Package Body SFGINF_MFGPV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_MFGPV */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_MFGPV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_MFGPV_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_MFGPV_GetList(
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
          C.NUMEROCUENTA AS NUMERO_CUENTA
          , C.CODIGOBANCO AS OFICINA
          , '1' AS TIPO_CUENTA
          , MFC.FECHALIMITEPAGOFIDUCIA as FECHA
          , MFC.REFERENCIAGTECH AS NUMERO_DOCUMENTO
          , '-' AS GUION
          , '000000000000' AS VALOR
          , '.' AS PUNTO
          , '0000' AS CODIGO_TRANSACCION
          , '0' AS TRANSACCION
          , '0' AS CAUSAL_DEVOLUCION

        from WSXML_SFG.puntodeventa PV
             inner join WSXML_SFG.maestrofacturacionpdv MF on PV.id_puntodeventa = MF.codpuntodeventa
             inner join WSXML_SFG.maestrofacturacioncompconsig MFC on MFC.id_maestrofactcompconsig = MF.codmaestrofacturacioncompconsi
             inner join WSXML_SFG.ciclofacturacionpdv CF on CF.id_ciclofacturacionpdv = MF.codciclofacturacionpdv
             left join WSXML_SFG.cuenta C on MFC.CODCUENTAPAGOFIDUCIA = C.ID_CUENTA
       where
        CF.id_ciclofacturacionpdv =
             WSXML_SFG.ULTIMO_CICLOFACTURACION(@p_FECHAINICIO)


      ORDER BY
           MFC.REFERENCIAGTECH;
  END;
GO





