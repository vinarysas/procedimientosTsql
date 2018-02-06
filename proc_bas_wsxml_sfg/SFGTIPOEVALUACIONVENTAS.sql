USE SFGPRODU;
--  DDL for Package Body SFGTIPOEVALUACIONVENTAS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPOEVALUACIONVENTAS */ 


--Get List of Records Active or Inactive in the table COMISIONRANGOTIEMPO table.
  IF OBJECT_ID('WSXML_SFG.SFGTIPOEVALUACIONVENTAS_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOEVALUACIONVENTAS_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOEVALUACIONVENTAS_GetList AS
    BEGIN
    SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
    SELECT
     ID_TIPOEVALUACIONVENTAS,
     DESCRIPCION
    FROM WSXML_SFG.TIPOEVALUACIONVENTAS
    WHERE ACTIVE = 1
    ORDER BY DESCRIPCION;
	
    END;

