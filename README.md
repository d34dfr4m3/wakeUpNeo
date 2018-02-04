## wakeUpNeo
Com a necessidade de ligar os servidores da minha rede local quando eu não estiver na minha rede local, decidi codar algo para me ajudar com isso. 

O script bem simples, ele atualiza as tabela arp disparando ping no range da rede de forma primitiva, então analisa a tabela arp, caso não encontrar o MAC do host que será ligado, significa que o host não está ligado, então dispara o pacote. 

Importante lembrar que o script parte do ponto que o Wake On lan já está habilitado no host, caso não tenha configurado, tente seguir esse post explicando como [Configurar o wake on lan](http://diesec.sytes.net/configurando-wake-on-lan/)

##### Dependencias.
 - wakeonlan

##### Configuração.
O Script vai carregar as configurações a partir de um arquivo conf, nesse primeiro prototipo funcional, só é necessário o prefixo da rede e os MAC's quais desejam ser inicializados separdos por espaço, segue exemplo:

```
	## Network Area
	NETWORK=10.10.0

	## Hosts Area
	host0=00:00:00:00:00:00
	host1=00:00:00:00:00:00
	host2=00:00:00:00:00:00

```
##### Execução.
```
	 Usage: ./wakeupneo {-options} 
		-u -> Do no check with hosts are online
		-H -> Define the host to send the magic packet, the host must exist in the config file
		
		Without options the script will check with the hosts are online and wake up all"
	Exemplos:
		./wakeupneo -> Vai atualizar a tabela arp disparando ping para a $NETWORK na máscara /24 e então disparar os pacotes para todos os hosts configurados no config.
		./wakeupneo -u -> Não atualiza a tabela arp e dispara para todos os hosts. 
		./wakeupneo -u -H host0 -> Não atualiza a tabela e dispara para o host0 especificado.
```

O script por hora só trabalha com a redes /24, na real nem sei porque codei tudo isso, foi mais pra eliminar o tédio, então, troque o prefixo e defina os targets e execute. 

Eu ia colocar uma outra função para que o script avise quando o host ligar e pegar um IPv4 na LAN mas o script iria ficar processando até os sistemas ligar e subir na rede, então sei lá, não acho necessário pro meu problema. 

