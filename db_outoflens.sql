drop database if exists DB_OOL;

create database if not exists DB_OOL;

use DB_OOL;

create table if not exists PESSOA
(
    	CÓDIGO int auto_increment not null primary key,
	NOME varchar(255) not null,
	NOME_SOCIAL varchar(255) not null,
	GENERO char(2) not null,
	RG varchar(15) not null,
	CPF varchar(11) not null, 
	NASCIMENTO datetime not null,
	TELEFONE varchar(15) not null,
	CEL varchar(15) not null,
	EMAIL varchar(255) not null,
	ATIVO boolean not null default true
);

create table if not exists CARGO
(
    	CÓDIGO int auto_increment primary key,
    	NOME varchar(255) not null,
	DESCRIÇÃO varchar(255) not null
);

create table if not exists FUNCIONÁRIO
(
    	CÓDIGO int auto_increment primary key,
    	CÓDIGO_USUÁRIO int not null,
	NÍVEL_ACESSO int not null,
	RFID varchar(255) not null,
	SENHA varchar(20) not null,
	CÓDIGO_CARGO int not null
);

create table if not exists CLIENTE
(
	CÓDIGO int auto_increment primary key,
	CÓDIGO_USUÁRIO int not null
);

create table if not exists TURNO
(
    	CÓDIGO int auto_increment primary key,
	CÓDIGO_FUNCIONÁRIO int not null,
	HORÁRIO_ENTRADA datetime not null,
	HORÁRIO_SAÍDA datetime null
);

create table if not exists CONTRATAÇÃO
(
    	CÓDIGO int auto_increment primary key,
	DIA datetime not null,
	CÓDIGO_FUNCIONÁRIO int not null
);

create table if not exists TIPO_PACOTE
(
    	CÓDIGO int auto_increment primary key,
	TIPO_PACOTE varchar(255) not null,
	DESCRIÇÃO varchar(255) not null,
	DISPONÍVEL boolean not null default true
);

create table if not exists PACOTE
(
    	CÓDIGO int auto_increment primary key,
	CÓDIGO_TIPO_PACOTE int not null,
	VALOR numeric(18,2) not null,
	QUALIDADE varchar(255) not null,
	QUANTIDADE int not null,
	TAMANHO_A int not null,
	TAMANHO_L int not null,
	DISPONÍVEL boolean not null default true,
	DESCRIÇÃO varchar(255) not null
);

create table if not exists IMAGEM_PACOTE
(
	CÓDIGO int auto_increment primary key,
	CÓDIGO_PACOTE int not null,
	NOME_IMAGEM varchar(255) not null,
	DESCRIÇÃO varchar (255) not null
);

create table if not exists PEDIDO
(
    	CÓDIGO int auto_increment primary key,
    	DIA datetime not null,
	CÓDIGO_CLIENTE int not null,
	ENTREGUE boolean not null default false,
	CÓDIGO_PACOTE int not null
);

create table if not exists SESSÃO
(
    	CÓDIGO int auto_increment primary key,
	ENDEREÇO varchar(255) not null,
	HORARIO_INÍCIO datetime not null,
	HORARIO_FINALIZAÇÃO datetime not null,
	CÓDIGO_PEDIDO int not null,
	DESCRIÇÃO varchar(255) not null
);

create table if not exists ASSOC_SESSÃO_FUNCIONÁRIO
(
    	CÓDIGO int auto_increment primary key,
   	CÓDIGO_SESSÃO int not null,
	CÓDIGO_FUNCIONÁRIO int not null
);

create table if not exists RELATÓRIO
(
    	CÓDIGO int auto_increment primary key,
    	DIA datetime not null,
	DESCRIÇÃO varchar(255) not null,
	CÓDIGO_PEDIDO int,
	CÓDIGO_SESSÃO int,
	CÓDIGO_FUNCIONÁRIO int not null
);

create table if not exists TIPO_EQUIPAMENTO
(
    	CÓDIGO int auto_increment primary key,
    	TIPO_EQUIPAMENTO varchar(255) not null,
	DESCRIÇÃO varchar(255) not null
);

create table if not exists EQUIPAMENTO
(
    	CÓDIGO int auto_increment primary key,
    	CÓDIGO_TIPO_EQUIPAMENTO int not null,
	NOME varchar(255) not null,
	USO varchar(255) not null,
	VALOR numeric(18,2) not null,
	QUANTIDADE_ESTOQUE int not null
);

create table if not exists RETIRADA_EQUIPAMENTO
(
    	CÓDIGO int auto_increment primary key,
    	CÓDIGO_EQUIPAMENTO int not null,
	CÓDIGO_ASSOC_SESSÃO_FUNCIONÁRIO int not null,
	HORÁRIO_RETIRADA datetime not null,
	HORÁRIO_RETORNO datetime not null
);

