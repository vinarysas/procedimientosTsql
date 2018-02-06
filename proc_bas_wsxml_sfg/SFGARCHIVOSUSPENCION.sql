USE SFGPRODU;
--  DDL for Package Body SFGARCHIVOSUSPENCION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGARCHIVOSUSPENCION */ 


 IF OBJECT_ID('WSXML_SFG.SFGARCHIVOSUSPENCION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOSUSPENCION_GetList;
GO
CREATE   PROCEDURE WSXML_SFG.SFGARCHIVOSUSPENCION_GetList(@p_CADENA NVARCHAR(2000), @p_FECHAINICIO DATETIME,@p_FECHAFIN DATETIME,@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
	  
           select
              --LPAD(codigogtechpuntodeventa,6,'0') AS PtoVenta
			  RIGHT(REPLICATE('0', 6) + codigogtechpuntodeventa, 6) AS PtoVenta
          from WSXML_SFG.suspensionpdv SP
            inner join WSXML_SFG.puntodeventa PV ON PV.id_puntodeventa = SP.CODPUNTODEVENTA
            LEFT JOIN  WSXML_SFG.suspensionpdvomision SPO ON SP.id_suspensionpdv = SPO.codsuspensionpdv
          WHERE SPO.active <> 1 OR SPO.active IS NULL
          --AND pv.codigogtechpuntodeventa = CASE WHEN p_CODPV = '-1' THEN pv.codigogtechpuntodeventa ELSE p_CODPV END
          AND SP.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN SP.ACTIVE ELSE @p_ACTIVE END
          --AND SP.fechahoramodificacion >= p_FECHAINICIO
          --AND SP.fechahoramodificacion <= p_FECHAFIN
          ;
	
END

