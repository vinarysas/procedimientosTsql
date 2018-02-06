USE SFGPRODU;
--  DDL for Package Body SFGPLANTILLAPRODUCTOMASIVA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA */ 

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListLineadeNegocio', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListLineadeNegocio;
GO
CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListLineadeNegocio
AS
BEGIN
SET NOCOUNT ON;
     SELECT ID_LINEADENEGOCIO, NOMLINEADENEGOCIO
    FROM WSXML_SFG.LINEADENEGOCIO;
END;
  GO

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListProductoxLineadeNegocio', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListProductoxLineadeNegocio;
GO

CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListProductoxLineadeNegocio(
    @p_CODLINEADENEGOCIO integer)
AS

BEGIN
SET NOCOUNT ON;
     SELECT ID_PRODUCTO, NOMPRODUCTO
    FROM WSXML_SFG.PRODUCTO
    INNER JOIN TIPOPRODUCTO ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
    WHERE TIPOPRODUCTO.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
    order by nomproducto;
END;
GO  

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetComisionPlantillasxprod', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetComisionPlantillasxprod;
GO

CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetComisionPlantillasxprod(@p_CODLINEADENEGOCIO NUMERIC(22,0),
                                         @p_CODPRODUCTO NUMERIC(22,0))
  AS 
  BEGIN
  SET NOCOUNT ON;
    
       select plantillaproducto.nomplantillaproducto,
           isnull(convert(varchar, rangocomisiondetalle.valorporcentual), ' '), 
           isnull(convert(varchar, rangocomisiondetalle.valortransaccional), ' '), 
           tipocomision.nomtipocomision, 
           isnull(plantillaproductodetalle.id_plantillaproductodetalle, 0) as id_plantillaproductodetalle,
           plantillaproducto.codlineadenegocio
     from WSXML_SFG.plantillaproducto
     left outer join plantillaproductodetalle on plantillaproductodetalle.codplantillaproducto = plantillaproducto.id_plantillaproducto 
     and plantillaproductodetalle.codproducto = @p_CODPRODUCTO
     left outer join rangocomision on plantillaproductodetalle.codrangocomision = rangocomision.id_rangocomision
     left outer join rangocomisiondetalle on rangocomisiondetalle.codrangocomision = rangocomision.id_rangocomision
     left outer join tipocomision  on tipocomision.id_tipocomision = rangocomision.codtipocomision
     where plantillaproducto.codlineadenegocio =  @p_CODLINEADENEGOCIO;

  END;
  GO

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetComisionproductosxplantilla', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetComisionproductosxplantilla;
GO

CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetComisionproductosxplantilla(@p_CODLINEADENEGOCIO NUMERIC(22,0),
                                         @p_CODPLANTILLA NUMERIC(22,0))
AS 
BEGIN
SET NOCOUNT ON;
         select 
       producto.nomproducto, 
      isnull(convert(varchar, rangocomisiondetalle.valorporcentual), ' ') as valorporcentual,
      isnull(convert(varchar, rangocomisiondetalle.valortransaccional), ' ') as valortransaccional, 
      tipoproducto.codlineadenegocio,
       tipocomision.nomtipocomision,
      plantillaproductodetalle.id_plantillaproductodetalle,
      producto.id_producto
      from WSXML_SFG.producto
      left outer join WSXML_SFG.plantillaproductodetalle on plantillaproductodetalle.codproducto = producto.id_producto and plantillaproductodetalle.codplantillaproducto = @p_CODPLANTILLA
      left outer join WSXML_SFG.rangocomision on plantillaproductodetalle.codrangocomision = rangocomision.id_rangocomision
      left outer join WSXML_SFG.tipoproducto on tipoproducto.id_tipoproducto = producto.codtipoproducto
      left outer join WSXML_SFG.rangocomisiondetalle on rangocomisiondetalle.codrangocomision = rangocomision.id_rangocomision
      left outer join WSXML_SFG.tipocomision  on tipocomision.id_tipocomision = rangocomision.codtipocomision
      where tipoproducto.codlineadenegocio = @p_CODLINEADENEGOCIO
      ORDER BY PRODUCTO.NOMPRODUCTO;
 
                END;
  GO
                
           
 IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_SaveComisionplantillas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_SaveComisionplantillas;
GO

CREATE   PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_SaveComisionplantillas(@pk_id_plantillaproductodetalle NUMERIC(22,0),
                                 @p_CODPLANTILLAPRODUCTO NUMERIC(22,0),
                                 @p_CODPRODUCTO NUMERIC(22,0),
                                 @p_CODRANGOCOMISION NUMERIC(22,0),
                                 @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                                 @p_ACTIVE NUMERIC(22,0),
                                 @p_ID_PLANTILLAPRODUCTODETA_OUT NUMERIC(22,0) OUT)
  as 
  begin
  set nocount on;
    
	DECLARE @FECHAHOY DATETIME = GETDATE();
    if @pk_id_plantillaproductodetalle = 0 begin
      EXEC WSXML_SFG.sfgwebplantillaproductodetalle_AddRecord 
												@p_CODPLANTILLAPRODUCTO,
                                               @p_CODPRODUCTO,
                                               @p_CODRANGOCOMISION,
                                               @FECHAHOY,
                                               @p_CODUSUARIOMODIFICACION,
                                               @p_ACTIVE,
                                               @p_ID_PLANTILLAPRODUCTODETA_OUT OUT
           
      end
      else begin 
        EXEC WSXML_SFG.sfgwebplantillaproductodetalle_UpdateRecord 
													@pk_id_plantillaproductodetalle,
                                                    @p_CODPLANTILLAPRODUCTO,
                                                   @p_CODPRODUCTO,
                                                   @p_CODRANGOCOMISION,
                                                   @FECHAHOY,
                                                   @p_CODUSUARIOMODIFICACION,
                                                   @p_ACTIVE
          
                                                   
                                                   
      end 
