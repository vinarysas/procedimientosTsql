USE SFGPRODU;
--  DDL for Function COMISIONSIMPLEINCENTIVO_F
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.COMISIONSIMPLEINCENTIVO_F', 'P') IS NOT NULL
    DROP PROCEDURE WSXML_SFG.COMISIONSIMPLEINCENTIVO_F;
GO

  CREATE PROCEDURE WSXML_SFG.COMISIONSIMPLEINCENTIVO_F (@p_CODTIPOCOMISION NUMERIC(22,0), @p_VALORPORCENTUAL NUMERIC(22,0), @p_VALORTRANSACCIONAL NUMERIC(22,0), @p_CODINCENTIVOCOMISIONGLOBAL NUMERIC(22,0), @commissionid NUMERIC(22,0))  AS
 BEGIN
 -- DECLARE @commissionid NUMERIC(22,0);
  DECLARE @coutdetailid NUMERIC(22,0);
  DECLARE @modifieruser NUMERIC(22,0) = 1;
  DECLARE @newrecord    NUMERIC(22,0) = 0;
  DECLARE @l_COMISIONFORMATSIMPLE_F NVARCHAR(2000)
  DECLARE @rowcount NUMERIC(22,0) = 0
  
  IF @p_CODTIPOCOMISION = 1 -- Porcentual
    BEGIN
		  SELECT @commissionid = ID_RANGOCOMISION 
		  FROM WSXML_SFG.RANGOCOMISION
		  INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE ON (CODRANGOCOMISION = ID_RANGOCOMISION)
		  WHERE CODTIPOCOMISION = @p_CODTIPOCOMISION AND VALORPORCENTUAL = @p_VALORPORCENTUAL AND VALORTRANSACCIONAL = 0 AND CODINCENTIVOCOMISIONGLOBAL = @p_CODINCENTIVOCOMISIONGLOBAL;
		 
		SET @rowcount  = @@ROWCOUNT;
		IF @ROWCOUNT = 0 BEGIN
			SET @l_COMISIONFORMATSIMPLE_F = WSXML_SFG.COMISIONFORMATSIMPLE_F(@p_CODTIPOCOMISION, @p_VALORPORCENTUAL, 0);
			EXEC WSXML_SFG.SFGRANGOCOMISION_AddRecord @l_COMISIONFORMATSIMPLE_F, @p_CODTIPOCOMISION, 2, @modifieruser, @commissionid OUT
			EXEC WSXML_SFG.SFGRANGOCOMISIONDETALLE_AddRecord @commissionid, NULL, NULL, @p_VALORPORCENTUAL, 0, NULL, NULL, 0, @modifieruser, @coutdetailid OUT
			UPDATE WSXML_SFG.RANGOCOMISION SET CODINCENTIVOCOMISIONGLOBAL = @p_CODINCENTIVOCOMISIONGLOBAL WHERE ID_RANGOCOMISION = @commissionid;
			SET @newrecord = 1;
		END		
		
    END;
  ELSE IF @p_CODTIPOCOMISION = 2 -- Transaccional
		BEGIN
			SELECT @commissionid = ID_RANGOCOMISION 
			FROM WSXML_SFG.RANGOCOMISION
			INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE ON (CODRANGOCOMISION = ID_RANGOCOMISION)
			WHERE CODTIPOCOMISION = @p_CODTIPOCOMISION AND VALORPORCENTUAL = 0 AND VALORTRANSACCIONAL = @p_VALORTRANSACCIONAL AND CODINCENTIVOCOMISIONGLOBAL = @p_CODINCENTIVOCOMISIONGLOBAL;
			
			SET @rowcount  = @@ROWCOUNT;
			
			IF @ROWCOUNT = 0 BEGIN
				SET @l_COMISIONFORMATSIMPLE_F = WSXML_SFG.COMISIONFORMATSIMPLE_F(@p_CODTIPOCOMISION, 0, @p_VALORTRANSACCIONAL)
				EXEC WSXML_SFG.SFGRANGOCOMISION_AddRecord @l_COMISIONFORMATSIMPLE_F, @p_CODTIPOCOMISION, 1, @modifieruser, @commissionid OUT
				EXEC WSXML_SFG.SFGRANGOCOMISIONDETALLE_AddRecord @commissionid, NULL, NULL, 0, @p_VALORTRANSACCIONAL, NULL, NULL, 0, @modifieruser, @coutdetailid OUT
				UPDATE WSXML_SFG.RANGOCOMISION SET CODINCENTIVOCOMISIONGLOBAL = @p_CODINCENTIVOCOMISIONGLOBAL WHERE ID_RANGOCOMISION = @commissionid;
				SET @newrecord = 1;
			END
		END
  ELSE IF @p_CODTIPOCOMISION = 3 -- Mixto
	BEGIN
		  SELECT @commissionid = ID_RANGOCOMISION 
		  FROM WSXML_SFG.RANGOCOMISION
		  INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE ON (CODRANGOCOMISION = ID_RANGOCOMISION)
		  WHERE CODTIPOCOMISION = @p_CODTIPOCOMISION AND VALORPORCENTUAL = @p_VALORPORCENTUAL AND VALORTRANSACCIONAL = @p_VALORTRANSACCIONAL AND CODINCENTIVOCOMISIONGLOBAL = @p_CODINCENTIVOCOMISIONGLOBAL;
		
		SET @rowcount  = @@ROWCOUNT;
		IF @ROWCOUNT = 0 BEGIN
			SET @l_COMISIONFORMATSIMPLE_F = WSXML_SFG.COMISIONFORMATSIMPLE_F(@p_CODTIPOCOMISION, @p_VALORPORCENTUAL, @p_VALORTRANSACCIONAL)
			EXEC WSXML_SFG.SFGRANGOCOMISION_AddRecord @l_COMISIONFORMATSIMPLE_F, @p_CODTIPOCOMISION, 3, @modifieruser, @commissionid OUT
			EXEC WSXML_SFG.SFGRANGOCOMISIONDETALLE_AddRecord @commissionid, NULL, NULL, @p_VALORPORCENTUAL, @p_VALORTRANSACCIONAL, NULL, NULL, 0, @modifieruser, @coutdetailid OUT
			UPDATE WSXML_SFG.RANGOCOMISION SET CODINCENTIVOCOMISIONGLOBAL = @p_CODINCENTIVOCOMISIONGLOBAL WHERE ID_RANGOCOMISION = @commissionid;
			SET @newrecord = 1;
		END;
	END
  ELSE BEGIN
   RAISERROR ('-20054 No se puede obtener una comision compuesta a partir de la función', 16,1);
   RETURN 0;
  END
  
  IF @newrecord = 1 BEGIN
      DECLARE @commissionname VARCHAR(4000) /* Use -meta option RANGOCOMISION.NOMRANGOCOMISION%TYPE */;
    BEGIN
      SET @commissionname = SFGRANGOCOMISION.GetCommissionName(@commissionid);
      UPDATE WSXML_SFG.RANGOCOMISION SET NOMRANGOCOMISION = @commissionname WHERE ID_RANGOCOMISION = @commissionid;
    END;
  END 
  
  IF @ROWCOUNT > 1 BEGIN
	RAISERROR('-20055 Error de consistencia en las comisiones simples del sistema. Por favor revisar.', 16,1);
	RETURN 0
  END
END 
GO

  

