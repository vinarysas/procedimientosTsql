USE SFGPRODU;
--  DDL for Package Body SFGENTRADAARCHIVOCONTROL
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGENTRADAARCHIVOCONTROL */ 

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CONSTANT;
GO

CREATE PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CONSTANT(
	@p_SERVICIOSCOMERCIALES TINYINT OUT,
	@p_JUEGOS TINYINT OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    
    -- Return the number output parameter
	SET @p_SERVICIOSCOMERCIALES = 1;
	SET @p_JUEGOS = 2;

END;
GO
  
IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_AddRecord(@p_TIPOARCHIVO                  NUMERIC(22,0),
                      @p_FECHAARCHIVO                 DATETIME,
                      @p_VALORTRANSACCIONES           FLOAT,
                      @p_NUMEROTRANSACCIONES          NUMERIC(22,0),
                      @p_ID_ENTRADAARCHIVOCONTROL_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cEXISTING NUMERIC(22,0) = 0;
    
   SET NOCOUNT ON;
  --Traza error  
/* 
  EXECUTE IMMEDIATE 'alter session set events ''8103 trace name errorstack level 3'''; 
  EXECUTE IMMEDIATE 'alter session set events ''10236 trace name context forever, level 1'''; 
  EXECUTE IMMEDIATE 'alter session set max_dump_file_size=''UNLIMITED'''; 
  EXECUTE IMMEDIATE 'alter session set db_file_multiblock_read_count=1'; 
  EXECUTE IMMEDIATE  'alter session set tracefile_identifier=''ORA8103'''; 
 */
  
    SELECT @cEXISTING = COUNT(1) FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
     WHERE CONVERT(DATETIME, CONVERT(DATE,FECHAARCHIVO)) = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO))
       AND TIPOARCHIVO = @p_TIPOARCHIVO
       AND REVERSADO = 0;

    IF @cEXISTING = 1 BEGIN
      RAISERROR('-20001 Ya se cargo el archivo de este dia', 16, 1);
    END 

    INSERT INTO WSXML_SFG.ENTRADAARCHIVOCONTROL (
                                       TIPOARCHIVO,
                                       FECHAARCHIVO,
                                       VALORTRANSACCIONES,
                                       NUMEROTRANSACCIONES,
                                       CODUSUARIOMODIFICACION)
    VALUES (
            @p_TIPOARCHIVO,
            @p_FECHAARCHIVO,
            @p_VALORTRANSACCIONES,
            @p_NUMEROTRANSACCIONES,
            1);
    SET @p_ID_ENTRADAARCHIVOCONTROL_out = SCOPE_IDENTITY();

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_SearchAnnulment', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_SearchAnnulment;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_SearchAnnulment(@p_TIPOARCHIVO                  NUMERIC(22,0),
                            @p_FECHAARCHIVO                 DATETIME,
                            @p_ID_ENTRADAARCHIVOCONTROL_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cEXISTING NUMERIC(22,0) = 0;
   
  SET NOCOUNT ON;
    SELECT @cEXISTING = COUNT(1) 
	FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
    WHERE CONVERT(DATETIME, CONVERT(DATE,FECHAARCHIVO)) = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO))
		AND TIPOARCHIVO = @p_TIPOARCHIVO AND REVERSADO = 0;
    IF @cEXISTING = 1 BEGIN
        DECLARE @cCODENTRADAARCHIVOCONTROL NUMERIC(22,0);
        DECLARE @cANULACIONCARGADA         NUMERIC(22,0);
        DECLARE @cARCHIVOFACTURADO         NUMERIC(22,0);
		
		BEGIN
			SELECT @cCODENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL, @cANULACIONCARGADA = ANULACIONCARGADA, @cARCHIVOFACTURADO = FACTURADO
			FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
			WHERE CONVERT(DATETIME, CONVERT(DATE,FECHAARCHIVO)) = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO))
			  AND TIPOARCHIVO = @p_TIPOARCHIVO AND REVERSADO = 0;

			IF @cANULACIONCARGADA = 1 BEGIN
			  RAISERROR('-20054 Ya se cargaron las anulaciones para el archivo', 16, 1);
			--ELSIF cARCHIVOFACTURADO = 1 THEN
			  --RAISE_APPLICATION_ERROR(-20054, 'Este archivo ya fue facturado. No se pueden cargar anulaciones');
			END
			ELSE BEGIN
			  UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL SET ANULACIONCARGADA = 1 WHERE ID_ENTRADAARCHIVOCONTROL = @cCODENTRADAARCHIVOCONTROL;
			  SET @p_ID_ENTRADAARCHIVOCONTROL_out = @cCODENTRADAARCHIVOCONTROL;
			END 
		END;

    END
    ELSE BEGIN
      RAISERROR('-20054 No se ha cargado el archivo de ventas para este dia', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_ReverseAnnulment', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_ReverseAnnulment;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_ReverseAnnulment(@p_TIPOARCHIVO                  NUMERIC(22,0),
                             @p_FECHAARCHIVO                 DATETIME,
                             @p_ID_ENTRADAARCHIVOCONTROL_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCODENTRADAARCHIVOCONTROL NUMERIC(22,0) = 0;
   
  SET NOCOUNT ON;
    SELECT @cCODENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
    WHERE CONVERT(DATETIME, CONVERT(DATE,FECHAARCHIVO)) = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO))
      AND TIPOARCHIVO = @p_TIPOARCHIVO AND REVERSADO = 0;

    UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL SET ANULACIONCARGADA = 0 WHERE ID_ENTRADAARCHIVOCONTROL = @cCODENTRADAARCHIVOCONTROL;
    SET @p_ID_ENTRADAARCHIVOCONTROL_out = @cCODENTRADAARCHIVOCONTROL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetAnnulmentOrphans', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetAnnulmentOrphans;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetAnnulmentOrphans(
	@p_TIPOARCHIVO  NUMERIC(22,0),
@p_FECHAARCHIVO DATETIME
	            
) AS
BEGIN
    DECLARE @cCODENTRADAARCHIVOCONTROL NUMERIC(22,0) = 0;
   
  SET NOCOUNT ON;
    -- Get File ID
    SELECT @cCODENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
    WHERE CONVERT(DATETIME, CONVERT(DATE,FECHAARCHIVO)) = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO)) AND TIPOARCHIVO = @p_TIPOARCHIVO AND REVERSADO = 0;
    -- Open query for references
    IF @p_TIPOARCHIVO = 1 BEGIN
		 
			SELECT NUMERO_DE_TRANSACCION 
			FROM WSXML_SFG.HUERFANOSERVICIOSCOMERCIALES
			WHERE CODENTRADAARCHIVOCONTROL = @cCODENTRADAARCHIVOCONTROL;
		
    END
    ELSE BEGIN
      -- No hay anulaciones separadas de archivo de juegos (no referencias)
      SELECT NULL;
    END 
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_UpdateRecord(@pk_ID_ENTRADAARCHIVOCONTROL NUMERIC(22,0),
                         @p_TIPOARCHIVO               NUMERIC(22,0),
                         @p_FECHAARCHIVO              DATETIME,
                         @p_VALORTRANSACCIONES        FLOAT,
                         @p_NUMEROTRANSACCIONES       NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION    NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL
       SET TIPOARCHIVO            = @p_TIPOARCHIVO,
           FECHAARCHIVO           = @p_FECHAARCHIVO,
           VALORTRANSACCIONES     = @p_VALORTRANSACCIONES,
           NUMEROTRANSACCIONES    = @p_NUMEROTRANSACCIONES,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE()
     WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetRecord(@pk_ID_ENTRADAARCHIVOCONTROL NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ENTRADAARCHIVOCONTROL WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT ID_ENTRADAARCHIVOCONTROL,
             TIPOARCHIVO,
             FECHAARCHIVO,
             VALORTRANSACCIONES,
             NUMEROTRANSACCIONES,
             FECHAHORAMODIFICACION
        FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
       WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetList AS
  BEGIN
  SET NOCOUNT ON;
	
      SELECT ID_ENTRADAARCHIVOCONTROL,
             TIPOARCHIVO,
             FECHAARCHIVO,
             VALORTRANSACCIONES,
             NUMEROTRANSACCIONES,
             FECHAHORAMODIFICACION
        FROM WSXML_SFG.ENTRADAARCHIVOCONTROL;
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CountOrphans', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CountOrphans;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CountOrphans(@pk_ID_ENTRADAARCHIVOCONTROL NUMERIC(22,0), @p_ORPHANS_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @countSERVCS NUMERIC(22,0) = 0;
    DECLARE @countJUEGOS NUMERIC(22,0) = 0;
   
  SET NOCOUNT ON;
    SELECT @countSERVCS = COUNT(1) FROM WSXML_SFG.HUERFANOSERVICIOSCOMERCIALES
    WHERE CODENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;

    SELECT @countJUEGOS = COUNT(1) FROM WSXML_SFG.HUERFANOJUEGOS
    WHERE CODENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;

    SELECT @p_ORPHANS_out = @countSERVCS + @countJUEGOS;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetCDCNumberByID', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetCDCNumberByID;
GO

CREATE FUNCTION WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetCDCNumberByID(@pk_ID_ENTRADAARCHIVOCONTROL NUMERIC(22,0)) RETURNS NUMERIC(22,0) AS
 BEGIN
    DECLARE @FECHACONTROL DATETIME;

    SELECT @FECHACONTROL = FECHAARCHIVO 
	FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
    WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
	
	IF @@ROWCOUNT = 0 OR @FECHACONTROL IS NULL
		RETURN 0;
	
    RETURN SFG_PACKAGE.GETNUMEROCDC(@FECHACONTROL);

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetFileTypeName', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetFileTypeName;
GO

CREATE     FUNCTION WSXML_SFG.SFGENTRADAARCHIVOCONTROL_GetFileTypeName(@p_TIPOARCHIVO NUMERIC(22,0)) RETURNS NVARCHAR(2000) AS
  BEGIN
	
	DECLARE @c_SERVICIOSCOMERCIALES TINYINT;
	DECLARE @c_JUEGOS TINYINT;

	EXEC WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CONSTANT @c_SERVICIOSCOMERCIALES OUTPUT, @c_JUEGOS OUTPUT


    IF @p_TIPOARCHIVO = @c_SERVICIOSCOMERCIALES BEGIN
      RETURN 'Servicios Comerciales';
    END
    ELSE IF @p_TIPOARCHIVO = @c_JUEGOS BEGIN
      RETURN 'Juegos';
    END
    ELSE BEGIN
      RETURN 'Otro';
    END 
    RETURN NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CheckBalancedLoadedFiles', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CheckBalancedLoadedFiles;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CheckBalancedLoadedFiles(@p_FECHAARCHIVO DATETIME, @p_LOADEDFLAG NUMERIC(22,0) OUT, @p_ERRORMESSAGE NVARCHAR(2000) OUT) AS
 BEGIN
	SET NOCOUNT ON;
    
	--DECLARE @UNBALANCEDSLSFILE EXCEPTION;
    --DECLARE @REFERENCESMISSING EXCEPTION;

    -- Servicios comerciales
    DECLARE @cCODENTRADAARCHIVOCONTROL NUMERIC(22,0);
	DECLARE @vBALANCE NUMERIC(22,0) = 0;
    DECLARE @vREFERNC NUMERIC(22,0) = 0;

	DECLARE @c_SERVICIOSCOMERCIALES TINYINT;
	DECLARE @c_JUEGOS TINYINT;

	BEGIN 
		EXEC WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CONSTANT @c_SERVICIOSCOMERCIALES OUTPUT, @c_JUEGOS OUTPUT

		SELECT @cCODENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL 
		FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
		WHERE TIPOARCHIVO = @c_SERVICIOSCOMERCIALES 
			AND FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO)) AND REVERSADO = 0;
			
		IF @@ROWCOUNT = 0 BEGIN
			SET @p_ERRORMESSAGE = 'No se ha cargado el ultimo archivo de Servicios Comerciales';
			SET @p_LOADEDFLAG = 0;
			RETURN 0
		END
		-- Verificacion de Balance
		--SELECT CASE WHEN NUMEROTRANSACCIONES = (NUMEROHUERFANOS + NUMEROREGISTRADOS) AND VALORTRANSACCIONES = (VALORHUERFANOS + VALORREGISTRADOS) THEN 1 ELSE 0 END INTO vBALANCE
		SELECT @vBALANCE = CASE WHEN VALORTRANSACCIONES = (VALORHUERFANOS + VALORREGISTRADOS) THEN 1 ELSE 0 END
		FROM (SELECT ID_ENTRADAARCHIVOCONTROL,
                   NUMEROTRANSACCIONES,
                   NUMEROHUERFANOS,
                   NUMEROREGISTRADOS,
                   VALORTRANSACCIONES,
                   VALORHUERFANOS,
                   VALORREGISTRADOS
            FROM WSXML_SFG.VW_BALANCEDSALESFILE
            WHERE ID_ENTRADAARCHIVOCONTROL = @cCODENTRADAARCHIVOCONTROL
		) s;
		/*  	IF vBALANCE <> 1 BEGIN
				SET @p_ERRORMESSAGE = 'No existe balance de valores en el ultimo archivo de Servicios Comerciales';
				SET @p_LOADEDFLAG = 0;
			END;*/

		-- Verificacion de Referencias Cargadas
		SELECT @vREFERNC = CASE WHEN T.TRANSACCIONES <= T.REFERENCIAS THEN 1 ELSE 0 END
		FROM (
			SELECT SUM(CASE WHEN CODTIPOREGISTRO = 1 THEN NUMTRANSACCIONES ELSE 0 END) AS TRANSACCIONES,
                   SUM(CONTEOREFERENCIAS)                                              AS REFERENCIAS
            FROM WSXML_SFG.REGISTROFACTURACION REG
				LEFT OUTER JOIN (
					SELECT CODREGISTROFACTURACION, COUNT(1) AS CONTEOREFERENCIAS 
					FROM WSXML_SFG.REGISTROFACTREFERENCIA
                    GROUP BY CODREGISTROFACTURACION
				) RFR ON (RFR.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
            WHERE CODENTRADAARCHIVOCONTROL = @cCODENTRADAARCHIVOCONTROL
		) T
		
		IF @vREFERNC <> 1 BEGIN
			SET @p_ERRORMESSAGE = 'No existe balance de referencias en el ultimo archivo de Servicios Comerciales';
			SET @p_LOADEDFLAG = 0;
			RETURN 0
		END

	END;

    -- Juegos
      --DECLARE @cCODENTRADAARCHIVOCONTROL NUMERIC(22,0);
      --DECLARE @vBALANCE NUMERIC(22,0) = 0;
    BEGIN
		EXEC WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CONSTANT @c_SERVICIOSCOMERCIALES OUTPUT, @c_JUEGOS OUTPUT

		SELECT @cCODENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
		WHERE TIPOARCHIVO = @c_JUEGOS AND FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO)) AND REVERSADO = 0;
		
		IF @@ROWCOUNT = 0 BEGIN
			SET @p_ERRORMESSAGE = 'No se ha cargado el ultimo archivo de Juegos';
			SET @p_LOADEDFLAG = 0;
			RETURN 0
		END		
		
		-- Verificacion de Balance
      
		SELECT @vBALANCE = CASE WHEN NUMEROTRANSACCIONES = (NUMEROHUERFANOS + NUMEROREGISTRADOS) AND VALORTRANSACCIONES = (VALORHUERFANOS + VALORREGISTRADOS) THEN 1 ELSE 0 END
		FROM (
			SELECT ID_ENTRADAARCHIVOCONTROL,
                   NUMEROTRANSACCIONES,
                   NUMEROHUERFANOS,
                   NUMEROREGISTRADOS,
                   VALORTRANSACCIONES,
                   VALORHUERFANOS,
                   VALORREGISTRADOS
            FROM WSXML_SFG.VW_BALANCEDSALESFILE
            WHERE ID_ENTRADAARCHIVOCONTROL = @cCODENTRADAARCHIVOCONTROL
		) s;
		/*  
		IF vBALANCE <> 1 THEN
			SET @p_ERRORMESSAGE = 'No existe balance de valores en el ultimo archivo de Juegos';
			SET @p_LOADEDFLAG = 0;
			EXIT;
		END IF;
		*/
		
		  
	END;

    SET @p_LOADEDFLAG = 1;
    SET @p_ERRORMESSAGE = 'Los archivos de ventas de la fecha fueron cargados completamente';
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CheckOrphansLoadedFiles', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CheckOrphansLoadedFiles;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CheckOrphansLoadedFiles(@p_ORPHANFLAG NUMERIC(22,0) OUT, @p_ERRORMESSAGE NVARCHAR(2000) OUT) AS
 BEGIN
	SET NOCOUNT ON;
    
	DECLARE @lstLOADEDFILES MEDIUMNUMBERARRAY;
    --DECLARE @UNBALANCEDSLSFILE EXCEPTION;
    --DECLARE @ORPHANSEXISTINFLE EXCEPTION;

    SET @p_ORPHANFLAG = 1;
    -- Balance y huerfanos de todos los archivos a considerar; y advertencia en entradas por fuera

	INSERT @lstLOADEDFILES 
    SELECT ID_ENTRADAARCHIVOCONTROL --BULK COLLECT INTO @lstLOADEDFILES 
	FROM WSXML_SFG.ENTRADAARCHIVOCONTROL WHERE REVERSADO = 0 AND FACTURADO = 0 AND ARCHIVOFACTURABLE = 1;

	IF @@ROWCOUNT > 0 BEGIN
		
		DECLARE ix CURSOR FOR SELECT IDValue FROM @lstLOADEDFILES
		DECLARE @idxVal INT
	
		OPEN ix
		FETCH NEXT FROM ix INTO @idxVal
		WHILE (@@FETCH_STATUS = 0)
			BEGIN  

				IF @p_ORPHANFLAG = 1 BEGIN
					
					DECLARE @vBALANCE NUMERIC(22,0);
					DECLARE @vORPHANS NUMERIC(22,0);
					DECLARE @vARCHIVO NVARCHAR(50);
					BEGIN
						SELECT @vBALANCE = CASE WHEN /*NUMEROTRANSACCIONES = (NUMEROHUERFANOS + NUMEROREGISTRADOS) AND*/ VALORTRANSACCIONES = (VALORHUERFANOS + VALORREGISTRADOS) THEN 1 ELSE 0 END,
							   @vORPHANS = CASE WHEN NUMEROHUERFANOS = 0 OR VALORHUERFANOS = 0 THEN 1 ELSE 0 END,
							   @vARCHIVO = ISNULL(S.TIPOARCHIVO, '') + ' ' + ISNULL(S.CDCARCHIVO, '')
						FROM (
							SELECT ID_ENTRADAARCHIVOCONTROL,
								TIPOARCHIVO,
								CDCARCHIVO,
								NUMEROTRANSACCIONES,
								NUMEROHUERFANOS,
								NUMEROREGISTRADOS,
								VALORTRANSACCIONES,
								VALORHUERFANOS,
								VALORREGISTRADOS
							  FROM [WSXML_SFG].[VW_BALANCEDSALESFILE]
							  WHERE ID_ENTRADAARCHIVOCONTROL = @idxVal
						) S

						IF @vBALANCE <> 1 BEGIN
							SET @p_ERRORMESSAGE = 'No existe balance para el archivo ' + ISNULL(@vARCHIVO, '');
							SET @p_ORPHANFLAG = 0;
							RETURN;
						END 
						IF @vORPHANS <> 1 BEGIN
							SET @p_ERRORMESSAGE = 'Existen valores huerfanos para el archivo ' + ISNULL(@vARCHIVO, '');
							SET @p_ORPHANFLAG = 0;
							RETURN;
						END 
					END
				END

			FETCH NEXT FROM ix INTO @idxVal
			END

		CLOSE ix
		DEALLOCATE ix


	END ELSE BEGIN
      SET @p_ERRORMESSAGE = 'No existen archivos por facturar.';
      SET @p_ORPHANFLAG = 1;
      RETURN;
    END 
    SET @p_ERRORMESSAGE = 'Todos los archivos a considerar estan balanceados y no contemplan entradas huerfanas';
    SET @p_ORPHANFLAG = 1;
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_ImporteBalanceTotal', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_ImporteBalanceTotal;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_ImporteBalanceTotal(@p_CODTIPOARCHIVO NUMERIC(22,0), @p_CDCARCHIVO NUMERIC(22,0), @p_TRANSACCIONES_out NUMERIC(22,0) OUT, @p_VENTAS_out FLOAT OUT) AS
 BEGIN
    DECLARE @cCODENTRADAARCHIVOCONTROL NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @cCODENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
    WHERE REVERSADO = 0 AND TIPOARCHIVO = @p_CODTIPOARCHIVO AND SFG_PACKAGE.GetNumeroCDC(FECHAARCHIVO) = @p_CDCARCHIVO;
	
	IF @@ROWCOUNT = 0 BEGIN
		RAISERROR('-20006 No se encontro el archivo de ventas al que hace referencia', 16, 1);
		RETURN 0
	END
    -- Obtain Values through single variables
    SELECT @p_TRANSACCIONES_out = SUM(
				CASE 
					WHEN CODTIPOREGISTRO = 1 THEN NUMTRANSACCIONES
                    WHEN CODTIPOREGISTRO = 2 THEN NUMTRANSACCIONES * (-1) ELSE 0 END
			),
			@p_VENTAS_out = SUM(
				CASE 
					WHEN CODTIPOREGISTRO = 1 THEN VALORTRANSACCION
					WHEN CODTIPOREGISTRO = 2 THEN VALORTRANSACCION * (-1) ELSE 0 
				END
			)
    FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
    INNER JOIN WSXML_SFG.REGISTROFACTURACION ON (CODENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL)
    WHERE ID_ENTRADAARCHIVOCONTROL = @cCODENTRADAARCHIVOCONTROL;
    
