USE SFGPRODU;
--  DDL for Package Body SFGPRODUCTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPRODUCTO */ 

  		IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_AddRecord;
GO

CREATE 		  		  PROCEDURE WSXML_SFG.SFGPRODUCTO_AddRecord(@p_CODIGOGTECHPRODUCTO    NVARCHAR(2000),
										@p_NOMPRODUCTO            NVARCHAR(2000),
										@p_CODALIADOESTRATEGICO   NUMERIC(22,0),
										@p_CODTIPOPRODUCTO        NUMERIC(22,0),
										@p_PORCENTAJEGTECH        NUMERIC(22,0),
										@p_PORCENTAJEFIDUCIA      NUMERIC(22,0),
										@p_CODUSUARIOMODIFICACION NUMERIC(22,0),
										@p_ID_PRODUCTO_out        NUMERIC(22,0) OUT)
					AS
					BEGIN
						DECLARE @V_ID_PRODUCTO    NUMERIC(22,0);
						DECLARE @V_CODTIPOPRODUCO NUMERIC(22,0);
						DECLARE @V_CODTIPOPRODUCOVENTAS NUMERIC(22,0);
						DECLARE @V_NOMPRODUCTO VARCHAR(255);
					 
					SET NOCOUNT ON;


					INSERT INTO WSXML_SFG.PRODUCTO (
											CODIGOGTECHPRODUCTO,
											NOMPRODUCTO,
											CODALIADOESTRATEGICO,
											CODTIPOPRODUCTO,
											PORCENTAJEGTECH,
											PORCENTAJEFIDUCIA,
											CODUSUARIOMODIFICACION)
						VALUES (
								@p_CODIGOGTECHPRODUCTO,
								@p_NOMPRODUCTO,
								@p_CODALIADOESTRATEGICO,
								@p_CODTIPOPRODUCTO,
								@p_PORCENTAJEGTECH,
								@p_PORCENTAJEFIDUCIA,
								@p_CODUSUARIOMODIFICACION);



				   SELECT @V_ID_PRODUCTO = MAX(ID_PRODUCTO) FROM WSXML_SFG.PRODUCTO;

				---- Verifica el CODTIPOPRODUCO y de esta manera ingresar el CODTIPOPRODUCTOVENTAS
				  SELECT  @V_CODTIPOPRODUCO = codtipoproducto , @V_NOMPRODUCTO = nomproducto    FROM WSXML_SFG.PRODUCTO WHERE ID_PRODUCTO = @V_ID_PRODUCTO;


				 IF @V_CODTIPOPRODUCO = 1 BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = 1;
				 END
 				ELSE IF @V_CODTIPOPRODUCO = 2  BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = 2;
				 END
 				ELSE IF @V_CODTIPOPRODUCO = 3  BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = 3;
				 END
 				ELSE IF @V_CODTIPOPRODUCO = 4  BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = 4;
				 END
 				ELSE IF @V_CODTIPOPRODUCO = 5  BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = NULL;
				 END
 				ELSE IF @V_CODTIPOPRODUCO = 6  BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = 5;
				 END
 				ELSE IF @V_CODTIPOPRODUCO = 7  BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = 5;
				 END
 				ELSE IF @V_CODTIPOPRODUCO = 8  BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = 6;
				 END
 				ELSE IF @V_CODTIPOPRODUCO = 9  BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = 6;
				 END
 				ELSE IF @V_CODTIPOPRODUCO = 10  BEGIN
				   IF CHARINDEX('GIRO', UPPER(@V_NOMPRODUCTO)) <> 0 BEGIN
					 ---- GIROS
					 SET @V_CODTIPOPRODUCOVENTAS = 8;
				   END
   				ELSE BEGIN
					 ---- RETIROS
					 SET @V_CODTIPOPRODUCOVENTAS = 7;
					 END 

				 END
 				ELSE BEGIN
				  SET @V_CODTIPOPRODUCOVENTAS = NULL;
				 END 

				 INSERT INTO WSXML_SFG.PRDOCUTOAREAVENTAS (ID_PRDOCUTOAREAVENTAS,
											CODPRODUCTO,
											CODTIPOPRODUCTOVENTAS,
                      ACTIVE)
            VALUES (@V_ID_PRODUCTO,
                @V_ID_PRODUCTO,
                @V_CODTIPOPRODUCOVENTAS,
                1);

           ---- RETORNA EL ID DE LA TABLA PRODUCTO
           SET @p_ID_PRODUCTO_out = @V_ID_PRODUCTO;

				END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_AddComprehensiveRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_AddComprehensiveRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_AddComprehensiveRecord(@p_CODIGOGTECHPRODUCTO    NVARCHAR(2000),
											   @p_NOMPRODUCTO            NVARCHAR(2000),
											   @p_CODALIADOESTRATEGICO   NUMERIC(22,0),
											   @p_CODTIPOPRODUCTO        NUMERIC(22,0),
											   @p_CODAGRUPACIONPRODUCTO  NUMERIC(22,0),
											   @p_CODCOMPANIA            NUMERIC(22,0),
											   @p_CODVENTADEPARTAMENTO   NUMERIC(22,0),
											   @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
											   @p_ID_PRODUCTO_out        NUMERIC(22,0) OUT)
					AS
					BEGIN
						DECLARE @V_ID_PRODUCTO  NUMERIC(22,0);
						DECLARE @V_CODTIPOPRODUCO NUMERIC(22,0);
						DECLARE @V_CODTIPOPRODUCOVENTAS NUMERIC(22,0);
						DECLARE @V_NOMPRODUCTO VARCHAR(255);
					 
					SET NOCOUNT ON;


					INSERT INTO WSXML_SFG.PRODUCTO (
											CODIGOGTECHPRODUCTO,
											NOMPRODUCTO,
											CODALIADOESTRATEGICO,
											CODTIPOPRODUCTO,
											CODAGRUPACIONPRODUCTO,
											CODCOMPANIA,
											CODVENTADEPARTAMENTO,
											CODUSUARIOMODIFICACION)
						VALUES (
								@p_CODIGOGTECHPRODUCTO,
								@p_NOMPRODUCTO,
								@p_CODALIADOESTRATEGICO,
								@p_CODTIPOPRODUCTO,
								@p_CODAGRUPACIONPRODUCTO,
								@p_CODCOMPANIA,
								@p_CODVENTADEPARTAMENTO,
								@p_CODUSUARIOMODIFICACION);


					  SELECT @V_ID_PRODUCTO = MAX(ID_PRODUCTO) FROM WSXML_SFG.PRODUCTO;

					---- Verifica el CODTIPOPRODUCO y de esta manera ingresar el CODTIPOPRODUCTOVENTAS
					SELECT  @V_CODTIPOPRODUCO = codtipoproducto , @V_NOMPRODUCTO = nomproducto    FROM WSXML_SFG.PRODUCTO WHERE ID_PRODUCTO = @V_ID_PRODUCTO;


					IF @V_CODTIPOPRODUCO = 1 BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = 1;
					END
					ELSE IF @V_CODTIPOPRODUCO = 2  BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = 2;
					END
					ELSE IF @V_CODTIPOPRODUCO = 3  BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = 3;
					END
					ELSE IF @V_CODTIPOPRODUCO = 4  BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = 4;
					END
					ELSE IF @V_CODTIPOPRODUCO = 5  BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = NULL;
					END
					ELSE IF @V_CODTIPOPRODUCO = 6  BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = 5;
					END
					ELSE IF @V_CODTIPOPRODUCO = 7  BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = 5;
					END
					ELSE IF @V_CODTIPOPRODUCO = 8  BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = 6;
					END
					ELSE IF @V_CODTIPOPRODUCO = 9  BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = 6;
					END
					ELSE IF @V_CODTIPOPRODUCO = 10  BEGIN
						 IF CHARINDEX('GIRO', UPPER(@V_NOMPRODUCTO)) <> 0 BEGIN
						   ---- GIROS
						   SET @V_CODTIPOPRODUCOVENTAS = 8;
						 END
 						ELSE BEGIN
						   ---- RETIROS
						   SET @V_CODTIPOPRODUCOVENTAS = 7;
						 END 

				   END
   				ELSE BEGIN
						SET @V_CODTIPOPRODUCOVENTAS = NULL;
				   END 



					INSERT INTO WSXML_SFG.PRDOCUTOAREAVENTAS (ID_PRDOCUTOAREAVENTAS,
											CODPRODUCTO,
											CODTIPOPRODUCTOVENTAS,
											ACTIVE)
						VALUES (@V_ID_PRODUCTO,
								@V_ID_PRODUCTO,
								@V_CODTIPOPRODUCOVENTAS,
								1);



					--  RETORNA EL ID DEL REGISTRO INGRESADO
					SET @p_ID_PRODUCTO_out = @V_ID_PRODUCTO;
					END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_UpdateRecord(@pk_ID_PRODUCTO           NUMERIC(22,0),
									@p_CODIGOGTECHPRODUCTO    NVARCHAR(2000),
									@p_NOMPRODUCTO            NVARCHAR(2000),
									@p_CODALIADOESTRATEGICO   NUMERIC(22,0),
									@p_CODTIPOPRODUCTO        NUMERIC(22,0),
									@p_PORCENTAJEGTECH        NUMERIC(22,0),
									@p_PORCENTAJEFIDUCIA      NUMERIC(22,0),
									@p_CODUSUARIOMODIFICACION NUMERIC(22,0),
									@p_ACTIVE                 NUMERIC(22,0)) AS
