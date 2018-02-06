USE SFGPRODU;
--  DDL for Procedure PR_UN_SOLO_USO_FLETE_MATRIZ
--------------------------------------------------------
/* set define off; */

  IF OBJECT_ID('WSXML_SFG.PR_UN_SOLO_USO_FLETE_MATRIZ', 'P') IS NOT NULL
    DROP PROCEDURE WSXML_SFG.PR_UN_SOLO_USO_FLETE_MATRIZ;
GO

  CREATE PROCEDURE WSXML_SFG.PR_UN_SOLO_USO_FLETE_MATRIZ as

begin
set nocount on;

  begin

    declare tmp cursor for select rfr.id_registrofactreferencia,
                       rfr.recibo as SPRN,
                       rfr.valortransaccion,
                       rfr.fechahoratransaccion,
                       tm.valor_comision,
                       rfr.estado
                  from WSXML_SFG.registrofactreferencia rfr, WSXML_SFG.TARIFAS_MATRIX TM
                 where CAST(RFR.VALORTRANSACCION AS INT) BETWEEN
                       TM.RANGO_INICIO AND TM.RANGO_FIN
                   and rfr.codregistrofacturacion in
                       (select rf.id_registrofacturacion
                          from WSXML_SFG.registrofacturacion rf
                         where rf.codproducto in (1875, 1874)
                           AND RF.CODTIPOREGISTRO = 1
                           and rf.codentradaarchivocontrol BETWEEN 12885 AND
                               12887)
                   AND isnull(rfr.suscriptor, 0) = 0
                 order by rfr.fechahoratransaccion; 
				 
	OPEN tmp;
	
	DECLARE @id_registrofactreferencia NUMERIC(22,0);
	DECLARE @SPRN VARCHAR(50);
    DECLARE @valortransaccion FLOAT;
	DECLARE @fechahoratransaccion TIMESTAMP;
    DECLARE @valor_comision NUMERIC(22,0);
	DECLARE @estado VARCHAR(1);
	
	FETCH NEXT FROM tmp INTO @id_registrofactreferencia, @SPRN, @valortransaccion, @fechahoratransaccion, @valor_comision, @estado
	
	WHILE (@@FETCH_STATUS = 0)
        BEGIN
			update WSXML_SFG.registrofactreferencia
			 set suscriptor = suscriptor
		   where id_registrofactreferencia = @id_registrofactreferencia
			 AND isnull(suscriptor, 0) = 0;
		FETCH NEXT FROM tmp INTO @id_registrofactreferencia, @SPRN, @valortransaccion, @fechahoratransaccion, @valor_comision, @estado
		END
	
	close tmp;
	deallocate tmp;
END
end;


GO