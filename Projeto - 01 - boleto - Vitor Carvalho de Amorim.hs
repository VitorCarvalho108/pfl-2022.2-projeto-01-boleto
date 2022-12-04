
Função Bissexto
bissexto :: Int -> Bool
bissexto ano -- Efetua o calculo se o ano é bissexto ou não.
 | mod ano 4 == 0 && (mod ano 100 /= 0 || mod ano 400 == 0) = True
 | otherwise = False
 
Função DiasMesAno
diasMesAno :: Int -> Int -> Int
diasMesAno a b -- Verifica quantos dias cada mês possui

 |a == 1 = 31
 |a == 2 && bissexto b = 29
 |a == 2 = 28
 |a == 3 = 31
 |a == 4 = 30
 |a == 5 = 31
 |a == 6 = 30
 |a == 7 = 31
 |a == 8 = 31
 |a == 9 = 30
 |a == 10 = 31
 |a == 11 = 30
 |a == 12  = 31

Função DataSomaDias
dataSomaDias :: (Int,Int,Int) -> Int -> (Int,Int,Int)
dataSomaDias (a, b, c) x -- Pega uma determinada data e soma com o fator de vencimento
 | x == 0 = (a, b, c)
 | a == (diasMesAno b c) && (b == 12) = dataSomaDias (1, 1, (c+1)) (x - 1)
 | a == (diasMesAno b c) = dataSomaDias (1, (b+1), c) (x - 1)
 | a < (diasMesAno b c) = dataSomaDias ((a+1), b, c) (x - 1)

Função BoletoNum
boletoNum :: String -> [Int]
boletoNum[] = []
boletoNum (x:xs)
 |x == '0' = 0 : boletoNum xs
 |x == '1' = 1 : boletoNum xs
 |x == '2' = 2 : boletoNum xs
 |x == '3' = 3 : boletoNum xs
 |x == '4' = 4 : boletoNum xs
 |x == '5' = 5 : boletoNum xs
 |x == '6' = 6 : boletoNum xs
 |x == '7' = 7 : boletoNum xs
 |x == '8' = 8 : boletoNum xs
 |x == '9' = 9 : boletoNum xs
 |otherwise = boletoNum xs

Função BancoBoleto
bancoBoleto :: [Int] -> Int
convertInt :: [Int] -> Int
convertInt [a,b,c] = (a*100 + b*10 + c*1) -- Converte os elementos da lista em um inteiro
bancoBoleto codigo = convertInt(take 3 codigo) -- pega os primeiros 3 digitos da lista e retorna como um numero inteiro

Função ValorBoleto
valorBoleto :: [Int] -> Double
convertvalor :: [Int] -> Int
convertvalor (a:b:c:d:e:f:g:h:i:j:as) = (a*1000000000 + b*100000000 + c*10000000 + d*1000000+e*100000+f*10000+g*1000+h*100+i*10+j*1) -- Converte os valores da lista em um só inteiro.
valorBoleto valor = fromIntegral(convertvalor(drop 37 valor)) -- Pega os numeros na lista e retorna o valor do boleto

Função VencimentoBoleto
vencimentoBoleto :: [Int] -> (Int,Int,Int)
convertdias :: [Int] -> Int
fatia :: [Int] -> Int -> Int -> [Int]
vencboleto :: [Int] -> Int
fatia x a b = drop (a-1)(take b x) -- Pega apenas uma parte da lista
convertdias [a,b,c,d] = (a*1000 + b*100 + c*10 + d*1) -- Converte os valores da lista em um numero inteiro
vencboleto codigo = convertdias(fatia codigo 34 37) -- Retira o valor do boleto e transforma em um numero inteiro para efetuar o calculo
vencimentoBoleto num = dataSomaDias (7,10,1997) (vencboleto num) -- Efetua o calculo do dia do vencimento do boleto

Função BoletoValido
boletoValido :: [Int] -> Bool
campoum :: [Int] -> Int -> Bool
codigo :: [Int] -> [Int]
fatia :: [Int] -> Int -> Int -> [Int]

fatia x a b = drop (a-1)(take b x)  -- Retirar uma parte especifica da lista

codigo boleto = take 9 boleto -- Pegar apenas os 9 primeiros digitos

digitover :: [Int] -> Int 
digitover boleto = boleto !! 9 -- Pegar o digito verificador

digitoverdois :: [Int] -> Int
digitoverdois boleto = boleto !! 20 -- Pegar o digito verificador

digitovertres :: [Int] -> Int
digitovertres boleto = boleto !! 31 -- Pegar o digito verificador

resumedigito :: Int -> Int 
resumedigito x = (x `div` 10) + (x `mod` 10) -- Pegar um valor com dois digitos e transformar em um numero de um digito

codigocampodois :: [Int] -> [Int]
codigocampodois boleto = fatia boleto 11 20 -- Retirando os valores do campo dois da lista

codigocampotres :: [Int] -> [Int]
codigocampotres boleto = fatia boleto 22 31 -- Retirando os valores do campo Três da lista

multiplica :: [Int] -> Int -> Int
multiplica [] a = 0 
multiplica (x:xs) mult  -- Função para utilizar o multiplicador nos valores da lista
 |mult == 1 = (x*1) + (multiplica xs 2) 
 |mult == 2 && ((x*2) > 9) = (resumedigito(x*2)) + (multiplica xs 1)
 |mult == 2 = (x*2) + (multiplica xs 1) 

boletoValido x -- Testa se o boleto é válido ou não
 |campoum (codigo x) (digitover x) && campodois (codigocampodois x) (digitoverdois x) && campotres (codigocampotres x) (digitovertres x) = True
 |otherwise = False

campoum boleto digitover -- Verifica se o campo 1 do boleto se é válido
 |((10 - ((multiplica boleto 2) `mod` 10)) `mod` 10) == digitover = True
 |otherwise = False

campodois boleto digitover -- Verifica se o campo 2 do boleto é válido
 |((10 - ((multiplica boleto 1) `mod` 10)) `mod` 10) == digitover = True
 |otherwise = False

campotres boleto digitover -- Verifica se o campo 3 do boleto é válido 
 |((10 - ((multiplica boleto 1) `mod` 10)) `mod` 10) == digitover = True
 |otherwise = False


