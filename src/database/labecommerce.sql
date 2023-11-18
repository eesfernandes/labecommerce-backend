-- Active: 1700264726242@@127.0.0.1@3306

-- =========================== Tabela de usuários =========================== --
CREATE TABLE users (
    id TEXT PRIMARY KEY UNIQUE NOT NULL,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at DATETIME DEFAULT (
        strftime(
            '%d-%m-%Y %H:%M:%S',
            'now',
            'localtime'
        )
    ) NOT NULL
);

SELECT * FROM users;

SELECT name FROM users;

DROP Table users;

DELETE FROM users WHERE id = 'u002'

INSERT INTO users (id, name, email, password)
VALUES 
('u001', 'Eric', 'eric@email.com', 'eric123'), 
('u002', 'João', 'joao@email.com', 'joao123'),
('u003', 'Pedro', 'pedro@email.com', 'pedro123')

INSERT INTO users (id, name, email, password)
VALUES
('u004', 'Maria', 'maria@email.com', 'maria123')


-- =========================== Tabela produtos =========================== --
CREATE TABLE products (
    id TEXT PRIMARY KEY UNIQUE NOT NULL,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    description TEXT NOT NULL,
    image_url TEXT NOT NULL
);

SELECT * FROM products;

SELECT name FROM products;

SELECT name FROM products WHERE name LIKE '%monitor%'

DELETE FROM products WHERE id = 'p001'

INSERT INTO products (id, name, price, description, image_url)
VALUES
('p001', 'Mouse gamer', 200, 'Mouse Gamer', 'http://123'),
('p002', 'Teclado', 300, 'Teclado Gamer', 'http://1234'),
('p003', 'Monitor', 1000, 'Monitor Gamer', 'http://12345'),
('p004', 'Caixa de som', 150, 'Caixa de som top', 'http://123456'),
('p005', 'Notebook', 5000, 'Notebook Gamer Acer', 'http://1234567')

INSERT INTO products
VALUES ('p006', 'Placa de video', 2000, 'Placa de video Nvidea', 'http://12345678')

UPDATE products
SET name = 'Pc gamer',
    price = 8000,
    description = 'Computador gamer de ultima geração',
    image_url = 'http://update'
WHERE id = 'p005'


-- =========================== Tabela de compras =========================== --
CREATE TABLE
    purchases (
        id TEXT PRIMARY KEY UNIQUE NOT NULL,
        buyer TEXT NOT NULL,
        total_price REAL NOT NULL,
        created_at TEXT DATETIME DEFAULT (
            strftime(
                '%d-%m-%Y %H:%M:%S',
                'now',
                'localtime'
            )
        ) NOT NULL,
        FOREIGN KEY (buyer) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
    );

INSERT INTO purchases (id, buyer, total_price)
VALUES
('c001', 'u001', '100.00'),
('c002', 'u002', '200.00')

SELECT * FROM purchases

DROP TABLE purchases;

UPDATE purchases
SET total_price = 300
WHERE id = 'c002'

SELECT
    purchases.id AS purchases_id,
    buyer AS buyer_id,
    users.name AS buyer_name,
    users.email AS email,
    total_price,
    purchases.created_at
FROM users
INNER JOIN purchases
ON buyer = users.id;

-- =========================== Tabela de compras & produtos =========================== --
CREATE TABLE purchases_products (
    purchase_id TEXT NOT NULL,
    product_id TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (purchase_id) REFERENCES purchases(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO purchases_products (purchase_id, product_id, quantity)
VALUES
('c001', 'p001', 1),
('c001', 'p002', 2),
('c002', 'p003', 1)

SELECT * FROM purchases_products;

DROP TABLE purchases_products;

SELECT
    purchase_id AS IdDaCompra,
    product_id AS IdDoProduto,
    products.name AS NomeDoProduto,
    quantity AS QuantidadeComprada,
    price AS PreçoUnitario
FROM purchases_products
    INNER JOIN products ON purchases_products.product_id = products.id
    INNER JOIN purchases ON purchases_products.purchase_id = purchases.id

-- Todas as informações das três tabelas:

SELECT *
FROM purchases_products
    INNER JOIN products ON purchases_products.product_id = products.id
    INNER JOIN purchases ON purchases_products.purchase_id = purchases.id