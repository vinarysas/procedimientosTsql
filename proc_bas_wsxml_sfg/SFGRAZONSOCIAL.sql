USE SFGPRODU;
--  DDL for Package Body SFGRAZONSOCIAL
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGRAZONSOCIAL */ 

  IF OBJECT_ID('WSXML_SFG.SFGRAZONSOCIAL_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_AddRecord(@p_CODIGOGTECHRAZONSOCIAL NUMERIC(22,0),
                      @p_NOMRAZONSOCIAL         NVARCHAR(2000),
                      @p_IDENTIFICACION         NUMERIC(22,0),
                      @p_DIGITOVERIFICACION     NUMERIC(22,0),
                      @p_NOMBRECONTACTO         NVARCHAR(2000),
                      @p_EMAILCONTACTO          NVARCHAR(2000),
                      @p_TELEFONOCONTACTO       NVARCHAR(2000),
                      @p_DIRECCIONCONTACTO      NVARCHAR(2000),
                      @p_CODCIUDAD              NUMERIC(22,0),
                      @p_CODREGIMEN             NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_RAZONSOCIAL_out     NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    IF @p_CODIGOGTECHRAZONSOCIAL > 0 BEGIN
      INSERT INTO WSXML_SFG.RAZONSOCIAL
        (
         CODIGOGTECHRAZONSOCIAL,
         NOMRAZONSOCIAL,
         IDENTIFICACION,
         DIGITOVERIFICACION,
         NOMBRECONTACTO,
         EMAILCONTACTO,
         TELEFONOCONTACTO,
         DIRECCIONCONTACTO,
         CODCIUDAD,
         CODREGIMEN,
         CODUSUARIOMODIFICACION)
      VALUES
        (
         @p_CODIGOGTECHRAZONSOCIAL,
         @p_NOMRAZONSOCIAL,
         @p_IDENTIFICACION,
         @p_DIGITOVERIFICACION,
         @p_NOMBRECONTACTO,
         @p_EMAILCONTACTO,
         @p_TELEFONOCONTACTO,
         @p_DIRECCIONCONTACTO,
         @p_CODCIUDAD,
         @p_CODREGIMEN,
         @p_CODUSUARIOMODIFICACION);
      SET @p_ID_RAZONSOCIAL_out = SCOPE_IDENTITY();
    END
    ELSE BEGIN
      --SELECT @p_ID_RAZONSOCIAL_out = RAZONSOCIAL_SEQ.NextVal;
      INSERT INTO WSXML_SFG.RAZONSOCIAL
        (ID_RAZONSOCIAL,
         CODIGOGTECHRAZONSOCIAL,
         NOMRAZONSOCIAL,
         IDENTIFICACION,
         DIGITOVERIFICACION,
         NOMBRECONTACTO,
         EMAILCONTACTO,
         TELEFONOCONTACTO,
         DIRECCIONCONTACTO,
         CODCIUDAD,
         CODREGIMEN,
         CODUSUARIOMODIFICACION)
      VALUES
        (@p_ID_RAZONSOCIAL_out,
         @p_ID_RAZONSOCIAL_out * -1,
         @p_NOMRAZONSOCIAL,
         @p_IDENTIFICACION,
         @p_DIGITOVERIFICACION,
         @p_NOMBRECONTACTO,
         @p_EMAILCONTACTO,
         @p_TELEFONOCONTACTO,
         @p_DIRECCIONCONTACTO,
         @p_CODCIUDAD,
         @p_CODREGIMEN,
         @p_CODUSUARIOMODIFICACION);
		
		set @p_ID_RAZONSOCIAL_out = SCOPE_IDENTITY() ;

    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGRAZONSOCIAL_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_UpdateRecord(@pk_ID_RAZONSOCIAL        NUMERIC(22,0),
                         @p_CODIGOGTECHRAZONSOCIAL NUMERIC(22,0),
                         @p_NOMRAZONSOCIAL         NVARCHAR(2000),
                         @p_IDENTIFICACION         NUMERIC(22,0),
                         @p_DIGITOVERIFICACION     NUMERIC(22,0),
                         @p_NOMBRECONTACTO         NVARCHAR(2000),
                         @p_EMAILCONTACTO          NVARCHAR(2000),
                         @p_TELEFONOCONTACTO       NVARCHAR(2000),
                         @p_DIRECCIONCONTACTO      NVARCHAR(2000),
                         @p_CODCIUDAD              NUMERIC(22,0),
                         @p_CODREGIMEN             NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    IF @p_CODIGOGTECHRAZONSOCIAL > 0 BEGIN
      UPDATE WSXML_SFG.RAZONSOCIAL
         SET NOMRAZONSOCIAL         = @p_NOMRAZONSOCIAL,
             IDENTIFICACION         = @p_IDENTIFICACION,
             DIGITOVERIFICACION     = @p_DIGITOVERIFICACION,
             NOMBRECONTACTO         = @p_NOMBRECONTACTO,
             EMAILCONTACTO          = @p_EMAILCONTACTO,
             TELEFONOCONTACTO       = @p_TELEFONOCONTACTO,
             DIRECCIONCONTACTO      = @p_DIRECCIONCONTACTO,
             CODCIUDAD              = @p_CODCIUDAD,
             CODREGIMEN             = @p_CODREGIMEN,
             CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION  = GETDATE()
       WHERE ID_RAZONSOCIAL = @pk_ID_RAZONSOCIAL;
    END
    ELSE BEGIN
      -- Do not update identification
      UPDATE WSXML_SFG.RAZONSOCIAL
         SET NOMRAZONSOCIAL         = @p_NOMRAZONSOCIAL,
             NOMBRECONTACTO         = @p_NOMBRECONTACTO,
             EMAILCONTACTO          = @p_EMAILCONTACTO,
             TELEFONOCONTACTO       = @p_TELEFONOCONTACTO,
             DIRECCIONCONTACTO      = @p_DIRECCIONCONTACTO,
             CODCIUDAD              = @p_CODCIUDAD,
             CODREGIMEN             = @p_CODREGIMEN,
             CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION  = GETDATE()
       WHERE ID_RAZONSOCIAL = @pk_ID_RAZONSOCIAL;
    END 
    
    UPDATE WSXML_SFG.PUNTODEVENTA SET IDENTIFICACION =@p_IDENTIFICACION ,DIGITOVERIFICACION=@p_DIGITOVERIFICACION , CODREGIMEN =@p_CODREGIMEN
    WHERE CODRAZONSOCIAL= @pk_ID_RAZONSOCIAL;
    
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGRAZONSOCIAL_AddUpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_AddUpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_AddUpdateRecord(@p_CODIGOGTECHRAZONSOCIAL NUMERIC(22,0),
                            @p_NOMRAZONSOCIAL         NVARCHAR(2000),
                            @p_IDENTIFICACION         NUMERIC(22,0),
                            @p_DIGITOVERIFICACION     NUMERIC(22,0),
                            @p_NOMBRECONTACTO         NVARCHAR(2000),
                            @p_EMAILCONTACTO          NVARCHAR(2000),
                            @p_TELEFONOCONTACTO       NVARCHAR(2000),
                            @p_DIRECCIONCONTACTO      NVARCHAR(2000),
                            @p_CODCIUDAD              NUMERIC(22,0),
                            @p_CODREGIMEN             NUMERIC(22,0),
                            @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                            @p_ID_RAZONSOCIAL_out     NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    IF @p_CODIGOGTECHRAZONSOCIAL > 0 BEGIN
      SELECT @p_ID_RAZONSOCIAL_out = ID_RAZONSOCIAL
        FROM WSXML_SFG.RAZONSOCIAL
       WHERE CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
      UPDATE WSXML_SFG.RAZONSOCIAL
         SET NOMRAZONSOCIAL         = @p_NOMRAZONSOCIAL,
             IDENTIFICACION         = @p_IDENTIFICACION,
             DIGITOVERIFICACION     = @p_DIGITOVERIFICACION,
             NOMBRECONTACTO         = @p_NOMBRECONTACTO,
             EMAILCONTACTO          = @p_EMAILCONTACTO,
             TELEFONOCONTACTO       = @p_TELEFONOCONTACTO,
             DIRECCIONCONTACTO      = @p_DIRECCIONCONTACTO,
             CODCIUDAD              = @p_CODCIUDAD,
             CODREGIMEN             = @p_CODREGIMEN,
             CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION  = GETDATE()
       WHERE ID_RAZONSOCIAL = @p_ID_RAZONSOCIAL_out;
    END
    ELSE BEGIN
      DECLARE @keyid NUMERIC(22,0);
		  BEGIN
			--SELECT @keyid = RAZONSOCIAL_SEQ.NextVal;
			-- Insert with negative code so it can be overwritten
			INSERT INTO WSXML_SFG.RAZONSOCIAL
			  (--ID_RAZONSOCIAL,
			   CODIGOGTECHRAZONSOCIAL,
			   NOMRAZONSOCIAL,
			   IDENTIFICACION,
			   DIGITOVERIFICACION,
			   NOMBRECONTACTO,
			   EMAILCONTACTO,
			   TELEFONOCONTACTO,
			   DIRECCIONCONTACTO,
			   CODCIUDAD,
			   CODREGIMEN,
			   CODUSUARIOMODIFICACION)
			VALUES
			  (--@keyid,
			   @keyid * (-1),
			   @p_NOMRAZONSOCIAL,
			   @p_IDENTIFICACION,
			   @p_DIGITOVERIFICACION,
			   @p_NOMBRECONTACTO,
			   @p_EMAILCONTACTO,
			   @p_TELEFONOCONTACTO,
			   @p_DIRECCIONCONTACTO,
			   @p_CODCIUDAD,
			   @p_CODREGIMEN,
			   @p_CODUSUARIOMODIFICACION);
			SET @p_ID_RAZONSOCIAL_out = SCOPE_IDENTITY();
		  END;
    END 
	
	IF @@ROWCOUNT = 0 BEGIN
        --DECLARE @keyid NUMERIC(22,0);
		 
			--SELECT @keyid = RAZONSOCIAL_SEQ.NextVal;
			-- Insert with negative code so it can be overwritten
			INSERT INTO WSXML_SFG.RAZONSOCIAL
			  (--ID_RAZONSOCIAL,
			   CODIGOGTECHRAZONSOCIAL,
			   NOMRAZONSOCIAL,
			   IDENTIFICACION,
			   DIGITOVERIFICACION,
			   NOMBRECONTACTO,
			   EMAILCONTACTO,
			   TELEFONOCONTACTO,
			   DIRECCIONCONTACTO,
			   CODCIUDAD,
			   CODREGIMEN,
			   CODUSUARIOMODIFICACION)
			VALUES
			  (--@keyid,
			   @keyid * (-1),
			   @p_NOMRAZONSOCIAL,
			   @p_IDENTIFICACION,
			   @p_DIGITOVERIFICACION,
			   @p_NOMBRECONTACTO,
			   @p_EMAILCONTACTO,
			   @p_TELEFONOCONTACTO,
			   @p_DIRECCIONCONTACTO,
			   @p_CODCIUDAD,
			   @p_CODREGIMEN,
			   @p_CODUSUARIOMODIFICACION);
			SET @p_ID_RAZONSOCIAL_out = SCOPE_IDENTITY();
		 
	  END 
end
GO

  IF OBJECT_ID('WSXML_SFG.SFGRAZONSOCIAL_SetContrato', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_SetContrato;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_SetContrato(
						@p_CODRAZONSOCIAL             NUMERIC(22,0),
                        @p_CODSERVICIO                NUMERIC(22,0),
                        @p_CODCOMPANIA                NUMERIC(22,0),
                        @p_CODTIPOCONTRATOPDV         NUMERIC(22,0),
                        @p_NUMEROCONTRATO             NVARCHAR(2000),
                        @p_CODCANALNEGOCIO            NUMERIC(22,0),                        
                        @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                        @p_ID_RAZONSOCIALCONTRATO_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @p_ID_RAZONSOCIALCONTRATO_out = ID_RAZONSOCIALCONTRATO
      FROM WSXML_SFG.RAZONSOCIALCONTRATO
     WHERE CODRAZONSOCIAL = @p_CODRAZONSOCIAL
       AND CODSERVICIO = @p_CODSERVICIO
       AND CODCANALNEGOCIO=@p_CODCANALNEGOCIO;
    UPDATE WSXML_SFG.RAZONSOCIALCONTRATO
       SET CODCOMPANIA            = @p_CODCOMPANIA,
           CODTIPOCONTRATOPDV     = @p_CODTIPOCONTRATOPDV,
           NUMEROCONTRATO         = @p_NUMEROCONTRATO,
           CODCANALNEGOCIO        = @p_CODCANALNEGOCIO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE()
     WHERE ID_RAZONSOCIALCONTRATO = @p_ID_RAZONSOCIALCONTRATO_out;
	  IF @@ROWCOUNT = 0 BEGIN
      INSERT INTO WSXML_SFG.RAZONSOCIALCONTRATO
        (
         CODRAZONSOCIAL,
         CODSERVICIO,
         CODCOMPANIA,
         CODTIPOCONTRATOPDV,
         NUMEROCONTRATO,
         CODUSUARIOMODIFICACION,
         CODCANALNEGOCIO)
      VALUES
        (
         @p_CODRAZONSOCIAL,
         @p_CODSERVICIO,
         @p_CODCOMPANIA,
         @p_CODTIPOCONTRATOPDV,
         @p_NUMEROCONTRATO,
         @p_CODUSUARIOMODIFICACION,
         @p_CODCANALNEGOCIO);
      SET @p_ID_RAZONSOCIALCONTRATO_out = SCOPE_IDENTITY();
	  END
  END;
GO

  --Analiza el tipo de persona tributaria que debe tener un nit
  --El nit debe estar sin digito de verificacion
  IF OBJECT_ID('WSXML_SFG.SFGRAZONSOCIAL_GetTipoPersonaJuridica', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_GetTipoPersonaJuridica;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_GetTipoPersonaJuridica(@p_NIT                NVARCHAR(2000),
                                   @p_CODTIPOPERSONATRIB NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @LENNIT INT;
   
  SET NOCOUNT ON;
    SET @LENNIT = LEN(RTRIM(LTRIM(@p_NIT)));
    IF @LENNIT = 9 BEGIN
      IF SUBSTRING(@p_NIT, 1, 1) IN ('8', '9') BEGIN
        SET @p_CODTIPOPERSONATRIB = 2; --Juridica
      END
      ELSE BEGIN
        SET @p_CODTIPOPERSONATRIB = 1; --Natural
      END 
    END
    ELSE BEGIN
      SET @p_CODTIPOPERSONATRIB = 1; --Natural
    END 

  END;
GO






  IF OBJECT_ID('WSXML_SFG.SFGRAZONSOCIAL_RazonSocialPorNit', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_RazonSocialPorNit;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRAZONSOCIAL_RazonSocialPorNit(@P_NIT NVARCHAR(2000)) AS
 BEGIN
    DECLARE @V_REGISTROS      NUMERIC(22,0);
    DECLARE @V_ID_RAZONSOCIAL NUMERIC(22,0);
   
  SET NOCOUNT ON;

    SET @V_REGISTROS      = 0;
    SET @V_ID_RAZONSOCIAL = 0;
    
    IF CHARINDEX('-', @P_NIT)>0 BEGIN--Si tiene digito de verificacion
        SELECT @V_REGISTROS = COUNT(*)
          FROM WSXML_SFG.RAZONSOCIAL
         WHERE ISNULL(CONVERT(VARCHAR,RAZONSOCIAL.IDENTIFICACION), '') + '-' +
               ISNULL(CONVERT(VARCHAR,RAZONSOCIAL.DIGITOVERIFICACION), '') = @P_NIT AND RAZONSOCIAL.ID_RAZONSOCIAL IN (SELECT CODRAZONSOCIAL FROM WSXML_SFG.PUNTODEVENTA);
    END
    ELSE BEGIN--Si no tiene digito de verificacion 
           SELECT @V_REGISTROS = COUNT(*)
          FROM WSXML_SFG.RAZONSOCIAL
         WHERE RAZONSOCIAL.IDENTIFICACION  = @P_NIT AND RAZONSOCIAL.ID_RAZONSOCIAL IN (SELECT CODRAZONSOCIAL FROM WSXML_SFG.PUNTODEVENTA);    
    END          

    IF @V_REGISTROS = 0 BEGIN
      RAISERROR('-20054 El Nit ingresado no corresponde a una Raz?n Social', 16, 1);
    END
    ELSE BEGIN

      --- Toma la Raz?n Social con mayor n?mero de puntos de  venta
       IF CHARINDEX('-', @P_NIT)>0 BEGIN--Si tiene digito de verificacion
           SELECT @V_ID_RAZONSOCIAL = ID_RAZONSOCIAL
            FROM (SELECT COUNT(*) AS COUNT_, PV1.CODRAZONSOCIAL AS ID_RAZONSOCIAL
                    FROM WSXML_SFG.PUNTODEVENTA PV1
                   WHERE PV1.CODRAZONSOCIAL IN
                         (
							SELECT RZ1.ID_RAZONSOCIAL
                            FROM WSXML_SFG.RAZONSOCIAL RZ1
							WHERE ISNULL(CONVERT(VARCHAR,RZ1.IDENTIFICACION), '') + '-' + ISNULL(CONVERT(VARCHAR,RZ1.DIGITOVERIFICACION), '') = @P_NIT
						  )
                   GROUP BY PV1.CODRAZONSOCIAL
                  HAVING COUNT(*) > 0
                   --ORDER BY 1 DESC
				   ) s
          
       END
       ELSE BEGIN 
            SELECT @V_ID_RAZONSOCIAL = ID_RAZONSOCIAL
            FROM (SELECT COUNT(*) AS COUNT_, PV1.CODRAZONSOCIAL AS ID_RAZONSOCIAL
                    FROM WSXML_SFG.PUNTODEVENTA PV1
                   WHERE PV1.CODRAZONSOCIAL IN
                         (SELECT RZ1.ID_RAZONSOCIAL
                            FROM WSXML_SFG.RAZONSOCIAL RZ1
                           WHERE RZ1.IDENTIFICACION = @P_NIT)
                   GROUP BY PV1.CODRAZONSOCIAL
                  HAVING COUNT(*) > 0
                   --ORDER BY 1 DESC
				   ) s
          
       END 

        SELECT ISNULL(CONVERT(VARCHAR,RZ.IDENTIFICACION), '') + '-' +
                                 ISNULL(CONVERT(VARCHAR,RZ.DIGITOVERIFICACION), '')                  AS NIT,
               RZ.NOMRAZONSOCIAL      AS "RAZON SOCIAL",
               TPC.NOMTIPOCONTRATOPDV AS "TIPO CONTRATO"
          FROM WSXML_SFG.RAZONSOCIAL RZ
         INNER JOIN WSXML_SFG.RAZONSOCIALCONTRATO RZC
            ON RZC.CODRAZONSOCIAL = RZ.ID_RAZONSOCIAL
         INNER JOIN WSXML_SFG.TIPOCONTRATOPDV TPC
            ON RZC.CODTIPOCONTRATOPDV = TPC.ID_TIPOCONTRATOPDV
         WHERE RZ.ID_RAZONSOCIAL = @V_ID_RAZONSOCIAL
         GROUP BY ISNULL(CONVERT(VARCHAR,RZ.IDENTIFICACION), '') + '-' +
                                 ISNULL(CONVERT(VARCHAR,RZ.DIGITOVERIFICACION), '')        , RZ.NOMRAZONSOCIAL, TPC.NOMTIPOCONTRATOPDV;

    END 

  END;
GO