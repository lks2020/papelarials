-- Criação do banco de dados
CREATE DATABASE papelaria_ls;
USE papelaria_ls;

-- Tabela de Categorias
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Produtos
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    preco_promocional DECIMAL(10,2),
    estoque INT NOT NULL DEFAULT 0,
    categoria_id INT NOT NULL,
    imagem_principal VARCHAR(255),
    destaque BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Tabela de Imagens dos Produtos
CREATE TABLE produto_imagens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT NOT NULL,
    imagem_url VARCHAR(255) NOT NULL,
    ordem INT DEFAULT 0,
    FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE CASCADE
);

-- Tabela de Clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cpf CHAR(11) UNIQUE,
    telefone VARCHAR(20),
    endereco TEXT,
    data_nascimento DATE,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Pedidos
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendente', 'processando', 'enviado', 'entregue', 'cancelado') DEFAULT 'pendente',
    total DECIMAL(10,2) NOT NULL,
    forma_pagamento ENUM('cartao_credito', 'cartao_debito', 'pix', 'boleto', 'transferencia') NOT NULL,
    endereco_entrega TEXT,
    observacoes TEXT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Tabela de Itens do Pedido
CREATE TABLE itens_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- Tabela de Banners
CREATE TABLE banners (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    subtitulo VARCHAR(255),
    imagem_url VARCHAR(255) NOT NULL,
    link VARCHAR(255),
    ordem INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    data_inicio DATE,
    data_fim DATE
);

-- Tabela de Avaliações de Produtos
CREATE TABLE avaliacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT NOT NULL,
    cliente_id INT NOT NULL,
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES produtos(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
Dados Iniciais para Teste
sql
-- Inserir categorias
INSERT INTO categorias (nome, descricao) VALUES
('Material Escolar', 'Produtos para uso em atividades escolares'),
('Escritório', 'Artigos para ambiente de trabalho'),
('Papelaria Criativa', 'Materiais para artesanato e projetos criativos'),
('Organização', 'Produtos para organização pessoal e profissional');

-- Inserir produtos
INSERT INTO produtos (nome, descricao, preco, preco_promocional, estoque, categoria_id, imagem_principal, destaque) VALUES
('Caderno Universitário 200 folhas', 'Caderno espiral capa dura 200 folhas', 24.90, 19.90, 50, 1, 'caderno-universitario.jpg', TRUE),
('Caneta Esferográfica Azul', 'Ponta média, caixa com 12 unidades', 15.50, NULL, 120, 2, 'caneta-azul.jpg', TRUE),
('Marca-texto Neon 6 cores', 'Conjunto com 6 cores vibrantes', 28.90, 24.90, 35, 3, 'marcatexto-neon.jpg', TRUE),
('Estojo Escolar Grande', 'Estojo em poliéster com 3 zíperes', 32.90, NULL, 25, 1, 'estojo-escolar.jpg', FALSE),
('Mochila Executiva', 'Mochila para notebook até 15.6"', 189.90, 169.90, 15, 4, 'mochila-executiva.jpg', TRUE);

-- Inserir imagens adicionais para produtos
INSERT INTO produto_imagens (produto_id, imagem_url, ordem) VALUES
(1, 'caderno-universitario-2.jpg', 1),
(1, 'caderno-universitario-3.jpg', 2),
(2, 'caneta-azul-2.jpg', 1),
(5, 'mochila-executiva-2.jpg', 1),
(5, 'mochila-executiva-3.jpg', 2);

-- Inserir banners
INSERT INTO banners (titulo, subtitulo, imagem_url, link, ordem, ativo, data_inicio, data_fim) VALUES
('Volta às Aulas', '20% OFF em materiais escolares', 'banner-volta-as-aulas.jpg', '/produtos?categoria=1', 1, TRUE, '2023-01-01', '2023-02-28'),
('Frete Grátis', 'Para compras acima de R$ 150,00', 'banner-frete-gratis.jpg', '/promocoes', 2, TRUE, '2023-01-01', '2023-12-31'),
('Novidades', 'Confira nossos lançamentos', 'banner-novidades.jpg', '/novidades', 3, TRUE, '2023-01-01', '2023-12-31');

-- Inserir clientes de exemplo
INSERT INTO clientes (nome, email, senha, cpf, telefone, endereco, data_nascimento) VALUES
('João Silva', 'joao.silva@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '12345678901', '(11) 99999-9999', 'Rua das Flores, 123 - São Paulo/SP', '1990-05-15'),
('Maria Oliveira', 'maria.oliveira@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '23456789012', '(21) 98888-8888', 'Avenida Brasil, 456 - Rio de Janeiro/RJ', '1985-08-22');
Consultas SQL Úteis para o Site
1. Buscar produtos em destaque
sql
SELECT p.id, p.nome, p.descricao, p.preco, p.preco_promocional, p.imagem_principal, c.nome AS categoria
FROM produtos p
JOIN categorias c ON p.categoria_id = c.id
WHERE p.destaque = TRUE AND p.ativo = TRUE
ORDER BY p.data_criacao DESC
LIMIT 6;
2. Buscar banners ativos
sql
SELECT titulo, subtitulo, imagem_url, link
FROM banners
WHERE ativo = TRUE 
AND (data_inicio <= CURDATE() AND (data_fim IS NULL OR data_fim >= CURDATE()))
ORDER BY ordem;
3. Cadastro de novo cliente
sql
INSERT INTO clientes (nome, email, senha, telefone, endereco)
VALUES ('Novo Cliente', 'novo@email.com', '$2y$10$hashedpassword', '(31) 97777-7777', 'Rua Nova, 123 - Cidade');
4. Criação de novo pedido (transação)
sql
START TRANSACTION;

-- Inserir o pedido
INSERT INTO pedidos (cliente_id, total, forma_pagamento, endereco_entrega)
VALUES (1, 0, 'cartao_credito', 'Rua das Flores, 123 - São Paulo/SP');

SET @pedido_id = LAST_INSERT_ID();

-- Inserir itens do pedido
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario)
VALUES 
(@pedido_id, 1, 2, (SELECT preco_promocional FROM produtos WHERE id = 1)),
(@pedido_id, 3, 1, (SELECT preco FROM produtos WHERE id = 3));

-- Atualizar total do pedido
UPDATE pedidos
SET total = (
    SELECT SUM(quantidade * (preco_unitario - COALESCE(desconto, 0)))
    FROM itens_pedido
    WHERE pedido_id = @pedido_id
)
WHERE id = @pedido_id;

-- Atualizar estoque
UPDATE produtos p
JOIN itens_pedido ip ON p.id = ip.produto_id
SET p.estoque = p.estoque - ip.quantidade
WHERE ip.pedido_id = @pedido_id;

COMMIT;