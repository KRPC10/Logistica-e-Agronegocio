# 🌾 Agroflow IA

Plataforma de logística preditiva agrícola para gestão de frotas e prevenção de gargalos no escoamento de safras em silos (SENAI MT).

---

## 🗄️ Estrutura da Base de Dados

A base de dados é composta por 8 tabelas principais[cite: 3]:

- **PRODUTOR**: Registo dos produtores e fazendas de origem[cite: 3].
- **MOTORISTA**: Registo dos condutores[cite: 3].
- **CAMINHAO**: Frota de veículos, placas e capacidade[cite: 3].
- **SILO**: Pontos de receção e capacidade de armazenamento[cite: 3].
- **ROTA**: Trajetos, distâncias e tempo estimado[cite: 3].
- **ENTREGA**: Registos do transporte de grãos[cite: 3].
- **LOG_IA**: Histórico de decisões tomadas pela IA[cite: 3].
- **PREVISAO_IA**: Previsões de ocupação e alertas gerados[cite: 3].

---

## 🚀 Como Executar o Projeto

### 1. Configurar a Base de Dados (MySQL)
Execute os ficheiros da pasta `database/` no seu SGBD (MySQL Workbench, DBeaver ou terminal) na seguinte ordem:
1. `database/schema.sql` (Cria a base de dados e as tabelas)
2. `database/seed.sql` (Povoa a base de dados com as informações de teste)

### 2. Abrir a Aplicação
- **Opção Direta:** Dê dois cliques no ficheiro `frontend/index.html` para abrir diretamente no seu navegador.
- **Opção via Servidor Local (Python):**
  Execute o comando na raiz do projeto:
  ```bash
  python -m http.server 8000
