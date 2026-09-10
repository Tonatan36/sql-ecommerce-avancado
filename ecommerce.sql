-- =====================================================================
-- PROJETO LÓGICO DE BANCO DE DADOS - E-COMMERCE (DIRECIONADO A QUERIES)
-- =====================================================================

-- 1. Criação das Tabelas Principais
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_cliente ENUM('PF', 'PJ') NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE cliente_pf (
    id_cliente INT PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    rg VARCHAR(20),
    CONSTRAINT fk_pf_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE cliente_pj (
    id_cliente INT PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    razao_social VARCHAR(100) NOT NULL,
    CONSTRAINT fk_pj_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    tipo_pagamento VARCHAR(50) NOT NULL, -- Ex: Cartão, Pix, Boleto
    detalhes VARCHAR(100),
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    status_pedido VARCHAR(50) NOT NULL,
    descricao VARCHAR(100),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    status_entrega VARCHAR(50) NOT NULL,
    codigo_rastreio VARCHAR(50) NOT NULL,
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);

CREATE TABLE fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(100) NOT NULL,
    cnpj VARCHAR(14) NOT NULL UNIQUE
);

CREATE TABLE vendedor (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    nome_vendedor VARCHAR(100) NOT NULL,
    localizacao VARCHAR(100)
);

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    preco DECIMAL(10,2) NOT NULL
);

CREATE TABLE produto_por_fornecedor (
    id_fornecedor INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (id_fornecedor, id_produto),
    CONSTRAINT fk_ppf_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor),
    CONSTRAINT fk_ppf_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

CREATE TABLE itens_pedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT fk_ip_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    CONSTRAINT fk_ip_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);


-- 2. Inserção de Dados para Testes
INSERT INTO cliente (nome, tipo_cliente, email) VALUES ('Ana Souza', 'PF', 'ana@email.com');
INSERT INTO cliente_pf (id_cliente, cpf, rg) VALUES (1, '12345678901', '1234567');

INSERT INTO cliente (nome, tipo_cliente, email) VALUES ('Tech Comércio LTDA', 'PJ', 'contato@tech.com');
INSERT INTO cliente_pj (id_cliente, cnpj, razao_social) VALUES (2, '12345678000199', 'Tech Comércio de Informática S.A.');

INSERT INTO pagamento (id_cliente, tipo_pagamento, detalhes) VALUES (1, 'Cartão de Crédito', 'Final 1234');
INSERT INTO pagamento (id_cliente, tipo_pagamento, detalhes) VALUES (1, 'Pix', 'Chave CPF');
INSERT INTO pagamento (id_cliente, tipo_pagamento, detalhes) VALUES (2, 'Boleto', 'Vencimento em 30 dias');

INSERT INTO produto (nome_produto, categoria, preco) VALUES ('Notebook Gamer', 'Informática', 4500.00);
INSERT INTO produto (nome_produto, categoria, preco) VALUES ('Mouse Sem Fio', 'Periféricos', 150.00);
INSERT INTO produto (nome_produto, categoria, preco) VALUES ('Cadeira Ergonômica', 'Móveis', 1200.00);

INSERT INTO fornecedor (razao_social, cnpj) VALUES ('Distribuidora Global S.A.', '98765432000111');
INSERT INTO produto_por_fornecedor (id_fornecedor, id_produto, quantidade) VALUES (1, 1, 50), (1, 2, 200);

INSERT INTO pedido (id_pedido, id_cliente, status_pedido, descricao) VALUES (101, 1, 'Processando', 'Compra de periféricos');
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES (101, 2, 2, 150.00);

INSERT INTO entrega (id_pedido, status_entrega, codigo_rastreio) VALUES (101, 'Em trânsito', 'BR987654321X');


-- =====================================================================
-- 3. QUERIES AVANÇADAS SOLICITADAS NO DESAFIO
-- =====================================================================

-- Q1: Recuperações simples com SELECT e Filtros com WHERE
-- Pergunta: Quais são os clientes cadastrados do tipo Pessoa Física?
SELECT id_cliente, nome, email 
FROM cliente 
WHERE tipo_cliente = 'PF';


-- Q2: Expressões para gerar atributos derivados
-- Pergunta: Qual o valor total de cada item nos pedidos (quantidade * preço)?
SELECT 
    id_pedido, 
    id_produto, 
    quantidade, 
    preco_unitario, 
    (quantidade * preco_unitario) AS valor_total_item
FROM itens_pedido;


-- Q3: Ordenação dos dados com ORDER BY
-- Pergunta: Quais são os produtos ordenados do mais caro para o mais barato?
SELECT nome_produto, preco 
FROM produto 
ORDER BY preco DESC;


-- Q4: Junções entre tabelas (JOINs) e Agrupamentos (Quantos pedidos por cliente?)
-- Pergunta: Quantos pedidos foram feitos por cada cliente?
SELECT 
    c.nome AS nome_cliente,
    c.tipo_cliente,
    COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome, c.tipo_cliente;


-- Q5: Junções complexas com Relacionamento de Fornecedores e Produtos
-- Pergunta: Qual é a relação de nomes dos fornecedores e os nomes dos produtos fornecidos com seus estoques?
SELECT 
    f.razao_social AS fornecedor,
    p.nome_produto AS produto,
    ppf.quantidade AS quantidade_em_estoque
FROM fornecedor f
JOIN produto_por_fornecedor ppf ON f.id_fornecedor = ppf.id_fornecedor
JOIN produto p ON ppf.id_produto = p.id_produto;


-- Q6: Condições de filtros aos grupos com HAVING
-- Pergunta: Quais clientes possuem mais de uma forma de pagamento cadastrada?
SELECT 
    c.nome AS cliente,
    COUNT(pg.id_pagamento) AS total_formas_pagamento
FROM cliente c
JOIN pagamento pg ON c.id_cliente = pg.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(pg.id_pagamento) > 1;