END
GO


IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_UpdateControlFromAnnulment', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_UpdateControlFromAnnulment;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_UpdateControlFromAnnulment(@pk_ID_ENTRADAARCHIVOCONTROL NUMERIC(22,0),
                                       @p_NUMTRANSACCIONES          NUMERIC(22,0),
                                       @p_VALORTRANSACCION          FLOAT) AS
 BEGIN
    DECLARE @cTIPOARCHIVO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @cTIPOARCHIVO = TIPOARCHIVO FROM WSXML_SFG.ENTRADAARCHIVOCONTROL WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
    IF @cTIPOARCHIVO = 1 BEGIN
      -- Servicios comerciales: Anulaciones suman al archivo de Control
      UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL SET NUMEROTRANSACCIONES = NUMEROTRANSACCIONES + @p_NUMTRANSACCIONES,
                                       VALORTRANSACCIONES  = VALORTRANSACCIONES + @p_VALORTRANSACCION
      WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
    END
    ELSE IF @cTIPOARCHIVO = 2 BEGIN
      -- Juegos: Anulaciones restan al archivo de Control
      UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL SET NUMEROTRANSACCIONES = NUMEROTRANSACCIONES - @p_NUMTRANSACCIONES,
                                       VALORTRANSACCIONES  = VALORTRANSACCIONES - @p_VALORTRANSACCION
      WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
    END
    ELSE BEGIN
		DECLARE @msglog VARCHAR(2000) = 'Annulment of service ' + ISNULL(@cTIPOARCHIVO, '') + ' cannot modify control value'
      EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @msglog
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_UpdateReverseControlFromType', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_UpdateReverseControlFromType;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_UpdateReverseControlFromType(@pk_ID_ENTRADAARCHIVOCONTROL NUMERIC(22,0),
                                         @p_CODTIPOREGISTRO           NUMERIC(22,0),
                                         @p_NUMTRANSACCIONES          NUMERIC(22,0),
                                         @p_VALORTRANSACCION          FLOAT) AS
 BEGIN
    DECLARE @cTIPOARCHIVO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @cTIPOARCHIVO = TIPOARCHIVO FROM WSXML_SFG.ENTRADAARCHIVOCONTROL WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
    IF @cTIPOARCHIVO = 1 BEGIN -- Servicios comerciales: Todos los tipos de transaccion suman al archivo de Control
      UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL SET NUMEROTRANSACCIONES = NUMEROTRANSACCIONES - @p_NUMTRANSACCIONES,
                                       VALORTRANSACCIONES  = VALORTRANSACCIONES - @p_VALORTRANSACCION
      WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
    END
    ELSE IF @cTIPOARCHIVO = 2 BEGIN -- Juegos: Ventas suman, otros restan al archivo de Control
      UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL SET NUMEROTRANSACCIONES = NUMEROTRANSACCIONES - CASE WHEN @p_CODTIPOREGISTRO = 1 THEN @p_NUMTRANSACCIONES ELSE (@p_NUMTRANSACCIONES * (-1)) END,
                                       VALORTRANSACCIONES  = VALORTRANSACCIONES - CASE WHEN @p_CODTIPOREGISTRO = 1 THEN @p_VALORTRANSACCION ELSE (@p_VALORTRANSACCION * (-1)) END
      WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
    END
    ELSE BEGIN
		DECLARE @msglog VARCHAR(2000) = 'Annulment of service ' + ISNULL(CONVERT(VARCHAR,@cTIPOARCHIVO), '') + ' cannot modify control value'
		EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @msglog
    END 
  END;
