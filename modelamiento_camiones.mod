# Modelo distribucion hidrica: tuberias + camiones

set N;
set E dimen 2;   # arcos tuberias
set ER dimen 2;  # arcos red vial camiones
set D;
set P;
set M;

# param tuberias
param S{D} >= 0;
param G{P union M} >= 0;
param f{E} >= 0;
param c{E} >= 0;
param BigM := sum{i in D} S[i];  # cota superior = oferta total

# param camiones
param d >= 0;                    # costo fijo por ruta de camion activada
param g{ER} >= 0 default 0;     # costo variable por litro en camion
param CAP >= 0;                  # capacidad maxima por arco de camion

# var tuberias
var x{E}, binary;    # 1 si se construye tuberia (i,j)
var y{E} >= 0;       # flujo por tuberia (i,j)

# var camiones
var z{ER}, binary;   # 1 si se activa ruta camion (i,j)
var w{ER} >= 0;      # flujo por camion en arco (i,j)
var r{P}, binary;    # 1 si nodo poblado recibe agua por camion
var t{N}, binary;    # 1 si nodo recibe agua por tuberia

# objetivo: minimizar costos tuberias + camiones
minimize CostoTotal:
    sum{(i,j) in E} (f[i,j]*x[i,j] + c[i,j]*y[i,j])
    + sum{(i,j) in ER} (d*z[i,j] + g[i,j]*w[i,j]);

# desaladoras no superan oferta (tanto tuberias como camion
subject to OfertaDesaladora{n in D}:
    sum{(n,j) in E} y[n,j] + sum{(n,j) in ER} w[n,j] <= S[n];

# nodos de paso
subject to Transito{n in N diff (D union P union M)}:
    sum{(i,n) in E} y[i,n] = sum{(n,j) in E} y[n,j];

# flujo solo si hay tuberia
subject to ActivacionFlujo{(i,j) in E}:
    y[i,j] <= BigM * x[i,j];

# cada consumidor recibe exactamente su demanda neta (tuberias + camiones)
subject to DemandaConsumidor{n in P union M}:
    sum{(i,n) in E} y[i,n] - sum{(n,j) in E} y[n,j]
    + sum{(i,n) in ER} w[i,n] - sum{(n,j) in ER} w[n,j] = G[n];

# camiones solo abastecen poblados como destino final
subject to CamionSoloPoblados{(i,j) in ER: j in M}:
    w[i,j] = 0;

# flujo camion limitado por capacidad y solo si se activa ruta
subject to ActivacionCamion{(i,j) in ER}:
    w[i,j] <= CAP * z[i,j];

# detecta si nodo recibe agua por tuberia
subject to DetectaEntradaTuberia{n in N diff D}:
    sum{(i,n) in E} y[i,n] <= BigM * t[n];

# camion solo puede salir desde nodo que recibe tuberia o es desaladora
subject to OrigenCamion{n in N diff D}:
    sum{(n,j) in ER} w[n,j] <= BigM * t[n];

# detecta si nodo poblado recibe agua por camion
subject to DetectaEntradaCamion{n in P}:
    sum{(i,n) in ER} w[i,n] <= BigM * r[n];

# si recibe por camion no puede reenviar por tuberia
subject to NoRetorno{n in P}:
    sum{(n,j) in E} y[n,j] <= BigM * (1 - r[n]);