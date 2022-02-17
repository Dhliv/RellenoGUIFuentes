int: n;
int: m;
float: bound = 2*n;
int: puntos = 32;
var 0.0..bound: r; %El radio del calculo con distancia en L

array[1..m, 1..2] of int: ciudades;
array[1..m] of int: X = ciudades[1..m, 1];
array[1..m] of int: Y = ciudades[1..m, 2];
array[1..5] of int: direccionX = [0, 1, 0,-1, 0];
array[1..5] of int: direccionY = [1, 0,-1, 0, 1];
array[1..puntos] of float: ux = [0/32, 1/32, 2/32, 3/32, 4/32, 5/32, 6/32, 7/32, 8/32, 9/32, 10/32, 11/32, 12/32, 13/32, 14/32, 15/32, 16/32, 17/32, 18/32, 19/32, 20/32, 21/32, 22/32, 23/32, 24/32, 25/32, 26/32, 27/32, 28/32, 29/32, 30/32, 31/32];
array[1..puntos] of float: uy = [32/32, 31/32, 30/32, 29/32, 28/32, 27/32, 26/32, 25/32, 24/32, 23/32, 22/32, 21/32, 20/32, 19/32, 18/32, 17/32, 16/32, 15/32, 14/32, 13/32, 12/32, 11/32, 10/32, 9/32, 8/32, 7/32, 6/32, 5/32, 4/32, 3/32, 2/32, 1/32];
array[1..4] of float: signox = [1, 1, -1, -1];
array[1..4] of float: signoy = [1, -1, -1, 1];
array[1..4] of float: dentro = [1, -1, -1, 1];

constraint r <= bound;
constraint r >= 0;

predicate fueraDePoligonos(var float: x,var float: y,var float: aX,var float: bX,var float: aY,var float: bY, var int: j) = (
    ((dentro[j]*((bX - aX)*(y - aY) - (bY - aY)*(x - aX))) >= 0.0)
);

% Retorna true si el punto que se revisa está al interior del territorio permitido.
predicate checkInsideLand(var float: x, var float: y) = (
  (
    y >= 0 /\ 
    y <= n /\ 
    x >= 0  /\ 
    x <= n
  )
);

predicate checkPoint(var float: x, var float: y, int: j) = (
  (
    checkInsideLand(x, y) /\
    exists(l in 1..4)(
      fueraDePoligonos(
        x,
        y,
        X[j] + r*direccionX[l],
        X[j] + r*direccionX[l+1],
        Y[j] + r*direccionY[l],
        Y[j] + r*direccionY[l+1],
        j
      )
    )
  )
);

constraint exists(i in 1..m) (  
  if (m == 1) then (
    exists(k in 1..4)( 
      exists(augment in 1..puntos)(
        checkInsideLand(signox[k]*r*ux[augment] + X[i], signoy[k]*r*uy[augment] + Y[i])
      )
    )
  )
  else (
    forall(j in 1..m where i != j)(
      exists(k in 1..4)( 
        exists(augment in 1..puntos)(
          checkPoint(signox[k]*r*ux[augment] + X[i], signoy[k]*r*uy[augment] + Y[i], j)
        )
      )
    )
  )
  endif
);

solve maximize r;