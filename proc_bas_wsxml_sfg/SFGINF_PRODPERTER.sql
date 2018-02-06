USE SFGPRODU;
--  DDL for Package Body SFGINF_PRODPERTER
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_PRODPERTER */ 

  -- Author  : SANDRA.ESLAVA
  -- Created : 15/04/2008 1:30 p.m.
  -- Purpose : Se creo procedimiento para informe de producto por terminal
  -- Faltan 5 campos por definir
  IF OBJECT_ID('WSXML_SFG.SFGINF_PRODPERTER_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_PRODPERTER_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_PRODPERTER_GetList(
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

         SELECT PV.CODIGOGTECHPUNTODEVENTA AS POS,
             PV.NUMEROTERMINAL AS TERM,
             CASE WHEN PV.id_puntodeventa = APV.CODPUNTODEVENTACABEZA THEN 'Head of chain' ELSE 'Subordinate' end AS CHAIN_STATUS
             ,case when
             (
              select
              count(*)
              from WSXML_SFG.inactivacionpdv I LEFT JOIN inactivacionpdvomision IO
              ON I.ID_INACTIVACIONPDV = IO.CODINACTIVACIONPDV
              where I.CODPUNTODEVENTA = PV.ID_PUNTODEVENTA
              and I.CODLINEADENEGOCIO=1
              AND I.ACTIVE=1 AND IO.CODINACTIVACIONPDV IS NULL
              )<>0 THEN 'FALSE' ELSE 'TRUE' END
             as EVOUCHE_STATE
             ,case when
             (
              select
              count(*)
              from WSXML_SFG.inactivacionpdv I LEFT JOIN inactivacionpdvomision IO
              ON I.ID_INACTIVACIONPDV = IO.CODINACTIVACIONPDV
              where I.CODPUNTODEVENTA = PV.ID_PUNTODEVENTA
              and I.CODLINEADENEGOCIO=3
              AND I.ACTIVE=1 AND IO.CODINACTIVACIONPDV IS NULL
              )<>0 THEN 'FALSE' ELSE 'TRUE' END
              as BP_STATE
             ,case when
             (
              select
              count(*)
              from WSXML_SFG.inactivacionpdv I LEFT JOIN inactivacionpdvomision IO
              ON I.ID_INACTIVACIONPDV = IO.CODINACTIVACIONPDV
              where I.CODPUNTODEVENTA = PV.ID_PUNTODEVENTA
              and I.CODLINEADENEGOCIO=2
              AND I.ACTIVE=1 AND IO.CODINACTIVACIONPDV IS NULL
              )<>0 THEN 'FALSE' ELSE 'TRUE' END
              as E_RECHARGE_STATE
              /*, SUM(CASE WHEN VPVF.CODLINEADENEGOCIO = 2 THEN VPVF.NUEVOSALDOAFAVORGTECH ELSE 0 END)
              - SUM(CASE WHEN VPVF.CODLINEADENEGOCIO = 2 THEN VPVF.SALDOANTERIORAFAVORGTECH ELSE 0 END)
              AS DEBT_CURRENT_WEEK_PREPAID
              , SUM(CASE WHEN VPVF.CODLINEADENEGOCIO = 3 THEN VPVF.NUEVOSALDOAFAVORGTECH ELSE 0 END)
              - SUM(CASE WHEN VPVF.CODLINEADENEGOCIO = 3 THEN VPVF.SALDOANTERIORAFAVORGTECH ELSE 0 END)
              AS DEBT_CURRENT_WEEK_BILLPAYMENT
              , SUM(CASE WHEN VPVF.CODLINEADENEGOCIO = 2 THEN VPVF.NUEVOSALDOAFAVORGTECH ELSE 0 END) AS DEBT_TOTAL_PREPAID
              , SUM(CASE WHEN VPVF.CODLINEADENEGOCIO = 3 THEN VPVF.NUEVOSALDOAFAVORGTECH ELSE 0 END) AS DEBT_TOTAL_BP*/

        FROM
        WSXML_SFG.vw_show_pdvfacturacion VPVF
        inner join WSXML_SFG.PUNTODEVENTA PV ON PV.ID_PUNTODEVENTA = VPVF.ID_PUNTODEVENTA
        inner join WSXML_SFG.AGRUPACIONPUNTODEVENTA APV  ON APV.ID_AGRUPACIONPUNTODEVENTA = PV.CODAGRUPACIONPUNTODEVENTA
       WHERE VPVF.ID_CICLOFACTURACIONPDV =
             wsxml_sfg.ULTIMO_CICLOFACTURACION(@p_FECHAINICIO)
        GROUP BY
             PV.CODIGOGTECHPUNTODEVENTA,
             APV.CODPUNTODEVENTACABEZA,
             PV.NUMEROTERMINAL,
             PV.id_puntodeventa
         ;
  END;
GO





