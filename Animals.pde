//  Animals.pde
//  Hewan pedesaan: Bird, Chicken, Cat.
//  [TRANSFORMASI] translate (gerak), rotate (sayap/ekor), scale (napas)

// BURUNG (terbang melintas)
class Bird {
  float x, y, spd, s;
  Bird(float x, float y, float spd, float s) { this.x = x; this.y = y; this.spd = spd; this.s = s; }
  void display() {
    x += spd;
    if (spd > 0 && x > VW + 40) x = -40;
    if (spd < 0 && x < -40) x = VW + 40;
    float yy = y + sin(frameCount * 0.05 + x * 0.01) * 8;   // naik-turun

    pushMatrix(); pushStyle();
    translate(x, yy);                          // [TRANSFORMASI] translasi
    scale(s * (spd < 0 ? -1 : 1), s);
    float flap = sin(frameCount * 0.4) * 0.6;  // kepakan
    stroke(60, 60, 70); strokeWeight(3); noFill();
    // sayap kiri & kanan (rotasi = mengepak)
    pushMatrix(); rotate(-flap); line(0, 0, -16, -4); popMatrix();  // [TRANSFORMASI] rotasi
    pushMatrix(); rotate(flap);  line(0, 0,  16, -4); popMatrix();
    // badan
    noStroke(); fill(70, 70, 80); ellipse(0, 0, 10, 6);
    popStyle(); popMatrix();
  }
}

//  AYAM (jalan + mematuk)
class Chicken {
  float x, y, baseX, range, t;
  boolean alarmed = false;     // ribut saat hampir ketahuan
  Chicken(float x, float y, float range) {
    this.x = x; this.y = y; this.baseX = x; this.range = range; this.t = random(TWO_PI);
  }
  void display() {
    t += alarmed ? 0.12 : 0.03;
    x = baseX + sin(t) * range;                // [TRANSFORMASI] (jalan bolak-balik)
    int dir = (cos(t) >= 0) ? 1 : -1;
    float peck = alarmed ? abs(sin(t*4)) * 0.5 : max(0, sin(t * 2)) * 0.35;
    float hop = alarmed ? abs(sin(t*6)) * 8 : 0;

    drawShadow(x, y + 1, 28 - hop * 0.6, 8);   // [BAYANGAN] (tetap di tanah saat lompat)

    pushMatrix(); pushStyle();
    translate(x, y - hop);                      // [TRANSFORMASI] translasi
    scale(dir, 1);
    noStroke();
    // kaki
    stroke(220, 160, 40); strokeWeight(2.5);
    line(-3, 0, -3, -10); line(4, 0, 4, -10);
    // badan
    noStroke(); fill(245, 240, 232);
    ellipse(0, -20, 30, 24);
    // ekor
    fill(230, 224, 214); triangle(-14, -22, -22, -32, -12, -14);
    // kepala (mematuk = rotasi)
    pushMatrix();
    translate(10, -28);
    rotate(peck);                               // [TRANSFORMASI] rotasi
    fill(245, 240, 232); ellipse(0, 0, 14, 14);
    fill(230, 120, 60); triangle(6, 0, 14, -1, 6, 4);   // paruh
    fill(220, 60, 50); arc(-2, -8, 8, 8, PI, TWO_PI);   // jengger
    fill(30); ellipse(2, -1, 3, 3);                     // mata
    popMatrix();
    popStyle(); popMatrix();
  }
}

//  KUCING (duduk, ekor bergerak, napas)
class Cat {
  float x, y;
  Cat(float x, float y) { this.x = x; this.y = y; }
  void display() {
    drawShadow(x, y + 2, 34, 10);               // [BAYANGAN]
    pushMatrix(); pushStyle();
    translate(x, y);                            // [TRANSFORMASI] translasi
    float br = 1 + sin(frameCount * 0.06) * 0.03;
    scale(1, br);                               // [TRANSFORMASI] dilatasi (napas)
    noStroke();
    color fur = color(120, 110, 100);
    // ekor (bergoyang = rotasi)
    pushMatrix();
    translate(-16, -10);
    rotate(sin(frameCount * 0.05) * 0.5);       // [TRANSFORMASI] rotasi
    stroke(fur); strokeWeight(7); strokeCap(ROUND); noFill();
    line(0, 0, -16, -18);
    popMatrix();
    // badan duduk
    noStroke(); fill(fur);
    ellipse(0, -14, 28, 30);
    // kepala
    ellipse(0, -36, 24, 22);
    // telinga
    triangle(-11, -44, -3, -52, -2, -42);
    triangle(11, -44, 3, -52, 2, -42);
    // wajah
    fill(40); ellipse(-5, -36, 3, 4); ellipse(5, -36, 3, 4);
    fill(230, 150, 150); triangle(-2, -32, 2, -32, 0, -29);
    stroke(60); strokeWeight(1);
    line(-3, -30, -14, -32); line(3, -30, 14, -32);
    popStyle(); popMatrix();
  }
}
