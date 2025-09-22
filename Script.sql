-- CRIANDO SEQUÊNCIAS 
CREATE SEQUENCE IF NOT EXISTS SEQ_ANIMAL               START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_CLIENTE              START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_ESPECIE              START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_ATENDIMENTO          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_VENDA                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_VENDA_DETALHE        START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_SERVICO              START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_FUNCIONARIO          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_CARGO                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_PRODUTO              START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_CATEGORIA            START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_PAGAMENTO            START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS SEQ_FORMA_PAGAMENTO      START WITH 1 INCREMENT BY 1;



-- CRIANDO TABELAS E SEUS RELACIONAMENTOS (CONSTRAINTS)
CREATE TABLE IF NOT EXISTS TB_CLIENTE (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_CLIENTE'),
    NOME        VARCHAR(100),
    CPF_CNPJ    VARCHAR(30),
    EMAIL       VARCHAR(100),
    TELEFONE    VARCHAR(50),
    CONSTRAINT PK_CLIENTE PRIMARY KEY (ID)
);

CREATE UNIQUE INDEX UNQ_CLIENTE ON TB_CLIENTE(NOME,CPF_CNPJ);



CREATE TABLE IF NOT EXISTS TB_ESPECIE (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_ESPECIE'),
    NOME        VARCHAR(100),
    DESCRICAO   VARCHAR(400),
    CONSTRAINT PK_ESPECIE PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS TB_ANIMAL (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_ANIMAL'),
    NOME        VARCHAR(50),
    DATA_NASCIMENTO DATE,
    PESO        FLOAT,
    FK_CLIENTE  BIGINT NOT NULL,
    FK_ESPECIE  BIGINT NOT NULL,
    CONSTRAINT PK_ANIMAL PRIMARY KEY (ID),
    CONSTRAINT FK_ANIMAL_CLIENTE FOREIGN KEY (FK_CLIENTE) REFERENCES PUBLIC.TB_CLIENTE (ID),
    CONSTRAINT FK_ANIMAL_ESPECIE FOREIGN KEY (FK_ESPECIE) REFERENCES PUBLIC.TB_ESPECIE (ID)
);


CREATE TABLE IF NOT EXISTS TB_CATEGORIA (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_CATEGORIA'),
    NOME        VARCHAR(100),
    DESCRICAO   VARCHAR(400),
    CONSTRAINT PK_CATEGORIA PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS TB_PRODUTO (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_PRODUTO'),
    NOME        VARCHAR(100),
    DESCRICAO   VARCHAR(400),
    FK_CATEGORIA BIGINT NOT NULL,
    VALOR       FLOAT,
    CONSTRAINT PK_PRODUTO PRIMARY KEY (ID),
    CONSTRAINT FK_PRODUTO_CATEGORIA FOREIGN KEY (FK_CATEGORIA) REFERENCES PUBLIC.TB_CATEGORIA (ID)    
);


CREATE TABLE IF NOT EXISTS TB_CARGO (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_CARGO'),
    NOME        VARCHAR(100),
    DESCRICAO   VARCHAR(400),
    CONSTRAINT PK_CARGO PRIMARY KEY (ID)
);


CREATE TABLE IF NOT EXISTS TB_FUNCIONARIO (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_FUNCIONARIO'),
    NOME        VARCHAR(100),
    EMAIL       VARCHAR(100),
    TELEFONE    VARCHAR(20),
    FK_CARGO    BIGINT,
    SALARIO     FLOAT,
    CONSTRAINT PK_FUNCIONARIO PRIMARY KEY (ID),
    CONSTRAINT FK_FUNCIONARIO_CARGO FOREIGN KEY (FK_CARGO) REFERENCES TB_CARGO (ID)
);


CREATE TABLE IF NOT EXISTS TB_SERVICO (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_SERVICO'),
    NOME        VARCHAR(100) NOT NULL,
    DESCRICAO   VARCHAR(200),
    VALOR       FLOAT,
    CONSTRAINT PK_SERVICO PRIMARY KEY (ID)
);


CREATE TABLE IF NOT EXISTS TB_ATENDIMENTO (
    ID              BIGINT DEFAULT NEXTVAL('SEQ_ATENDIMENTO'),
    DATAHORA_INICIO DATE,
    DATAHORA_FIM    DATE,
    FK_PET          BIGINT,
    SATISFACAO      INT CHECK (SATISFACAO BETWEEN 1 AND 10),
    FK_FUNCIONARIO  BIGINT,
    CONSTRAINT PK_ATENDIMENTO PRIMARY KEY (ID),
    CONSTRAINT FK_ATENDIMENTO_PET FOREIGN KEY (FK_PET) REFERENCES PUBLIC.TB_ANIMAL (ID),
    CONSTRAINT FK_ATENDIMENTO_FUNCIONARIO FOREIGN KEY (FK_FUNCIONARIO) REFERENCES PUBLIC.TB_FUNCIONARIO (ID)
);



CREATE TABLE IF NOT EXISTS TB_VENDA (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_VENDA'),
    DATAHORA_INICIO DATE DEFAULT NOW(),
    DATAHORA_FIM DATE,    
    CONSTRAINT PK_VENDA PRIMARY KEY (ID)
);


CREATE TABLE IF NOT EXISTS TB_VENDA_DETALHE (
    ID             BIGINT DEFAULT NEXTVAL('SEQ_VENDA_DETALHE'),
    FK_VENDA       BIGINT NOT NULL,
    FK_PRODUTO     BIGINT,
    FK_SERVICO     BIGINT,
    QUANTIDADE     BIGINT,
    FK_ATENDIMENTO BIGINT,
    CONSTRAINT PK_VENDA_DETALHE PRIMARY KEY (ID),
    CONSTRAINT FK_VENDA_DETALHE_VENDA FOREIGN KEY (FK_VENDA) REFERENCES PUBLIC.TB_VENDA (ID),
    CONSTRAINT FK_VENDA_DETALHE_SERVICO FOREIGN KEY (FK_SERVICO) REFERENCES PUBLIC.TB_SERVICO (ID),
    CONSTRAINT FK_VENDA_DETALHE_ATENDIMENTO FOREIGN KEY (FK_ATENDIMENTO) REFERENCES PUBLIC.TB_ATENDIMENTO (ID),
    CONSTRAINT FK_VENDA_DETALHE_PRODUTO FOREIGN KEY (FK_PRODUTO) REFERENCES PUBLIC.TB_PRODUTO (ID)
);


CREATE TABLE IF NOT EXISTS TB_FORMA_PAGAMENTO (
    ID          BIGINT DEFAULT NEXTVAL('SEQ_FORMA_PAGAMENTO'),
    NOME        VARCHAR(50) NOT NULL,  
    DESCRICAO   VARCHAR(400),            
    CONSTRAINT PK_FORMA_PAGAMENTO PRIMARY KEY (ID)
);



CREATE TABLE IF NOT EXISTS TB_PAGAMENTO (
    ID                  BIGINT DEFAULT NEXTVAL('SEQ_PAGAMENTO'),
    FK_VENDA            BIGINT NOT NULL,
    FK_FORMA_PAGAMENTO  BIGINT NOT NULL,
    VALOR_TOTAL         FLOAT8 NOT NULL,
    NUMERO_PARCELAS     INT DEFAULT 1,
    VALOR_PARCELA       FLOAT,
    DATA_PAGAMENTO      DATE DEFAULT CURRENT_DATE,
    CONSTRAINT PK_PAGAMENTO PRIMARY KEY (ID),
    CONSTRAINT FK_PAGAMENTO_VENDA FOREIGN KEY (FK_VENDA) REFERENCES PUBLIC.TB_VENDA (ID),
    CONSTRAINT FK_PAGAMENTO_FORMA_PAGAMENTO FOREIGN KEY (FK_FORMA_PAGAMENTO) REFERENCES PUBLIC.TB_FORMA_PAGAMENTO (ID)
);




/********************************************************************************************************************************/
INSERT 
  INTO TB_FORMA_PAGAMENTO (NOME, DESCRICAO) 
 VALUES
('Dinheiro', 'Pagamento em espécie, sem uso de cartões ou aplicativos.'),
('Cartão de Crédito', 'Pagamento parcelado ou à vista com cartão de crédito.'),
('Cartão de Débito', 'Pagamento à vista com cartão de débito.'),
('Pix', 'Transferência instantânea via Pix.'),
('Boleto Bancário', 'Pagamento via boleto gerado para quitação em banco ou internet banking.');





INSERT 
  INTO TB_SERVICO (NOME, DESCRICAO, VALOR) 
 VALUES
('Banho', 'Serviço de banho completo para pets.', 50.00),
('Tosa', 'Serviço de tosa higiênica ou estética.', 70.00),
('Massagem', 'Massagem relaxante para animais de estimação.', 40.00),
('Consulta Veterinária', 'Avaliação clínica realizada por veterinário.', 120.00),
('Vacinação', 'Aplicação de vacinas conforme calendário veterinário.', 80.00);




INSERT 
  INTO TB_CATEGORIA (NOME, DESCRICAO)
 VALUES
('Rações', 'Alimentos balanceados para cães, gatos e outros animais.'),
('Acessórios', 'Coleiras, camas, guias, comedouros e outros acessórios para pets.'),
('Medicamentos', 'Remédios, vitaminas e suplementos para saúde dos animais.'),
('Brinquedos', 'Bolas, mordedores, pelúcias e brinquedos educativos para pets.');


INSERT 
  INTO TB_PRODUTO (NOME, DESCRICAO, FK_CATEGORIA, VALOR)
 VALUES
('Ração Cão Adulto', 'Ração completa para cães adultos', 1, 120.00),
('Ração Cão Filhote', 'Ração nutritiva para filhotes de cães', 1, 100.00),
('Ração Gato Adulto', 'Ração completa para gatos adultos', 1, 110.00),
('Ração Gato Filhote', 'Ração nutritiva para filhotes de gatos', 1, 95.00),
('Ração Pássaro Exótico', 'Ração balanceada para pássaros exóticos', 1, 30.00),
('Ração Coelho', 'Ração rica em fibras para coelhos', 1, 45.00),
('Ração Lagarto', 'Alimento balanceado para lagartos pequenos', 1, 50.00),
('Ração Gato Senior', 'Ração para gatos idosos', 1, 115.00),
('Ração Cão Sênior', 'Ração para cães idosos', 1, 125.00),
('Ração Mix Animais', 'Ração multi-espécies', 1, 90.00),
('Coleira Cão', 'Coleira ajustável para cães', 2, 35.00),
('Cama Cão', 'Cama confortável para cães', 2, 120.00),
('Coleira Gato', 'Coleira leve para gatos', 2, 25.00),
('Guia Cão', 'Guia resistente para passeios', 2, 40.00),
('Brinquedo Pássaro', 'Balanço para gaiolas de pássaros', 2, 20.00),
('Cama Coelho', 'Cama macia para coelhos', 2, 60.00),
('Terrário Lagarto', 'Terrário pequeno para lagartos', 2, 200.00),
('Comedouro Cão', 'Comedouro grande para cães', 2, 50.00),
('Comedouro Gato', 'Comedouro duplo para gatos', 2, 45.00),
('Brinquedo Interativo Cão', 'Brinquedo educativo para cães', 2, 55.00),
('Vitaminas Cão', 'Suplemento vitamínico para cães', 3, 60.00),
('Vitaminas Gato', 'Suplemento vitamínico para gatos', 3, 55.00),
('Remédio Vermífugo Cão', 'Vermífugo para cães adultos', 3, 40.00),
('Remédio Vermífugo Gato', 'Vermífugo para gatos', 3, 38.00),
('Suplemento Pássaro', 'Suplemento nutricional para pássaros', 3, 30.00),
('Suplemento Coelho', 'Suplemento para fortalecer ossos de coelhos', 3, 35.00),
('Suplemento Lagarto', 'Suplemento vitamínico para lagartos', 3, 45.00),
('Remédio Anti-pulgas Cão', 'Controle de pulgas e carrapatos', 3, 70.00),
('Remédio Anti-pulgas Gato', 'Controle de pulgas e carrapatos', 3, 65.00),
('Multivitamínico Mix', 'Suplemento multi-espécies', 3, 50.00),
('Bola Cão', 'Bola de borracha resistente para cães', 4, 25.00),
('Mordedor Cão', 'Mordedor de nylon para cães', 4, 30.00),
('Arranhador Gato', 'Arranhador vertical para gatos', 4, 80.00),
('Bola Gato', 'Bola leve para gatos brincarem', 4, 20.00),
('Brinquedo Pássaro', 'Brinquedo para gaiolas de pássaros', 4, 15.00),
('Brinquedo Coelho', 'Brinquedo seguro para coelhos mastigarem', 4, 18.00),
('Brinquedo Lagarto', 'Brinquedo para lagartos pequenos', 4, 22.00),
('Pelúcia Cão', 'Pelúcia divertida para cães', 4, 35.00),
('Pelúcia Gato', 'Pelúcia divertida para gatos', 4, 30.00),
('Brinquedo Interativo Mix', 'Brinquedo multi-espécies', 4, 40.00),
('Ração Tartaruga Aquática', 'Ração balanceada para tartarugas aquáticas', 1, 35.00),
('Ração Tartaruga Terrestre', 'Ração rica em fibras para tartarugas terrestres', 1, 40.00),
('Ração Hamster', 'Ração nutritiva para hamsters', 1, 25.00),
('Ração Porquinho-da-índia', 'Ração rica em vitamina C para porquinhos-da-índia', 1, 28.00),
('Ração Chinchila', 'Ração de alta fibra para chinchilas', 1, 30.00),
('Aquário Tartaruga', 'Aquário com filtro e área seca para tartarugas', 2, 250.00),
('Cama Roedor', 'Cama macia e segura para hamsters, porquinhos-da-índia e chinchilas', 2, 50.00),
('Brinquedo Roedor', 'Rodas, túneis e brinquedos para roedores', 2, 20.00),
('Terrário Tartaruga', 'Terrário terrestre adequado para tartarugas pequenas', 2, 180.00),
('Comedouro Roedor', 'Comedouro de fácil acesso para pequenos roedores', 2, 15.00),
('Suplemento Tartaruga', 'Suplemento vitamínico para tartarugas', 3, 25.00),
('Suplemento Hamster', 'Suplemento vitamínico para hamsters', 3, 18.00),
('Suplemento Porquinho-da-índia', 'Suplemento vitamínico rico em C', 3, 20.00),
('Suplemento Chinchila', 'Suplemento para fortalecer ossos e pelagem', 3, 22.00),
('Multivitamínico Roedores', 'Suplemento multi-espécies para pequenos roedores', 3, 23.00),
('Brinquedo Tartaruga', 'Brinquedo seguro para tartarugas pequenas', 4, 15.00),
('Brinquedo Hamster', 'Túneis, bolas e escorregadores para hamsters', 4, 12.00),
('Brinquedo Porquinho-da-índia', 'Brinquedos interativos para porquinhos-da-índia', 4, 14.00),
('Brinquedo Chinchila', 'Brinquedos para roer e escalar', 4, 18.00),
('Brinquedo Interativo Tartaruga', 'Brinquedo multiuso seguro para tartarugas', 4, 20.00);



INSERT
  INTO TB_CARGO (NOME, DESCRICAO)
 VALUES
('Atendente', 'Responsável pelo atendimento aos clientes e cadastro de serviços.'),
('Veterinário', 'Profissional responsável por consultas e procedimentos clínicos.'),
('Tosador', 'Responsável pelos serviços de banho e tosa dos animais.'),
('Auxiliar de Serviços', 'Auxilia nas tarefas de higiene, organização e apoio geral.'),
('Gerente', 'Responsável pela gestão da equipe e controle das operações do estabelecimento.');

INSERT 
  INTO TB_FUNCIONARIO (NOME, EMAIL, TELEFONE, FK_CARGO, SALARIO)
 VALUES
('Maria Silva', 'maria.silva@email.com', '(31) 99999-1111', 3, 2000.00),
('João Pereira', 'joao.pereira@email.com', '(31) 98888-2222', 2, 4500.00),
('Ana Costa', 'ana.costa@email.com', '(31) 97777-3333', 1, 1800.00),
('Carlos Souza', 'carlos.souza@email.com', '(31) 96666-4444', 3, 2200.00),
('Fernanda Lima', 'fernanda.lima@email.com', '(31) 95555-5555', 5, 6000.00),
('Lucas Almeida', 'lucas.almeida@email.com', '(31) 94444-6666', 3, 2100.00),
('Beatriz Martins', 'beatriz.martins@email.com', '(31) 93333-7777', 3, 4700.00),
('Rafael Gomes', 'rafael.gomes@email.com', '(31) 92222-8888', 1, 1800.00),
('Tiago Fernandes', 'tiago.fernandes@email.com', '(31) 90000-0000', 2, 4700.00);



INSERT 
  INTO TB_ESPECIE (NOME, DESCRICAO) 
 VALUES
('Cão', 'Animal doméstico, geralmente amigável e leal.'),
('Gato', 'Animal doméstico, independente e ágil.'),
('Pássaro', 'Animal de pequeno porte, muitas vezes de estimação, que pode cantar.'),
('Coelho', 'Animal doméstico ou de fazenda, herbívoro e de pelagem macia.'),
('Lagarto', 'Réptil de pequeno a médio porte, geralmente mantido em terrários.'),
('Hamster', 'Pequeno roedor de estimação, fácil de cuidar.'),
('Tartaruga', 'Réptil de casco duro, tranquilo e de baixa manutenção.'),
('Iguana', 'Réptil herbívoro, exige cuidados especiais em terrário.'),
('Papagaio', 'Ave inteligente, pode aprender palavras e truques.'),
('Canário', 'Ave pequena e colorida, conhecida pelo canto.'),
('Periquito', 'Pequena ave sociável, ideal para gaiolas.'),
('Furão', 'Animal curioso e brincalhão, exige atenção constante.');




