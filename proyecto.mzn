int: n;
int: m;
float: bound = n*n;
var 0.0..bound: r; %El radio del calculo con distancia en L

array[1..m, 1..2] of int: ciudades;
array[1..m] of int: X = ciudades[1..m, 1];
array[1..m] of int: Y = ciudades[1..m, 2];
array[1..5] of int: direccionX = [0, 1, 0,-1, 0];
array[1..5] of int: direccionY = [1, 0,-1, 0, 1];
array[1..4] of int: dentro = [1, -1, 1, -1];



%Positivo es left, negativo es rigth

%Retorna true si se encuentra fuera de un poligono.
predicate fueraDePoligonos(int: dentro,var float: cY,var float: cX,var float: aX,var float: bX,var float: aY,var float: bY) = (
    (dentro*((bX - aX)*(cY - aY) + (bY - aY)*(cX - aX)) >= 0)
);

predicate checkPoint(var float: x, var float: y, int: j, int: k) = (
    (
      y >= 0 /\ 
      y <= n /\ 
      x >= 0  /\ 
      x <= n /\ 
      fueraDePoligonos(
        dentro[k],
        x,
        y,
        X[j] + r*direccionX[k],
        X[j] + r*direccionX[k+1],
        Y[j] + r*direccionY[k],
        Y[j] + r*direccionY[k+1]
      )
  )
);

predicate searchPoint(var float: ax, var float: bx, var float: ay, var float: by, int: j, int: k) = (
  let{
    var 0.0..n: x;
    var 0.0..n: y;
    
    constraint x >= max(0.0, ax);
    constraint x <= max(min(bx, n), 0.0);
    constraint y >= max(0.0, ay);
    constraint y <= max(min(by, n), 0.0);
  } in
    checkPoint(x, y, j, k)
);

% Retorna true si la punta no se encuentra dentro de otro poligono y está en los limites del mapa permitido. 
predicate validPikeRombo(int: i, int: j, int: k, int: l) = (
      
      let{
        var float: yl = Y[i] + r*direccionY[l],
        var float: xl = X[i] + r*direccionX[l],
        var float: xr = X[i] + r*direccionX[l+1],
        var float: yr = Y[i] + r*direccionY[l+1]
      } in
      (
        if (checkPoint(xl, yl, j, k)) then true
        else(
          searchPoint(min(xl, xr), max(xl, yr), min(yl, yr), max(yl, yr), j, k)
        )endif 
      )  
);

constraint r <= bound;
constraint r >= 0;

constraint forall(i, j in 1..m where i != j) (  
  % Retorna true si la punta no se encuentra dentro de otro poligono y está en los limites del mapa permitido. 
  exists(k, l in 1..4)( 
      validPikeRombo(i,j,k,l)
  )
);

solve maximize r;