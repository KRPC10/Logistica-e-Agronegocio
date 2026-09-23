import heapq

class AgriculturalRouter:
    def __init__(self):
        # Grafo de rodovias de MT (origem -> destino: (distancia_km, qualidade_pista_1_a_3))
        # Exemplo: 1 = Pista Dupla, 2 = Pista Simples/Asfalto ruim, 3 = Estrada de Terra
        self.graph = {
            "Fazenda_Sorriso": [("Entroncamento_BR163", 25, 2), ("Silo_Norte", 40, 3)],
            "Entroncamento_BR163": [("Silo_Norte", 30, 1), ("Silo_Central", 50, 1)],
            "Silo_Norte": [],
            "Silo_Central": []
        }

    def calculate_optimal_route(self, origin: str, target_silos_data: dict):
        """
        Dijkstra Modificado: O peso da aresta não é só distância, mas TEMPO TOTAL
        Tempo Total = (Distância / Velocidade com base no piso) + Fila do Silo (IA)
        """
        # Fila de prioridade: (tempo_total_acumulado, nó_atual, caminho)
        queue = [(0, origin, [origin])]
        visited = set()

        while queue:
            (cost, current_node, path) = heapq.heappop(queue)

            if current_node in visited:
                continue
            visited.add(current_node)

            # Se chegamos a um silo de destino
            if current_node in target_silos_data:
                silo_info = target_silos_data[current_node]
                tempo_espera_silo = silo_info["estimated_wait_time_min"]
                tempo_total = cost + tempo_espera_silo

                return {
                    "destination_silo": current_node,
                    "recommended_path": " -> ".join(path),
                    "travel_time_min": round(cost, 1),
                    "silo_wait_time_min": tempo_espera_silo,
                    "total_cycle_time_min": round(tempo_total, 1),
                    "silo_status": silo_info["status"]
                }

            # Explora vizinhos no grafo
            for neighbor, distance_km, road_quality in self.graph.get(current_node, []):
                if neighbor not in visited:
                    # Velocidade média ajustada pelo tipo de rodovia agrícola
                    speed_kmh = 80 if road_quality == 1 else (50 if road_quality == 2 else 30)
                    travel_time_minutes = (distance_km / speed_kmh) * 60
                    
                    heapq.heappush(queue, (cost + travel_time_minutes, neighbor, path + [neighbor]))

        return None

router = AgriculturalRouter()