#### wakeUpNeo
Com a necessidade de ligar os servidores da minha rede local quando eu não estiver na minha rede local, decidi codar algo para me ajudar com isso. 
O script bem simples, ele atualiza as tabela arp disparando ping no range da rede de forma primitiva, então analisa a tabela arp, caso não encontrar o MAC do host que será ligado, significa que o host não está ligado, então dispara o pacote. 

##### Dependencias.
 - wakeonlan

##### Configuração
O Script vai carregar as configurações a partir de um arquivo conf, nesse primeiro prototipo funcional, só é necessário o prefixo da rede e os MAC's quais desejam ser inicializados separdos por espaço, segue exemplo:

```
  NETWORK=10.10.10
  TARGETS="00:00:00:00:00:00 00:00:00:00:00:00 00:00:00:00:00:00 00:00:00:00:00:00 00:00:00:00:00:00"
```

O script por hora só trabalha com a redes /24, na real nem sei porque codei tudo isso, foi mais pra eliminar o tédio, então, troque o prefixo e defina os targets e execute. 

Eu ia colocar uma outra função para que o script avise quando o host ligar e pegar um IPv4 na LAN mas o script iria ficar processando até os sistemas ligar e subir na rede, então sei lá, não acho necessário pro meu problema. 
