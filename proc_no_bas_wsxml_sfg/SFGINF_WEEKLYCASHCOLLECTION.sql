USE SFGPRODU;
--------------------------------------------------------
--  DDL for Package Body SFGINF_WEEKLYCASHCOLLECTION
--------------------------------------------------------

  /* PACKAGE BODY "WSXML_SFG"."SFGINF_WEEKLYCASHCOLLECTION" */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_WEEKLYCASHCOLLECTION_GetReportData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_WEEKLYCASHCOLLECTION_GetReportData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_WEEKLYCASHCOLLECTION_GetReportData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                          @pg_CADENA                NVARCHAR(2000),
                          @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                          @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @countelements    NUMERIC(22,0) = 40;
    DECLARE @currentsequence  NUMERIC(22,0);
    DECLARE @initialsequence  NUMERIC(22,0);
    DECLARE @lstcycles        WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @additionalcycle  NUMERIC(22,0);
    DECLARE @lstcashcollected WSXML_SFG.IDVALUE;
   
  SET NOCOUNT ON;
    /* Get cycles */
    SELECT @currentsequence = SECUENCIA FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    SET @initialsequence = @currentsequence - @countelements;
    IF @initialsequence <= 0 BEGIN
      SET @initialsequence = 1;
    END 
	INSERT INTO @lstcycles 
    SELECT ID_CICLOFACTURACIONPDV 
	FROM WSXML_SFG.CICLOFACTURACIONPDV 
	WHERE ACTIVE = 1 AND SECUENCIA >= @initialsequence 
	ORDER BY SECUENCIA;

    SELECT @additionalcycle = ID_CICLOFACTURACIONPDV 
	FROM WSXML_SFG.CICLOFACTURACIONPDV 
	WHERE ACTIVE = 1 AND SECUENCIA = @initialsequence - 1;
    /* Get Cash Collected */
    /*SELECT IDVALUE(CODCICLOFACTURACION, DEPOSITOS) BULK COLLECT INTO lstcashcollected FROM vw_WeeklyCashCollected@HELION
    WHERE CODCICLOFACTURACION IN (SELECT COLUMN_VALUE FROM TABLE(lstcycles)) OR CODCICLOFACTURACION = additionalcycle;
    */
      SELECT 'W/E ' + ISNULL(FORMAT(CFP.FECHAEJECUCION, 'MM/dd/yyyy'), '')                                                                       AS "[space]",
             '  '                                                                                                                      AS "Lottery Selling Terminals",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND PDV.CODREDPDV = 82 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]ETESA",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND PDV.CODREDPDV = 83 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]AEL",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND PDV.CODREDPDV = 84 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]QAP",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN MFP.CODPUNTODEVENTA END))                                         AS "[m]Tot. Lottery Selling Term.",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "Lottery Gross Sales",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND DFP.CODTIPOPRODUCTO = 1 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Lotto Game (Baloto)",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND DFP.CODTIPOPRODUCTO = 2 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Chance Game (Pagatodo)",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND DFP.CODTIPOPRODUCTO = 3 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Traditional Lottery",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND DFP.CODTIPOPRODUCTO = 4 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Numbers (Astro)",
             --SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND DFP.CODTIPOPRODUCTO = 5 THEN DFP.VALORVENTA ELSE 0 END)                       AS "[c]Races (Hipico Millonario)",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.VALORVENTA ELSE 0 END), 6)                                         AS "[z]Total Lottery Gross Sales",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "Less",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.VALORPREMIOPAGO ELSE 0 END), 6)                                    AS "[c]Prizes Paid By Agents",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.VALORCOMISIONNOANTICIPO ELSE 0 END), 6)                            AS "[c]Agent Commissions",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.VALORANULACION ELSE 0 END), 6)                                     AS "[c]Cancellations",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.VALORIVACOMISION ELSE 0 END), 6)                                   AS "[c]VAT Agent Commission",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.VALORRETENCIONES * (-1) ELSE 0 END), 6)                            AS "[c]Taxes W/H From Commission",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.VALORCOMISIONANTICIPO ELSE 0 END), 6)                              AS "[c]Chance Proceeds Col. AEL",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.VALORPREMIOPAGO +
                                                                DFP.VALORCOMISIONNOANTICIPO +
                                                                DFP.VALORANULACION +
                                                                DFP.VALORCOMISIONANTICIPO +
                                                                DFP.VALORIVACOMISION -
                                                                DFP.VALORRETENCIONES ELSE 0 END), 6)                                   AS "[z]Total Lottery Deductions",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.VALORVENTA - (DFP.VALORPREMIOPAGO +
                                                                                  DFP.VALORCOMISIONNOANTICIPO +
                                                                                  DFP.VALORANULACION +
                                                                                  DFP.VALORCOMISIONANTICIPO +
                                                                                  DFP.VALORIVACOMISION -
                                                                                  DFP.VALORRETENCIONES) ELSE 0 END), 6)                AS "[zv]Lottery Amount due Agents",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "ETU Selling Terminals",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 2 AND PDV.CODREDPDV = 82 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]ETESA",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 2 AND PDV.CODREDPDV = 83 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]AEL",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 2 AND PDV.CODREDPDV = 84 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]QAP",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN MFP.CODPUNTODEVENTA END))                                         AS "[m]Tot. ETU Selling Terminals",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "ETU Gross Sales",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 AND DFP.CODTIPOPRODUCTO = 6 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]E-Voucher",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 AND DFP.CODTIPOPRODUCTO = 7 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]E-Recharge",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN DFP.VALORVENTA ELSE 0 END), 6)                                         AS "[z]Total ETU Gross Sales",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "Less",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN DFP.VALORCOMISION ELSE 0 END), 6)                                      AS "[c]Agent Commissions",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN DFP.VALORANULACION ELSE 0 END), 6)                                     AS "[c]Cancellations",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN DFP.VALORIVACOMISION ELSE 0 END), 6)                                   AS "[c]VAT Agent Commission",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN DFP.VALORRETENCIONES * (-1) ELSE 0 END), 6)                            AS "[c]Taxes W/H From Commission",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN DFP.VALORCOMISION +
                                                                DFP.VALORANULACION +
                                                                DFP.VALORIVACOMISION -
                                                                DFP.VALORRETENCIONES ELSE 0 END), 6)                                   AS "[z]Total ETU Deductions",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN DFP.VALORVENTA - (DFP.VALORCOMISION +
                                                                                  DFP.VALORANULACION +
                                                                                  DFP.VALORIVACOMISION -
                                                                                  DFP.VALORRETENCIONES) ELSE 0 END), 6)                AS "[zv]ETU Amount due from Agents",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "BP Selling Terminals",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 3 AND PDV.CODREDPDV = 82 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]ETESA",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 3 AND PDV.CODREDPDV = 83 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]AEL",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 3 AND PDV.CODREDPDV = 84 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]QAP",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN MFP.CODPUNTODEVENTA END))                                         AS "[m]Tot. BP Selling Terminals",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "BP Gross Sales",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 AND DFP.CODTIPOPRODUCTO = 8 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Bill Payment",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 AND DFP.CODTIPOPRODUCTO = 9 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Deposits On Line",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN DFP.VALORVENTA ELSE 0 END), 6)                                         AS "[z]Total BP Gross Sales",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "Less",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN DFP.VALORCOMISION ELSE 0 END), 6)                                      AS "[c]Agent Commissions",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN DFP.VALORANULACION ELSE 0 END), 6)                                     AS "[c]Cancellations",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN DFP.VALORIVACOMISION ELSE 0 END), 6)                                   AS "[c]VAT Agent Commission",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN DFP.VALORRETENCIONES * (-1) ELSE 0 END), 6)                            AS "[c]Taxes W/H From Commission",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN DFP.VALORCOMISION +
                                                                DFP.VALORANULACION +
                                                                DFP.VALORIVACOMISION -
                                                                DFP.VALORRETENCIONES ELSE 0 END), 6)                                   AS "[z]Total BP Deductions",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN DFP.VALORVENTA - (DFP.VALORCOMISION +
                                                                                  DFP.VALORANULACION +
                                                                                  DFP.VALORIVACOMISION -
                                                                                  DFP.VALORRETENCIONES) ELSE 0 END), 6)                AS "[zv]BP Amount due from Agents",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "Withdrawals Selling Terminals",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 4 AND PDV.CODREDPDV = 82 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]ETESA",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 4 AND PDV.CODREDPDV = 83 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]AEL",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 4 AND PDV.CODREDPDV = 84 THEN MFP.CODPUNTODEVENTA END))                  AS "[n]QAP",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN MFP.CODPUNTODEVENTA END))                                         AS "[m]Tot. W/draw Selling Term.",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "W/draw Gross Sales",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 AND DFP.CODTIPOPRODUCTO = 10 THEN 0              ELSE 0 END), 6)            AS "[c]Withdrawals",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN 0 ELSE 0 END), 6)                                                      AS "[z]Total W/drawal Gross Sales",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "Less",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN DFP.VALORCOMISION ELSE 0 END), 6)                                      AS "[c]Agent Commissions",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN DFP.VALORANULACION ELSE 0 END), 6)                                     AS "[c]Cancellations",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN DFP.VALORIVACOMISION ELSE 0 END), 6)                                   AS "[c]VAT Agent Commission",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN DFP.VALORRETENCIONES * (-1) ELSE 0 END), 6)                            AS "[c]Taxes W/H From Commission",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN DFP.VALORCOMISION +
                                                                DFP.VALORANULACION +
                                                                DFP.VALORIVACOMISION -
                                                                DFP.VALORRETENCIONES ELSE 0 END), 6)                                   AS "[z]Total W/drawal Deductions",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN 0 -              (DFP.VALORCOMISION +
                                                                                  DFP.VALORANULACION +
                                                                                  DFP.VALORIVACOMISION -
                                                                                  DFP.VALORRETENCIONES) ELSE 0 END), 6)                AS "[zv]W/draw Amount due Agents",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "Avg No. of Selling Terminals",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN MFP.CODPUNTODEVENTA END))                                         AS "[n]Lottery",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN MFP.CODPUNTODEVENTA END))                                         AS "[n]ETU (Electronic Top Ups)",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN MFP.CODPUNTODEVENTA END))                                         AS "[n]BP (Bill Payment)",
             COUNT(DISTINCT(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN MFP.CODPUNTODEVENTA END))                                         AS "[n]Withdrawals",
             COUNT(DISTINCT(MFP.CODPUNTODEVENTA))                                                                                      AS "[m]Total No. of Selling Term.",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "Gross Sales",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND DFP.CODTIPOPRODUCTO = 1 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Lotto Game (Baloto)",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND DFP.CODTIPOPRODUCTO = 2 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Chance Game (Pagatodo)",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND DFP.CODTIPOPRODUCTO = 3 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Traditional Lottery",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 AND DFP.CODTIPOPRODUCTO = 4 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Numbers (Superastro)",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 AND DFP.CODTIPOPRODUCTO = 6 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]E-Voucher",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 AND DFP.CODTIPOPRODUCTO = 7 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]E-Recharge",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 AND DFP.CODTIPOPRODUCTO = 8 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Bill Payment",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 AND DFP.CODTIPOPRODUCTO = 9 THEN DFP.VALORVENTA ELSE 0 END), 6)             AS "[c]Deposits On Line",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 AND DFP.CODTIPOPRODUCTO = 10 THEN 0 ELSE 0 END), 6)                         AS "[c]Withdrawals",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN 0 ELSE DFP.VALORVENTA END), 6)                                         AS "[z]Total Gross Sales",
             '  '                                                                                                                      AS "[space]",
             '  '                                                                                                                      AS "Less",
             ROUND(SUM(DFP.VALORPREMIOPAGO), 6)                                                                                        AS "[c]Prizes Paid By Agents",
             ROUND(SUM(DFP.VALORCOMISIONNOANTICIPO), 6)                                                                                AS "[c]Agent Commissions",
             ROUND(SUM(DFP.VALORANULACION), 6)                                                                                         AS "[c]Cancellations",
             ROUND(SUM(DFP.VALORIVACOMISION), 6)                                                                                       AS "[c]VAT Agent Commision",
             ROUND(SUM(DFP.VALORRETENCIONES * (-1)), 6)                                                                                AS "[c]Taxes W/H From Commission",
             ROUND(SUM(DFP.VALORCOMISIONANTICIPO), 6)                                                                                  AS "[c]Chance Proceeds Col. AEL",
             ROUND(SUM(DFP.VALORPREMIOPAGO +
                       DFP.VALORCOMISIONNOANTICIPO +
                       DFP.VALORANULACION +
                       DFP.VALORCOMISIONANTICIPO +
                       DFP.VALORIVACOMISION -
                       DFP.VALORRETENCIONES), 6)                                                                                       AS "[z]Total Deductions",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN 0 ELSE DFP.VALORVENTA END - (DFP.VALORPREMIOPAGO +
                                                                                             DFP.VALORCOMISIONNOANTICIPO +
                                                                                             DFP.VALORANULACION +
                                                                                             DFP.VALORCOMISIONANTICIPO +
                                                                                             DFP.VALORIVACOMISION -
                                                                                             DFP.VALORRETENCIONES)), 6)                AS "[zv]Amount due from Agents",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(ISNULL(CPV.FACTURACIONGTECH + CPV.FACTURACIONFIDUCIA, 0)) / COUNT(1), 6)                                           AS "[zv]Amount due Prior Week",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(ISNULL(CCH.Depositos, 0)) / COUNT(1), 6)                                                                           AS "[cn]Cash Collected from Agents",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(ISNULL(CCH.Depositos, 0) - ISNULL(CPV.FACTURACIONGTECH + CPV.FACTURACIONFIDUCIA, 0)) / COUNT(1), 6)                   AS "[zv]Amount Underpaid/Overpaid",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(ISNULL(CCH.Depositos, 0) / ISNULL(CPV.FACTURACIONGTECH + CPV.FACTURACIONFIDUCIA, 0)) / COUNT(1), 6)                   AS "[p]Weekly Cash Collection Rate",
             ROUND(SUM(ISNULL(CCH.Depositos, 0) / ISNULL(CPV.FACTURACIONGTECH + CPV.FACTURACIONFIDUCIA, 0)) / COUNT(1), 6)                   AS "[pv]Cummulative WCC Rate",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 1 THEN DFP.INGRESOCORPORATIVO ELSE 0 END), 6)                                 AS "[cn]On Line Sales Revenue",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 2 THEN DFP.INGRESOCORPORATIVO ELSE 0 END), 6)                                 AS "[cn]ETU Revenue",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 3 THEN DFP.INGRESOCORPORATIVO ELSE 0 END), 6)                                 AS "[cn]BP Revenue",
             ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 4 THEN DFP.INGRESOCORPORATIVO ELSE 0 END), 6)                                 AS "[cn]Withdrawals Revenue",
             ROUND(SUM(DFP.INGRESOCORPORATIVO), 6)                                                                                     AS "[zv]Weekly GTECH Revenue",
             '  '                                                                                                                      AS "[space]",
             ROUND(SUM(ISNULL(CPV.INGRESOCORPORATIVO, 0)) / COUNT(1), 6)                                                                  AS "[z]Revenue Prior Week",
             ROUND(SUM((ISNULL(CCH.Depositos, 0) - ISNULL(CPV.FACTURACIONGTECH + CPV.FACTURACIONFIDUCIA, 0)) /
                        ISNULL(CPV.INGRESOCORPORATIVO, 0)) / COUNT(1), 6)                                                                 AS "[p]Weekly Cash Bal. % Revenue",
             ROUND(SUM((ISNULL(CCH.Depositos, 0) - ISNULL(CPV.FACTURACIONGTECH + CPV.FACTURACIONFIDUCIA, 0)) /
                        ISNULL(CPV.INGRESOCORPORATIVO, 0)) / COUNT(1), 6)                                                                 AS "[pv]Cummulative WCB % Revenue"
      FROM WSXML_SFG.CICLOFACTURACIONPDV CFP
      INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFP ON (MFP.CODCICLOFACTURACIONPDV = CFP.ID_CICLOFACTURACIONPDV)
      INNER JOIN WSXML_SFG.PUNTODEVENTA          PDV ON (PDV.ID_PUNTODEVENTA        = MFP.CODPUNTODEVENTA)
      INNER JOIN (SELECT CODMAESTROFACTURACIONPDV, CODTIPOPRODUCTO,
                         SUM(CANTIDADVENTA)                                                    AS CANTIDADVENTA,
                         SUM(VALORVENTA)                                                       AS VALORVENTA,
                         SUM(D.CANTIDADANULACION)                                              AS CANTIDADANULACION,
                         SUM(D.VALORANULACION)                                                 AS VALORANULACION,
                         SUM(D.VALORVENTABRUTA)                                                AS VALORVENTABRUTA,
                         SUM(D.CANTIDADPREMIOPAGO)                                             AS CANTIDADPREMIOPAGO,
                         SUM(D.VALORPREMIOPAGO)                                                AS VALORPREMIOPAGO,
                         SUM(CASE WHEN D.COMISIONANTICIPO = 0 THEN D.VALORCOMISION ELSE 0 END) AS VALORCOMISIONNOANTICIPO,
                         SUM(CASE WHEN D.COMISIONANTICIPO = 1 THEN D.VALORCOMISION ELSE 0 END) AS VALORCOMISIONANTICIPO,
                         SUM(D.VALORCOMISION)                                                  AS VALORCOMISION,
                         SUM(D.IVACOMISION)                                                    AS VALORIVACOMISION,
                         SUM(ISNULL(RET.VALORRETENCION, 0) + ISNULL(UVT.VALORRETENCION, 0))          AS VALORRETENCIONES,
                         SUM(D.NUEVOSALDOENCONTRAGTECH - D.NUEVOSALDOAFAVORGTECH)              AS FACTURACIONGTECH,
                         SUM(D.NUEVOSALDOENCONTRAFIDUCIA - D.NUEVOSALDOAFAVORFIDUCIA)          AS FACTURACIONFIDUCIA,
                         SUM(R.INGRESOCORPORATIVO)                                             AS INGRESOCORPORATIVO
                  FROM WSXML_SFG.DETALLEFACTURACIONPDV D
                  INNER JOIN (SELECT CODDETALLEFACTURACIONPDV, SUM(CASE WHEN RG.CODTIPOREGISTRO = 1 THEN ISNULL(RV.INGRESOCORPORATIVO, 0) WHEN RG.CODTIPOREGISTRO = 2 THEN ISNULL(RV.INGRESOCORPORATIVO, 0) * (-1) ELSE 0 END) AS INGRESOCORPORATIVO
                              FROM WSXML_SFG.REGISTROFACTURACION RG
                              LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE RV ON (RV.CODENTRADAARCHIVOCONTROL = RG.CODENTRADAARCHIVOCONTROL AND RV.CODREGISTROFACTURACION = RG.ID_REGISTROFACTURACION)
                              GROUP BY CODDETALLEFACTURACIONPDV) R ON (R.CODDETALLEFACTURACIONPDV = ID_DETALLEFACTURACIONPDV)
                  LEFT OUTER JOIN (SELECT CODDETALLEFACTURACIONPDV, SUM(VALORRETENCION) AS VALORRETENCION FROM WSXML_SFG.DETALLEFACTURACIONRETENCION
                                   GROUP BY CODDETALLEFACTURACIONPDV) RET ON (RET.CODDETALLEFACTURACIONPDV = ID_DETALLEFACTURACIONPDV)
                  LEFT OUTER JOIN (SELECT CODDETALLEFACTURACIONPDV, SUM(VALORRETENCION) AS VALORRETENCION FROM WSXML_SFG.DETALLEFACTURACIONRETUVT
                                   GROUP BY CODDETALLEFACTURACIONPDV) UVT ON (UVT.CODDETALLEFACTURACIONPDV = ID_DETALLEFACTURACIONPDV)
                  GROUP BY CODMAESTROFACTURACIONPDV, CODTIPOPRODUCTO) DFP ON (DFP.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV)
      LEFT OUTER JOIN (SELECT CP.ID_CICLOFACTURACIONPDV, CP.SECUENCIA, SUM(ISNULL(DP.FACTURACIONGTECH, 0))   AS FACTURACIONGTECH,
                                                                       SUM(ISNULL(DP.FACTURACIONFIDUCIA, 0)) AS FACTURACIONFIDUCIA,
                                                                       SUM(ISNULL(DP.INGRESOCORPORATIVO, 0)) AS INGRESOCORPORATIVO
                       FROM WSXML_SFG.CICLOFACTURACIONPDV CP
                       INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MP ON (MP.CODCICLOFACTURACIONPDV   = CP.ID_CICLOFACTURACIONPDV)
                       LEFT OUTER JOIN (SELECT CODMAESTROFACTURACIONPDV, SUM(NUEVOSALDOENCONTRAGTECH - NUEVOSALDOAFAVORGTECH)     AS FACTURACIONGTECH,
                                                                         SUM(NUEVOSALDOENCONTRAFIDUCIA - NUEVOSALDOAFAVORFIDUCIA) AS FACTURACIONFIDUCIA,
                                                                         SUM(INGRESOCORPORATIVO)                                  AS INGRESOCORPORATIVO
                                        FROM WSXML_SFG.DETALLEFACTURACIONPDV
                                        INNER JOIN (
												SELECT CODDETALLEFACTURACIONPDV, SUM(CASE WHEN RG.CODTIPOREGISTRO = 1 THEN ISNULL(RV.INGRESOCORPORATIVO, 0) WHEN RG.CODTIPOREGISTRO = 2 THEN ISNULL(RV.INGRESOCORPORATIVO, 0) * (-1) ELSE 0 END) AS INGRESOCORPORATIVO
                                                FROM WSXML_SFG.REGISTROFACTURACION RG
											        LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE RV ON (RV.CODENTRADAARCHIVOCONTROL = RG.CODENTRADAARCHIVOCONTROL AND RV.CODREGISTROFACTURACION = RG.ID_REGISTROFACTURACION)
                                                GROUP BY CODDETALLEFACTURACIONPDV
													) T ON (CODDETALLEFACTURACIONPDV = ID_DETALLEFACTURACIONPDV)
                                        GROUP BY CODMAESTROFACTURACIONPDV) DP ON (DP.CODMAESTROFACTURACIONPDV = MP.ID_MAESTROFACTURACIONPDV)
                       /*LEFT OUTER JOIN (SELECT CODMAESTROFACTURACIONPDV, SUM(VALORAPLICADO) AS VALORRECAUDADO
                                        FROM PAGOFACTURACIONPDV GROUP BY CODMAESTROFACTURACIONPDV)    PF ON (PF.CODMAESTROFACTURACIONPDV = MP.ID_MAESTROFACTURACIONPDV)*/
                       WHERE CP.ACTIVE = 1 GROUP BY CP.ID_CICLOFACTURACIONPDV, CP.SECUENCIA) CPV ON (CPV.SECUENCIA = CFP.SECUENCIA - 1)
      LEFT OUTER JOIN (SELECT ID AS CODCICLOFACTURACIONPDV, VALUE AS DEPOSITOS FROM @lstcashcollected) CCH ON (CCH.CODCICLOFACTURACIONPDV = CPV.ID_CICLOFACTURACIONPDV)
      WHERE CFP.ID_CICLOFACTURACIONPDV IN (SELECT IDVALUE FROM @lstcycles)
      GROUP BY CFP.ID_CICLOFACTURACIONPDV, CFP.FECHAEJECUCION, CFP.SECUENCIA ORDER BY CFP.SECUENCIA;
  END;

GO
