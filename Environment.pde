//  Environment.pde
//  Elemen pedesaan sebagai class & objek.
//  [KRITERIA 4] class & objek
//  [KRITERIA 6] beginShape()/endShape()
//  [TRANSFORMASI] rotate (sinar matahari), translate (awan)

// TANAH / RUMPUT
class GrassField {
  float topY;
  GrassField(float topY) { this.topY = topY; }
  void display() {
    pushStyle();
    noStroke();
    fill(C_GRASS);
    rect(0, topY, VW, VH - topY);
    // tekstur garis rumput
    stroke(C_GRASS_DARK); strokeWeight(2);
    for (int i = 0; i < 90; i++) {
      float gx = (i * 53) % VW;
      float gy = topY + 18 + ((i * 37) % (int)(VH - topY - 20));
      line(gx, gy, gx - 3, gy - 8);
      line(gx + 4, gy, gx + 5, gy - 7);
    }
    popStyle();
  }
}

// JALAN DESA
class Road {
  float cx, topY, wTop, wBot;
  Road(float cx, float topY, float wTop, float wBot) {
    this.cx = cx; this.topY = topY; this.wTop = wTop; this.wBot = wBot;
  }
  void display() {
    pushStyle();
    noStroke(); fill(C_ROAD);
    // jalan menyempit ke kejauhan (trapesium)
    quad(cx - wTop/2, topY, cx + wTop/2, topY,
         cx + wBot/2, VH, cx - wBot/2, VH);
    // batu kerikil
    fill(178, 160, 132);
    for (int i = 0; i < 40; i++) {
      float ry = topY + (i * 29) % (VH - topY);
      float spread = map(ry, topY, VH, wTop, wBot) * 0.4;
      ellipse(cx + sin(i * 2.3) * spread, ry, 5, 3);
    }
    popStyle();
  }
}

// MATAHARI (sinar berputar)
class Sun {
  float x, y, r;
  Sun(float x, float y, float r) { this.x = x; this.y = y; this.r = r; }
  void display() {
    pushMatrix(); pushStyle();
    translate(x, y);                          // [TRANSFORMASI] translasi
    // sinar berputar
    pushMatrix();
    rotate(frameCount * 0.006);               // [TRANSFORMASI] rotasi
    stroke(255, 214, 92, 200); strokeWeight(6); strokeCap(ROUND);
    for (int i = 0; i < 12; i++) {
      rotate(TWO_PI / 12);
      line(r + 8, 0, r + 26, 0);
    }
    popMatrix();
    // bola matahari
    noStroke();
    fill(255, 236, 140, 120); ellipse(0, 0, r * 2.5, r * 2.5);
    fill(255, 214, 70);       ellipse(0, 0, r * 2, r * 2);
    popStyle(); popMatrix();
  }
}

// AWAN (beginShape + bergerak)
class Cloud {
  float x, y, s, spd;
  Cloud(float x, float y, float s, float spd) { this.x = x; this.y = y; this.s = s; this.spd = spd; }
  void display() {
    x += spd;
    if (x - 120 * s > VW) x = -120 * s;     // loop
    pushMatrix(); pushStyle();
    translate(x, y);                          // [TRANSFORMASI] translasi (awan bergerak)
    scale(s);
    noStroke(); fill(255, 255, 255, 230);
    // [SHAPE] gumpalan awan
    beginShape();
    curveVertex(-60, 10);
    curveVertex(-60, 10);
    curveVertex(-40, -14);
    curveVertex(-12, -24);
    curveVertex(  16, -28);
    curveVertex(  44, -16);
    curveVertex(  62, 8);
    curveVertex(  62, 12);
    curveVertex( -60, 12);
    curveVertex( -60, 12);
    endShape(CLOSE);
    popStyle(); popMatrix();
  }
}

