import lightgbm as lgb
import numpy as np
import pandas as pd

class SiloOccupancyPredictor:
    def __init__(self):
        # Em produção, carrega o arquivo treinado: lgb.Booster(model_file='model.txt')
        self.model = None 

    def predict_occupancy(self, silo_id: int, current_capacity_pct: float, 
                          incoming_trucks_24h: int, rain_forecast_mm: float) -> dict:
        """
        Projeta a ocupação e o tempo médio de fila (24h e 72h).
        O tempo de chuva impacta diretamente a taxa de recepção e secagem do grão.
        """
        # Exemplo de payload de entrada para o LightGBM
        features = np.array([[silo_id, current_capacity_pct, incoming_trucks_24h, rain_forecast_mm]])
        
        # Simulação de inferência do modelo LightGBM
        # Lógica preditiva: Chuva reduz a vazão do silo; excesso de caminhões gera gargalo
        factor_rain = 1.0 + (rain_forecast_mm * 0.02)
        projected_24h = min(100.0, current_capacity_pct + (incoming_trucks_24h * 0.4 * factor_rain))
        projected_72h = min(100.0, projected_24h + (incoming_trucks_24h * 0.2 * factor_rain))
        
        # Estimativa do tempo de fila no silo (em minutos) com base na ocupação
        wait_time_minutes = int(max(0, (projected_24h - 70) * 8)) if projected_24h > 70 else 15

        return {
            "silo_id": silo_id,
            "occupancy_24h_pct": round(projected_24h, 2),
            "occupancy_72h_pct": round(projected_72h, 2),
            "estimated_wait_time_min": wait_time_minutes,
            "status": "CRITICO" if projected_24h >= 90 else ("ALERTA" if projected_24h >= 75 else "NORMAL")
        }

predictor = SiloOccupancyPredictor()