USE SFGPRODU;
--  DDL for Package Body SFG_ARCHIVO_L1ADVSAL1
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1 */ 

  IF OBJECT_ID('WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecord(@p_CODPRODUCTO      NUMERIC(22,0),
                      @p_CDCARCHIVO       NUMERIC(22,0),
                      @p_SORTEO           NUMERIC(22,0),
                      @p_VENTA            NUMERIC(22,0),
                      @p_FECHA            DATETIME,
                      @p_FECHAARCHIVO     DATETIME,
                      @p_ID_ARCHIVO_L1ADVSAL1_out NUMERIC(22,0) OUT) AS
 BEGIN

  DECLARE @l_count INTEGER;
  DECLARE @p_ID_ARCHIVO_L1ADVSAL1 NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*)
           FROM WSXML_SFG.ARCHIVO_L1ADVSAL1
           WHERE ID_PRODUCTO = @p_CODPRODUCTO and CDC_ARCHIVO=@p_CDCARCHIVO AND SORTEO=@p_SORTEO
           AND FECHA=@p_FECHA AND FECHAARCHIVO=@p_FECHAARCHIVO;

    IF @l_count = 0 BEGIN
       
        INSERT INTO WSXML_SFG.ARCHIVO_L1ADVSAL1(ID_PRODUCTO,CDC_ARCHIVO,SORTEO,VENTA,FECHA,FECHAARCHIVO,ACTIVE)
        VALUES (@p_CODPRODUCTO,@p_CDCARCHIVO,@p_SORTEO,@p_VENTA,CONVERT(DATETIME, CONVERT(DATE,@p_FECHA)),CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO)),1);

		SET @p_ID_ARCHIVO_L1ADVSAL1  = SCOPE_IDENTITY();

     END 

     IF @l_count >= 1 BEGIN
        SELECT @p_ID_ARCHIVO_L1ADVSAL1_out = (
			SELECT  ID_ARCHIVO_L1ADVSAL1
			FROM WSXML_SFG.ARCHIVO_L1ADVSAL1
			WHERE ID_PRODUCTO = @p_CODPRODUCTO 
				and CDC_ARCHIVO=@p_CDCARCHIVO AND @p_SORTEO=@p_SORTEO and active =1
				AND FECHA=@p_FECHA AND FECHAARCHIVO=@p_FECHAARCHIVO
		)

		EXEC WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_UpdateRecord 
			@p_ID_ARCHIVO_L1ADVSAL1_out,@p_CODPRODUCTO,@p_CDCARCHIVO,@p_SORTEO,@p_VENTA,@p_FECHA,@p_FECHAARCHIVO,0;

	
		INSERT INTO WSXML_SFG.ARCHIVO_L1ADVSAL1(ID_PRODUCTO,CDC_ARCHIVO,SORTEO,VENTA,FECHA,FECHAARCHIVO,ACTIVE)
			VALUES (@p_CODPRODUCTO,@p_CDCARCHIVO,@p_SORTEO,@p_VENTA,CONVERT(DATETIME, CONVERT(DATE,@p_FECHA)),CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO)),1);

		SET @p_ID_ARCHIVO_L1ADVSAL1 = SCOPE_IDENTITY();
        END 
    -- END IF;
   SET @p_ID_ARCHIVO_L1ADVSAL1_OUT=@p_ID_ARCHIVO_L1ADVSAL1;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_UpdateRecord(@pk_ID_ARCHIVO_L1ADVSAL1    NUMERIC(22,0),
                         @p_CODPRODUCTO     NUMERIC(22,0),
                         @p_CDCARCHIVO      NUMERIC(22,0),
                         @p_SORTEO          NUMERIC(22,0),
                         @p_VENTA           NUMERIC(22,0),
                         @p_FECHA           DATETIME,
                         @P_FECHAARCHIVO    DATETIME,
                         @p_ACTIVE          NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ARCHIVO_L1ADVSAL1
       SET ID_PRODUCTO = @p_CODPRODUCTO,
           CDC_ARCHIVO = @p_CDCARCHIVO,
           SORTEO = @p_SORTEO,
           VENTA = @p_VENTA,
           FECHA = CONVERT(DATETIME, CONVERT(DATE,@p_FECHA)),
           FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@P_FECHAARCHIVO)),
           ACTIVE=@p_ACTIVE
     WHERE ID_ARCHIVO_L1ADVSAL1 = @pk_ID_ARCHIVO_L1ADVSAL1;
	
	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetRecord;
