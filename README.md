# Optimización AMPL

Modelos de programación matemática en AMPL para problemas de distribución de agua.

## Modelos

### 1. Tuberías (`modelamiento_tuberias.mod`)
Modelo de flujo en redes para determinar qué tuberías construir minimizando costos fijos y variables, sujeto a:
- Oferta de desaladoras
- Demanda de poblados y mineras
- Conservación de flujo en nodos de tránsito

### 2. Tuberías + Camiones (`modelamiento_camiones.mod`)
Extensión del modelo anterior que incorpora una red de distribución por camiones como alternativa complementaria a las tuberías.

## Archivos

| Archivo | Descripción |
|---|---|
| `modelamiento_tuberias.mod` | Modelo AMPL solo tuberías |
| `modelamiento_camiones.mod` | Modelo AMPL tuberías + camiones |
| `tuberias_datos.dat` | Datos para el modelo de tuberías |
| `camiones_datos.dat` | Datos para el modelo combinado |
| `Tuberias.run` | Script de ejecución (tuberías) |
| `Camiones.run` | Script de ejecución (tuberías + camiones) |

## Uso

Ejecutar desde AMPL:
```
include Tuberias.run;
```
o
```
include Camiones.run;
```

> Requiere el solver **Gurobi**.
