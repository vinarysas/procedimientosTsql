USE SFGPRODU;
--  DDL for Package Body SFGARCHIVOREACTIVACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGARCHIVOREACTIVACION */ 

IF OBJECT_ID('WSXML_SFG.SFGARCHIVOREACTIVACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOREACTIVACION_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGARCHIVOREACTIVACION_GetList(
	@p_CADENA NVARCHAR(2000), @p_FECHAINICIO DATETIME,@p_FECHAFIN DATETIME,@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
	  
          select --LPAD(codigogtechpuntodeventa,8,'0') AS PtoVenta
			RIGHT(REPLICATE('0', 8) + codigogtechpuntodeventa, 8) AS PtoVenta
          from WSXML_SFG.reactivacionpdv rpv
                  inner join WSXML_SFG.puntodeventa pv on pv.id_puntodeventa = rpv.codpuntodeventa
          WHERE
          --AND pv.codigogtechpuntodeventa = CASE WHEN p_CODPV = '-1' THEN pv.codigogtechpuntodeventa ELSE p_CODPV END
          rpv.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN rpv.ACTIVE ELSE @p_ACTIVE END
          --AND ipv.fechahoramodificacion >= p_FECHAINICIO
          --AND ipv.fechahoramodificacion <= p_FECHAFIN
	
  END
GO





