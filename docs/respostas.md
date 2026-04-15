# 1. SGBD

Um SGBD relacional como PostgreSQL garante propriedades ACID...

# 2. Schemas

O uso de schemas permite melhor organização...

# 3. Modelo Lógico

Aluno(id_aluno, nome, email, ativo)
Professor(id_professor, nome, ativo)
Disciplina(id_disciplina, nome, ativo)
Turma(id_turma, id_disciplina, id_professor, ciclo, ativo)
Matricula(id_matricula, id_aluno, id_turma, ativo)
Nota(id_nota, id_matricula, valor)

# 4. Normalização

1NF: remove redundâncias  
2NF: remove dependências parciais  
3NF: remove dependências transitivas  

# 5. Concorrência

O isolamento garante que transações simultâneas não interfiram...