// BUKIT LATAR (beginShape)
class Hill {
  float baseY, h, hue;
  color col;
  Hill(float baseY, float h, color col) { this.baseY = baseY; this.h = h; this.col = col; }
  void display() {
    pushStyle();
    noStroke(); fill(col);
    // [SHAPE] bukit bergelombang
    beginShape();
    curveVertex(-50, baseY);
    curveVertex(-50, baseY);
    curveVertex(VW * 0.15, baseY - h);
    curveVertex(VW * 0.4, baseY - h * 0.6);
    curveVertex(VW * 0.65, baseY - h);
    curveVertex(VW * 0.9, baseY - h * 0.5);
    curveVertex(VW + 50, baseY - h * 0.8);
    curveVertex(VW + 50, baseY);
    curveVertex(VW + 50, baseY);
    endShape(CLOSE);
    popStyle();
  }
}

// POHON — jenis: 0=BULAT, 1=CEMARA, 2=MANGGA, 3=KELAPA
class Tree {
  float x, y, s;
  int jenis;
  boolean berbuah;
  Tree(float x, float y, float s, int jenis) {
    this.x = x; this.y = y; this.s = s; this.jenis = jenis;
    this.berbuah = (jenis == 2);
  }
  void display() {
    drawShadow(x, y + 2, 120 * s, 24 * s);   // [BAYANGAN] (ikut skala pohon)
    pushMatrix(); pushStyle();
    translate(x, y);
    scale(s);
    float sway = sin(frameCount * 0.02 + x) * 0.02;
    rotate(sway);                              // [TRANSFORMASI] rotasi (goyang halus)

    if (jenis == 3) drawKelapa();
    else if (jenis == 1) drawCemara();
    else drawRimbun(jenis == 2);

    popStyle(); popMatrix();
  }

  // pohon bulat / mangga
  void drawRimbun(boolean mangga) {
    // batang
    noStroke(); fill(C_TRUNK);
    rect(-8, -90, 16, 90, 4);
    // [SHAPE] mahkota daun
    fill(mangga ? color(58, 132, 60) : C_LEAF);
    beginShape();
    curveVertex(-50, -90);
    curveVertex(-50, -90);
    curveVertex(-64, -128);
    curveVertex(-34, -160);
    curveVertex(  0, -172);
    curveVertex( 36, -158);
    curveVertex( 62, -126);
    curveVertex( 48, -90);
    curveVertex(  0, -78);
    curveVertex(-50, -90);
    curveVertex(-50, -90);
    endShape(CLOSE);
    // sorot daun lebih terang
    fill(mangga ? color(80, 158, 78) : C_LEAF2);
    ellipse(-14, -130, 50, 44);
    if (mangga) {
      // buah mangga
      fill(222, 182, 70);
      ellipse(-26, -108, 16, 12);
      ellipse(  8, -120, 16, 12);
      ellipse( 30, -100, 16, 12);
      ellipse(-4, -96, 16, 12);
    }
  }

  // pohon cemara (segitiga bertumpuk)
  void drawCemara() {
    noStroke(); fill(C_TRUNK);
    rect(-7, -60, 14, 60, 3);
    fill(46, 120, 64);
    triangle(-46, -70, 46, -70, 0, -150);
    triangle(-40, -110, 40, -110, 0, -180);
    fill(58, 138, 74);
    triangle(-32, -150, 32, -150, 0, -206);
  }

  // pohon kelapa (batang melengkung + pelepah)
  void drawKelapa() {
    noFill(); stroke(C_TRUNK); strokeWeight(14); strokeCap(ROUND);
    // [SHAPE] batang melengkung
    beginShape();
    curveVertex(0, 0);
    curveVertex(0, 0);
    curveVertex(8, -70);
    curveVertex(-6, -140);
    curveVertex(-18, -190);
    curveVertex(-18, -190);
    endShape();
    // pelepah daun (rotasi menyebar)
    pushMatrix();
    translate(-18, -190);
    stroke(54, 126, 60); strokeWeight(7);
    for (int i = 0; i < 6; i++) {
      float a = map(i, 0, 5, -2.5, -0.6);
      pushMatrix();
      rotate(a);                               // [TRANSFORMASI] rotasi (pelepah)
      noFill();
      beginShape();                            // [SHAPE] pelepah melengkung
      curveVertex(0, 0);
      curveVertex(0, 0);
      curveVertex(40, 6);
      curveVertex(80, 24);
      curveVertex(80, 24);
      endShape();
      popMatrix();
    }
    // buah kelapa
    noStroke(); fill(96, 70, 44);
    ellipse(2, 6, 14, 14); ellipse(-10, 8, 14, 14);
    popMatrix();
  }
}

