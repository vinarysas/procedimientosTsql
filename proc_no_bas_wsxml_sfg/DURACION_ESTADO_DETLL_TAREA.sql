USE SFGPRODU;
--  DDL for Function DURACION_ESTADO_DETLL_TAREA
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.DURACION_ESTADO_DETLL_TAREA', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.DURACION_ESTADO_DETLL_TAREA;
GO

  CREATE FUNCTION WSXML_SFG.DURACION_ESTADO_DETLL_TAREA (@P_CODDETLLTAREAEJECUTADA       NUMERIC(22,0),
                                                       @P_ID_ESTADODETLLTAREAEJECUTADA NUMERIC(22,0))
  RETURNS VARCHAR(4000) AS
 BEGIN
  DECLARE @result VARCHAR(MAX);
 
  SELECT @result = WSXML_SFG.FECHAS_DIFERENCIA (
         CASE WHEN MN.ID_ESTADODETALLETAREAEJECUTADA = MX.ID_ESTADODETALLETAREAEJECUTADA
               AND MN.CODESTADOTAREA IN (1, 2)
              THEN GETDATE() -- No hay registro siguiente y se esta ejecutando
              ELSE MN.FECHAHORAESTADO
         END,
         CASE WHEN MN.CODESTADOTAREA IN (1, 2)
                OR MA.ID_ESTADODETALLETAREAEJECUTADA IS NULL
              THEN MN.FECHAHORAESTADO
              ELSE MA.FECHAHORAESTADO
         END
         )
    FROM (SELECT ET.ID_ESTADODETALLETAREAEJECUTADA,
                 ET.CODDETALLETAREAEJECUTADA,
                 ET.CODESTADOTAREA,
                 ET.FECHAHORAMODIFICACION,
                 ET.FECHAHORAESTADO
            FROM WSXML_SFG.ESTADODETALLETAREAEJECUTADA ET
           WHERE ET.CODDETALLETAREAEJECUTADA = @P_CODDETLLTAREAEJECUTADA
             AND ET.ID_ESTADODETALLETAREAEJECUTADA = @P_ID_ESTADODETLLTAREAEJECUTADA
           --ORDER BY ET.FECHAHORAESTADO DESC
		   ) MN, -- Registro mostrado
         (SELECT ET.ID_ESTADODETALLETAREAEJECUTADA,
                 ET.CODDETALLETAREAEJECUTADA,
                 ET.CODESTADOTAREA,
                 ET.FECHAHORAMODIFICACION,
                 ET.FECHAHORAESTADO
            FROM WSXML_SFG.ESTADODETALLETAREAEJECUTADA ET
           WHERE ET.CODDETALLETAREAEJECUTADA = @P_CODDETLLTAREAEJECUTADA
           --ORDER BY ET.FECHAHORAESTADO DESC
		   ) MX -- Registro siguiente (Siguiente estado)
  LEFT OUTER JOIN (SELECT ET.ID_ESTADODETALLETAREAEJECUTADA,
                          ET.CODDETALLETAREAEJECUTADA,
                          ET.CODESTADOTAREA,
                          ET.FECHAHORAMODIFICACION,
                          ET.FECHAHORAESTADO
                   FROM WSXML_SFG.ESTADODETALLETAREAEJECUTADA ET
                   WHERE ET.CODDETALLETAREAEJECUTADA = @P_CODDETLLTAREAEJECUTADA
                   --ORDER BY ET.FECHAHORAESTADO DESC
				   ) MA ON (MA.ID_ESTADODETALLETAREAEJECUTADA < @P_ID_ESTADODETLLTAREAEJECUTADA) -- Registro anterior (estado previo)
   WHERE MX.ID_ESTADODETALLETAREAEJECUTADA >= MN.ID_ESTADODETALLETAREAEJECUTADA
    -- AND;

  RETURN(@result);
END
GO


