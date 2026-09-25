# 🌾 Agroflow IA — Plataforma de Logística Preditiva e Otimização para o Agronegócio

> **Projeto Integrador SENAI MT | Cenário 2: Gargalos na Safra (BR-163 / Mato Grosso)**

O **Agroflow IA** é uma solução baseada em dados e Inteligência Artificial projetada para mitigar gargalos operacionais no escoamento de grãos (soja e milho) no estado de Mato Grosso. O sistema combina machine learning preditivo, roteirização dinâmica e monitoramento em tempo real para eliminar filas quilométricas em silos e otimizar o transporte rodoviário na região da BR-163.

---

## 🚀 Funcionalidades Principais

- **📊 Landing Page Comercial (`landing.html`):** Apresentação da solução B2B SaaS, modelo de negócios, ROI estimado e planos comerciais (Starter, Professional, Enterprise).
- **🗺️ Dashboard Interativo de Simulação (`index.html`):**
  - **Animação em Tempo Real:** Movimentação fluida de caminhões navegando pelas rotas em mapa interativo (Leaflet.js).
  - **Escoamento Dinâmico de Grãos:** Simulação contínua e realista de vazão/expedição nos silos, permitindo que a IA recalcule e normalize fluxos automaticamente.
  - **Histórico de Roteamento:** Tabela dinâmica de movimentação da frota com sinalização visual de redirecionamentos e bloqueios.
- **🧠 Motor Preditivo de IA (FastAPI):** Backend em Python responsável por analisar o nível de ocupação dos silos, projetar gargalos e recomendar rotas otimizadas em tempo real via endpoint REST (`/api/predict`).

---

## 📁 Estrutura do Repositório

```text
Logistica-e-Agronegocio/
├── backend/
│   └── main.py            # API FastAPI com rotas preditivas e regras de decisão
├── index.html             # Dashboard interativo com mapa Leaflet e simulação
├── landing.html           # Landing page comercial e apresentação de planos
├── requirements.txt       # Dependências Python da aplicação
└── README.md              # Documentação do projeto


🚀 Passo a Passo de Instalação e Execução
Passo 1: Obter os arquivos do projeto
Abra o terminal ou prompt de comando e navegue até a pasta do projeto:

  cd Logistica-e-Agronegocio
Passo 2: Criar e ativar o ambiente virtual (venv)
No terminal, execute o comando correspondente ao seu sistema operacional:

Linux / macOS:
    python3 -m venv venv
    source venv/bin/activate

Windows (Command Prompt):
    python -m venv venv
    venv\Scripts\activate

Windows (PowerShell):
    python -m venv venv
    .\venv\Scripts\Activate.ps1

Passo 3: Instalar as dependências
Com o ambiente virtual ativado, instale as bibliotecas necessárias listadas no requirements.txt:

pip install -r requirements.txt

Passo 4: Iniciar o servidor Backend (FastAPI)
Inicie o motor da API com o servidor Uvicorn:

uvicorn backend.main:app --reload --port 8000
A API estará rodando em: http://localhost:8000

Documentação interativa (Swagger UI): http://localhost:8000/docs

Passo 5: Acessar a aplicação no navegador

Com a API rodando no terminal, abra os arquivos HTML diretamente no seu navegador ou via extensão Live Server (VS Code):

Apresentação do Produto & Planos: Abra o arquivo landing.html no navegador.

Dashboard de Simulação em Tempo Real: Abra o arquivo index.html no navegador (ou clique nos botões de demo dentro da landing.html).