// RUMAH
class House {
  float x, y, w, h;
  color wall, roof;
  House(float x, float y, float w, float h, color wall, color roof) {
    this.x = x; this.y = y; this.w = w; this.h = h; this.wall = wall; this.roof = roof;
  }
  void display() {
    drawShadow(x, y + 2, w * 1.1, 22);        // [BAYANGAN]
    pushMatrix(); pushStyle();
    translate(x, y);
    noStroke();
    // dinding
    fill(wall); rect(-w/2, -h, w, h);
    // atap segitiga
    fill(roof); triangle(-w/2 - 12, -h, w/2 + 12, -h, 0, -h - h*0.55);
    // pintu
    fill(110, 78, 52); rect(-14, -42, 28, 42, 3);
    fill(230,200,90); ellipse(8, -22, 4, 4);
    // jendela
    fill(150, 205, 230);
    rect(-w/2 + 14, -h + 18, 24, 24, 3);
    rect(w/2 - 38, -h + 18, 24, 24, 3);
    stroke(90); strokeWeight(2);
    line(-w/2 + 26, -h + 18, -w/2 + 26, -h + 42);
    line(w/2 - 26, -h + 18, w/2 - 26, -h + 42);
    popStyle(); popMatrix();
  }
}

// PAGAR KAYU
class Fence {
  float x, y, segLen; int n;
  Fence(float x, float y, int n, float segLen) { this.x = x; this.y = y; this.n = n; this.segLen = segLen; }
  void display() {
    pushStyle();
    stroke(150, 110, 70); strokeWeight(5);
    float x2 = x + n * segLen;
    line(x, y - 22, x2, y - 22);
    line(x, y - 10, x2, y - 10);
    for (int i = 0; i <= n; i++) {
      float px = x + i * segLen;
      line(px, y - 34, px, y + 4);
    }
    popStyle();
  }
}

// TONG SAMPAH
class TrashCan {
  float x, y;
  TrashCan(float x, float y) { this.x = x; this.y = y; }
  void display() {
    pushStyle();
    noStroke();
    drawShadow(x, y + 2, 50, 13);             // [BAYANGAN]
    fill(70, 120, 90);  rect(x - 18, y - 46, 36, 46, 4);   // badan
    fill(54, 100, 74);  rect(x - 22, y - 54, 44, 10, 3);   // tutup
    fill(40, 80, 58);   rect(x - 6, y - 60, 12, 6, 2);     // pegangan
    stroke(40, 80, 58); strokeWeight(2);
    line(x - 10, y - 44, x - 10, y - 4);
    line(x + 10, y - 44, x + 10, y - 4);
    // simbol daur ulang
    noFill(); stroke(235); strokeWeight(2.5);
    pushMatrix();
    translate(x, y - 22);
    for (int i = 0; i < 3; i++) {
      rotate(TWO_PI / 3);                      // [TRANSFORMASI] rotasi
      line(-4, -7, 4, -7);
    }
    popMatrix();
    popStyle();
  }
}

// BUNGA
class Flower {
  float x, y; color col;
  Flower(float x, float y, color col) { this.x = x; this.y = y; this.col = col; }
  void display() {
    drawShadow(x, y + 1, 16, 5);              // [BAYANGAN]
    pushMatrix(); pushStyle();
    translate(x, y);
    stroke(60, 130, 60); strokeWeight(3); line(0, 0, 0, -18);
    noStroke();
    pushMatrix();
    translate(0, -22);
    rotate(frameCount * 0.01);                 // [TRANSFORMASI] rotasi (kelopak)
    fill(col);
    for (int i = 0; i < 5; i++) { rotate(TWO_PI/5); ellipse(0, -6, 7, 11); }
    fill(255, 210, 70); ellipse(0, 0, 7, 7);
    popMatrix();
    popStyle(); popMatrix();
  }
}

