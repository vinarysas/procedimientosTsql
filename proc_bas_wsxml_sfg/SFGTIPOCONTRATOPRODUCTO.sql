USE SFGPRODU;
--  DDL for Package Body SFGTIPOCONTRATOPRODUCTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPOCONTRATOPRODUCTO */ 

  IF OBJECT_ID('WSXML_SFG.SFGTIPOCONTRATOPRODUCTO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOCONTRATOPRODUCTO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOCONTRATOPRODUCTO_GetList AS
  BEGIN
  SET NOCOUNT ON;
   
      SELECT ID_TIPOCONTRATOPRODUCTO, NOMTIPOCONTRATOPRODUCTO, ORDEN, DESCRIPCION FROM WSXML_SFG.TIPOCONTRATOPRODUCTO;
	  
  END;
GO






