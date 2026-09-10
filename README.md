# Desafio de Projeto: Projeto Lógico de Banco de Dados para E-commerce

Este repositório contém a implementação do projeto lógico de banco de dados para o cenário de **E-commerce**, contemplando o mapeamento de modelos do EER (Modelo Entidade-Relacionamento Aprimorado), a criação do script SQL estruturado com restrições de integridade (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`), inserção de dados de teste e o desenvolvimento de consultas (queries) avançadas.

---

## 📌 Refinamentos Aplicados no Modelo Lógico

1. **Cliente PF e PJ Exclusivos:** A entidade genérica `Cliente` foi desmembrada em tabelas especializadas (`cliente_pf` e `cliente_pj`), garantindo que uma conta seja estritamente de um tipo, sem duplicidade de informações.
2. **Múltiplas Formas de Pagamento:** Modelagem que permite a um único cliente associar diferentes meios de pagamento (Cartão, Pix, Boleto) à sua conta.
3. **Controle Logístico de Entregas:** A entidade `Entrega` foi vinculada diretamente aos pedidos, armazenando status atualizados e códigos de rastreio individuais.

---

## 🔍 Consultas SQL Desenvolvidas (Queries Avançadas)

O script SQL do projeto responde a perguntas estratégicas de negócio utilizando os seguintes recursos exigidos:
- **`SELECT` e `WHERE`:** Recuperações direcionadas e filtragem de registros (ex: listagem de clientes PF).
- **Atributos Derivados:** Cálculo matemático dinâmico (ex: `quantidade * preco_unitario` para obter o valor total dos itens do pedido).
- **`ORDER BY`:** Ordenação de dados em ordem decrescente de preço.
- **`JOIN` (Junções):** Cruzamento de tabelas complexas para mapear relações entre fornecedores, produtos e estoques.
- **`GROUP BY` e `HAVING`:** Agrupamento de dados e aplicação de filtros em conjuntos (ex: clientes com mais de uma forma de pagamento cadastrada).

---

## 📂 Estrutura do Repositório

```text
├── sql/
│   └── ecommerce_logico_queries.sql   # Script DDL, DML e Queries Avançadas
└── README.md
