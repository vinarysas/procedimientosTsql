USE SFGPRODU;
--  DDL for Package Body SFGCOMISIONVARIABLE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCOMISIONVARIABLE */ 

       IF OBJECT_ID('WSXML_SFG.SFGCOMISIONVARIABLE_ConsultaMontoTXporPDV', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGCOMISIONVARIABLE_ConsultaMontoTXporPDV;
go

create               PROCEDURE WSXML_SFG.SFGCOMISIONVARIABLE_ConsultaMontoTXporPDV( @p_CODIGOGTECHPUNTODEVENTA NUMERIC(22,0),
                                        @p_FECHAINICIO DATETIME,
                                        @P_FECHAFIN DATETIME,
                                        @p_TOTALTRANSACCIONES_out NUMERIC(22,0) OUT) AS
       BEGIN
       SET NOCOUNT ON; 
       
         select @p_TOTALTRANSACCIONES_out = isnull(sum(valortransaccion), 0) 
         from WSXML_SFG.registrofacturacion 
         inner join WSXML_SFG.entradaarchivocontrol on id_entradaarchivocontrol = codentradaarchivocontrol
         inner join WSXML_SFG.puntodeventa on codpuntodeventa = id_puntodeventa
         where codigogtechpuntodeventa = @p_CODIGOGTECHPUNTODEVENTA 
         and fechaarchivo between @p_FECHAINICIO and @P_FECHAFIN
         and codtiporegistro = 1;
      
       
 
end 

