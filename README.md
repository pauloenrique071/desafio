# Projeto Engenharia de Dados

## Estrutura de Pastas

- `docker/`: Arquivos de configuração do Docker (ex: docker-compose.yml)
- `sql/`: Scripts SQL para criação e carga do banco
- `etl/`: Scripts de ETL (Apache Beam, config.json)
- `data/`: Arquivos CSV gerados ou de exemplo

## Como rodar o ambiente MySQL

1. Entre na pasta `docker` e execute:
   ```sh
   docker-compose up -d
   ```
2. O banco estará disponível em `localhost:3306`.
   - Usuário: `user`
   - Senha: `password`
   - Banco: `desafio`

3. Para verificar a conexão, use um cliente MySQL como DBeaver ou o terminal:
   ```sh
   mysql -h localhost -P 3306 -u user -p
   ```

## Como rodar o ETL

1. Certifique-se de que o ambiente virtual Python está ativado:
   ```sh
   source .venv/bin/activate
   ```

2. Instale as dependências necessárias:
   ```sh
   pip install apache-beam mysql-connector-python
   ```

3. Execute o script Beam:
   ```sh
   python3 etl/etl_beam.py --config etl/config.json --result data/movimento_flat.csv --runner DirectRunner
   ```

   - Para rodar no Google Dataflow, adicione o ID do projeto:
     ```sh
     python3 etl/etl_beam.py --config etl/config.json --result data/movimento_flat.csv --runner DataflowRunner --project your-gcp-project-id
     ```

## Scripts SQL

- O script para criação e carga do banco está em `sql/estrutura_e_dados.sql`.
- Para executar o script, conecte-se ao MySQL e rode:
  ```sh
  mysql -h localhost -P 3306 -u user -p desafio < sql/estrutura_e_dados.sql
  ```

## Dependências

### Python
- `apache-beam`
- `mysql-connector-python`

### Outros
- Docker
- MySQL

## Observações

- Certifique-se de que as portas necessárias (ex: 3306 para MySQL) estão livres no seu sistema.
- Adapte os caminhos e configurações conforme necessário para o seu ambiente.

---