end;   
GO
  
IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListRangoComision', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListRangoComision;
go
create PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListRangoComision
  as
  begin
  set nocount on;
                     select id_rangocomision, rangocomisiondetalle.valorporcentual, rangocomisiondetalle.valortransaccional
            from WSXML_SFG.rangocomision
            inner join rangocomisiondetalle on rangocomisiondetalle.codrangocomision = rangocomision.id_rangocomision
            where rangocomision.active = 1;
            
    end;
   GO
IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListPlantillaProducto', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListPlantillaProducto;
go
create PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetListPlantillaProducto
  as
  begin
  set nocount on;
                     select id_plantillaproducto, nomplantillaproducto
            from WSXML_SFG.plantillaproducto;
    end; 
   GO

  IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetIdRangocomision', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetIdRangocomision;
go

create     PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetIdRangocomision(@p_valorporcentual numeric(38,0),
                               @p_valortransaccional numeric(38,0),
                               @p_nomtipocomision varchar,
                               @p_idrangocomision integer out)
    as 
    begin
    set nocount on;
      
   
      
        select @p_idrangocomision = min(rangocomision.id_rangocomision)
        from WSXML_SFG.rangocomision
        inner join tipocomision on rangocomision.codtipocomision = tipocomision.id_tipocomision
        inner join rangocomisiondetalle on rangocomision.id_rangocomision = rangocomisiondetalle.codrangocomision
        where tipocomision.nomtipocomision = @p_nomtipocomision
        and rangocomisiondetalle.valorporcentual = @p_valorporcentual
        and rangocomisiondetalle.valortransaccional = @p_valortransaccional
        and nomrangocomision not like '%Rangos Tiempo%';
        
   
end;
 GO
IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetIdPlantillaProducto', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetIdPlantillaProducto;
go

create PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetIdPlantillaProducto(@p_nombreplantillaproducto varchar,
                                  @p_idplantillaproducto integer out)
                                  
as
begin
set nocount on;
  select @p_idplantillaproducto = plantillaproducto.id_plantillaproducto
  from WSXML_SFG.plantillaproducto
  where UPPER(plantillaproducto.nomplantillaproducto) = UPPER(@p_nombreplantillaproducto)
  and active = 1;
  end;
  GO

 IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetIdLineadeNegocio', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetIdLineadeNegocio;
go

create   PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetIdLineadeNegocio(@p_idplantillaproducto NUMERIC(22,0),
                               @p_IdLineadeNegocio NUMERIC(22,0) out)
   as
   begin
   set nocount on;
      select @p_IdLineadeNegocio = plantillaproducto.codlineadenegocio
      from WSXML_SFG.plantillaproducto
      where plantillaproducto.id_plantillaproducto = @p_idplantillaproducto;
      end;

  GO 
    IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_Deleteproductoplantilladetalle', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_Deleteproductoplantilladetalle;
go

create         PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_Deleteproductoplantilladetalle(@pk_id_plantillaproductodetalle NUMERIC(22,0))
   as 
   begin
   set nocount on;
     delete from plantillaproductodetalle 
     where id_plantillaproductodetalle = @pk_id_plantillaproductodetalle;
     end;
   IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_getlistplantillaprductodetalle', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_getlistplantillaprductodetalle;
go

    IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_getlistplantillaprductodetalle', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_getlistplantillaprductodetalle;
go

create       PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_getlistplantillaprductodetalle(@pk_idplanitllaproducto NUMERIC(22,0)
                                            )
     as 
     begin
     set nocount on;
             select plantillaproductodetalle.codproducto, plantillaproductodetalle.codrangocomision, 
       plantillaproductodetalle.fechahoramodificacion, plantillaproductodetalle.codusuariomodificacion,
       plantillaproductodetalle.id_plantillaproductodetalle
       from WSXML_SFG.plantillaproductodetalle
       where codplantillaproducto = @pk_idplanitllaproducto;
       end;
GO
   
 IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetNomProductobyId', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetNomProductobyId;
go

create   PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTOMASIVA_GetNomProductobyId(@p_idproducto NUMERIC(22,0)
                              )
   as 
   begin
   set nocount on;
           select nomproducto 
        -- into p_nombreproducto
         from WSXML_SFG.producto 
         where id_producto = @p_idproducto;
         end;  
 
 GO


