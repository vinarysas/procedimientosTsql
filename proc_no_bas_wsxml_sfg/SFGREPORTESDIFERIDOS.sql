USE SFGPRODU;
--  DDL for Package Body SFGREPORTESDIFERIDOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREPORTESDIFERIDOS */ 

  IF OBJECT_ID('WSXML_SFG.SFGREPORTESDIFERIDOS_REPORTE_1CUOTA_DIFERIDOS', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTESDIFERIDOS_REPORTE_1CUOTA_DIFERIDOS;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTESDIFERIDOS_REPORTE_1CUOTA_DIFERIDOS(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                     @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                     @pg_CADENA                NVARCHAR(2000),
                                     @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                    @pg_PRODUCTO              NVARCHAR(2000)
                                     ) as
  BEGIN
  SET NOCOUNT ON;
     
      select isnull(Punto_De_Venta, ' ') as Punto_De_Venta,
             isnull(Identificacion, ' ') as Identificacion,
             isnull(Razon_Social, ' ') as Razon_Social,
             isnull(Regimen, ' ') as Regimen,
             isnull(Telefono, ' ') as Telefono,
             isnull(Direccion, ' ') as Direccion,
             isnull(Tipo_de_Pago, ' ') as Tipo_de_Pago,
             isnull(Cuota_No, 0) as Cuota_No,
             isnull(Valor_A_Pagar, 0) as Valor_A_Pagar,
             isnull(Fecha_en_que_se_Facturara, ' ') as Fecha_en_que_se_Facturara,
             isnull(Fecha_Consignacion, ' ') as Fecha_Consignacion,
             isnull(Valor_Consignado, 0) as Valor_Consignado,
             isnull(Sucursal, ' ') as Sucursal,
             isnull(Referencia_Consignacion, ' ') as Referencia_Consignacion,
             --             CODENTRADAARCHIVOCONTROL,
             fecha_prefacturacion
        from WSXML_SFG.VW_REPORTE_1CUOTA_DIFERIDOS
       where fecha_prefacturacion = DATEADD(day, -1, CONVERT(DATETIME, CONVERT(DATE,GETDATE())));
	
END

