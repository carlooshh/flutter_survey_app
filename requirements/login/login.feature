Feature: login

Como um cliente quero acessar minha conta e me manter logado
Para que eu posso ver e responder surveys de forma rápida

Cenário: Credenciais válidas
Dado que o cliente informou credenciais válidas
Quando solicitar para fazer login
Então o sistema deve enviar o usuário para a telas de pesquisas
E manter o usuário conectado

Cenário: Credenciais inválidas
Dado que o cliente informou credencias inválidas
Quando solicitar para fazer login
Então o sistema deve retornar uma mensagem de erro