USE SFGPRODU;
--  DDL for Package Body SFGCUENTA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCUENTA */ 

  IF OBJECT_ID('WSXML_SFG.SFGCUENTA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCUENTA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCUENTA_AddRecord(@p_NOMCUENTA              NVARCHAR(2000),
                      @p_CODIGOBANCO            NVARCHAR(2000),
                      @p_NUMEROCUENTA           NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_CUENTA_out          NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.CUENTA (
                          NOMCUENTA,
                          CODIGOBANCO,
                          NUMEROCUENTA,
                          CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMCUENTA,
            @p_CODIGOBANCO,
            @p_NUMEROCUENTA,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_CUENTA_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCUENTA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCUENTA_UpdateRecord;
GO


  CREATE PROCEDURE WSXML_SFG.SFGCUENTA_UpdateRecord(@pk_ID_CUENTA             NUMERIC(22,0),
                         @p_NOMCUENTA              NVARCHAR(2000),
                         @p_CODIGOBANCO            NVARCHAR(2000),
                         @p_NUMEROCUENTA           NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    UPDATE WSXML_SFG.CUENTA
       SET NOMCUENTA              = @p_NOMCUENTA,
           CODIGOBANCO            = @p_CODIGOBANCO,
           NUMEROCUENTA           = @p_NUMEROCUENTA,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
      WHERE ID_CUENTA = @pk_ID_CUENTA;

	  DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
      IF @rowcount = 0 BEGIN
        RAISERROR('-20054 The record no longer exists.', 16, 1);
      END 

      IF @rowcount > 1 BEGIN
        RAISERROR('-20053 Duplicate object instances.', 16, 1);
      END 

  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGCUENTA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCUENTA_GetRecord;
GO


  CREATE PROCEDURE WSXML_SFG.SFGCUENTA_GetRecord(@pk_ID_CUENTA NUMERIC(22,0)
                                                     ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
   
      SELECT @l_count = count(*)
      FROM WSXML_SFG.CUENTA
      WHERE ID_CUENTA = @pk_ID_CUENTA;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be returned along the row data to support concurrency.
	
      SELECT ID_CUENTA,
             NOMCUENTA,
             CODIGOBANCO,
             NUMEROCUENTA,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.CUENTA
      WHERE ID_CUENTA = @pk_ID_CUENTA;
	  
  END;
GO 


  IF OBJECT_ID('WSXML_SFG.SFGCUENTA_GetList', 'P') IS NOT NULL
    DROP PROCEDURE WSXML_SFG.SFGCUENTA_GetList;
  GO

  -- Used by payment loader. Therefore, includes file information
  CREATE PROCEDURE WSXML_SFG.SFGCUENTA_GetList(@p_ACTIVE NUMERIC(22,0)
                                                   ) AS
  BEGIN
  SET NOCOUNT ON;
   
      SELECT CNT.ID_CUENTA,
             CNT.NOMCUENTA,
             CNT.CODIGOBANCO,
             CNT.NUMEROCUENTA,
             CNT.CODTIPOCUENTA,
             CNT.CODLINEADENEGOCIO,
             LDN.NOMLINEADENEGOCIO,
             CNT.FIDUCIA,
             ISNULL(CNF.CABECERA, 0)                   AS CABECERA,
             ISNULL(CNF.CABFECHADIAPOSICION, 0)        AS CABFECHADIAPOSICION,
             ISNULL(CNF.CABFECHADIATAMANO, 0)          AS CABFECHADIATAMANO,
             ISNULL(CNF.CABFECHAMESPOSICION, 0)        AS CABFECHAMESPOSICION,
             ISNULL(CNF.CABFECHAMESTAMANO, 0)          AS CABFECHAMESTAMANO,
             ISNULL(CNF.CABFECHAANOPOSICION, 0)        AS CABFECHAANOPOSICION,
             ISNULL(CNF.CABFECHAANOTAMANO, 0)          AS CABFECHAANOTAMANO,
             ISNULL(CNF.CABVALORCONTROLPOSICION, 0)    AS CABVALORCONTROLPOSICION,
             ISNULL(CNF.CABVALORCONTROLTAMANO, 0)      AS CABVALORCONTROLTAMANO,
             ISNULL(CNF.CABREGISTROSPOSICION, 0)       AS CABREGISTROSPOSICION,
             ISNULL(CNF.CABREGISTROSTAMANO, 0)         AS CABREGISTROSTAMANO,
             ISNULL(CNF.FECHADIAPOSICION, 0)           AS FECHADIAPOSICION,
             ISNULL(CNF.FECHADIATAMANO, 0)             AS FECHADIATAMANO,
             ISNULL(CNF.FECHAMESPOSICION, 0)           AS FECHAMESPOSICION,
             ISNULL(CNF.FECHAMESTAMANO, 0)             AS FECHAMESTAMANO,
             ISNULL(CNF.FECHAANOPOSICION, 0)           AS FECHAANOPOSICION,
             ISNULL(CNF.FECHAANOTAMANO, 0)             AS FECHAANOTAMANO,
             ISNULL(CNF.VALORTRANSACCIONPOSICION, 0)   AS VALORTRANSACCIONPOSICION,
             ISNULL(CNF.VALORTRANSACCIONTAMANO, 0)     AS VALORTRANSACCIONTAMANO,
             ISNULL(CNF.VALORTRANSACCIONTAMANODEC, 0)  AS VALORTRANSACCIONTAMANODEC,
             ISNULL(CNF.REFERENCIAPOSICION, 0)         AS REFERENCIAPOSICION,
             ISNULL(CNF.REFERENCIATAMANO, 0)           AS REFERENCIATAMANO,
             ISNULL(CNF.REFERENCIATAMANOMOVIMIENTO, 0) AS REFERENCIATAMANOMOVIMIENTO,
             ISNULL(CNF.PREFIJOARCHIVO, '')            AS PREFIJOARCHIVO,
             ISNULL(CNF.ARCHIVOACUMULADO, 0)           AS ARCHIVOACUMULADO,
             ISNULL(CNF.CODPERIODICIDADPAGO, 0)        AS CODPERIODICIDADPAGO,
             CNT.CODUSUARIOMODIFICACION,
             CNT.FECHAHORAMODIFICACION,
             CNT.ACTIVE
      FROM WSXML_SFG.CUENTA CNT
      INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN ON (CNT.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO)
      LEFT OUTER JOIN WSXML_SFG.CUENTAARCHIVOCONFIG CNF ON (CNF.CODCUENTA = CNT.ID_CUENTA)
      WHERE CNT.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN CNT.ACTIVE ELSE @p_ACTIVE END;
	  
  END;
GO 


  IF OBJECT_ID('WSXML_SFG.SFGCUENTA_GetRecordByNumero', 'P') IS NOT NULL
    DROP PROCEDURE WSXML_SFG.SFGCUENTA_GetRecordByNumero;
  GO


  CREATE PROCEDURE WSXML_SFG.SFGCUENTA_GetRecordByNumero(@p_ACTIVE NUMERIC(22,0), 
                                                            @p_NUMEROCUENTA NVARCHAR(2000)
															 ) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT ID_CUENTA,
             NOMCUENTA,
             CODIGOBANCO,
             NUMEROCUENTA,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.CUENTA
      WHERE NUMEROCUENTA = @p_NUMEROCUENTA
        AND ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
		
  END;
GO






