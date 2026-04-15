-- =========================
-- SCHEMAS
-- =========================
CREATE SCHEMA academico;
CREATE SCHEMA seguranca;

-- =========================
-- TABELAS (ACADEMICO)
-- =========================
CREATE TABLE academico.aluno (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.professor (
    id_professor SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.disciplina (
    id_disciplina SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.turma (
    id_turma SERIAL PRIMARY KEY,
    id_disciplina INT REFERENCES academico.disciplina(id_disciplina),
    id_professor INT REFERENCES academico.professor(id_professor),
    ciclo VARCHAR(10),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.matricula (
    id_matricula SERIAL PRIMARY KEY,
    id_aluno INT REFERENCES academico.aluno(id_aluno),
    id_turma INT REFERENCES academico.turma(id_turma),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.nota (
    id_nota SERIAL PRIMARY KEY,
    id_matricula INT REFERENCES academico.matricula(id_matricula),
    valor DECIMAL(4,2)
);

-- =========================
-- TABELA (SEGURANCA)
-- =========================
CREATE TABLE seguranca.usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);

-- =========================
-- ROLES (DCL)
-- =========================
CREATE ROLE professor_role;
CREATE ROLE coordenador_role;

-- Permissões
GRANT USAGE ON SCHEMA academico TO professor_role;
GRANT SELECT ON ALL TABLES IN SCHEMA academico TO professor_role;
GRANT UPDATE (valor) ON academico.nota TO professor_role;

-- Bloquear acesso ao email
REVOKE SELECT (email) ON academico.aluno FROM professor_role;

-- Coordenador acesso total
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA academico TO coordenador_role;

-- =========================
-- INSERTS (DML)
-- =========================
INSERT INTO academico.aluno (nome, email) VALUES 
('João', 'joao@email.com'),
('Pedro', 'pedro@email.com');

INSERT INTO academico.professor (nome) VALUES 
('Carlos');

INSERT INTO academico.disciplina (nome) VALUES 
('Banco de Dados');

INSERT INTO academico.turma (id_disciplina, id_professor, ciclo)
VALUES (1, 1, '2026/1');

INSERT INTO academico.matricula (id_aluno, id_turma)
VALUES (1, 1), (2, 1);

INSERT INTO academico.nota (id_matricula, valor)
VALUES 
(1, 8.5),
(2, 5.0);

-- =========================
-- QUERIES
-- =========================

-- QUERY 1: Matriculados
SELECT a.nome, d.nome AS disciplina, t.ciclo
FROM academico.aluno a
JOIN academico.matricula m ON a.id_aluno = m.id_aluno
JOIN academico.turma t ON m.id_turma = t.id_turma
JOIN academico.disciplina d ON t.id_disciplina = d.id_disciplina
WHERE t.ciclo = '2026/1';

-- QUERY 2: Média < 6
SELECT d.nome, AVG(n.valor) AS media
FROM academico.nota n
JOIN academico.matricula m ON n.id_matricula = m.id_matricula
JOIN academico.turma t ON m.id_turma = t.id_turma
JOIN academico.disciplina d ON t.id_disciplina = d.id_disciplina
GROUP BY d.nome
HAVING AVG(n.valor) < 6;

-- QUERY 3: Professores (LEFT JOIN)
SELECT p.nome AS professor, d.nome AS disciplina
FROM academico.professor p
LEFT JOIN academico.turma t ON p.id_professor = t.id_professor
LEFT JOIN academico.disciplina d ON t.id_disciplina = d.id_disciplina;

-- QUERY 4: Melhor nota em Banco de Dados
SELECT a.nome, n.valor
FROM academico.nota n
JOIN academico.matricula m ON n.id_matricula = m.id_matricula
JOIN academico.aluno a ON m.id_aluno = a.id_aluno
JOIN academico.turma t ON m.id_turma = t.id_turma
JOIN academico.disciplina d ON t.id_disciplina = d.id_disciplina
WHERE d.nome = 'Banco de Dados'
AND n.valor = (
    SELECT MAX(n2.valor)
    FROM academico.nota n2
    JOIN academico.matricula m2 ON n2.id_matricula = m2.id_matricula
    JOIN academico.turma t2 ON m2.id_turma = t2.id_turma
    JOIN academico.disciplina d2 ON t2.id_disciplina = d2.id_disciplina
    WHERE d2.nome = 'Banco de Dados'
);