GO



IF Object_id('WSXML_SFG.SFGENTRADAARCHIVOCONTROL_ReversoArchivosVentasDiarias', 'P') IS NOT NULL
	DROP PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_ReversoArchivosVentasDiarias;
GO

CREATE PROCEDURE WSXML_SFG.SFGENTRADAARCHIVOCONTROL_ReversoArchivosVentasDiarias( 
	@p_ID_DETALLETAREAEJECUTADA NUMERIC(22,0), 
	@p_FECHA DATETIME 
)AS 
BEGIN 
  SET NOCOUNT ON;
    DECLARE @lstLOADEDFILES MEDIUMNUMBERARRAY; 
 
    --Reversa archivos cargados para el dia 
    INSERT @lstLOADEDFILES 
    SELECT id_entradaarchivocontrol 
    FROM   wsxml_sfg.entradaarchivocontrol 
    WHERE  fechaarchivo = CONVERT(DATETIME, CONVERT(DATE,@p_FECHA)); 
     
    IF @@ROWCOUNT > 0 
    BEGIN 
		
		DECLARE ix CURSOR FOR SELECT IDValue FROM @lstLOADEDFILES
		DECLARE @idxVal INT
	
		OPEN ix
		FETCH NEXT FROM ix INTO @idxVal
		WHILE (@@FETCH_STATUS = 0)
			BEGIN


				DECLARE @v_szsql_string             VARCHAR(4000); 
				DECLARE @v_id_entradaarchivocontrol NUMERIC(22,0) = @idxVal
				DECLARE @f_retvalue_out             NUMERIC(22,0); 	

				BEGIN
				
				
					--select * from entradaarchivocontrol order by 1 desc 
					--WSXML_SFG.AJUSTEFACTURACION.codregistrofactorigen 
					DECLARE bb CURSOR FOR 
					SELECT a.id_ajustefacturacion as fila --a.rowid AS fila 
					FROM   wsxml_sfg.ajustefacturacion a 
					WHERE  a.codregistrofactorigen IN ( 
						  SELECT r.id_registrofacturacion 
						  FROM   wsxml_sfg.registrofacturacion r, 
								 wsxml_sfg.entradaarchivocontrol e 
						  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
						  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol
						); 
					
					DECLARE @fila INT;
					
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.ajustefacturacion WHERE id_ajustefacturacion = @fila; --rowid = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					END; 
					CLOSE bb; 
					DEALLOCATE bb;


					--WSXML_SFG.AJUSTEFACTURACION.codregistrofactdestino 
					DECLARE bb CURSOR FOR 
					SELECT a.id_ajustefacturacion as fila --a.rowid AS fila 
					FROM   wsxml_sfg.ajustefacturacion a 
					WHERE  a.codregistrofactdestino IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.ajustefacturacion WHERE id_ajustefacturacion = @fila; --rowid = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					END; 
					CLOSE bb; 
					DEALLOCATE bb;	


					--WSXML_SFG.AJUSTEREVENUE.codregistrofactorigen 
					DECLARE bb CURSOR FOR 
					SELECT a.id_ajusterevenue AS fila 
					FROM   wsxml_sfg.ajusterevenue a 
					WHERE  a.codregistrofactorigen IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila

					WHILE @@fetch_status=0 
					BEGIN 
						DELETE wsxml_sfg.ajusterevenue WHERE  id_ajusterevenue = @fila; 
						--COMMIT; 
						FETCH NEXT FROM bb INTO @fila				 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.AJUSTEREVENUE.codregistrofactdestino 
					DECLARE bb CURSOR FOR 
					SELECT a.id_ajusterevenue AS fila 
					FROM   wsxml_sfg.ajusterevenue a 
					WHERE  a.codregistrofactdestino IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila				 
					 
					WHILE @@fetch_status=0 
					BEGIN 
						DELETE wsxml_sfg.ajusterevenue WHERE  id_ajusterevenue = @fila; 
						--COMMIT; 
						FETCH NEXT FROM bb INTO @fila				 					 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.ARCHIVOTRANSALIADOCACHE.codregistrofacturacion 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_ARCHIVOTRANSALIADOCACHE AS fila 
					FROM   wsxml_sfg.archivotransaliadocache a 
					WHERE  a.codregistrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.archivotransaliadocache WHERE ID_ARCHIVOTRANSALIADOCACHE = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					--WSXML_SFG.ARCHIVOTRANSALIADOCACHE.codregistrofacturacion 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_REGISTROFACTDESCUENTO AS fila 
					FROM   wsxml_sfg.registrofactdescuento a 
					WHERE  a.codregistrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.registrofactdescuento WHERE  ID_REGISTROFACTDESCUENTO = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					--SFG_CONCILIACION.COM_CADENA_DESCONTAR.cod_registrofacturacion 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_CADENA_DESCONTAR AS fila 
					FROM   sfg_conciliacion.com_cadena_descontar a 
					WHERE  a.cod_registrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE sfg_conciliacion.com_cadena_descontar WHERE  ID_CADENA_DESCONTAR = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					--WSXML_SFG.IMPUESTOREGFACTURACION.codregistrofacturacion 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_IMPUESTOREGFACTURACION AS fila 
					FROM   wsxml_sfg.impuestoregfacturacion a 
					WHERE  a.codregistrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.impuestoregfacturacion WHERE  ID_IMPUESTOREGFACTURACION = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					--WSXML_SFG.REGISTROFACTTRANSAVANZADO.codregistrofacturacion 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_REGISTROFACTTRANSAVANZADO AS fila 
					FROM   wsxml_sfg.registrofacttransavanzado a 
					WHERE  a.codregistrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.registrofacttransavanzado WHERE  ID_REGISTROFACTTRANSAVANZADO = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.REGISTROREVENUE.codregistrofacturacion 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_REGISTROREVENUE AS fila 
					FROM   wsxml_sfg.registrorevenue a 
					WHERE  a.codregistrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.registrorevenue WHERE  ID_REGISTROREVENUE = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila			 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.REGISTROREVENUE.CODENTRADAARCHIVOCONTROL 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_REGISTROREVENUE AS fila 
					FROM   wsxml_sfg.registrorevenue a 
					WHERE  a.codentradaarchivocontrol = @v_id_entradaarchivocontrol; 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.registrorevenue WHERE  ID_REGISTROREVENUE = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila			 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.RETENCIONREGFACTURACION.codregistrofacturacion 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_RETENCIONREGFACTURACION AS fila 
					FROM   wsxml_sfg.retencionregfacturacion a 
					WHERE  a.codregistrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.retencionregfacturacion WHERE  ID_RETENCIONREGFACTURACION = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila				 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.RETUVTREGFACTURACION.codregistrofacturacion 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_RETUVTREGFACTURACION AS fila 
					FROM   wsxml_sfg.retuvtregfacturacion a 
					WHERE  a.codregistrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.retuvtregfacturacion WHERE  ID_RETUVTREGFACTURACION = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.TRANSACCIONALIADO.codregistrofacturacion 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_TRANSACCIONALIADO AS fila 
					FROM   wsxml_sfg.transaccionaliado a 
					WHERE  a.codregistrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.transaccionaliado WHERE  ID_TRANSACCIONALIADO = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila				 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.AJUSTEFACTURACION.codregistrofactreforigen 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_AJUSTEFACTURACION AS fila 
					FROM   wsxml_sfg.ajustefacturacion a 
					WHERE  a.codregistrofactreforigen IN 
						   ( 
								  SELECT rf.id_registrofactreferencia 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e, 
										 wsxml_sfg.registrofactreferencia rf 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    rf.codregistrofacturacion = r.id_registrofacturacion 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.ajustefacturacion WHERE  ID_AJUSTEFACTURACION = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila					 
					END; 
					CLOSE bb; 
					DEALLOCATE bb;
					
					--WSXML_SFG.AJUSTEFACTURACION.codregistrofactrefdestino 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_AJUSTEFACTURACION AS fila 
					FROM   wsxml_sfg.ajustefacturacion a 
					WHERE  a.codregistrofactrefdestino IN 
						   ( 
								  SELECT rf.id_registrofactreferencia 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e, 
										 wsxml_sfg.registrofactreferencia rf 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    rf.codregistrofacturacion = r.id_registrofacturacion 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.ajustefacturacion WHERE  ID_AJUSTEFACTURACION = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.AJUSTEFACTURACION.codregistrofactrefdestino 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_AJUSTEFACTURACION AS fila 
					FROM   wsxml_sfg.ajustefacturacion a 
					WHERE  a.codregistrofactrefdestino IN 
						   ( 
								  SELECT rf.id_registrofactreferencia 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e, 
										 wsxml_sfg.registrofactreferencia rf 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    rf.codregistrofacturacion = r.id_registrofacturacion 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.ajustefacturacion WHERE  ID_AJUSTEFACTURACION = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila				 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					--WSXML_SFG.ARCHIVOTRANSALIADOCACHE.codregistrofactreferencia 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_ARCHIVOTRANSALIADOCACHE AS fila 
					FROM   wsxml_sfg.archivotransaliadocache a 
					WHERE  a.codregistrofactreferencia IN 
						   ( 
								  SELECT rf.id_registrofactreferencia 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e, 
										 wsxml_sfg.registrofactreferencia rf 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    rf.codregistrofacturacion = r.id_registrofacturacion 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.archivotransaliadocache WHERE  ID_ARCHIVOTRANSALIADOCACHE = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--SFG_CONCILIACION.ENTRADACONCILIAGTK.codregistrofactreferencia 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_ENTRADACONCILIAGTK AS fila 
					FROM   sfg_conciliacion.entradaconciliagtk a 
					WHERE  a.codregistrofactreferencia IN 
						   ( 
								  SELECT rf.id_registrofactreferencia 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e, 
										 wsxml_sfg.registrofactreferencia rf 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    rf.codregistrofacturacion = r.id_registrofacturacion 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE sfg_conciliacion.entradaconciliagtk WHERE  ID_ENTRADACONCILIAGTK = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila					 
					END; 
					CLOSE bb; 
					DEALLOCATE bb; 
					
					--WSXML_SFG.TRANSACCIONALIADO.codregistrofactreferencia 
					DECLARE bb CURSOR FOR 
					SELECT a.ID_TRANSACCIONALIADO AS fila 
					FROM   wsxml_sfg.transaccionaliado a 
					WHERE  a.codregistrofactreferencia IN 
						   ( 
								  SELECT rf.id_registrofactreferencia 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e, 
										 wsxml_sfg.registrofactreferencia rf 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    rf.codregistrofacturacion = r.id_registrofacturacion 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol); 
					 
					OPEN bb; 
					FETCH NEXT FROM bb INTO @fila
					 
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.transaccionaliado WHERE  ID_TRANSACCIONALIADO = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					END;
					CLOSE bb;
					DEALLOCATE bb; 
					
					--WSXML_SFG.REGISTROFACTREFERENCIA.codregistrofacturacionDECLARE bb CURSOR FOR 
					
					SELECT a.ID_REGISTROFACTREFERENCIA AS fila 
					FROM   wsxml_sfg.registrofactreferencia a 
					WHERE  a.codregistrofacturacion IN 
						   ( 
								  SELECT r.id_registrofacturacion 
								  FROM   wsxml_sfg.registrofacturacion r, 
										 wsxml_sfg.entradaarchivocontrol e 
								  WHERE  r.codentradaarchivocontrol = e.id_entradaarchivocontrol 
								  AND    e.id_entradaarchivocontrol = @v_id_entradaarchivocontrol);
					OPEN bb;
					FETCH NEXT FROM bb INTO @fila
					
					WHILE @@fetch_status=0 
					BEGIN 
					  DELETE wsxml_sfg.registrofactreferencia WHERE  ID_REGISTROFACTREFERENCIA = @fila; 
					  --COMMIT; 
					  FETCH NEXT FROM bb INTO @fila
					END;
					CLOSE bb;
					DEALLOCATE bb;					
							
				END
		
			FETCH NEXT FROM ix INTO @idxVal
			END

		CLOSE ix
		DEALLOCATE ix
	
    END ELSE BEGIN
		RAISERROR('-20006 No se encontro el archivo de ventas para reversar', 16, 1);
		RETURN;
	END 
END;

