USE SFGPRODU;
--  DDL for Package Body SFGINF_INVFILE000
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_INVFILE000 */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_INVFILE000_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_INVFILE000_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_INVFILE000_GetList(
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
			RIGHT(REPLICATE('0', 4) + APV.Codigoagrupaciongtech, 4) as CHAIN
			, RIGHT(REPLICATE('0', 6) + PV.CODIGOGTECHPUNTODEVENTA, 6) as POS
			, RIGHT(REPLICATE('0', 5) + dbo.fn_CharLTrim(0,PV.NUMEROTERMINAL), 5) as TERM
			, RIGHT(REPLICATE('0', 15) + SUM(isnull(VPVF.VALORVENTA,0)), 15) as VENTAS_VAT
			, RIGHT(REPLICATE('0', 15) + SUM(VPVF.IMPUESTO_IVA), 15) as VAT		
			, RIGHT(REPLICATE('0', 15) + (SUM(VPVF.VALORVENTA)- SUM(VPVF.IMPUESTO_IVA)), 15) as VENTAS_SIN_VAT
			, RIGHT(REPLICATE('0', 15) + SUM(isnull(VPVF.VALORANULACION,0)), 15) as VALORANULACION
			, RIGHT(REPLICATE('0', 12) + SUM(isnull(VPVF.VALORCOMISIONNETA,0)), 12) as COMISSION_GROSS			
			, RIGHT(REPLICATE('0', 12) + SUM(isnull(VPVF.VATCOMISION,0)), 12) as VAT_COMISSION_GROSS
			, RIGHT(REPLICATE('0', 12) + SUM(isnull(VPVF.VALORCOMISION,0)), 12) as TOTAL_COMISSION
			, RIGHT(REPLICATE('0', 10) + SUM(VPVF.RETENCION_RENTA), 10) as TAX_RENTA
			, RIGHT(REPLICATE('0', 10) + SUM(VPVF.RETENCION_RETEICA), 10) as TAXS_INDCOME
			, RIGHT(REPLICATE('0', 10) + SUM(VPVF.RETENCION_RETEIVA), 10) as TAX_IVA
			, RIGHT(REPLICATE('0', 15) + SUM(VPVF.VALORPREMIOPAGO), 15) as GAMES_PAYMENT
			, RIGHT(REPLICATE('0', 12) + SUM(isnull(VPVF.RETENCIONPREMIOSPAGADOS,0)), 12) as TAX_RENTA_GAMES
			
            /*, LPAD((SUM (NVL(VPVF.VALORPREMIOPAGO,0))
              + SUM(NVL(VPVF.RETENCIONPREMIOSPAGADOS,0))),12,'0') AS TOTAL_GAMES_PAYMENT
            , LPAD(SUM(nvl(VPVF.NUEVOSALDOENCONTRAGTECH,0)),15,'0')
              AS TOTAL_MONTO_ADEUDADO
            , LPAD(0,15,'0') AS TOTAL_BALANCE
            , LPAD(SUM(nvl(VPVF.NUEVOSALDOAFAVORGTECH,0)),15,'0')
              AS TOTAL_ADEUDADO_POS*/
			  
            , RIGHT(REPLICATE('0', 15) + 0, 15) AS DEBT_FIDUCIARY
            , RIGHT(REPLICATE('0', 15) + 0, 15) AS DEBT_DAT
            , RIGHT(REPLICATE('0', 15) + 0, 15) AS DEBT_GTECH
			
       FROM WSXML_SFG.vw_show_pdvfacturacion VPVF
            inner join PUNTODEVENTA PV on PV.id_puntodeventa= VPVF.ID_PUNTODEVENTA
            inner join AGRUPACIONPUNTODEVENTA APV ON APV.ID_AGRUPACIONPUNTODEVENTA= VPVF.CODAGRUPACIONPUNTODEVENTA
        WHERE VPVF.ID_CICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(@p_FECHAINICIO)
            and VPVF.CODLINEADENEGOCIO = @p_LINEA
            AND PV.CODAGRUPACIONPUNTODEVENTA = WSXML_SFG.AGRUPACION_F(0)

        GROUP BY
            Apv.Codigoagrupaciongtech
            , PV.CODIGOGTECHPUNTODEVENTA
            , PV.NUMEROTERMINAL;



  END;
GO




