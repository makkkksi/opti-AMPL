
set N;  # nodos
set E dimen 2; #tubertias posibles
set D; # desaladoras
set P; # poblados
set M; # mineras

# param 
param S{D} >= 0;       # oferta desaladora i en litros
param G{P union M} >= 0;  # demanda consumidor j en litros
param f{E} >= 0;       # costo fijo arco en millones dolars
param c{E} >= 0;       # costo variable por litro 
param BigM;            

# var
var x{E}, binary;      # 1 si se construye tuberia (i,j) 
var y{E} >= 0;         # flujo por arco (i,j) en litros

# funcion obj
minimize CostoTotal: sum{(i,j) in E} (f[i,j]*x[i,j] + c[i,j]*y[i,j]);

# restricciones %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# desaladoras no pueden mandar mas de su oferta
subject to OfertaDesaladora{n in D}:
    sum{(n,j) in E} y[n,j] <= S[n];

# cada consumidor debe recibir exactamente su demanda
subject to DemandaConsumidor{n in P union M}:
    sum{(i,n) in E} y[i,n] = G[n];

# todo lo q entra sale
subject to Transito{n in N diff (D union P union M)}:
    sum{(i,n) in E} y[i,n] = sum{(n,j) in E} y[n,j];

# no hay flujo si no se construye na
subject to ActivacionFlujo{(i,j) in E}:
    y[i,j] <= BigM * x[i,j];