BEGIN
	SET NOCOUNT ON;


	UPDATE WSXML_SFG.PRODUCTO
		SET CODIGOGTECHPRODUCTO    = @p_CODIGOGTECHPRODUCTO,
			NOMPRODUCTO            = @p_NOMPRODUCTO,
			CODALIADOESTRATEGICO   = @p_CODALIADOESTRATEGICO,
			CODTIPOPRODUCTO        = @p_CODTIPOPRODUCTO,
			PORCENTAJEGTECH        = @p_PORCENTAJEGTECH,
			PORCENTAJEFIDUCIA      = @p_PORCENTAJEFIDUCIA,
			CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
			ACTIVE                 = @p_ACTIVE
		WHERE ID_PRODUCTO = @pk_ID_PRODUCTO;

		DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;

		IF @rowcount = 0 BEGIN
			RAISERROR('-20054 The record no longer exists.', 16, 1);
			RETURN 0
		END 
		IF @rowcount > 1 BEGIN
			RAISERROR('-20053 Duplicate object instances.', 16, 1);
			RETURN 0
		END 

		UPDATE WSXML_SFG.PRDOCUTOAREAVENTAS
		SET    ACTIVE                 = @p_ACTIVE
		WHERE CODPRODUCTO = @pk_ID_PRODUCTO;

		SET @rowcount = @@ROWCOUNT;

		IF @rowcount = 0 BEGIN
		RAISERROR('-20054 The record no longer exists.', 16, 1);
		END 
		IF @rowcount > 1 BEGIN
		RAISERROR('-20053 Duplicate object instances.', 16, 1);
		END 