// WARUNG / LAPAK
class Warung {
  float x, y, w;
  Warung(float x, float y, float w) { this.x = x; this.y = y; this.w = w; }
  void display() {
    pushStyle();
    noStroke();
    drawShadow(x, y + 2, w * 1.05, 20);       // [BAYANGAN]
    // tiang + meja
    fill(140, 100, 64);
    rect(x - w/2, y - 14, w, 14);
    rect(x - w/2 + 6, y - 14, 8, 14);
    rect(x + w/2 - 14, y - 14, 8, 14);
    // atap terpal bergaris
    for (int i = 0; i < 6; i++) {
      fill((i % 2 == 0) ? color(220, 80, 70) : color(245, 235, 220));
      float seg = w / 6;
      rect(x - w/2 + i*seg, y - 86, seg, 18);
    }
    fill(120, 84, 52);
    rect(x - w/2, y - 90, w, 6);               // bingkai atap
    rect(x - w/2 + 4, y - 84, 6, 70);          // tiang kiri
    rect(x + w/2 - 10, y - 84, 6, 70);         // tiang kanan
    // dagangan di meja
    fill(230, 120, 60); ellipse(x - 30, y - 20, 14, 12);
    fill(120, 200, 90); ellipse(x - 10, y - 20, 14, 12);
    fill(240, 210, 90); ellipse(x + 12, y - 20, 14, 12);
    fill(200, 60, 60);  ellipse(x + 32, y - 20, 14, 12);
    // papan nama
    fill(80, 110, 150); rect(x - 34, y - 112, 68, 22, 4);
    fill(255); textSize(13); text("WARUNG", x, y - 101);
    popStyle();
  }
}

// PEMILIK WARUNG TIDUR DI BANGKU
//  [SHAPE] perut & kepala organik   [TRANSFORMASI] rotasi badan/kepala bersandar
class WarungOwner {
  float bx, by;     // bx = pusat bangku, by = garis tanah
  WarungOwner(float bx, float by) { this.bx = bx; this.by = by; }

  void display() {
    drawShadow(bx, by + 2, 180, 20);          // [BAYANGAN]
    pushMatrix(); pushStyle();
    translate(bx, by);
    float seatY = -50;                       // tinggi dudukan
    float breath = sin(frameCount * 0.045);  // napas pelan

    // BANGKU KAYU
    noStroke();
    fill(120, 84, 52);                        // kaki bangku
    rect(-66, seatY, 12, 50, 2);
    rect( 54, seatY, 12, 50, 2);
    fill(152, 106, 66);                       // dudukan
    rect(-80, seatY, 160, 12, 3);
    fill(120, 84, 52);                        // tiang sandaran
    rect(-74, seatY - 46, 8, 46, 2);
    rect( 66, seatY - 46, 8, 46, 2);
    fill(152, 106, 66);                       // palang sandaran
    rect(-76, seatY - 46, 150, 9, 3);
    rect(-76, seatY - 28, 150, 9, 3);

    // SOSOK TERTIDUR
    pushMatrix();
    translate(2, seatY);
    drawSleeper(breath);
    popMatrix();

    popStyle(); popMatrix();
  }

