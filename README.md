# Desafio Back-end 
## Estacionamento

O desafio consiste em:
- Registrar entrada, saída e pagamento por placa;
- Não deve liberar saída sem pagamento;
- Deve fornecer um histórico por placa.

## Rotas Disponíveis 
| Descrição | URL | Tipo | Parâmetros 
| ------ | ------ | ------ | ------ |
| Lista todos os estacionamentos | http://localhost:8000/parking/ | GET ||
| Lista os estacionamentos do veículo | http://localhost:8000/parking/NQF-6D72 | GET | Plate|
| Adiciona um registro de estacionamento | http://localhost:8000/parking/ | POST | Plate|
| Registra pagamento do veículo | http://localhost:8000/parking/NQF-6D72/pay | PUT | Plate|
| Registra saída do veículo | http://localhost:8000/parking/NQF-6D72/out | PUT | Plate|

## Instalação

### Docker
```sh
$ docker-compose up
```

### rails
```sh
#Banco de dados
$ rails db:create 
$ rails db:migrate
#Rodando
$ rails s
```