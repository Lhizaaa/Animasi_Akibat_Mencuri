//  Character.pde
//  Class karakter + 3 varian (RANGGA, PAKBUDI, PAKUSTAD) lewat parameter "type".
//  [KRITERIA 4] class & objek
//  [KRITERIA 5] translate(), rotate(), scale()
//  [KRITERIA 6] badan/jubah pakai beginShape()/endShape()

class Character {
  String type;            // "RANGGA" | "PAKBUDI" | "PAKUSTAD"
  float x, y;             // y = posisi kaki (berpijak di tanah)
  float scaleFactor = 1.15;
  int   faceDir = 1;      // 1 = kanan, -1 = kiri
  int   state = IDLE;
  float targetX;          // tujuan jalan
  float speed = 2.4;
  boolean visible = true;
  boolean carrying = false;  // membawa mangga curian
  boolean sad = false;       // menunduk / menyesal
  float walkPhase = 0;       // fase ayunan kaki-tangan
  float breath = 0;          // fase napas (idle)

  color skin, cloth, clothDark, hatCol, pantCol;

  Character(String type, float x, float y) {
    this.type = type;
    this.x = x;
    this.y = y;
    this.targetX = x;
    this.breath = random(TWO_PI);

    // ciri warna per karakter
    if (type.equals("RANGGA")) {            // pemuda kurus, kaos merah, topi
      skin = color(238, 198, 156);
      cloth = color(214, 58, 52);
      clothDark = color(168, 40, 36);
      pantCol = color(58, 70, 96);
      hatCol = color(60, 120, 70);
      scaleFactor = 1.08;
    } else if (type.equals("PAKBUDI")) {    // dewasa gemuk, kumis, peci hitam
      skin = color(214, 168, 124);
      cloth = color(110, 150, 96);
      clothDark = color(86, 120, 74);
      pantCol = color(90, 78, 66);
      hatCol = color(28, 30, 40);
      scaleFactor = 1.22;
    } else {                                // PAKUSTAD: jubah putih, peci putih, janggut
      skin = color(228, 186, 146);
      cloth = color(248, 248, 244);
      clothDark = color(214, 214, 206);
      pantCol = color(236, 236, 230);
      hatCol = color(252, 252, 250);
      scaleFactor = 1.2;
    }
  }

  void walkTo(float tx) { targetX = tx; if (state == IDLE) state = WALK; }
  void setState(int s)  { state = s; }

  // y puncak kepala (sasaran ekor balon kata)
  float headTopY() { return y - 152 * scaleFactor; }

  void update() {
    breath += 0.05;
    if (state == WALK || state == RUN) {
      float spd = (state == RUN) ? speed * 2.1 : speed;
      if (abs(targetX - x) > spd) {
        float dir = (targetX > x) ? 1 : -1;
        x += dir * spd;
        faceDir = (int) dir;
        walkPhase += (state == RUN) ? 0.55 : 0.30;
      } else {
        x = targetX;
        if (state == WALK) state = IDLE;   // sampai tujuan -> diam
      }
    } else {
      walkPhase += 0.02;                    // ayunan kecil saat idle
    }
  }

  void display() {
    if (!visible) return;

    // [BAYANGAN] bayangan di kaki (tidak ikut napas/flip)
    drawShadow(x, y + 4, 60 * scaleFactor, 15);

    pushMatrix();
    pushStyle();

    translate(x, y);                         // [TRANSFORMASI] translasi

    if (state == RUN) rotate(faceDir * 0.13); // [TRANSFORMASI] rotasi (condong saat lari)
    else if (sad)     rotate(faceDir * 0.05); // menunduk saat menyesal

    float br = 1.0 + 0.022 * sin(breath);    // napas
    scale(faceDir * scaleFactor, br * scaleFactor); // [TRANSFORMASI] dilatasi + flip arah

    drawBody();

    popStyle();
    popMatrix();
  }

  //  Gambar tubuh (menghadap kanan, kaki di origin)
  void drawBody() {
    float hipY    = -56;
    float shldrY  = -106;
    float headCY  = -130;

    float legSwing = sin(walkPhase) * ((state == IDLE) ? 0.04 : (state == RUN ? 0.7 : 0.45));
    float armSwing = sin(walkPhase + PI) * ((state == IDLE) ? 0.04 : (state == RUN ? 0.7 : 0.4));

    boolean isUstad = type.equals("PAKUSTAD");

    // KAKI (rotasi = ayunan)
    if (!isUstad) {
      drawLimb(-6, hipY, 58, legSwing,  pantCol, 13);   // [TRANSFORMASI] rotasi kaki
      drawLimb( 6, hipY, 58, -legSwing, lerpColor(pantCol, color(0), 0.18), 13);
    } else {
      // kaki Pak Ustad samar (di balik jubah)
      drawLimb(-5, -34, 32, legSwing * 0.3,  color(120, 90, 60), 10);
      drawLimb( 5, -34, 32, -legSwing * 0.3, color(120, 90, 60), 10);
    }

    // LENGAN BELAKANG
    drawLimb(-2, shldrY, 46, armSwing, clothDark, 11);

    // BADAN / JUBAH
    drawTorso(hipY, shldrY);                 // [SHAPE] badan/jubah organik

    // LENGAN DEPAN
    if (carrying) {
      // tangan menjulur memegang mangga curian
      pushMatrix(); pushStyle();
      translate(2, shldrY);
      rotate(-0.9);                          // [TRANSFORMASI] rotasi lengan memegang
      stroke(skin); strokeWeight(11); strokeCap(ROUND);
      line(0, 0, 0, 44);
      noStroke(); fill(214, 178, 64);        // mangga
      ellipse(0, 48, 22, 17);
      fill(120, 170, 60); ellipse(-7, 44, 6, 5);
      popStyle(); popMatrix();
    } else {
      float frontArm = sad ? -0.5 : -armSwing; // sedih: tangan di dada
      drawLimb(2, shldrY, 46, frontArm, cloth, 11);
    }

    // KEPALA
    drawHead(headCY);
  }