create table if not exists DEMISSÃO
(
    	CÓDIGO int auto_increment primary key,
	DIA datetime not null,
	MOTIVO varchar(255) not null,
	CÓDIGO_FUNCIONÁRIO int not null,
	CÓDIGO_RELATÓRIO int 
);

ALTER TABLE FUNCIONÁRIO ADD FOREIGN KEY (CÓDIGO_USUÁRIO) REFERENCES PESSOA (CÓDIGO);
ALTER TABLE FUNCIONÁRIO ADD FOREIGN KEY (CÓDIGO_CARGO) REFERENCES CARGO (CÓDIGO);

ALTER TABLE CLIENTE ADD FOREIGN KEY (CÓDIGO_USUÁRIO) REFERENCES PESSOA (CÓDIGO);

ALTER TABLE TURNO ADD FOREIGN KEY (CÓDIGO_FUNCIONÁRIO) REFERENCES FUNCIONÁRIO (CÓDIGO);

ALTER TABLE CONTRATAÇÃO ADD FOREIGN KEY (CÓDIGO_FUNCIONÁRIO) REFERENCES FUNCIONÁRIO (CÓDIGO);

ALTER TABLE PACOTE ADD FOREIGN KEY (CÓDIGO_TIPO_PACOTE) REFERENCES TIPO_PACOTE (CÓDIGO);

ALTER TABLE IMAGEM_PACOTE ADD FOREIGN KEY (CÓDIGO_PACOTE) REFERENCES PACOTE (CÓDIGO);

ALTER TABLE PEDIDO ADD FOREIGN KEY (CÓDIGO_CLIENTE) REFERENCES CLIENTE (CÓDIGO);
ALTER TABLE PEDIDO ADD FOREIGN KEY (CÓDIGO_PACOTE) REFERENCES PACOTE (CÓDIGO);

ALTER TABLE SESSÃO ADD FOREIGN KEY (CÓDIGO_PEDIDO) REFERENCES PEDIDO (CÓDIGO);

ALTER TABLE ASSOC_SESSÃO_FUNCIONÁRIO ADD FOREIGN KEY (CÓDIGO_SESSÃO) REFERENCES SESSÃO (CÓDIGO);
ALTER TABLE ASSOC_SESSÃO_FUNCIONÁRIO ADD FOREIGN KEY (CÓDIGO_FUNCIONÁRIO) REFERENCES FUNCIONÁRIO (CÓDIGO);

ALTER TABLE RELATÓRIO ADD FOREIGN KEY (CÓDIGO_PEDIDO) REFERENCES PEDIDO (CÓDIGO);
ALTER TABLE RELATÓRIO ADD FOREIGN KEY (CÓDIGO_SESSÃO) REFERENCES SESSÃO (CÓDIGO);
ALTER TABLE RELATÓRIO ADD FOREIGN KEY (CÓDIGO_FUNCIONÁRIO) REFERENCES FUNCIONÁRIO (CÓDIGO);

ALTER TABLE EQUIPAMENTO ADD FOREIGN KEY (CÓDIGO_TIPO_EQUIPAMENTO) REFERENCES TIPO_EQUIPAMENTO (CÓDIGO);

ALTER TABLE RETIRADA_EQUIPAMENTO ADD FOREIGN KEY (CÓDIGO_EQUIPAMENTO) REFERENCES EQUIPAMENTO (CÓDIGO);
ALTER TABLE RETIRADA_EQUIPAMENTO ADD FOREIGN KEY (CÓDIGO_ASSOC_SESSÃO_FUNCIONÁRIO) REFERENCES ASSOC_SESSÃO_FUNCIONÁRIO (CÓDIGO);

ALTER TABLE DEMISSÃO ADD FOREIGN KEY (CÓDIGO_FUNCIONÁRIO) REFERENCES FUNCIONÁRIO (CÓDIGO);
ALTER TABLE DEMISSÃO ADD FOREIGN KEY (CÓDIGO_RELATÓRIO) REFERENCES RELATÓRIO (CÓDIGO);

create view UltimoTurno as
    select
           CÓDIGO,
           CÓDIGO_FUNCIONÁRIO,
           HORÁRIO_ENTRADA,
           HORÁRIO_SAÍDA,
           GREATEST(coalesce(HORÁRIO_ENTRADA, HORÁRIO_SAÍDA),
           coalesce(HORÁRIO_SAÍDA, HORÁRIO_ENTRADA)) as MAIOR_HORÁRIO
            from TURNO 
                order by MAIOR_HORÁRIO desc limit 1;