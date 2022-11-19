# Tarefa 2 de Programa��o Funcional e L�gica

# Vis�o geral

Nesta tarefa voc� dever� implementar fun��es de manipula��o de n�mero de boleto banc�rio brasileiro, de maneira a praticar a constru��o de fun��es simples em Haskell. 

# Descri��o

<img src="images/BoletoBancario.png" />

O [boleto banc�rio brasileiro](https://pt.wikipedia.org/wiki/Boleto_banc%C3%A1rio) pode ser identificado por um de dois n�meros:

* **Linha digit�vel**:  � um identificador com 47 n�meros que aparece no topo do boleto banc�rio que � projetado para facilitar a digita��o por humanos.
* **C�digo de barras**: � um identificador com 44 n�meros representado no boleto pelo c�digo de barras bidimensional que � projetado para a leitura autom�tica por dispositivos eletr�nicos.

Ambas as identifica��es traduzem um mesmo boleto banc�rio e possuem o mesmo conjunto de informa��es que, entretanto, � traduzida em n�meros de maneiras diferentes. Esta tarefa envolve unicamente a interpreta��o da **linha digit�vel** e por isso voc� deve ter **cuidado para n�o implementar** a manipula��o do c�digo de barras (tenha cuidado ao procurar informa��es de outras fontes al�m desta descri��o).

Por exemplo, as seguintes "linha digit�vel" e "c�digo de barras" representam o mesmo boleto:

```
		00190.50095 40144.816069 06809.350314 3 37370000000100 - linha digit�vel
		00193373700000001000500940144816060680935031 - c�digo de barras
```

## Estrutura da Linha Digit�vel

Considere a seguinte estrutura dos 47 n�mero da "linha digit�vel":

		+-------------+--------------+--------------+---------+----------------+
		|   Campo 1   |   Campo 2    |   Campo 3    | Campo 4 |    Campo 5     |
		+-------------+--------------+--------------+---------+----------------+
		| AAABC.CCCCX | DDDDD.DDDDDY | EEEEE.EEEEEZ | K       | UUUUVVVVVVVVVV |
		+-------------+--------------+--------------+---------+----------------+

Os n�meros devem ser interpretados da seguinte maneira:

* `AAA`: posi��es 1 a 3 identificam o banco de acordo com um identificador �nico atribu�do a cada banco. Por exemplo, "001" � Banco do Brasil e "237" � Bradesco (voc� encontra os c�digos de todos os banco [aqui](https://www.febraban.org.br/associados/utilitarios/bancos.asp)).
* `B`: posi��o 4 identifica a moeda aplicada ao boleto, que � usualmente "9", c�digo do real.
* `X`: posi��o 10 � o d�gito verificador das informa��es do "Campo 1".
* `Y`: posi��o 21 � o d�gito verificador das informa��es do "Campo 2".
* `Z`: posi��o 31 � o d�gito verificador das informa��es do "Campo 3".
<!-- * `DDDDD.DDDDD`: posi��es 11 a 20 identificam o valor do boleto, multiplicado por 100. Ent�o se os n�mero s�o `00009.13499` ent�o o valor do boleto � R$ 9.134,99 (considerando que moeda � real). -->
* `UUUU`: posi��es 34 a 37 � o fator de vencimento, que indica a data de vencimento do boleto na forma de n�mero de dias ap�s 7/10/1997. 
* `VVVVVVVVVV`: posi��es 38 a 47 identificam o valor do boleto, multiplicado por 100. Ent�o se os n�mero s�o `0000913499` ent�o o valor do boleto � R$ 9.134,99 (considerando que moeda � real).
* `DDDDD.DDDDD`, `K` e `CCCCC`: a interpreta��o dessas posi��es � definida pelo banco ou � uma por��o do c�digo de barras e por este motivo n�o ser�o consideradas nesta tarefa. Voc� deve apenas considerar que eles ser�o fornecidos para voc�.


## Tarefas de Implementa��o

Dado um c�digo de boleto banc�rio na representa��o de linha digit�vel (n�meros que aparecem no boleto), voc� dever� implementar fun��es que retornem:

* Se o boleto � v�lido, ou seja, se os d�gitos verificadores dos tr�s campos (`X`, `Y` e `Z`) est�o corretos.
* Data de vencimento de um boleto
* Valor de um boleto
* Banco associado ao boleto

### C�lculo do fator de vencimento

O fator de vencimento indica a data de vencimento do boleto a forma de n�mero de dias ap�s 7 de outubro de 1997. Se o fator de vencimento � `0001` ent�o a data de vencimento � 8 de outubro de 1997 e assim por diante, como no exemplo mostrado na tabela.

<!--
Fator	Data de Vencimento
1000	03/07/2000
1001	04/07/2000
1002	05/07/2000
9999	21/02/2025
-->

| Fator | Data de Vencimento |
|-------|--------------------|
| 1000  | 03/07/2000         |
| 1001  | 04/07/2000         |
| 1002  | 05/07/2000         |
| 9999  | 21/02/2025         |


H� algumas regras adicionais para avaliar o fator de vencimento a partir de 21/02/2025, mas elas n�o ser�o consideradas nesta tarefa.

### C�lculo dos D�gitos Verificadores

Para o c�lculo dos digitos verificadores de cada campo, cada n�mero deve ser multiplicado por um "multiplicador" (1 ou 2), resumido em um n�mero de um d�gito (ver `resumeDigito`) e somados entre si. Do valor total, � extra�do o resultado da divis�o inteira e o resto (`R`). O valor do d�gito � `(10-R) mod 10`. 

A fun��o `resumeDigito`, que transforma um n�mero de dois d�gito em um d�gito, soma o valor da dezena com a unidade, at� que o resultado seja um n�mero de um d�gito.

O multiplicador � uma sequ�ncia de alternada de "2" e "1", iniciando por "2", a associada �s respectivas posi��es dos n�meros do c�digo, **excluindo** as posi��es dos d�gitos verificadores. 

		00190.50095 40144.816069 06809.350314 3 37370000000100
		Campo 1     Campo 2      Campo 3
		00190.50095 40144.816069 06809.350314
		21212 1212  12121 21212  12121 21212     <--- multiplicador

Para o "campo 2":

1. Aplica��o do multiplicador: 

		4x1 + 0x2 + 1x1 + 4x2 + 4x1 + 8x2 + 1x1 + 6x2 + 0x1 + 6x2
		4   + 0   + 1   + 8   + 4   + 16  + 1   + 12  + 0   + 12

2. Aplica��o do `resumeDigito`, totalizando 31.
 
		4 + 0 + 1 + 8 + 4 + 16    + 1 + 12    + 0 + 12
		4 + 0 + 1 + 8 + 4 + (1+6) + 1 + (1+2) + 0 + (1+2) = 31

3. Obten��o do resto

		31 mod 10 = 1

4. C�culo do valor do d�gito (que deve gerar o mesmo n�mero na posi��o 21 da linha digit�vel)

		(10 - 1) mod 10 = 9

Voc� encontra uma demonstra��o completos para o c�lculo dos campos 1, 2 e 3 para essa linha digit�vel no extrado da [especifica��o do boleto do banco do Brasil (Anexo IV)](boleto/especificacao.boleto.banco.brasil-anexoIV.pdf). Observe que o c�lculo (3) e (4) indicados no documento s�o ligeiramente diferentes dos indicados anteriormente, mas - salvo engano - produzem o mesmo resultado final.

## Requisitos Funcionais de Implementa��o

O n�mero do boleto ser� apresentado na forma de uma String, podendo ou n�o conter espa�os ou pontos. Para efeito de avalia��o, espa�os e pontos ser�o ignorados e os seguintes boletos dever�o ser considerados iguais

		"23791.11103 60000.000103 01000.222206 1 48622000000000"
		"23791111036000000010301000222206148622000000000"

1. Fun��o `boletoNum` que recebe um boleto e retorna uma lista de inteiros (`Int`) com o valor referente a cada posi��o do boleto.

		boletoNum "23791.11103 60000.000103 01000.222206 1 48622000000000" => [2,3,7,9,1,1,1,1,0,3,6,0,0,0,0,0,0,0,1,0,3,0,1,0,0,0,2,2,2,2,0,6,1,4,8,6,2,2,0,0,0,0,0,0,0,0,0]

2. Fun�ao `bancoBoleto` que recebe a lista de inteiros de um boleto e retorna o c�digo do banco

		bancoBoleto [2,3,7,9,1,1,1,1,0,3,6,0,0,0,0,0,0,0,1,0,3,0,1,0,0,0,2,2,2,2,0,6,1,4,8,6,2,2,0,0,0,0,0,0,0,0,0] => 237

3. Fun��o `valorBoleto` que recebe a lista de inteiros de um boleto e retorna o valor do boleto (como `Double`)

		valorBoleto [2,3,7,9,1,1,1,1,0,3,6,0,0,0,0,0,0,0,1,0,3,0,1,0,0,0,2,2,2,2,0,6,1,4,8,6,2,2,0,0,0,0,0,0,0,0,0] => 20000000,00

4. Fun��o `vencimentoBoleto` que recebe a lista de inteiros de um boleto e retorna a sua data de vencimento na forma de uma tupla com os valores num�ricos de dia, m�s e ano, respectivamente. Por exemplo, a data 13 de agosto de 2019 dever� ser representada como a tupla `(13,8,2019)`. Na linha digit�vel do exemplo, o valor do fato de vencimento � `4862`, ou seja, 4.862 dias ap�s 7 de outubro de 1997 que � o dia 29 de janeiro de 2011.

		vencimentoBoleto [2,3,7,9,1,1,1,1,0,3,6,0,0,0,0,0,0,0,1,0,3,0,1,0,0,0,2,2,2,2,0,6,1,4,8,6,2,2,0,0,0,0,0,0,0,0,0] => (29,1,2011)

  Como parte da implementa��o desta fun��o, voc� necessariamente dever� implementar as seguintes fun��es de (1) a (3):

  1. Fun��o `bissexto` que recebe um ano e retorna verdadeiro se ele � bissexto. Um ano � bissexto se *"(ano � divis�vel por 400)"* OU *"(ano � divis�vel por 4 E n�o � divis�vel por 100)"*.

  			bissexto 2016 => True
  			bissexto 2017 => False
  			bissexto 2020 => True

  2. Fun��o `dataSomaDias` que recebe uma tupla `D1` com dia, m�s e ano, respectivamente, um inteiro com n�mero de dias `d` e retorna outra tupla `D2` representando a data referente ao dia `D1` acrescido dos dias `d`. 

			dataSomaDias (7,10,1997) 1000 => (3,7,2000)
			dataSomaDias (7,10,1997) 1001 => (4,7,2000)
			dataSomaDias (7,10,1997) 1002 => (5,7,2000)
			dataSomaDias (7,10,1997) 9999 => (21,2,2025)

  3. Fun��o `diasMesAno` que dado um m�s, representado como numeral (janeiro = 1, fevereiro = 2) e um ano, retorna o n�mero de dias daquele m�s.

			diasMesAno 1 2016 => 31
			diasMesAno 2 2016 => 29
			diasMesAno 2 2017 => 28
			diasMesAno 4 2017 => 30

5. Fun��o `boletoValido` que retorna `True` caso os d�gitos verificadores do boleto estejam corretos.

		boletoValido [2,3,7,9,1,1,1,1,0,3,6,0,0,0,0,0,0,0,1,0,3,0,1,0,0,0,2,2,2,2,0,6,1,4,8,6,2,2,0,0,0,0,0,0,0,0,0] => True
		boletoValido [2,3,7,9,1,1,0,1,0,3,6,0,0,0,0,0,0,0,1,0,3,0,1,0,0,0,2,2,2,2,0,6,1,4,8,6,2,2,0,0,0,0,0,0,0,0,0] => False

# Recursos �teis

* P�gina �til para testes com [c�lculo online de boleto banc�rio](https://boletobancario-codigodebarras.blogspot.com/)
* [Especifica��o completa](boleto/especificacao.boleto.banco.brasil.pdf) do formato do boleto do Banco do Brasil


# Requisitos

Reveja o **plano da disciplina** na se��o "PROCESSOS E CRIT�RIOS DE AVALIA��O", caso seja necess�rio relembrar como as tarefas ser�o avaliadas.

Os seguintes requisitos devem ser satisfeitos para o seu c�digo ter o conceito **FINALIZADO**.

1. Todas as fun��es devem ser implementadas tal como indicadas neste documento. **Nenhuma** mudan�a de nome ou estrutura das fun��es ser� aceita.
1. Todas as fun��es implementadas devem incluir c�digo de teste, para al�m das fun��es indicadas acima.
1. O seu c�digo dever� ser submetido pelo [GitHub Classroom](https://classroom.github.com/). 
2. As tarefas s�o individuais e nenhum tipo de c�pia ou similaridade com c�digo, seja de outro aluno, seja da Internet ou livros, ser� aceita.

# Prazo

O prazo para entrega da atividade est� indicado no Google Classroom. Inicie o mais r�pido poss�vel e resolva as d�vidas e dificuldades que tiver com o professor. Depois desse prazo, voc� poder� efetuar corre��es na sua implementa��o - quando solicitadas pelo professor - em at� 7 dias adicionais.


