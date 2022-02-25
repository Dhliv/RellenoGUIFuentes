int: n;
int: m;
float: bound = 2*n;
int: puntos = 64;
var 0.0..bound: r; %El radio del calculo con distancia en L

array[1..m, 1..2] of int: ciudades;
array[1..m] of int: X = ciudades[1..m, 1];
array[1..m] of int: Y = ciudades[1..m, 2];
array[1..5] of int: direccionX = [0, 1, 0,-1, 0];
array[1..5] of int: direccionY = [1, 0,-1, 0, 1];
array[1..puntos] of float: ux = [0/64, 1/64, 2/64, 3/64, 4/64, 5/64, 6/64, 7/64, 8/64, 9/64, 10/64, 11/64, 12/64, 13/64, 14/64, 15/64, 16/64, 17/64, 18/64, 19/64, 20/64, 21/64, 22/64, 23/64, 24/64, 25/64, 26/64, 27/64, 28/64, 29/64, 30/64, 31/64, 32/64, 33/64, 34/64, 35/64, 36/64, 37/64, 38/64, 39/64, 40/64, 41/64, 42/64, 43/64, 44/64, 45/64, 46/64, 47/64, 48/64, 49/64, 50/64, 51/64, 52/64, 53/64, 54/64, 55/64, 56/64, 57/64, 58/64, 59/64, 60/64, 61/64, 62/64, 63/64];
array[1..puntos] of float: uy = [64/64, 63/64, 62/64, 61/64, 60/64, 59/64, 58/64, 57/64, 56/64, 55/64, 54/64, 53/64, 52/64, 51/64, 50/64, 49/64, 48/64, 47/64, 46/64, 45/64, 44/64, 43/64, 42/64, 41/64, 40/64, 39/64, 38/64, 37/64, 36/64, 35/64, 34/64, 33/64, 32/64, 31/64, 30/64, 29/64, 28/64, 27/64, 26/64, 25/64, 24/64, 23/64, 22/64, 21/64, 20/64, 19/64, 18/64, 17/64, 16/64, 15/64, 14/64, 13/64, 12/64, 11/64, 10/64, 9/64, 8/64, 7/64, 6/64, 5/64, 4/64, 3/64, 2/64, 1/64];
array[1..4] of float: signox = [1.0, 1.0, -1.0, -1.0];
array[1..4] of float: signoy = [1.0, -1.0, -1.0, 1.0];

% Retorna true si el punto que se revisa está al interior del territorio permitido.
predicate checkInsideLand(var float: x, var float: y) = (
  (
    y >= 0 /\ 
    y <= n /\ 
    x >= 0  /\ 
    x <= n
  )
);

predicate checkOutside(var float: ya, var float: yb, int: l, int: j, var float: x, var float: y) = (
  let{
    var float: xjmagic = (X[j] + r*direccionX[l]);
  } in
    (ya > y xor (yb > y)) /\
    (x < (((X[j] + r*direccionX[l - 1] - xjmagic) * (y-ya)) / (yb-ya) + xjmagic))
);

predicate checkPoint(var float: x, var float: y, int: j) = (
  (
    checkInsideLand(x, y) /\
    let{
      var int: sumita = sum(l in 2..5)(
      checkOutside(Y[j] + r*direccionY[l],Y[j] + r*direccionY[l - 1],l,j,x,y)
    )
    }in sumita = 0 \/ sumita = 2)
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