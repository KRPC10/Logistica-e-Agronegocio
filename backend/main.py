from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import sys
import os

# Adiciona a pasta pai ao PATH para importar o ml_engine
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from ml_engine.predict_silos import predictor
from ml_engine.router_dijkstra import router

app = FastAPI(
    title="Plataforma de Logística Preditiva e Otimização AgTech",
    version="1.0.0",
    description="API de Gestão de Silos, Previsão via LightGBM e Roteirização Inteligente"
)

# 1. LIBERAR CORS (Permite que o frontend comunique com o backend localmente)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Schemas do Sistema ---
class RouteRequest(BaseModel):
    motorista_id: int
    origem: str
    carga_toneladas: float

class SlotBookingRequest(BaseModel):
    motorista_id: int
    silo_id: int
    horario_agendado: str

# Schema para o Simulador Frontend
class EntradaSimulacao(BaseModel):
    silo_a_ocupacao: float
    silo_b_ocupacao: float
    silo_c_ocupacao: float
    cargas_pendentes: int

# --- Endpoints da Aplicação ---

@app.get("/")
def health_check():
    return {"status": "online", "system": "Logistica Preditiva AgTech v1.0"}

# 2. ENDPOINT DE DECISÃO DA IA (Conectado ao Simulador)
@app.post("/api/predict")
def prever_redirecionamento(dados: EntradaSimulacao):
    a, b, c = dados.silo_a_ocupacao, dados.silo_b_ocupacao, dados.silo_c_ocupacao
    tempo_espera_a = round((a ** 1.8) / 30, 1)

    if a < 90.0:
        return {
            "silo_recomendado": "Silo A - Sorriso",
            "nivel_alerta": "MONITORANDO",
            "decisao_ia": "Fluxo normal. Silos operando dentro das margens normais.",
            "tempo_espera_a_min": tempo_espera_a
        }
    elif b < 90.0:
        return {
            "silo_recomendado": "Silo B - Sinop",
            "nivel_alerta": "DESVIO PARA SILO B",
            "decisao_ia": f"⚠️ Alerta Preditivo! Silo A atingiu {a}%. Rota alterada para Silo B (Sinop). Tempo de espera projetado: {tempo_espera_a}m.",
            "tempo_espera_a_min": tempo_espera_a
        }
    elif c < 90.0:
        return {
            "silo_recomendado": "Silo C - Vera",
            "nivel_alerta": "DESVIO PARA SILO C",
            "decisao_ia": f"🚨 Silo B saturado ({b}%)! Rota secundária ativada para o Silo C (Vera).",
            "tempo_espera_a_min": tempo_espera_a
        }
    else:
        return {
            "silo_recomendado": "BLOQUEADO",
            "nivel_alerta": "SATURAÇÃO REGIONAL",
            "decisao_ia": "🛑 Todos os silos regionais cheios (100%). Expedição suspensa na origem.",
            "tempo_espera_a_min": tempo_espera_a
        }

@app.get("/api/silos/previsao/{silo_id}")
def get_silo_occupancy_prediction(silo_id: int, capacidade_atual: float, caminhoes_24h: int, chuva_mm: float = 0.0):
    """Retorna a previsão de capacidade do silo para 24h/72h usando LightGBM."""
    res = predictor.predict_occupancy(silo_id, capacidade_atual, caminhoes_24h, chuva_mm)
    return res

@app.post("/api/rotas/otimizar")
def get_best_route(req: RouteRequest):
    """Calcula a rota otimizada considerando a fila preditiva no silo."""
    silos_predicaocao = {
        "Silo_Norte": predictor.predict_occupancy(1, current_capacity_pct=88.0, incoming_trucks_24h=50, rain_forecast_mm=10.0),
        "Silo_Central": predictor.predict_occupancy(2, current_capacity_pct=45.0, incoming_trucks_24h=12, rain_forecast_mm=0.0)
    }

    resultado_rota = router.calculate_optimal_route(req.origem, silos_predicaocao)
    
    if not resultado_rota:
        raise HTTPException(status_code=404, detail="Nenhuma rota disponível para os silos selecionados.")

    return {
        "motorista_id": req.motorista_id,
        "otimizacao": resultado_rota
    }

@app.post("/api/agendamento/slot-booking")
def create_slot_booking(req: SlotBookingRequest):
    """Emite o passe digital de descarga para o motorista (Slot Booking)."""
    return {
        "status": "CONFIRMADO",
        "passe_digital_id": f"PASS-{req.motorista_id}-{req.silo_id}",
        "silo_id": req.silo_id,
        "horario_agendado": req.horario_agendado,
        "qr_code_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }