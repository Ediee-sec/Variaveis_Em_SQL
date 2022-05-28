## Utilizando Váriaveis no SQL Server

> O tópico de hoje é sobre algo simples para muitos veteranos do SQL, porém para quem está ingressando agora na linguagem é algo desconhecido e que causa muitas dúvidas. As váriveis no SQL é algo fundamental de se aprender, conforme seu conhecimento na linguagem avança, mais coisas avançadas irá fazer, e chegará um ponto em que uma simples Query não resolverá mais e é ai que entra as váriáveis para nos auxiliar, não irei explicar como uma váriavel funciona para não externder muito o texto pois a intenção aqui é ser objetivo, porém irei deixar doi antigos, o primeiro fala sobre oque é uma váriável de computador e o segundo fala sobre varáveis no SQL

1. [Oque é uma Variável de computador?](https://vaiprogramar.com/o-que-sao-variaveis-em-programacao-passo-a-passo-com-exemplos/)
2. [Variáveis no SQL](https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/variables-transact-sql?view=sql-server-ver16)

-----

 #### No código abaixo irei mostrar um código onde utilizo váriáveis para fazer uma atualização em uma tabela lembrando que as tabelas não existem, são meramente ilustrativas 
 
 - Código 
 
~~~sql
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
~~~
----
### Explicando trecho a trecho

1. *Utilizamos a clausula [DECLARE](https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/declare-local-variable-transact-sql?view=sql-server-ver16) para declarar as variáveis, a mesma é identificada com o sinal de **@**, logo em seguida vem o nome da variável que pode ser qualquer um, logo após o nome vem o tipo da variável que informa se a mesma será por exemplo um texto ou um número, porém tem dezenas de tipos que podem ser atribuidos,*
> **Sendo assim uma variável ficaria da seguinte forma** `DECLARE @variavel INTERGER` 
 
~~~sql
    DECLARE
			@primera_var	VARCHAR(10)
       ,	@segunda_var	DECIMAL(6,2)
       ,    @terceira_var	INTEGER
       ,    @quarta_var		CHAR(6)  =  SUBSTRING(GETDATE(), 1, 6)
~~~
----

2. *Está é uma técnica que desenvolvedores SQL utilizam para atribuir valores de uma consulta para as váriável, não é a única forma de se atribuir valores a váriáveis porém neste exemplo iremos seguir desta forma, a variável fica do lado esquero da iguldade e o campo da tabela fica do lado direito da igualdade, com isso a variável passará a ter o valor do campo* 
> **Exemplo:** `SELECT @variavel = campo_da_tabela FROM tabela`
~~~sql
SELECT TOP 1
             @primera_var  = TBa.Campo_1
        ,    @segunda_var  = TBa.Campo_2
        ,    @terceira_var = TBa.Campo_3
FROM  Tabela_A TBa
WHERE TBa.Campo_4 = @quarta_var
ORDER BY TBa.Campo_1 DESC
~~~
----

3. *Com os valores atribuidos as variáveis podemos seguir com o UPDATE, o [BEGIN TRANSACTION](https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-ver16) garante a [Atomicidade](https://altieripereira.wordpress.com/2015/07/16/sql-server-acidatomicidade-consistencia-isolamento-e-disponibilidade/) da operação, na clausula SET podemos atribuir os valores armazenaods nas variáveis para os campos da tabela que desejamos alterar, vale ressaltar aqui para atenção a clausula WHERE não é recomendavél realizar qualquer operação de [DML](https://www.thomazrossito.com.br/comandos-dml-ddl-dcl-tcl-sql-server/) que altere dados sem uma condição, por tanto máxima atenção neste ponto*
> **Exemplo:** `UPDATE tabela SET campo_da_tabela = @variavel`
~~~sql
BEGIN TRANSACTION
    UPDATE Tabela_B TBb
    SET     TBb.Campo_1 = @primeira_var
        ,    TBb.Campo_2 = @segunda_var
        ,    TBb.Campo_3  = @terceira_var
    WHERE TBb.Campo_4 = @quarta_var
~~~
---
4. *Como definimos que o nosso UPDATE terá um [BEGIN TRANSACTION](https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-ver16), devemos informar ao banco de dados se oque foi alterado realmente está correto ou errado, neste irei altomatizar este processo utilizando a condicionais [IF ELSE](https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16)* e uma variável de ambiente [@@ROWCOUNT](https://docs.microsoft.com/pt-br/sql/t-sql/functions/rowcount-transact-sql?view=sql-server-ver16).
> **Exemplo: a variável de ambiente @@ROWCOUNT conta a quantidade de colunas foram afetas por nossa operação, com essa informação podemos definir se iremos confirmar ou recusar a operação, para isso é necessário realizar um `SELECT` da sua operação antes de iniciar a mesma para saber quantas linhas será afetada, para o exemplo a seguir sunhamos que 1000 linhas tenham que ser afetadas, se realmente 1000 linhas foram afetadas confirmamos a operação através do [IF](https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16), se não for atingido um valor diferente 1000 recusamos a operação atráveis do [ELSE](https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver16), não é obrigatório validar o [BEGIN TRANSACTION](https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-ver16) dessa forma, é apenas um jeito de automátizar o processo**
~~~sql
BEGIN
    IF @@ROWCOUNT = 1000
        COMMIT
        PRINT('OPERAÇÃO COM SUCESSO')
    ELSE
        ROLLBACK
        PRINT('OPERAÇÃO COM ERRO')
END
~~~
----

*Sei que é um tema que causa muitas dúvidas para quem está iniciando, porém é algo fundamental de se aprender se você que está lendo tem alguma duvida pode entrar em contato comigo no meu*, [![Linkedin](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/emerson-santos-9358041b7/)