USE SFGPRODU;
--  DDL for Package Body SFGTIPOCONTRATOPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPOCONTRATOPDV */ 

  IF OBJECT_ID('WSXML_SFG.SFGTIPOCONTRATOPDV_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOCONTRATOPDV_CONSTANT;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOCONTRATOPDV_CONSTANT(
  @p_ADMINISTRACION SMALLINT OUT,
  @p_ARRIENDO       SMALLINT OUT,
  @p_COLABORACION   SMALLINT OUT,
  @p_CONCESION      SMALLINT OUT
) AS
  BEGIN
  SET NOCOUNT ON;
   
  SET @p_ADMINISTRACION 	= 1;
  SET @p_ARRIENDO       	= 2;
  SET @p_COLABORACION    = 3;
  SET @p_CONCESION      	= 5;
  
  END;
GO

 
IF OBJECT_ID('WSXML_SFG.SFGTIPOCONTRATOPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOCONTRATOPDV_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOCONTRATOPDV_GetList AS
  BEGIN
  SET NOCOUNT ON;
   
      SELECT ID_TIPOCONTRATOPDV, NOMTIPOCONTRATOPDV FROM WSXML_SFG.TIPOCONTRATOPDV;
  
  END;
GO