END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_DeactivateRecord(@pk_ID_PRODUCTO           NUMERIC(22,0),
									 @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
BEGIN
	SET NOCOUNT ON;
	UPDATE WSXML_SFG.PRODUCTO
	SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
		FECHAHORAMODIFICACION  = GETDATE(),
		ACTIVE                 = 0
	WHERE ID_PRODUCTO = @pk_ID_PRODUCTO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
	IF @rowcount = 0 BEGIN
		RAISERROR('-20054 The record no longer exists.', 16, 1);
		RETURN 0
	END 
	IF @rowcount > 1 BEGIN
		RAISERROR('-20053 Duplicate object instances.', 16, 1);
		RETURN 0
	END 

	UPDATE WSXML_SFG.PRDOCUTOAREAVENTAS
	SET ACTIVE                 = 0
	WHERE CODPRODUCTO = @pk_ID_PRODUCTO;

	SET @rowcount = @@ROWCOUNT;
	IF @rowcount = 0 BEGIN
	  RAISERROR('-20054 The record no longer exists.', 16, 1);
	END 
	IF @rowcount > 1 BEGIN
	  RAISERROR('-20053 Duplicate object instances.', 16, 1);
	END 

END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_GetRecord(@pk_ID_PRODUCTO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.PRODUCTO WHERE ID_PRODUCTO = @pk_ID_PRODUCTO;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT P.ID_PRODUCTO,
             P.CODIGOGTECHPRODUCTO,
             P.NOMPRODUCTO,
             P.CODALIADOESTRATEGICO,
             A.NOMALIADOESTRATEGICO,
             P.CODTIPOPRODUCTO,
             T.NOMTIPOPRODUCTO,
             L.NOMLINEADENEGOCIO,
             P.PORCENTAJEGTECH,
             P.PORCENTAJEFIDUCIA,
             P.FECHAHORAMODIFICACION,
             P.CODUSUARIOMODIFICACION,
             P.ACTIVE
      FROM WSXML_SFG.PRODUCTO P
      LEFT OUTER JOIN ALIADOESTRATEGICO A ON CODALIADOESTRATEGICO = ID_ALIADOESTRATEGICO
      LEFT OUTER JOIN TIPOPRODUCTO T ON CODTIPOPRODUCTO = ID_TIPOPRODUCTO
      LEFT OUTER JOIN LINEADENEGOCIO L ON CODLINEADENEGOCIO = ID_LINEADENEGOCIO
      WHERE ID_PRODUCTO = @pk_ID_PRODUCTO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_GetRecordByCodigo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_GetRecordByCodigo;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_GetRecordByCodigo(@p_CODIGOGTECHPRODUCTO NVARCHAR(2000)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.PRODUCTO WHERE CODIGOGTECHPRODUCTO = @p_CODIGOGTECHPRODUCTO;
 /*   IF l_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20054, 'The record no longer exists.');
    END IF;*/
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT P.ID_PRODUCTO,
             P.CODIGOGTECHPRODUCTO,
             P.NOMPRODUCTO,
             P.CODALIADOESTRATEGICO,
             A.NOMALIADOESTRATEGICO,
             P.CODTIPOPRODUCTO,
             T.NOMTIPOPRODUCTO,
             L.NOMLINEADENEGOCIO,
             P.PORCENTAJEGTECH,
             P.PORCENTAJEFIDUCIA,
             P.FECHAHORAMODIFICACION,
             P.CODUSUARIOMODIFICACION,
             P.ACTIVE
      FROM WSXML_SFG.PRODUCTO P
      LEFT OUTER JOIN ALIADOESTRATEGICO A ON CODALIADOESTRATEGICO = ID_ALIADOESTRATEGICO
      LEFT OUTER JOIN TIPOPRODUCTO T ON CODTIPOPRODUCTO = ID_TIPOPRODUCTO
      LEFT OUTER JOIN LINEADENEGOCIO L ON CODLINEADENEGOCIO = ID_LINEADENEGOCIO
      WHERE CODIGOGTECHPRODUCTO = @p_CODIGOGTECHPRODUCTO;
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
     	   
      SELECT P.ID_PRODUCTO,
             P.CODIGOGTECHPRODUCTO,
             P.NOMPRODUCTO,
             P.CODALIADOESTRATEGICO,
             A.NOMALIADOESTRATEGICO,
             P.CODTIPOPRODUCTO,
             T.NOMTIPOPRODUCTO,
             L.NOMLINEADENEGOCIO,
             P.PORCENTAJEGTECH,
             P.PORCENTAJEFIDUCIA,
             P.FECHAHORAMODIFICACION,
             P.CODUSUARIOMODIFICACION,
             P.ACTIVE
      FROM WSXML_SFG.PRODUCTO P
      LEFT OUTER JOIN ALIADOESTRATEGICO A ON CODALIADOESTRATEGICO = ID_ALIADOESTRATEGICO
      LEFT OUTER JOIN TIPOPRODUCTO T ON CODTIPOPRODUCTO = ID_TIPOPRODUCTO
      LEFT OUTER JOIN LINEADENEGOCIO L ON CODLINEADENEGOCIO = ID_LINEADENEGOCIO
      WHERE P.ACTIVE = CASE WHEN @p_active = -1 THEN P.ACTIVE ELSE @p_active END;
	  	 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_GetListWithData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_GetListWithData;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_GetListWithData(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
   	   
      SELECT P.ID_PRODUCTO,
             P.CODIGOGTECHPRODUCTO,
             P.NOMPRODUCTO,
             P.CODALIADOESTRATEGICO,
             A.NOMALIADOESTRATEGICO,
             P.CODTIPOPRODUCTO,
             T.NOMTIPOPRODUCTO,
             L.NOMLINEADENEGOCIO,
             P.PORCENTAJEGTECH,
             P.PORCENTAJEFIDUCIA,
             P.FECHAHORAMODIFICACION,
             P.CODUSUARIOMODIFICACION,
             P.ACTIVE
      FROM WSXML_SFG.PRODUCTO P
      LEFT OUTER JOIN ALIADOESTRATEGICO A ON CODALIADOESTRATEGICO = ID_ALIADOESTRATEGICO
      LEFT OUTER JOIN TIPOPRODUCTO T ON CODTIPOPRODUCTO = ID_TIPOPRODUCTO
      LEFT OUTER JOIN LINEADENEGOCIO L ON CODLINEADENEGOCIO = ID_LINEADENEGOCIO
      LEFT OUTER JOIN USUARIO ON ID_USUARIO = P.CODUSUARIOMODIFICACION
      WHERE P.ACTIVE = CASE WHEN @p_active = -1 THEN P.ACTIVE ELSE @p_active END;
	 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_GetListByCodAliadoAndCodTipo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_GetListByCodAliadoAndCodTipo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_GetListByCodAliadoAndCodTipo(@p_active          NUMERIC(22,0),
                                         @p_codAliadoEstrategico NUMERIC(22,0),
                                        @p_codTipoProducto NUMERIC(22,0)
                                                         ) AS
  BEGIN
  SET NOCOUNT ON;
   	 
      SELECT ID_PRODUCTO, NOMPRODUCTO FROM WSXML_SFG.PRODUCTO
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END
         AND CODALIADOESTRATEGICO = CASE WHEN @p_codAliadoEstrategico = -1 THEN CODALIADOESTRATEGICO ELSE @p_codAliadoEstrategico END
         AND CODTIPOPRODUCTO = CASE WHEN @p_codTipoProducto = -1 THEN CODTIPOPRODUCTO ELSE @p_codTipoProducto END
       ORDER BY NOMPRODUCTO;
	 	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTO_GetListLinea', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTO_GetListLinea;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTO_GetListLinea(@p_active NUMERIC(22,0), @p_Linea NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
   	   
      SELECT P.ID_PRODUCTO,
             P.CODIGOGTECHPRODUCTO,
             P.NOMPRODUCTO
      FROM WSXML_SFG.PRODUCTO P
      INNER JOIN WSXML_SFG.TIPOPRODUCTO T ON P.CODTIPOPRODUCTO = ID_TIPOPRODUCTO
      WHERE  T.CODLINEADENEGOCIO  = CASE WHEN @p_Linea = -1 THEN T.CODLINEADENEGOCIO ELSE @p_Linea END
      AND P.ACTIVE = @p_active;
	 	  
  END;
GO






