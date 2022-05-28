DECLARE
			@primera_var	VARCHAR(10)
       ,	@segunda_var	DECIMAL(6,2)
       ,    @terceira_var	INTEGER
       ,    @quarta_var		CHAR(6)  =  SUBSTRING(GETDATE(), 1, 6)

                       

SELECT TOP 1
            @primera_var  = TBa.Campo_1
		,	@segunda_var  = TBa.Campo_2
        ,	@terceira_var = TBa.Campo_3

FROM  Tabela_A TBa
WHERE TBa.Campo_4 = @quarta_var
ORDER BY TBa.Campo_1 DESC


BEGIN TRANSACTION
	UPDATE Tabela_B TBb
    SET     TBb.Campo_1 = @primeira_var
		,	TBb.Campo_2 = @segunda_var
		,	TBb.Campo_3  = @terceira_var
    WHERE TBb.Campo_4 = @quarta_var

BEGIN
	IF @@ROWCOUNT = 1000
		COMMIT
        PRINT('OPERAÇÃO COM SUCESSO')
    ELSE
        ROLLBACK
        PRINT('OPERAÇÃO COM ERRO')
END