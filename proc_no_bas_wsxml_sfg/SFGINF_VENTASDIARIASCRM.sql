USE SFGPRODU;
GO
--  DDL for Package Body SFGINF_VENTASDIARIASCRM
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_VENTASDIARIASCRM */ 
  -- Sql server no soporta la funcion UTL_FILE

  IF OBJECT_ID('WSXML_SFG.SFGINF_VENTASDIARIASCRM_GetSalesByDay', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCRM_GetSalesByDay;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCRM_GetSalesByDay(@p_FECHAGENERACION DATETIME) AS
 BEGIN

    DECLARE cur_rec CURSOR LOCAL FOR
      SELECT --rownum as fila, --inicial masivo
             ID_PDV,
             ID_PRODUCTO,
             CANTIDAD_MONTO,
             CANTIDAD_EN_TX,
             FECHA_TRANSACCION
        FROM (SELECT PREF.CODIGOGTECHPUNTODEVENTA AS ID_PDV, -- Id_PDV,
                     PREF.CODIGOGTECHPRODUCTO AS ID_PRODUCTO, -- Id_Producto,
                     SUM(PREF.INGRESOS) AS CANTIDAD_MONTO, -- Cantidad Monto,
                     SUM(PREF.NUMINGRESOS) AS CANTIDAD_EN_TX, -- Cantidad en TX,
                     convert(varchar(10), PREF.FECHAARCHIVO, 111) AS FECHA_TRANSACCION -- Fecha Transacci?n
              FROM WSXML_SFG.VW_PREFACTURACION_DIARIA PREF
              --FROM WSXML_SFG.VW_PREFACTURACION_DIARIA@SFG_PRIMARY PREF --inicial masivo
              WHERE (PREF.FECHAARCHIVO BETWEEN CONVERT(DATETIME, CONVERT(DATE,@p_FECHAGENERACION)) AND CONVERT(DATETIME, CONVERT(DATE,@p_FECHAGENERACION)))
              --WHERE (PREF.FECHAARCHIVO BETWEEN TRUNC(TO_DATE('01/JAN/2012')) AND TRUNC(TO_DATE('03/MAY/2012'))) --inicial masivo
               AND PREF.NUMINGRESOS > 0
               AND PREF.INGRESOS > 0
               GROUP BY PREF.FECHAARCHIVO,
                        PREF.CODIGOGTECHPUNTODEVENTA,
                        PREF.CODIGOGTECHPRODUCTO) s;

    DECLARE @v_file UTL_FILE.FILE_TYPE;

   
  SET NOCOUNT ON;
    BEGIN
      SET @v_file = UTL_FILE.FOPEN(location     => 'INXAITCORPCRM',
                               filename     => 'SalesByDay_' +
                                               isnull(convert(varchar(8), @p_FECHAGENERACION,
                                                       112), '') + '.CSV',
                               open_mode    => 'w',
                               max_linesize => 32767);
      
	  OPEN cur_rec;

	  DECLARE @cur_rec__ID_PDV NUMERIC(38,0),
             @cur_rec__ID_PRODUCTO NUMERIC(38,0),
             @cur_rec__CANTIDAD_MONTO FLOAT,
             @cur_rec__CANTIDAD_EN_TX NUMERIC(22,0),
             @cur_rec__FECHA_TRANSACCION VARCHAR(10)
	 FETCH NEXT FROM cur_rec INTO @cur_rec__ID_PDV , @cur_rec__ID_PRODUCTO , @cur_rec__CANTIDAD_MONTO , @cur_rec__CANTIDAD_EN_TX , @cur_rec__FECHA_TRANSACCION ;
	 WHILE @@FETCH_STATUS=0
	 BEGIN
        UTL_FILE.PUT_LINE(@v_file,
                          --'' || cur_rec.fila || ';' || cur_rec.ID_PDV || ';' ||  --inicial masivo
                          '' + ISNULL(@cur_rec__ID_PDV, '') + ';' +
                           ISNULL(@cur_rec__ID_PRODUCTO, '') + ';' +
                           ISNULL(@cur_rec__CANTIDAD_MONTO, '') + ';' +
                           ISNULL(@cur_rec__CANTIDAD_EN_TX, '') + ';' +
                           ISNULL(@cur_rec__FECHA_TRANSACCION, '') );
     
		FETCH NEXT FROM cur_rec INTO @cur_rec__ID_PDV , @cur_rec__ID_PRODUCTO , @cur_rec__CANTIDAD_MONTO , @cur_rec__CANTIDAD_EN_TX , @cur_rec__FECHA_TRANSACCION ;
      END;
      CLOSE cur_rec;
      DEALLOCATE cur_rec;
      
	  UTL_FILE.FCLOSE(@v_file);

     EXCEPTION
    WHEN utl_file.invalid_mode THEN
      RAISERROR('-20051 Invalid Mode Parameter', 16, 1);
    WHEN utl_file.invalid_path THEN
      RAISERROR('-20052 Invalid File Location', 16, 1);
    WHEN utl_file.invalid_filehandle THEN
      RAISERROR('-20053 Invalid Filehandle', 16, 1);
    WHEN utl_file.invalid_operation THEN
      RAISERROR('-20054 Invalid Operation', 16, 1);
    WHEN utl_file.read_error THEN
      RAISERROR('-20055 Read Error', 16, 1);
    WHEN utl_file.internal_error THEN
      RAISERROR('-20057 Internal Error', 16, 1);
    WHEN utl_file.charsetmismatch THEN
      RAISERROR('-20058 Opened With FOPEN_NCHAR But Later I/O Inconsistent', 16, 1);
    WHEN utl_file.file_open THEN
      RAISERROR('-20059 File Already Opened', 16, 1);
    WHEN utl_file.invalid_maxlinesize THEN
      RAISERROR('-20060 Line Size Exceeds 32K', 16, 1);
    WHEN utl_file.invalid_filename THEN
      RAISERROR('-20061 Invalid File Name', 16, 1);
    WHEN utl_file.access_denied THEN
      RAISERROR('-20062 File Access Denied By', 16, 1);
    WHEN utl_file.invalid_offset THEN
      RAISERROR('-20063 FSEEK Param Less Than 0', 16, 1);
    WHEN others THEN
       UTL_FILE.FCLOSE(@v_file);
      RAISERROR('-20099 Unknown UTL_FILE Error', 16, 1);
    END;

  END;

END 
GO

