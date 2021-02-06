import 'dart:math';

typedef void Spiraled(int x, int z);

class Spiraler {
  int x, z, dx, dz, sizeX, sizeZ, t, maxI, i;
  int ox, oz;
  Spiraled spiraled;

  static void spiral(int x, int z, Spiraled spiraled) =>
      Spiraler(x, z, spiraled).drain();

  Spiraler(int sizeX, int sizeZ, Spiraled spiraled) {
    ox = 0;
    oz = 0;
    this.spiraled = spiraled;
    retarget(sizeX, sizeZ);
  }

  void drain() {
    while (hasNext()) {
      next();
    }
  }

  Spiraler setOffset(int ox, int oz) {
    this.ox = ox;
    this.oz = oz;
    return this;
  }

  void retarget(int sizeX, int sizeZ) {
    this.sizeX = sizeX;
    this.sizeZ = sizeZ;
    x = z = dx = 0;
    dz = -1;
    i = 0;
    t = max(sizeX, sizeZ);
    maxI = t * t;
  }

  bool hasNext() {
    return i < maxI;
  }

  void next() {
    if ((-sizeX / 2 <= x) &&
        (x <= sizeX / 2) &&
        (-sizeZ / 2 <= z) &&
        (z <= sizeZ / 2)) {
      spiraled(x + ox, z + ox);
    }

    if ((x == z) || ((x < 0) && (x == -z)) || ((x > 0) && (x == 1 - z))) {
      t = dx;
      dx = -dz;
      dz = t;
    }
    x += dx;
    z += dz;
    i++;
  }
}