  void drawSleeper(float breath) {
    color skin   = color(214, 168, 124);
    color baju   = color(150, 120, 200);
    color celana = color(82, 80, 72);

    // kaki menjulur ke depan
    stroke(celana); strokeWeight(15); strokeCap(ROUND);
    line(-6, -4, -22, 46);
    line( 8, -4,  18, 46);
    noStroke(); fill(58, 48, 42);             // sandal
    ellipse(-24, 48, 22, 10);
    ellipse( 20, 48, 22, 10);

    // badan gemuk bersandar ke belakang
    pushMatrix();
    rotate(-0.13);                            // [TRANSFORMASI] rotasi (bersandar)
    noStroke(); fill(baju);
    beginShape();                             // [SHAPE] perut buncit
    curveVertex(-22, -4);
    curveVertex(-22, -4);
    curveVertex(-32, -40);
    curveVertex(-16, -68);
    curveVertex( 16, -68);
    curveVertex( 32, -40);
    curveVertex( 22, -4);
    curveVertex(-22, -4);
    curveVertex(-22, -4);
    endShape(CLOSE);
    // tangan terkulai di atas perut
    stroke(skin); strokeWeight(13); strokeCap(ROUND);
    line(-18, -46, -3, -18);
    line( 18, -46,  3, -18);

    // kepala miring tertidur
    pushMatrix();
    translate(2, -68);
    rotate(0.34 + breath * 0.03);             // [TRANSFORMASI] rotasi (kepala + napas)
    stroke(skin); strokeWeight(11); line(0, 0, 0, 9);   // leher
    noStroke(); fill(skin);
    ellipse(0, -16, 38, 42);                  // kepala
    fill(40, 60, 110);                        // peci
    arc(0, -24, 40, 32, PI, TWO_PI);
    rect(-20, -25, 40, 5, 2);
    // mata terpejam
    stroke(70, 50, 40); strokeWeight(2); noFill();
    arc(-7, -16, 9, 6, 0.2, PI - 0.2);
    arc( 8, -16, 9, 6, 0.2, PI - 0.2);
    // kumis + mulut terbuka
    noStroke(); fill(60, 45, 35);
    ellipse(0, -8, 18, 5);
    fill(110, 65, 58); ellipse(0, -2, 8, 6);
    popMatrix();   // kepala
    popMatrix();   // badan

    // dengkur "Z z z"
    drawSnore();
  }

  void drawSnore() {
    pushStyle();
    textAlign(LEFT, CENTER);
    float cyc = (frameCount % 200) / 200.0;
    for (int i = 0; i < 3; i++) {
      float ph = (cyc + i * 0.33) % 1.0;
      float xx = 24 + ph * 30;
      float yy = -92 - ph * 48;
      fill(90, 90, 110, 230 * (1 - ph));
      textSize(13 + i * 6);
      text("Z", xx, yy);
    }
    popStyle();
  }
}

// MASJID (kubah + menara)
class Mosque {
  float x, y, w, h;
  Mosque(float x, float y, float w, float h) { this.x = x; this.y = y; this.w = w; this.h = h; }
  void display() {
    pushStyle();
    noStroke();
    drawShadow(x, y + 2, w * 1.5, 26);        // [BAYANGAN]
    // badan masjid
    fill(238, 232, 210);
    rect(x - w/2, y - h, w, h, 4);
    // [SHAPE] kubah utama
    fill(74, 158, 142);
    beginShape();
    curveVertex(x - w*0.32, y - h);
    curveVertex(x - w*0.32, y - h);
    curveVertex(x - w*0.32, y - h - h*0.35);
    curveVertex(x, y - h - h*0.62);
    curveVertex(x + w*0.32, y - h - h*0.35);
    curveVertex(x + w*0.32, y - h);
    curveVertex(x + w*0.32, y - h);
    endShape(CLOSE);
    // bulan-bintang puncak kubah
    fill(232, 200, 90);
    ellipse(x, y - h - h*0.72, 8, 8);
    rect(x - 1.5, y - h - h*0.86, 3, 14);
    // menara kiri & kanan
    for (int sgn = -1; sgn <= 1; sgn += 2) {
      float mx = x + sgn * (w/2 + 16);
      fill(238, 232, 210); rect(mx - 9, y - h - 36, 18, h + 36, 3);
      fill(74, 158, 142);
      arc(mx, y - h - 36, 24, 24, PI, TWO_PI);
      fill(232, 200, 90); ellipse(mx, y - h - 50, 5, 5);
    }
    // pintu lengkung
    fill(120, 90, 60);
    arc(x, y, 46, 70, PI, TWO_PI);
    rect(x - 23, y - 18, 46, 18);
    // jendela lengkung
    fill(150, 205, 230);
    arc(x - w*0.3, y - h*0.55, 26, 40, PI, TWO_PI);
    arc(x + w*0.3, y - h*0.55, 26, 40, PI, TWO_PI);
    popStyle();
  }
}
