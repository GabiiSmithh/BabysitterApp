# Babysitter App
Encontre uma babá para a sua criança!


## Trabalho em Grupo 
Trabalho desenvolvido para a matéria de Desenvolvimento Móvel, no curso de Ciência da Computação na Universidade Tecnológica Federal do Paraná - UTFPR, pelos alunos:
- Márcio Gabriel Pereira de Campos
- João Otávio Martini Korczovei
- Gabriela Smith Ferreira
- Hudson Taylor Perrut Cassim

## Sobre
O sistema desenvolvido se propõe a ser um aplicativo onde pessoas que
possuem crianças possam contratar babás para cuidar das mesmas por um
determinado período de tempo.
Os usuários são divididos entre babás e tutores. Os tutores podem se
cadastrar, criar um serviço, editar um serviço criado e editar as informações da
conta. As babás podem se cadastrar, se candidatar para um serviço criado e editar
as informações da conta. Existe a possibilidade de um tipo de usuário se
transformar em outro, basta adicionar informações pendentes no perfil do usuário.

# Aplicativo

## Passos para rodar

```bash
# Entre na pasta client
cd client

# Instale as dependências
flutter pub get

# Execute o aplicativo
flutter run
```

## Telas

### Login
![image](https://github.com/user-attachments/assets/f4066c14-ef84-40b5-bb68-9f6ee8beb2dd)

### Registro como Babá
![image](https://github.com/user-attachments/assets/6f43ccfe-195f-43d4-b83e-50d653ff3f35)

### Registro como Tutor
![image](https://github.com/user-attachments/assets/22e6fe89-67b6-421b-92d3-c8302bd19ee7)


### Acesso como Babá
![image](https://github.com/user-attachments/assets/2df817d0-0589-4d55-82fe-ac2ac796b3c1)

![image](https://github.com/user-attachments/assets/14fd10d3-1a52-4399-8e8f-a867ca27d423)

![image](https://github.com/user-attachments/assets/4949bf57-b1dc-4010-99ec-e29823fdc8e5)


### Acesso como Responsável
![image](https://github.com/user-attachments/assets/e580385b-71de-42d9-b177-462e608016d3)

![image](https://github.com/user-attachments/assets/0b73d609-0280-468d-b714-8f96eebc2178)

![image](https://github.com/user-attachments/assets/63d94b5a-c51b-489d-8057-c337804c4587)


## Entidades

### Usuario
- nome
- genero
- email
- senha
- telefone
- data de nascimento
- roles [tutor,baba]

### Tutor
- endereço
- quantidade filhos

### Babá
- tempo de experiencia (meses)

### Serviço
- id da baba
- id do tutor
- data de inicio
- data de fim
- valor
- quantidade de crianças
- endereço
