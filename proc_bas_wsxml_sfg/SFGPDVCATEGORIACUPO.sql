USE SFGPRODU;
--  DDL for Package Body SFGPDVCATEGORIACUPO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPDVCATEGORIACUPO */ 

  IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_AddRecord(@p_CODCATEGORIACUPO        NUMERIC(22,0),
                      @p_CODPUNTOVENTA         NUMERIC(38,0),
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ID_PDVCATEGORIACUPO_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PDVCATEGORIACUPO SET ACTIVE = 0
    WHERE CODPUNTODEVENTA = @p_CODPUNTOVENTA AND ACTIVE = 1;
    INSERT INTO WSXML_SFG.PDVCATEGORIACUPO (
                                  CODPUNTODEVENTA,
                                  CODUSUARIOMODIFICACION,
                                  CODCATEGORIACUPO)
    VALUES (
            @p_CODPUNTOVENTA,
            @p_CODUSUARIOMODIFICACION,
            @p_CODCATEGORIACUPO);
    SET @p_ID_PDVCATEGORIACUPO_out = SCOPE_IDENTITY();
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_UpdateRecord(@pk_ID_PDVCATEGORIACUPO    NUMERIC(22,0),
                         @p_CODCATEGORIACUPO        NUMERIC(22,0),
                         @p_CODPUNTOVENTA           NUMERIC(38,0),
                         @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                         @p_ACTIVE                  NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PDVCATEGORIACUPO SET CODPUNTODEVENTA        = @p_CODPUNTOVENTA,
                                CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
                                FECHAHORAMODIFICACION  = GETDATE(),
                                ACTIVE                 = @p_ACTIVE,
                                CODCATEGORIACUPO       = @p_CODCATEGORIACUPO
    WHERE ID_PDVCATEGORIACUPO = @pk_ID_PDVCATEGORIACUPO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_DeactivateRecord(@pk_ID_PDVCATEGORIACUPO NUMERIC(22,0), @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PDVCATEGORIACUPO
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_PDVCATEGORIACUPO = @pk_ID_PDVCATEGORIACUPO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_GetRecord(@p_CODPUNTOVENTA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT PC.ID_PDVCATEGORIACUPO, CC.VALORCUPO FROM WSXML_SFG.PDVCATEGORIACUPO PC
      INNER JOIN CATEGORIACUPO CC ON PC.CODCATEGORIACUPO = CC.ID_CATEGORIACUPO
      WHERE PC.CODPUNTODEVENTA = @p_CODPUNTOVENTA AND PC.ACTIVE = 1;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_GetCuposActuales', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_GetCuposActuales;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_GetCuposActuales(@pk_ID_LINEADENEGOCIO NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT PDV.ID_PUNTODEVENTA
      , PDV.CODIGOGTECHPUNTODEVENTA as NUMERO
      , LDN.ID_LINEADENEGOCIO
      , ROUND
      (case when
      (
        ISNULL(CCP.VALORCUPO, 0) -- Cupo actual
        - ISNULL((DSP.SALDOCONTRAGTECH - DSP.SALDOAFAVORGTECH) + (DSP.SALDOCONTRAFIDUCIA - DSP.SALDOAFAVORFIDUCIA), 0) -- Saldo actual (positivo significa que debe)
        - ISNULL(VENTASDIARIAS.VENTASDIARIAS, 0)
       ) < 0  then 0 else
       (
        ISNULL(CCP.VALORCUPO, 0) -- Cupo actual
        - ISNULL((DSP.SALDOCONTRAGTECH - DSP.SALDOAFAVORGTECH) + (DSP.SALDOCONTRAFIDUCIA - DSP.SALDOAFAVORFIDUCIA), 0)
        - ISNULL(VENTASDIARIAS.VENTASDIARIAS, 0)
       ) end,0
       )
       -- Saldo actual
        -- - SUM(VENTAS - ANULACIONES)
        -- Ventas de la semana
        AS LIMITEGLOBAL
      FROM WSXML_SFG.PUNTODEVENTA PDV
        INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN ON (LDN.ID_LINEADENEGOCIO = @pk_ID_LINEADENEGOCIO)
        -- Saldo Semanal Actual (si no existe saldo, no se puede generar archivo de cupo)
        INNER JOIN WSXML_SFG.SALDOPDV SPV ON (SPV.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA AND SPV.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO)
        INNER JOIN WSXML_SFG.DETALLESALDOPDV DSP ON (DSP.ID_DETALLESALDOPDV = SPV.CODDETALLESALDOPDV)
        INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFPV ON DSP.CODMAESTROFACTURACIONPDV  = MFPV.ID_MAESTROFACTURACIONPDV
        INNER JOIN WSXML_SFG.CICLOFACTURACIONPDV CFP ON MFPV.CODCICLOFACTURACIONPDV = CFP.ID_CICLOFACTURACIONPDV
        LEFT OUTER JOIN (SELECT CTR.FECHAARCHIVO, REG.CODPUNTODEVENTA, TPR.CODLINEADENEGOCIO,
                         SUM(CASE WHEN REG.CODTIPOREGISTRO = 1 THEN REG.VALORTRANSACCION ELSE 0 END) -
                         SUM(CASE WHEN REG.CODTIPOREGISTRO = 2 THEN REG.VALORTRANSACCION ELSE 0 END) AS VENTASDIARIAS
                         FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
                         INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
                         INNER JOIN WSXML_SFG.PRODUCTO PRD ON (REG.CODPRODUCTO = PRD.ID_PRODUCTO)
                         INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                         WHERE CTR.FACTURADO = 0 AND CTR.REVERSADO = 0
                         GROUP BY CTR.FECHAARCHIVO, REG.CODPUNTODEVENTA, TPR.CODLINEADENEGOCIO) VENTASDIARIAS ON (VENTASDIARIAS.FECHAARCHIVO > CFP.FECHAEJECUCION
                                                                                                              AND VENTASDIARIAS.CODPUNTODEVENTA   = PDV.ID_PUNTODEVENTA
                                                                                                              AND VENTASDIARIAS.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO)
        -- Cupo asignado para resta. RIGHT OUTER HASH reemplazado por verificacion de
        LEFT OUTER JOIN WSXML_SFG.PDVCATEGORIACUPO PCC ON (PCC.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA
                                             AND PCC.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO
                                             AND PCC.ACTIVE = 1)
        LEFT OUTER JOIN WSXML_SFG.CATEGORIACUPO CCP ON (CCP.ID_CATEGORIACUPO = PCC.CODCATEGORIACUPO)
        WHERE LDN.ID_LINEADENEGOCIO = @pk_ID_LINEADENEGOCIO
        --Se debe quitar queda solo para pruebas
        --AND PDV.CODAGRUPACIONPUNTODEVENTA = WSXML_SFG.AGRUPACION_F(0)
        --AND PDV.ID_PUNTODEVENTA > 26331

        ;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_GetCuposActualesXTipoProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_GetCuposActualesXTipoProducto;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_GetCuposActualesXTipoProducto(@pk_ID_TIPOPRODUCTO NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT PDV.ID_PUNTODEVENTA
             , PDV.CODIGOGTECHPUNTODEVENTA as NUMERO
             , case when TPR.ID_TIPOPRODUCTO = 6 THEN 'evoucher' else 'erecharge' end as SERVICIO
             , LDN.ID_LINEADENEGOCIO, TPR.ID_TIPOPRODUCTO
             , 0 AS LIMITEDIARIO
            , ROUND(
            case when
            (
              ISNULL(CCP.VALORCUPO, 0) - -- Cupo actual
              ISNULL((DSP.SALDOCONTRAGTECH - DSP.SALDOAFAVORGTECH) +
              (DSP.SALDOCONTRAFIDUCIA - DSP.SALDOAFAVORFIDUCIA), 0)
             ) < 0  then 0 else
             (
              ISNULL(CCP.VALORCUPO, 0) - -- Cupo actual
              ISNULL((DSP.SALDOCONTRAGTECH - DSP.SALDOAFAVORGTECH) +
              (DSP.SALDOCONTRAFIDUCIA - DSP.SALDOAFAVORFIDUCIA), 0)
             ) end,0
             )
              AS LIMITEGLOBAL

      FROM WSXML_SFG.PUNTODEVENTA PDV
      INNER JOIN LINEADENEGOCIO LDN ON (1 = 1)
      INNER JOIN TIPOPRODUCTO TPR ON (TPR.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO
                                  AND TPR.ID_TIPOPRODUCTO = @pk_ID_TIPOPRODUCTO)
      -- Saldo Semanal Actual (si no existe saldo, no se puede generar archivo de cupo)
      INNER JOIN SALDOPDV SPV ON (SPV.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA AND SPV.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO)
      INNER JOIN DETALLESALDOPDV DSP ON (DSP.ID_DETALLESALDOPDV = SPV.CODDETALLESALDOPDV)
      -- Cupo asignado para resta. RIGHT OUTER HASH reemplazado por verificacion de
      LEFT OUTER JOIN PDVCATEGORIACUPO PCC ON (PCC.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA
                                           AND PCC.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO
                                           AND PCC.ACTIVE = 1)
      LEFT OUTER JOIN CATEGORIACUPO CCP ON (CCP.ID_CATEGORIACUPO = PCC.CODCATEGORIACUPO)
      WHERE TPR.ID_TIPOPRODUCTO = @pk_ID_TIPOPRODUCTO
      --Se debe quitar queda solo para pruebas
      --AND PDV.CODAGRUPACIONPUNTODEVENTA = WSXML_SFG.AGRUPACION_F(0)
      --AND PDV.ID_PUNTODEVENTA > 28847
      ;
  END;
GO




  IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_SetCupo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_SetCupo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_SetCupo(@p_CODCATEGORIACUPO       NUMERIC(22,0),
                    @p_CODPUNTODEVENTA        NUMERIC(22,0),
                    @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                    @p_CODTIPOVINCULACION     NUMERIC(22,0),
                    @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      DECLARE @ruleRPLACE NUMERIC(22,0) = 0;
      DECLARE @ruleEXISTS NUMERIC(22,0) = 0;
    BEGIN
      -- Primero: Hay que verificar que el pdv no clasifique bajo una de las reglas
      DECLARE tREGLASCUPOS CURSOR FOR SELECT ID_PDVCATEGORIACUPO, CODPUNTODEVENTA, CODTIPOVINCULACION, CODCATEGORIACUPO FROM WSXML_SFG.PDVCATEGORIACUPO WHERE CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO AND ACTIVE = 1; 
	  OPEN tREGLASCUPOS;

	  DECLARE @tREGLASCUPOS__ID_PDVCATEGORIACUPO NUMERIC(38,0), @tREGLASCUPOS__CODPUNTODEVENTA NUMERIC(38,0), 
		@tREGLASCUPOS__CODTIPOVINCULACION NUMERIC(38,0), @tREGLASCUPOS__CODCATEGORIACUPO NUMERIC(38,0)

	 FETCH NEXT FROM tREGLASCUPOS INTO @tREGLASCUPOS__ID_PDVCATEGORIACUPO, @tREGLASCUPOS__CODPUNTODEVENTA, @tREGLASCUPOS__CODTIPOVINCULACION, @tREGLASCUPOS__CODCATEGORIACUPO
	 WHILE @@FETCH_STATUS=0
	 BEGIN
          DECLARE @thisTIPOVINCULACION NUMERIC(22,0);
        BEGIN
          SET @thisTIPOVINCULACION = @tREGLASCUPOS__CODTIPOVINCULACION;
          IF @thisTIPOVINCULACION = 1 BEGIN
              -- Debe ser el mismo punto de venta
              IF @tREGLASCUPOS__CODPUNTODEVENTA = @p_CODPUNTODEVENTA BEGIN
                SET @ruleEXISTS = 1;
              END 
            END ELSE IF @thisTIPOVINCULACION =  2 BEGIN
              -- Debe ser el mismo NIT
              SELECT @ruleEXISTS = 0-- CASE WHEN rule.IDENTIFICACION = this.IDENTIFICACION THEN 1 ELSE 0 END;

            END ELSE IF @thisTIPOVINCULACION = 3 BEGIN
              -- Debe ser la misma cadena
				SELECT @ruleEXISTS = 0--CASE WHEN rule.CODAGRUPACIONPUNTODEVENTA = this.CODAGRUPACIONPUNTODEVENTA THEN 1 ELSE 0 END;

			END 

          IF @ruleEXISTS = 1 BEGIN
            -- Si se encuentra el mismo parametro; no hay que reemplazar la regla
            IF @p_CODCATEGORIACUPO = @tREGLASCUPOS__CODCATEGORIACUPO BEGIN
              SET @ruleRPLACE = 0;
            END
            ELSE BEGIN
              SET @ruleRPLACE = @tREGLASCUPOS__ID_PDVCATEGORIACUPO;
            END 
			BREAK
          END 
        END;

      FETCH NEXT FROM tREGLASCUPOS INTO @tREGLASCUPOS__ID_PDVCATEGORIACUPO, @tREGLASCUPOS__CODPUNTODEVENTA, @tREGLASCUPOS__CODTIPOVINCULACION, @tREGLASCUPOS__CODCATEGORIACUPO
      END;

      CLOSE tREGLASCUPOS;
      DEALLOCATE tREGLASCUPOS;
      IF @ruleEXISTS = 1 AND @ruleRPLACE > 0 BEGIN
        UPDATE WSXML_SFG.PDVCATEGORIACUPO SET ACTIVE = 0 WHERE ID_PDVCATEGORIACUPO = @ruleRPLACE;
      END 
      -- Ingresar nueva regla
      IF NOT (@ruleEXISTS = 1 AND @ruleRPLACE = 0) begin
        INSERT INTO WSXML_SFG.PDVCATEGORIACUPO (--ID_PDVCATEGORIACUPO,
                                      CODCATEGORIACUPO,
                                      CODPUNTODEVENTA,
                                      CODTIPOVINCULACION,
                                      CODLINEADENEGOCIO,
                                      CODUSUARIOMODIFICACION)
        SELECT --PDVCATEGORIACUPO_SEQ.NEXTVAL,
                @p_CODCATEGORIACUPO,
                @p_CODPUNTODEVENTA,
                @p_CODTIPOVINCULACION,
                @p_CODLINEADENEGOCIO,
                @p_CODUSUARIOMODIFICACION
      END 
	END
END

GO




  IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_ObtenerIDPorValor', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_ObtenerIDPorValor;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_ObtenerIDPorValor(@p_VALORCUPO FLOAT,
                      @p_ID_PDVCATEGORIACUPO_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SET @p_ID_PDVCATEGORIACUPO_out = WSXML_SFG.SFGPDVCATEGORIACUPO_GetIDByValue(@p_VALORCUPO);

  END;
GO



  IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_ObtenerIDPorValor', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_ObtenerIDPorValor;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPDVCATEGORIACUPO_ObtenerIDPorValor(@p_VALORCUPO FLOAT,
                      @p_ID_PDVCATEGORIACUPO_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SET @p_ID_PDVCATEGORIACUPO_out = WSXML_SFG.SFGPDVCATEGORIACUPO_GetIDByValue(@p_VALORCUPO);

  END;
  GO
  
IF OBJECT_ID('WSXML_SFG.SFGPDVCATEGORIACUPO_GetIDByValue', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGPDVCATEGORIACUPO_GetIDByValue;
GO

CREATE FUNCTION WSXML_SFG.SFGPDVCATEGORIACUPO_GetIDByValue(
  @p_VALORCUPO FLOAT
) RETURNS NUMERIC(22,0) AS
BEGIN
  DECLARE @result NUMERIC(22,0) = 0
  DECLARE @msg    NVARCHAR(2000) = ''
  
  SELECT @result = isnull(cc.id_categoriacupo,0) 
  FROM WSXML_SFG.categoriacupo cc
  WHERE cc.valorcupo = @p_VALORCUPO
  
  IF @@ROWCOUNT = 0 
  BEGIN
    SET @msg = 'CupoAutomatico: ' + @p_VALORCUPO
    EXEC WSXML_SFG.SFGCATEGORIACUPO_AddRecord @msg, @p_VALORCUPO, 1, 0, @result out
  END 
  
  RETURN @result
  
END
GO