  // satu anggota badan (kaki/tangan), rotasi = ayunan
  void drawLimb(float px, float py, float len, float ang, color col, float w) {
    pushMatrix(); pushStyle();
    translate(px, py);
    rotate(ang);                             // [TRANSFORMASI] rotasi (ayunan)
    stroke(col); strokeWeight(w); strokeCap(ROUND);
    line(0, 0, 0, len);
    popStyle(); popMatrix();
  }

  // badan / jubah pakai beginShape() + curveVertex()
  void drawTorso(float hipY, float shldrY) {
    pushStyle();
    noStroke();
    fill(cloth);

    if (type.equals("PAKUSTAD")) {
      // [SHAPE] jubah panjang melebar ke bawah
      beginShape();
      curveVertex(-15, shldrY);
      curveVertex(-15, shldrY);
      curveVertex(-19, hipY);
      curveVertex(-30, -18);
      curveVertex(-34, -2);
      curveVertex( 34, -2);
      curveVertex( 30, -18);
      curveVertex( 19, hipY);
      curveVertex( 15, shldrY);
      curveVertex( 15, shldrY);
      endShape(CLOSE);
      stroke(clothDark); strokeWeight(2); noFill();
      line(0, shldrY + 6, 0, -8);            // garis tengah jubah
    } else if (type.equals("PAKBUDI")) {
      // [SHAPE] badan gemuk (perut membulat)
      fill(cloth);
      beginShape();
      curveVertex(-16, shldrY);
      curveVertex(-16, shldrY);
      curveVertex(-24, (shldrY + hipY) / 2);
      curveVertex(-18, hipY);
      curveVertex( 18, hipY);
      curveVertex( 24, (shldrY + hipY) / 2);
      curveVertex( 16, shldrY);
      curveVertex( 16, shldrY);
      endShape(CLOSE);
    } else {
      // [SHAPE] badan kurus Rangga
      fill(cloth);
      beginShape();
      curveVertex(-13, shldrY);
      curveVertex(-13, shldrY);
      curveVertex(-15, (shldrY + hipY) / 2);
      curveVertex(-12, hipY);
      curveVertex( 12, hipY);
      curveVertex( 15, (shldrY + hipY) / 2);
      curveVertex( 13, shldrY);
      curveVertex( 13, shldrY);
      endShape(CLOSE);
    }
    popStyle();
  }

  // kepala + wajah + penutup kepala tiap karakter
  void drawHead(float cy) {
    pushStyle();
    // leher
    stroke(skin); strokeWeight(9); line(0, cy + 16, 0, cy + 26);

    // kepala
    noStroke(); fill(skin);
    ellipse(0, cy, 34, 38);

    // mata
    fill(30);
    float eyeY = sad ? cy - 1 : cy - 3;
    ellipse(6, eyeY, 4.5, 5.5);
    ellipse(15, eyeY, 4.5, 5.5);

    // alis saat gelisah/sedih
    if (sad || type.equals("RANGGA")) {
      stroke(60, 40, 30); strokeWeight(2); noFill();
      line(3, cy - 9, 9, cy - 7);
      line(12, cy - 7, 18, cy - 9);
    }

    // mulut
    noFill(); stroke(120, 60, 50); strokeWeight(2);
    if (sad) arc(10, cy + 9, 12, 9, PI + 0.3, TWO_PI - 0.3);
    else     arc(10, cy + 7, 12, 8, 0.3, PI - 0.3);

    // penutup kepala & ciri khas
    if (type.equals("RANGGA")) {
      // topi + klep
      noStroke(); fill(hatCol);
      arc(2, cy - 6, 40, 34, PI, TWO_PI);
      rect(14, cy - 8, 22, 6, 3);
    } else if (type.equals("PAKBUDI")) {
      // peci hitam
      noStroke(); fill(hatCol);
      rect(-15, cy - 22, 30, 16, 4);
      // kumis tebal
      fill(40, 28, 20);
      ellipse(8, cy + 4, 20, 7);
      fill(40, 30, 24); ellipse(-13, cy + 2, 8, 14);   // rambut samping
    } else {
      // PAK USTAD: peci putih + janggut
      noStroke(); fill(hatCol);
      arc(0, cy - 8, 38, 30, PI, TWO_PI);
      stroke(210); strokeWeight(1); line(-17, cy - 8, 17, cy - 8);
      // [SHAPE] janggut
      noStroke(); fill(235, 235, 230);
      beginShape();
      curveVertex(-14, cy + 6);
      curveVertex(-14, cy + 6);
      curveVertex(-12, cy + 20);
      curveVertex(  0, cy + 30);
      curveVertex( 12, cy + 20);
      curveVertex( 16, cy + 6);
      curveVertex( 16, cy + 6);
      endShape(CLOSE);
    }
    popStyle();
  }
}