GO
CREATE PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetRecord(@pk_ID_ARCHIVO_L1ADVSAL1 NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 WHERE ID_ARCHIVO_L1ADVSAL1 = @pk_ID_ARCHIVO_L1ADVSAL1;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

       
	  SELECT ID_ARCHIVO_L1ADVSAL1,
             ID_PRODUCTO,
             CDC_ARCHIVO,
             SORTEO,
             VENTA,
             FECHA,
             FECHAARCHIVO
      FROM WSXML_SFG.ARCHIVO_L1ADVSAL1
      WHERE ID_ARCHIVO_L1ADVSAL1 = @pk_ID_ARCHIVO_L1ADVSAL1 AND ACTIVE=1;
	  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetList AS
  BEGIN
  SET NOCOUNT ON;
     
	SELECT ID_ARCHIVO_L1ADVSAL1,
             ID_PRODUCTO,
             CDC_ARCHIVO,
             SORTEO,
             VENTA,
             FECHA,
             FECHAARCHIVO
      FROM WSXML_SFG.ARCHIVO_L1ADVSAL1
      WHERE ACTIVE=1;
	   
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetListByCDC', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetListByCDC;
GO
CREATE     PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetListByCDC(@p_SORTEO  NUMERIC(22,0),@p_CDCmaximo NUMERIC(22,0) ) AS
    BEGIN
    SET NOCOUNT ON;

       
	  SELECT SORTEO,NOMPRODUCTO,SUM(A.ingresosjugadasavanzadas) as venta
      FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 A
		inner join WSXML_SFG.producto P on P.ID_PRODUCTO = A.ID_PRODUCTO
      WHERE A.ACTIVE=1 AND A.SORTEO>@p_SORTEO and A.CDC_ARCHIVO <=@p_CDCmaximo
      GROUP BY SORTEO,NOMPRODUCTO;
	   

   END;
GO


-- Revisar el procedimiento
-- Error Incorrect syntax near the keyword 'AS'.
IF OBJECT_ID('WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetVentasSemana', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetVentasSemana;
GO
CREATE       PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_GetVentasSemana(@p_Fecha  datetime,@p_producto NUMERIC(22,0)) AS
 BEGIN
     DECLARE @P_FECHA_V DATETIME;
     DECLARE @P_FECHAINICIO DATETIME;
     DECLARE @P_FECHAFIN DATETIME;
     DECLARE @p_ADICIONES NUMERIC(22,0);
     DECLARE @P_RETIROS NUMERIC(22,0);
     DECLARE @P_SALDOINICIAL NUMERIC(22,0);
     DECLARE @P_SALDOFINAL NUMERIC(22,0);
     DECLARE @P_FECHASALDO DATETIME;

      
     SET NOCOUNT ON;

      SET @P_FECHA_V = @p_Fecha - 7;
      --SET @P_FECHAINICIO = @P_FECHA_V - TO_NUMBER(to_char(@P_FECHA_V,'d','NLS_DATE_LANGUAGE=ENGLISH'))+ 1;
	  SET @P_FECHAINICIO = @P_FECHA_V - CAST(FORMAT(@P_FECHA_V,'d') AS INT)+ 1;
      SET @P_FECHAFIN = @P_FECHAINICIO + 6;

      --OPEN P_CUR FOR
   select
		@P_RETIROS = Sum(case when (fecha between @P_FECHAINICIO and @P_FECHAFIN) then venta else 0 end),

         @p_ADICIONES = sum( 
				case 
				when (fechaarchivo between @P_FECHAINICIO and @P_FECHAFIN) 
					and (fecha not between @P_FECHAINICIO and @P_FECHAFIN)
				then  (venta) else 0
				end
			) 
    from WSXML_SFG.archivo_l1advsal1 
	where archivo_l1advsal1.active=1 AND ID_PRODUCTO=@p_producto;

    select @P_SALDOINICIAL = SALDOFINAL, @P_FECHASALDO = fecha  
	from WSXML_SFG.SaldosAvanzadas 
	where CODPRODUCTO=@p_producto 
	order by 2 desc;


    SET @P_SALDOFINAL=(@P_SALDOINICIAL+@p_ADICIONES)-@P_RETIROS;

    EXEC WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecordSaldosAvanzadas 
	@P_SALDOINICIAL,@p_ADICIONES,@P_RETIROS,@P_SALDOFINAL,@p_Fecha,@p_producto

	  
	select @P_SALDOINICIAL as SaldoInicial,@P_RETIROS as Retiros,@p_ADICIONES as Adiones,@P_SALDOFINAL as SaldoFinal;
	 

   END
GO

IF OBJECT_ID('WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecordSaldosAvanzadas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecordSaldosAvanzadas;
GO

CREATE       PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecordSaldosAvanzadas(@p_SALDOINICIAL NUMERIC(22,0),
                                      @p_ADICIONES NUMERIC(22,0),
                                      @p_RETIROS NUMERIC(22,0),
                                      @p_SALDOFINAL NUMERIC(22,0),
                                      @p_FECHA DATETIME,
                                      @p_CODPRODUCTO NUMERIC(22,0)
                                     ) AS
  BEGIN
  SET NOCOUNT ON;
        INSERT INTO WSXML_SFG.SaldosAvanzadas(
                                      SALDOINICIAL,
                                      ADICIONES,
                                      RETIROS,
                                      SALDOFINAL,
                                      FECHA,
                                      CODPRODUCTO)
        VALUES (
                @p_SALDOINICIAL,
                @p_ADICIONES,
                @p_RETIROS,
                @p_SALDOFINAL,
                CONVERT(DATETIME, CONVERT(DATE,@p_FECHA)),
                @p_CODPRODUCTO);

--   p_ID_ARCHIVO_L1ADVSAL1_OUT:=p_ID_ARCHIVO_L1ADVSAL1;
  END;
GO

--   Revisar procedimiento con funcion sfgpremiosl1liab.GetProductobyNombre
IF OBJECT_ID('WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_SaveArchivoAvanzadas', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_SaveArchivoAvanzadas;
go

create     PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_SaveArchivoAvanzadas( @p_PRODUCTO      varchar(4000),
                                  @p_CDCARCHIVO       NUMERIC(22,0),
                                  @p_SORTEO           NUMERIC(22,0),
                                  @p_VENTA            NUMERIC(22,0),
                                  @p_VENTABRUTA       NUMERIC(22,0),
                                  @p_IVA              NUMERIC(22,0),
                                  @p_INGRESOSJUGADASAVANZADAS NUMERIC(22,0),
                                  @p_TOTALINGRESOSAVANZADAS   NUMERIC(22,0),
                                  @p_FECHA            DATETIME,
                                  @p_FECHAARCHIVO     DATETIME,
                                  @p_ID_ARCHIVO_L1ADVSAL1_out NUMERIC(22,0) OUT) AS
 BEGIN
                                  
                                  
  DECLARE @vCodProducto NUMERIC(22,0);
   
  SET NOCOUNT ON;
    
   EXEC WSXML_SFG.sfgpremiosl1liab_GetProductobyNombre @p_PRODUCTO, @vCodProducto OUT
  
    INSERT INTO WSXML_SFG.ARCHIVO_L1ADVSAL1(
                                    ID_PRODUCTO,
                                    CDC_ARCHIVO,
                                    SORTEO,
                                    VENTA,
                                    FECHA,
                                    FECHAARCHIVO,
                                    ACTIVE, 
                                    VENTABRUTA, 
                                    IVA,
                                    INGRESOSJUGADASAVANZADAS,
                                    TOTALINGRESOSAVANZADAS)
        VALUES (
                @vCodProducto,
                @p_CDCARCHIVO,
                @p_SORTEO,
                @p_VENTA,
                CONVERT(DATETIME, CONVERT(DATE,@p_FECHA)),
                CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO)),1, 
                @p_VENTABRUTA,
                @p_IVA, 
                @p_INGRESOSJUGADASAVANZADAS,
                @p_TOTALINGRESOSAVANZADAS);
         SET
                @p_ID_ARCHIVO_L1ADVSAL1_out = SCOPE_IDENTITY();
   END;
GO
   
 IF OBJECT_ID('WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_ReverseArchivoAvanzadas', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_ReverseArchivoAvanzadas;
go

create       PROCEDURE WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_ReverseArchivoAvanzadas( @p_CDCARCHIVO       NUMERIC(22,0)) as
     begin
     set nocount on; 
       delete from wsxml_sfg.archivo_l1advsal1 where cdc_archivo = @p_CDCARCHIVO;
     END;

