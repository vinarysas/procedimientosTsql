USE SFGPRODU;
--  DDL for Package Body SFGPREMIOSL1LIAB
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPREMIOSL1LIAB */ 

  -- Private type declarations
 IF OBJECT_ID('WSXML_SFG.SFGPREMIOSL1LIAB_AddControlPremiosL1liab', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_AddControlPremiosL1liab;
GO

CREATE   PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_AddControlPremiosL1liab(@pCDC NUMERIC(22,0),
                                   @pFECHAREPORTE DATETIME,
                                   @pTOTALNUMEROGANADORES NUMERIC(22,0),
                                   @pPREMIOSTOTALESPORSORTEO NUMERIC(22,0),
                                   @pPREMIOSPAGADOSHOY NUMERIC(22,0),
                                   @pCANTIDADPREMIOSPAGADOSHOY NUMERIC(22,0),
                                   @pPREMIOSPENDPAGOMENOR60 NUMERIC(22,0),
                                   @pCANTPREMIOSPENDPAGOMENOR60 NUMERIC(22,0),
                                   @pPREMIOSPENDIENTESMAYOR60 NUMERIC(22,0),
                                   @pPREMIOSPAGADOSHOYMAYOR60 NUMERIC(22,0),
                                   @pCANTPREMIOSPAGADOSHOYMAYOR60 NUMERIC(22,0),
                                   @pPREMIOSPENDPAGOMAYOR60 NUMERIC(22,0),
                                   @pCANTPREMIOSPENDPAGOMAYOR60 NUMERIC(22,0),
                                   @pPREMIOSCADUCOSMAYOR365 NUMERIC(22,0),
                                   @pCODUSUARIOMODIFICACION NUMERIC(22,0),
                                   @pFECHAHORAMODIFICACION DATETIME,
                                   @pID_CONTROLL1LIAB_out NUMERIC(22,0) out) as 
    begin
    set nocount on;
      --Almacena datos en cada uno de los campos
        INSERT INTO WSXML_SFG.CONTROLPREMIOSL1LIAB(
                                        CDC,
                                        FECHAREPORTE,
                                        TOTALNUMEROGANADORES,
                                        TOTALPREMIOSTOTALESSORTEO,
                                        TOTALPREMIOSPAGADOSHOY,
                                        TOTALCANTPREMIOSPAGADOSHOY,
                                        TOTALPREMIOSPENDPAGOMENOR60,
                                        TOTALCANTPREMIOSPENDPAGOMEN60,
                                        TOTALPREMIOSPENDMAYOR60,
                                        TOTALPREMIOSPAGHOYMAYOR60,
                                        TOTALCANTPREMIOSPAGHOYMAY60,
                                        TOTALPREMIOSPENDPAGOMAYOR60,
                                        TOTALCANTPREMIOSPENDPAGOMAY60,
                                        TOPREMIOSCADUCOSMAYOR360,
                                        CODUSUARIOMODIFICACION,
                                        FECHAHORAMODIFICACION)
        VALUES(
               @pCDC,
               @pFECHAREPORTE,
               @pTOTALNUMEROGANADORES,
               @pPREMIOSTOTALESPORSORTEO,
               @pPREMIOSPAGADOSHOY,
               @pCANTIDADPREMIOSPAGADOSHOY,
               @pPREMIOSPENDPAGOMENOR60,
               @pCANTPREMIOSPENDPAGOMENOR60,
               @pPREMIOSPENDIENTESMAYOR60,
               @pPREMIOSPAGADOSHOYMAYOR60,
               @pCANTPREMIOSPAGADOSHOYMAYOR60,
               @pPREMIOSPENDPAGOMAYOR60,
               @pCANTPREMIOSPENDPAGOMAYOR60,
               @pPREMIOSCADUCOSMAYOR365,
               @pCODUSUARIOMODIFICACION,
               getdate());
               SET
                @pID_CONTROLL1LIAB_out = SCOPE_IDENTITY();
                                    
    end;
GO
    
IF OBJECT_ID('WSXML_SFG.SFGPREMIOSL1LIAB_GetProductobyNombre', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_GetProductobyNombre;
GO

CREATE PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_GetProductobyNombre(@pNOMBREPRODUCTO VARCHAR(4000),
                                  @pIDPRODUCTO_OUT NUMERIC(22,0) OUT) AS
    BEGIN
    SET NOCOUNT ON;
        SELECT @pIDPRODUCTO_OUT = ID_PRODUCTO
        FROM WSXML_SFG.PRODUCTO 
        WHERE upper(NOMPRODUCTO) = upper(@pNOMBREPRODUCTO);
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPREMIOSL1LIAB_GetCategoriabyDivision', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_GetCategoriabyDivision;
GO

CREATE PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_GetCategoriabyDivision(@pDIVISION VARCHAR(4000),
                                  @pIDCATEGORIA_OUT NUMERIC(22,0) OUT) AS
    BEGIN
    SET NOCOUNT ON;
        SELECT @pIDCATEGORIA_OUT = ID_CATEGORIASORTEO
        FROM WSXML_SFG.CATEGORIASORTEO
        WHERE upper(DIVISION) = upper(@pDIVISION);
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPREMIOSL1LIAB_AddL1liabTotalesporproducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_AddL1liabTotalesporproducto;
GO

CREATE PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_AddL1liabTotalesporproducto( @pCodControlL1liab NUMERIC(22,0),
                                       @pNOMBREPRODUCTO varchar(4000),
                                       @pCATEGORIA varchar(4000),
                                       @pTOTALNUMEROGANADORES NUMERIC(22,0),
                                       @pPREMIOSTOTALESPORSORTEO NUMERIC(22,0),
                                       @pPREMIOSPAGADOSHOY NUMERIC(22,0),
                                       @pCANTIDADPREMIOSPAGADOSHOY NUMERIC(22,0),
                                       @pPREMIOSPENDPAGOMENOR60 NUMERIC(22,0),
                                       @pCANTPREMIOSPENDPAGOMENOR60 NUMERIC(22,0),
                                       @pPREMIOSPENDIENTESMAYOR60 NUMERIC(22,0),
                                       @pPREMIOSPAGADOSHOYMAYOR60 NUMERIC(22,0),
                                       @pCANTPREMIOSPAGADOSHOYMAYOR60 NUMERIC(22,0),
                                       @pPREMIOSPENDPAGOMAYOR60 NUMERIC(22,0),
                                       @pCANTPREMIOSPENDPAGOMAYOR60 NUMERIC(22,0),
                                       @pPREMIOSCADUCOSMAYOR365 NUMERIC(22,0),
                                       @pID_L1liabTotalproducto_out NUMERIC(22,0) out) as
GO


IF OBJECT_ID('WSXML_SFG.SFGPREMIOSL1LIAB_AddL1liabpremiosporsorteo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_AddL1liabpremiosporsorteo;
GO

CREATE PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_AddL1liabpremiosporsorteo( @pcdc NUMERIC(22,0),
                                       @pNOMBREPRODUCTO varchar(4000),
                                       @pCATEGORIA varchar(4000),
                                       @pSORTEO NUMERIC(22,0),
                                       @pTOTALNUMEROGANADORES NUMERIC(22,0),
                                       @pPREMIOSTOTALESPORSORTEO NUMERIC(22,0),
                                       @pPREMIOSPAGADOSHOY NUMERIC(22,0),
                                       @pCANTIDADPREMIOSPAGADOSHOY NUMERIC(22,0),
                                       @pPREMIOSPENDPAGOMENOR60 NUMERIC(22,0),
                                       @pCANTPREMIOSPENDPAGOMENOR60 NUMERIC(22,0),
                                       @pPREMIOSPENDIENTESMAYOR60 NUMERIC(22,0),
                                       @pPREMIOSPAGADOSHOYMAYOR60 NUMERIC(22,0),
                                       @pCANTPREMIOSPAGADOSHOYMAYOR60 NUMERIC(22,0),
                                       @pPREMIOSPENDPAGOMAYOR60 NUMERIC(22,0),
                                       @pCANTPREMIOSPENDPAGOMAYOR60 NUMERIC(22,0),
                                       @pPREMIOSCADUCOSMAYOR365 NUMERIC(22,0),
                                       @pID_L1LIABPREMIOSPORSORTEO_out NUMERIC(22,0) out) as
 begin

declare @vcodproducto NUMERIC(22,0);
declare @vcodcategoria NUMERIC(22,0);
declare @vcodtotalporproducto NUMERIC(22,0);
 
set nocount on;
  --Consulta idproducto con el nombre
  EXEC WSXML_SFG.SFGPREMIOSL1LIAB_GetProductobyNombre @pNOMBREPRODUCTO, @vcodproducto OUT
  --Consulta idcategoria por nombre de division
  EXEC WSXML_SFG.SFGPREMIOSL1LIAB_GetCategoriabyDivision @pCATEGORIA, @vcodcategoria
    --Obtiene idtotalporproducto por categoria, producto y cdc
    select @vcodtotalporproducto = ID_L1LIABTOTALESPORPRODUCTO
    from WSXML_SFG.L1LIABTOTALESPORPRODUCTO l
    inner join WSXML_SFG.CONTROLPREMIOSL1LIAB c on c.id_controlpremiosl1liab = l.codcontroll1liab
    where c.cdc  = @pcdc and l.codproducto = @vcodproducto and l.codcategoria = @vcodcategoria;
 
   --Inserta l1liabpremiosporsorteo
   INSERT INTO WSXML_SFG.L1LIABPREMIOSPORSORTEO(
                                        CODL1LIABTOTALESPREMIOS,
                                        SORTEO,
                                        NUMEROGANADORES,
                                        PREMIOSPORSORTEO,
                                        PREMIOSPAGADOSHOY,
                                        CANTIDADPREMIOSPAGADOSHOY,
                                        PREMIOSPENDPAGOMENOR60,
                                        CANTPREMIOSPENDPAGOMENOR60,
                                        PREMIOSPENDIENTESMAYOR60,
                                        PREMIOSPAGADOSHOYMAYOR60,
                                        CANTPREMIOSPAGADOSHOYMAYOR60,
                                        PREMIOSPENDPAGOMAYOR60,
                                        CANTPREMIOSPENDPAGOMAYOR60,
                                        PREMIOSCADUCOSMAYOR365)
        VALUES(
               @vcodtotalporproducto,
               @pSORTEO,
               @pTOTALNUMEROGANADORES,
               @pPREMIOSTOTALESPORSORTEO,
               @pPREMIOSPAGADOSHOY,
               @pCANTIDADPREMIOSPAGADOSHOY,
               @pPREMIOSPENDPAGOMENOR60,
               @pCANTPREMIOSPENDPAGOMENOR60,
               @pPREMIOSPENDIENTESMAYOR60,
               @pPREMIOSPAGADOSHOYMAYOR60,
               @pCANTPREMIOSPAGADOSHOYMAYOR60,
               @pPREMIOSPENDPAGOMAYOR60,
               @pCANTPREMIOSPENDPAGOMAYOR60,
               @pPREMIOSCADUCOSMAYOR365);
               SET
                @pID_L1LIABPREMIOSPORSORTEO_out = SCOPE_IDENTITY();
                                          
 end;
 GO
 
IF OBJECT_ID('WSXML_SFG.SFGPREMIOSL1LIAB_Reversepremiosl1liab', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_Reversepremiosl1liab;
go

create PROCEDURE WSXML_SFG.SFGPREMIOSL1LIAB_Reversepremiosl1liab(@pCDC NUMERIC(22,0)) as
  begin
  set nocount on; 
    delete from WSXML_SFG.controlpremiosl1liab where cdc = @pCDC;
  end;                                       

GO
