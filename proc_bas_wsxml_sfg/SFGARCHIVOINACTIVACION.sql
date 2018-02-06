USE SFGPRODU;
--  DDL for Package Body SFGARCHIVOINACTIVACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGARCHIVOINACTIVACION */ 

IF OBJECT_ID('WSXML_SFG.SFGARCHIVOINACTIVACION_GetListold', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOINACTIVACION_GetListold;
GO
CREATE   PROCEDURE WSXML_SFG.SFGARCHIVOINACTIVACION_GetListold(@p_CADENA NVARCHAR(2000), @p_FECHAINICIO DATETIME,@p_FECHAFIN DATETIME,@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
		
          select --LPAD(codigogtechpuntodeventa,6,'0') AS PtoVenta
			RIGHT(REPLICATE('0', 6) + codigogtechpuntodeventa, 6) AS PtoVenta
          from WSXML_SFG.inactivacionpdv ipv
                  inner join WSXML_SFG.puntodeventa pv on pv.id_puntodeventa = ipv.codpuntodeventa
                  left join WSXML_SFG.inactivacionpdvomision ipvo on ipv.id_inactivacionpdv = ipvo.codinactivacionpdv
          WHERE ipvo.active <> 1 OR ipvo.active IS NULL
          --AND pv.codigogtechpuntodeventa = CASE WHEN p_CODPV = '-1' THEN pv.codigogtechpuntodeventa ELSE p_CODPV END
          AND ipv.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ipv.ACTIVE ELSE @p_ACTIVE END
          AND ipv.fechahoramodificacion >= @p_FECHAINICIO
          AND ipv.fechahoramodificacion <= @p_FECHAFIN;
		  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGARCHIVOINACTIVACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOINACTIVACION_GetList;
GO 
CREATE PROCEDURE WSXML_SFG.SFGARCHIVOINACTIVACION_GetList(@p_LINEANEGOCIO NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
		
          select --LPAD(codigogtechpuntodeventa,8,'0') AS PtoVenta
			RIGHT(REPLICATE('0', 8) + codigogtechpuntodeventa, 8) AS PtoVenta
          from WSXML_SFG.inactivacionpdv ipv
                  inner join WSXML_SFG.puntodeventa pv on pv.id_puntodeventa = ipv.codpuntodeventa
                  left join WSXML_SFG.inactivacionpdvomision ipvo on ipv.id_inactivacionpdv = ipvo.codinactivacionpdv
          WHERE ipvo.active <> 1 OR ipvo.active IS NULL and ipv.codlineadenegocio=@p_LINEANEGOCIO;
		
  END;

