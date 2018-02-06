/* PACKAGE BODY              DWHSFGREPROCESOREVENUE */ 

IF OBJECT_ID('DWHSFGREPROCESOREVENUE_AddRecord', 'FN') IS NOT NULL
  DROP PROCEDURE DWH_REPTRANS.DWHSFGREPROCESOREVENUE_AddRecord;
GO

CREATE PROCEDURE DWH_REPTRANS.DWHSFGREPROCESOREVENUE_AddRecord(@p_CODPRODUCTO          FLOAT,
                      @p_FECHAARCHIVO         DATETIME) AS
 BEGIN

  SET NOCOUNT ON;
   
  DECLARE @p_FECHAPROCESO DATETIME = GETDATE();
  DECLARE @p_PROCESO VARCHAR(50) = 'RECALCULO REVENUE';
  DECLARE @v_COUNTRECORDS FLOAT = 0;

  BEGIN TRY 


      SELECT @v_COUNTRECORDS = COUNT(1) FROM  DWH_REPTRANS.REPROCESOREVENUE
      WHERE CODPRODUCTO = @p_CODPRODUCTO AND  FECHAARCHIVO = convert(datetime, convert(date,@p_FECHAARCHIVO)) ;

      IF @v_COUNTRECORDS > 0 BEGIN

        UPDATE DWH_REPTRANS.REPROCESOREVENUE
        SET FECHA = GETDATE()
        WHERE CODPRODUCTO = @p_CODPRODUCTO AND
			FECHAARCHIVO = convert(datetime, convert(date,@p_FECHAARCHIVO)) ;

      END 

      IF @v_COUNTRECORDS = 0 BEGIN
        INSERT INTO DWH_REPTRANS.REPROCESOREVENUE
        (
         FECHA,
         PROCESO,
         CODPRODUCTO,
         FECHAARCHIVO
        )
        VALUES
        (
          @p_FECHAPROCESO,
          @p_PROCESO,
          @p_CODPRODUCTO,
          convert(datetime, convert(date,@p_FECHAARCHIVO))
        );
      END 
	END TRY
	BEGIN CATCH
		RAISERROR('-20054 No se pudo insertar/actualizar dato Recalculo Revenue para proceso Repositorio de Datos - Reproceso Revenue', 16, 1);
	END CATCH

  END;
GO