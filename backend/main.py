from fastapi import FastAPI, HTTPException
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

# Schemas de Entrada/Saída
class RouteRequest(BaseModel):
    motorista_id: int
    origem: str
    carga_toneladas: float

class SlotBookingRequest(BaseModel):
    motorista_id: int
    silo_id: int
    horario_agendado: str

@app.get("/")
def health_check():
    return {"status": "online", "system": "Logistica Preditiva AgTech v1.0"}

@app.get("/api/silos/previsao/{silo_id}")
def get_silo_occupancy_prediction(silo_id: int, capacidade_atual: float, caminhoes_24h: int, chuva_mm: float = 0.0):
    """
    Retorna a previsão de capacidade do silo para 24h/72h usando LightGBM.
    """
    res = predictor.predict_occupancy(silo_id, capacidade_atual, caminhoes_24h, chuva_mm)
    return res

@app.post("/api/rotas/otimizar")
def get_best_route(req: RouteRequest):
    """
    Calcula a rota otimizada considerando a fila preditiva no silo.
    """
    # Dados de silos simulados (obtidos via IA)
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
    """
    Emite o passe digital de descarga para o motorista (Slot Booking).
    """
    return {
        "status": "CONFIRMADO",
        "passe_digital_id": f"PASS-{req.motorista_id}-{req.silo_id}",
        "silo_id": req.silo_id,
        "horario_agendado": req.horario_agendado,
        "qr_code_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }