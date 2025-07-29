CREATE TABLE associado (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    cpf VARCHAR(14)
);

CREATE TABLE conta (
    id SERIAL PRIMARY KEY,
    numero VARCHAR(20),
    associado_id INTEGER REFERENCES associado(id)
);

CREATE TABLE cartao (
    id SERIAL PRIMARY KEY,
    numero VARCHAR(20),
    conta_id INTEGER REFERENCES conta(id),
    associado_id INTEGER REFERENCES associado(id),
    validade DATE
);

CREATE TABLE movimentacao (
    id SERIAL PRIMARY KEY,
    cartao_id INTEGER REFERENCES cartao(id),
    valor NUMERIC(10,2),
    data_movimentacao DATE,
    descricao VARCHAR(255)
);

INSERT INTO associado (nome, cpf) VALUES
('Joao Silva', '123.456.789-00'),
('Maria Souza', '987.654.321-00'),
('Carlos Pereira', '111.222.333-44'),
('Ana Lima', '555.666.777-88'),
('Pedro Santos', '999.888.777-66'),
('Julia Costa', '444.333.222-11'),
('Marcos Souza', '222.333.444-55'),
('Fernanda Alves', '333.444.555-66'),
('Lucas Rocha', '777.888.999-00'),
('Patricia Dias', '888.999.000-11');

INSERT INTO conta (numero, associado_id) VALUES
('0001-1', 1),
('0002-2', 2),
('0003-3', 3),
('0004-4', 4),
('0005-5', 5),
('0006-6', 6),
('0007-7', 7),
('0008-8', 8),
('0009-9', 9),
('0010-10', 10),
('0011-1', 1),
('0012-2', 2);

INSERT INTO cartao (numero, conta_id, associado_id, validade) VALUES
('1111-2222-3333-4444', 1, 1, '2026-12-31'),
('5555-6666-7777-8888', 2, 2, '2027-11-30'),
('9999-0000-1111-2222', 3, 3, '2026-10-15'),
('3333-4444-5555-6666', 4, 4, '2028-01-20'),
('7777-8888-9999-0000', 5, 5, '2025-09-10'),
('2222-3333-4444-5555', 6, 6, '2027-05-05'),
('6666-7777-8888-9999', 7, 7, '2026-07-07'),
('4444-5555-6666-7777', 8, 8, '2028-03-03'),
('8888-9999-0000-1111', 9, 9, '2025-11-11'),
('1234-5678-9012-3456', 10, 10, '2027-08-08'),
('2345-6789-0123-4567', 11, 1, '2026-06-06'),
('3456-7890-1234-5678', 12, 2, '2028-12-12');

INSERT INTO movimentacao (cartao_id, valor, data_movimentacao, descricao) VALUES
(1, 150.00, '2025-07-01', 'Supermercado'),
(1, 200.00, '2025-07-05', 'Farmacia'),
(2, 300.00, '2025-07-03', 'Posto de Gasolina'),
(3, 50.00, '2025-06-15', 'Padaria'),
(4, 120.00, '2025-05-20', 'Restaurante'),
(5, 80.00, '2025-04-10', 'Farmacia'),
(6, 500.00, '2025-03-05', 'Eletronicos'),
(7, 60.00, '2025-02-07', 'Livraria'),
(8, 90.00, '2025-01-03', 'Cinema'),
(9, 250.00, '2025-07-09', 'Supermercado'),
(10, 110.00, '2025-07-10', 'Padaria'),
(11, 75.00, '2025-07-11', 'Restaurante'),
(12, 180.00, '2025-07-12', 'Farmacia'),
(1, 220.00, '2025-07-13', 'Posto de Gasolina'),
(2, 330.00, '2025-07-14', 'Supermercado'),
(3, 90.00, '2025-07-15', 'Cinema'),
(4, 60.00, '2025-07-16', 'Livraria'),
(5, 400.00, '2025-07-17', 'Eletronicos'),
(6, 50.00, '2025-07-18', 'Padaria'),
(7, 120.00, '2025-07-19', 'Restaurante');
 
