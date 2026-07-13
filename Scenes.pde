//  Scenes.pde
//  Objek lingkungan tiap scene, antrian dialog, dan logika scene
//  (drawScene1..drawScene5) + layar penutup.
//
//  5 lokasi: 1. Kebun mangga  2. Warung desa  3. Halaman rumah
//            4. Jalan desa (sore)  5. Depan masjid (senja) + penutup

// background bersama (berlanjut antar-scene)
Sun sun;
ArrayList<Cloud> clouds = new ArrayList<Cloud>();
ArrayList<Bird>  birds  = new ArrayList<Bird>();
GrassField grass;

// objek khusus tiap scene
ArrayList<Tree>   trees1, trees2, trees3, trees4, trees5;
ArrayList<House>  houses2, houses3, houses4;
ArrayList<Flower> flowers, flowers5;
Tree mangoTree;                 // pohon mangga scene 1
Road road, mosqueRoad;          // jalan scene 4 & jalan ke masjid (scene 5)
Fence fence;
TrashCan trashCan;
Warung warung;
WarungOwner warungOwner;        // pemilik warung tidur (scene 2)
Mosque mosque;
Chicken ayam1, ayam2;
Cat kucing;

// antrian dialog tiap scene
DialogQueue dq1, dq2, dq3, dq4, dq5;

// dekorasi intro
ArrayList<Tree> introTrees;
Mosque introMosque;

//  INISIALISASI OBJEK (dipanggil dari setup)
void initSceneObjects() {
  grass = new GrassField(470);
  sun   = new Sun(180, 150, 38);

  clouds.add(new Cloud(200, 110, 1.0, 0.25));
  clouds.add(new Cloud(620, 80,  1.4, 0.18));
  clouds.add(new Cloud(980, 140, 0.8, 0.32));

  birds.add(new Bird(300, 130, 1.1, 1.0));
  birds.add(new Bird(700, 100, 0.8, 0.8));
  birds.add(new Bird(150, 170, 1.4, 0.9));

  road      = new Road(640, 470, 120, 520);
  mosqueRoad = new Road(640, 472, 96, 300);  // jalan setapak ke masjid (scene 5)
  fence = new Fence(60, 560, 8, 60);
  trashCan = new TrashCan(1120, 600);
  warung   = new Warung(820, 560, 200);
  warungOwner = new WarungOwner(1020, 650);  // tidur di bangku kanan
  mosque   = new Mosque(640, 470, 230, 200);

  // pohon scene 1 (kebun mangga)
  trees1 = new ArrayList<Tree>();
  trees1.add(new Tree(160, 600, 1.0, 2));
  trees1.add(new Tree(980, 560, 0.8, 0));
  trees1.add(new Tree(1080, 600, 1.1, 2));
  mangoTree = new Tree(640, 610, 1.5, 2);   // pohon mangga utama (target curian)

  // pohon scene 2 (warung)
  trees2 = new ArrayList<Tree>();
  trees2.add(new Tree(70, 600, 1.0, 0));
  trees2.add(new Tree(600, 552, 0.8, 1));
  trees2.add(new Tree(1210, 600, 1.05, 2));

  // pohon scene 3 (halaman)
  trees3 = new ArrayList<Tree>();
  trees3.add(new Tree(120, 610, 1.1, 3));
  trees3.add(new Tree(1140, 600, 1.0, 0));

  // pohon scene 4 (jalan desa)
  trees4 = new ArrayList<Tree>();
  trees4.add(new Tree(110, 600, 1.0, 0));
  trees4.add(new Tree(300, 560, 0.8, 1));
  trees4.add(new Tree(1000, 560, 0.9, 2));
  trees4.add(new Tree(1180, 610, 1.1, 3));

  // pohon scene 5 (masjid)
  trees5 = new ArrayList<Tree>();
  trees5.add(new Tree(150, 600, 1.0, 1));
  trees5.add(new Tree(1130, 600, 1.0, 0));

  // rumah scene 2/3/4
  houses2 = new ArrayList<House>();
  houses2.add(new House(180, 470, 170, 120, color(236, 210, 160), color(170, 80, 60)));
  houses2.add(new House(400, 470, 150, 100, color(210, 224, 235), color(120, 90, 70)));

  houses3 = new ArrayList<House>();
  houses3.add(new House(720, 460, 220, 150, color(240, 224, 180), color(150, 70, 55)));

  houses4 = new ArrayList<House>();
  houses4.add(new House(560, 465, 150, 100, color(225, 235, 210), color(140, 95, 70)));
  houses4.add(new House(820, 470, 170, 120, color(236, 210, 175), color(160, 75, 58)));

  // bunga
  flowers = new ArrayList<Flower>();
  flowers.add(new Flower(420, 660, color(240, 90, 120)));
  flowers.add(new Flower(470, 672, color(250, 200, 80)));
  flowers.add(new Flower(880, 668, color(180, 110, 230)));

  // bunga scene 5 (menghiasi sisi jalan & halaman masjid)
  flowers5 = new ArrayList<Flower>();
  // sisi kiri jalan
  flowers5.add(new Flower(150, 650, color(240, 90, 120)));
  flowers5.add(new Flower(225, 672, color(250, 200, 80)));
  flowers5.add(new Flower(120, 702, color(250, 130, 90)));
  flowers5.add(new Flower(310, 690, color(180, 110, 230)));
  // sisi kanan jalan
  flowers5.add(new Flower(975, 660, color(240, 90, 150)));
  flowers5.add(new Flower(1065, 686, color(120, 200, 240)));
  flowers5.add(new Flower(1150, 706, color(250, 210, 90)));
  flowers5.add(new Flower(1030, 712, color(200, 110, 230)));
  // dekat halaman masjid
  flowers5.add(new Flower(455, 556, color(240, 120, 120)));
  flowers5.add(new Flower(825, 556, color(250, 200, 90)));
  flowers5.add(new Flower(400, 600, color(180, 110, 230)));
  flowers5.add(new Flower(880, 600, color(240, 90, 150)));

  // hewan
  ayam1 = new Chicken(520, 640, 60);
  ayam2 = new Chicken(760, 660, 50);
  kucing = new Cat(560, 612);

  // dekorasi intro (dibuat sekali)
  introTrees = new ArrayList<Tree>();
  introTrees.add(new Tree(120,  700, 0.95, 2));   // mangga kiri
  introTrees.add(new Tree(1165, 700, 0.95, 3));   // kelapa kanan
  introMosque = new Mosque(640, 700, 150, 120);   // masjid kecil tengah bawah
}

//  DIALOG tiap scene (detik = waktu dalam scene)
void initDialog() {
  // Tiap baris dialog & suara hewan diberi path file audio (folder data/).
  // Nama file harus persis seperti di bawah agar terpetakan otomatis.

  // SCENE 1 : Kebun mangga (40 dtk)
  dq1 = new DialogQueue();
  dq1.add(rangga,  "Wah, mangga Pak Budi banyak banget... ambil beberapa nggak apa-apa kali yaa.", 5, 6, "dialog/Rangga/Rangga 1.mp3");
  dq1.add(rangga,  "Mumpung nggak ada orang yang lihat.", 12, 4, "dialog/Rangga/Rangga 2.mp3");
  dq1.add(pakBudi, "Heh kamu! Itu mangga siapa yang kamu ambil, ayo cepat kembalikan?!", 27, 6, "dialog/Pak Budi/Pak budi 1.mp3");
  dq1.add(rangga,  "Ampun Pakk, saya cuma... kabuuur!", 32, 4, "dialog/Rangga/Rangga 3.mp3");

  // SCENE 2 : Warung desa (47 dtk)
  dq2 = new DialogQueue();
  dq2.add(rangga,  " Aduh perutku lagi Lapar nih.. mau beli tapi nggak punya uang. Ambil diam-diam aja kali yaa.", 6, 9, "dialog/Rangga/Rangga 4.mp3");
  dq2.addAt(560, 560, "Meong meong!", 22, 5, "sfx/Suara kucing.mp3");                   // suara kucing
  dq2.add(rangga,  "Diam kamu, nanti aku ketahuan!", 33, 4, "dialog/Rangga/Rangga 5.mp3");
  dq2.add(pakBudi, "Anak itu lagi... dari kemarin kelakuannya nggak berubah.", 40, 6, "dialog/Pak Budi/Pak budi 2.mp3");

  // SCENE 3 : Halaman rumah (41 dtk)
  dq3 = new DialogQueue();
  dq3.add(rangga,  "Wah ayam gemuk ini pasti enak kalau dimasak, ambil satu aja deh.", 6, 7, "dialog/Rangga/Rangga 6.mp3");
  dq3.addAt(520, 600, "Petok! Petok! petok!", 15, 6, "sfx/Suara ayam.mp3");  // suara ayam
  dq3.add(rangga,  "Aduh berisik! Jangan teriak doong!", 22, 5, "dialog/Rangga/Rangga 7.mp3");
  dq3.add(rangga,  "Tapi kenapa ya... setiap aku ambil yang bukan milikku hatiku selalu deg-degan dan nggak tenang.", 30, 9, "dialog/Rangga/Rangga 8.mp3");

  // SCENE 4 : Jalan desa, bertemu Pak Ustad (40 dtk)
  dq4 = new DialogQueue();
  dq4.add(pakUstad, "Assalamu'alaikum, Rangga. Kenapa wajahmu murung dan gelisah, Nak?", 5, 8, "dialog/Pak Ustad/Pak Ustad 1.mp3");
  dq4.add(rangga,   "Wa'alaikumussalam, Pak Ustad... saya merasa bersalah. Saya sering kali mengambil yang bukan hak milik saya.", 14, 8, "dialog/Rangga/Rangga 9.mp3");
  dq4.add(pakUstad, "Alhamdulillah kamu menyadarinya. Mari ikut bapak ke masjid, kita shalat maghrib dulu, Bapak nanti akan jelaskan sedikit tentang haramnya perbuatan mencuri.", 23, 16, "dialog/Pak Ustad/Pak Ustad 2.mp3");

  // SCENE 5 : Masjid, taubat (75 dtk)
  dq5 = new DialogQueue();
  dq5.add(pakUstad, "Rangga, mencuri itu hukumnya haram dalam Islam. Allah melarang kita memakan harta sesama dengan jalan yang batil.", 2, 12, "dialog/Pak Ustad/Pak Ustad 3.mp3");
  dq5.add(pakUstad, "Tangan yang mencuri akan dimintai pertanggungjawaban. Sekecil apa pun itu, Allah Maha Melihat.", 15, 10, "dialog/Pak Ustad/Pak Ustad 4.mp3");
  dq5.add(pakUstad, "Rezeki yang halal, meski sedikit, jauh lebih berkah daripada banyak harta tapi dari hasil mencuri.", 26, 10, "dialog/Pak Ustad/Pak Ustad 5.mp3");
  dq5.add(pakUstad, "Pintu taubat selalu terbuka. Kembalikan hak milik orang lain, minta maaflah, dan carilah rezeki dengan bekerja yang jujur.", 37, 12, "dialog/Pak Ustad/Pak Ustad 6.mp3");
  dq5.add(rangga,   "Saya bertaubat, Pak Ustad. Saya akan minta maaf dan kembalikan semuanya, dan juga mencari rezeki dengan bekerja yang jujur.", 51, 11, "dialog/Rangga/Rangga 10.mp3");
  dq5.add(pakBudi,  "Wah nak kamu sudah menyadarinya, Bapak maafkan kamu, Rangga. Ayo kita perbaiki sama-sama.", 64, 8, "dialog/Pak Budi/Pak budi 3.mp3");
}

//  MASUK SCENE BARU — reset posisi & state karakter
void onSceneEnter(int s) {
  playSceneMusic(s);                 // ganti backsound & reset suara dialog
  DialogQueue[] allQueues = { dq1, dq2, dq3, dq4, dq5 };
  allQueues[s].resetPlayback();

  // sembunyikan semua dulu
  rangga.visible = pakBudi.visible = pakUstad.visible = false;
  rangga.carrying = false;
  rangga.sad = false;

  switch (s) {
    case 0:   // kebun
      rangga.visible = true;
      rangga.x = -80; rangga.y = GROUND_Y; rangga.faceDir = 1;
      rangga.setState(WALK); rangga.walkTo(560);
      pakBudi.x = 1360; pakBudi.y = GROUND_Y; pakBudi.setState(IDLE);
      break;
    case 1:   // warung
      rangga.visible = true;
      rangga.x = -80; rangga.y = GROUND_Y; rangga.faceDir = 1;
      rangga.setState(WALK); rangga.walkTo(660);
      pakBudi.x = -120; pakBudi.y = GROUND_Y; pakBudi.setState(IDLE);
      break;
    case 2:   // halaman
      rangga.visible = true;
      rangga.x = -80; rangga.y = GROUND_Y; rangga.faceDir = 1;
      rangga.setState(WALK); rangga.walkTo(440);
      break;
    case 3:   // jalan desa
      rangga.visible = true; pakUstad.visible = true;
      rangga.x = 1180; rangga.y = GROUND_Y; rangga.faceDir = -1;
      rangga.sad = true; rangga.setState(WALK); rangga.walkTo(760);
      pakUstad.x = -60; pakUstad.y = GROUND_Y; pakUstad.faceDir = 1;
      pakUstad.setState(WALK); pakUstad.walkTo(560);
      break;
    case 4:   // masjid
      rangga.visible = true; pakUstad.visible = true;
      rangga.x = 760; rangga.y = GROUND_Y; rangga.faceDir = -1; rangga.sad = true;
      rangga.setState(IDLE);
      pakUstad.x = 480; pakUstad.y = GROUND_Y; pakUstad.faceDir = 1;
      pakUstad.setState(IDLE);
      pakBudi.x = 1360; pakBudi.y = GROUND_Y; pakBudi.faceDir = -1;
      pakBudi.setState(IDLE); pakBudi.visible = false;
      break;
  }
}

//  BACKGROUND BERSAMA (langit, bukit, matahari, awan, burung)
void drawSky(color top, color bot) {
  drawVerticalGradient(top, bot, 0, 480);     // [SHAPE] gradasi langit
}

void drawBackdrop(color skyTop, color skyBot, color hillC, boolean showSun) {
  drawSky(skyTop, skyBot);
  new Hill(478, 150, hillC).display();        // [SHAPE] bukit latar
  if (showSun) sun.display();
  for (Cloud c : clouds) c.display();
  for (Bird b : birds)  b.display();
  grass.display();
}

// BACKDROP PAGI (intro & scene 1): langit biru ke jingga, bukit berkabut
void drawMorningBackdrop(boolean showSun) {
  drawVerticalGradient(color(150, 184, 222), color(255, 224, 178), 0, 480);
  // bukit berlapis -> kesan kedalaman
  new Hill(478, 140, color(150, 178, 150)).display();
  new Hill(478, 100, color(178, 200, 166)).display();
  if (showSun) drawMorningSun(995, 392);
  // kabut tipis di kaki bukit
  pushStyle(); noStroke();
  for (int i = 0; i < 4; i++) {
    fill(255, 255, 255, 38);
    float my = 416 + i * 16;
    ellipse(VW * 0.30, my,     520, 24);
    ellipse(VW * 0.74, my + 8, 470, 22);
  }
  popStyle();
  for (Cloud c : clouds) c.display();
  for (Bird b : birds)  b.display();
  grass.display();
}

// matahari pagi: halo besar + sinar lembut
void drawMorningSun(float x, float y) {
  pushMatrix(); pushStyle();
  translate(x, y);
  noStroke();
  // halo bertingkat
  fill(255, 224, 150, 55);  ellipse(0, 0, 270, 270);
  fill(255, 230, 168, 90);  ellipse(0, 0, 185, 185);
  // sinar berputar
  pushMatrix();
  rotate(frameCount * 0.004);                 // [TRANSFORMASI] rotasi
  stroke(255, 222, 150, 150); strokeWeight(5); strokeCap(ROUND);
  for (int i = 0; i < 14; i++) {
    rotate(TWO_PI / 14);
    line(70, 0, 92, 0);
  }
  popMatrix();
  // bola matahari
  noStroke();
  fill(255, 208, 118); ellipse(0, 0, 108, 108);
  fill(255, 234, 180); ellipse(-8, -8, 58, 58);
  popStyle(); popMatrix();
}

//  INTRO JUDUL — pembuka (suasana pagi)
//  Reveal bertahap: latar -> ornamen -> judul -> subjudul -> ajakan

// easeOutCubic untuk munculnya elemen secara halus
float introEase(float t0, float t1, float now) {
  float k = constrain((now - t0) / (t1 - t0), 0, 1);
  return 1 - pow(1 - k, 3);
}

// ornamen bintang islami 8 sudut (dua persegi bersilang) yang berputar
void drawStarOrnament(float x, float y, float r, float rot, float a) {
  pushMatrix(); pushStyle();
  translate(x, y);
  rotate(rot);
  rectMode(CENTER);
  noFill(); stroke(255, 224, 150, a); strokeWeight(2.5);
  rect(0, 0, r * 1.45, r * 1.45);
  pushMatrix(); rotate(QUARTER_PI); rect(0, 0, r * 1.45, r * 1.45); popMatrix();
  ellipse(0, 0, r * 1.1, r * 1.1);
  noStroke(); fill(255, 222, 140, a); ellipse(0, 0, r * 0.32, r * 0.32);
  rectMode(CORNER);
  popStyle(); popMatrix();
}

void drawIntro(float t) {
  // latar pagi sama dengan scene 1 (transisi mulus)
  drawMorningBackdrop(true);

  // siluet desa kecil
  introMosque.display();
  for (Tree tr : introTrees) tr.display();

  // panel teduh agar judul terbaca
  float panelA = introEase(0.3, 1.2, t) * 130;
  pushStyle(); noStroke();
  fill(20, 26, 56, panelA);
  rect(VW/2 - 440, 138, 880, 268, 26);
  popStyle();

  // ornamen bintang berputar
  float ornA = introEase(0.6, 1.8, t) * 255;
  float ornS = introEase(0.6, 1.8, t);
  float rot  = frameCount * 0.01;
  drawStarOrnament(VW/2,       180, 26 * ornS, rot,  ornA);
  drawStarOrnament(VW/2 - 300, 270, 18 * ornS, -rot, ornA * 0.8);
  drawStarOrnament(VW/2 + 300, 270, 18 * ornS,  rot, ornA * 0.8);

  // JUDUL UTAMA: skala muncul + glow berdenyut
  float ts = lerp(0.55, 1.0, introEase(1.2, 2.4, t));
  float tA = introEase(1.2, 2.4, t) * 255;
  float pulse = 1.0 + 0.03 * sin(frameCount * 0.08);
  pushMatrix(); pushStyle();
  translate(VW/2, 262);
  scale(ts * pulse);
  textAlign(CENTER, CENTER);
  fill(255, 236, 150, tA);      textSize(74); text("AKIBAT MENCURI", 0, 0);
  popStyle(); popMatrix();

  // garis hias mengembang dari tengah
  float lineW = introEase(2.2, 3.1, t) * 300;
  float lineA = introEase(2.2, 3.1, t) * 220;
  pushStyle();
  stroke(255, 224, 150, lineA); strokeWeight(2.5);
  line(VW/2 - lineW, 322, VW/2 - 40, 322);
  line(VW/2 + 40, 322, VW/2 + lineW, 322);
  noStroke(); fill(255, 224, 150, lineA);
  ellipse(VW/2, 322, 7, 7);
  popStyle();

  // SUBJUDUL
  float subA = introEase(2.6, 3.6, t) * 255;
  pushStyle();
  textAlign(CENTER, CENTER);
  fill(255, 255, 255, subA); textSize(28);
  text("Animasi Dakwah Islami", VW/2, 358);
  popStyle();

  // TAGLINE
  float tagA = introEase(3.4, 4.4, t) * 230;
  pushStyle();
  textAlign(CENTER, CENTER);
  fill(255, 226, 160, tagA); textSize(18);
  text("\"Carilah rezeki yang halal & berkah\"", VW/2, 392);
  popStyle();

  // KREDIT TIM
  float creditA = introEase(4.2, 5.2, t) * 220;
  pushStyle();
  textAlign(CENTER, CENTER);
  fill(60, 52, 38, creditA); textSize(16);
  text("TIM Stickmation", VW/2, 432);
  popStyle();

  // fade-in dari hitam di awal
  float fade = 1 - introEase(0.0, 1.0, t);
  if (fade > 0) {
    pushStyle(); noStroke();
    fill(0, 255 * fade);
    rect(0, 0, VW, VH);
    popStyle();
  }

  // fade-out ke putih menjelang scene 1
  if (t > sceneManager.introDuration - 0.8) {
    float fo = introEase(sceneManager.introDuration - 0.8, sceneManager.introDuration, t);
    pushStyle(); noStroke();
    fill(255, 240, 210, 255 * fo);
    rect(0, 0, VW, VH);
    popStyle();
  }
}

//  SCENE 1 — KEBUN MANGGA PAK BUDI
void drawScene1(float t) {
  drawMorningBackdrop(true);

  // pagar dulu, pohon di depannya
  fence.display();
  for (Tree tr : trees1) tr.display();
  mangoTree.display();
  for (Flower f : flowers) f.display();

  // skrip aksi Rangga
  if (t > 16 && t < 24) {            // mencuri: diam lalu membawa
    rangga.setState(IDLE);
    if (t > 20) rangga.carrying = true;
  }
  if (t >= 25) {                     // Pak Budi datang dari kanan
    pakBudi.visible = true;
    pakBudi.walkTo(760);
  }
  if (t >= 34) {                     // Rangga kabur ke kiri
    rangga.setState(RUN);
    rangga.walkTo(-150);
  }

  rangga.update();  rangga.display();
  pakBudi.update(); pakBudi.display();

  drawDialog(dq1, t);
  drawSceneLabel("Kebun Mangga Pak Budi");
}

//  SCENE 2 — WARUNG DESA
void drawScene2(float t) {
  drawBackdrop(color(120, 190, 255), color(214, 240, 255), color(140, 188, 116), true);

  for (House h : houses2) h.display();
  for (Tree tr : trees2) tr.display();
  warung.display();
  warungOwner.display();
  trashCan.display();
  kucing.x = 560; kucing.y = 612; kucing.display();

  // skrip aksi
  if (t > 14 && t < 28) {            // lihat dagangan lalu mencuri
    rangga.setState(IDLE);
    if (t > 22) rangga.carrying = true;
  }
  if (t > 22 && t < 33) rangga.faceDir = 1;   // kaget ke arah kucing
  if (t >= 38) {                     // Pak Budi lewat (curiga)
    pakBudi.visible = true;
    pakBudi.faceDir = 1;
    pakBudi.x = constrain(pakBudi.x, -120, 9999);
    pakBudi.walkTo(1360);
  }

  rangga.update();  rangga.display();
  pakBudi.update(); pakBudi.display();

  drawDialog(dq2, t);
  drawSceneLabel("Warung Desa");
}

//  SCENE 3 — HALAMAN RUMAH WARGA
void drawScene3(float t) {
  drawBackdrop(color(130, 196, 255), color(220, 242, 255), color(146, 192, 118), true);

  for (House h : houses3) h.display();
  fence.display();
  for (Tree tr : trees3) tr.display();
  for (Flower f : flowers) f.display();

  // jemuran
  pushStyle();
  stroke(120); strokeWeight(2); line(900, 540, 1080, 540);
  noStroke(); fill(230, 120, 120); rect(920, 540, 26, 36, 3);
  fill(120, 160, 230); rect(970, 540, 26, 36, 3);
  fill(240, 220, 120); rect(1020, 540, 26, 36, 3);
  popStyle();

  // ayam ribut saat Rangga mendekat
  boolean dekat = (t > 14 && t < 30);
  ayam1.alarmed = dekat; ayam2.alarmed = dekat;
  ayam1.display(); ayam2.display();

  // skrip aksi
  if (t > 12) rangga.setState(IDLE);
  if (t > 14 && t < 22) rangga.carrying = false;   // gagal, ayam kabur
  if (t >= 31) rangga.sad = true;                  // mulai menyesal

  rangga.update(); rangga.display();

  drawDialog(dq3, t);
  drawSceneLabel("Halaman Rumah Warga");
}

//  SCENE 4 — JALAN DESA: BERTEMU PAK USTAD (sore)
void drawScene4(float t) {
  drawBackdrop(color(170, 190, 230), color(255, 226, 180), color(150, 170, 120), true);

  for (House h : houses4) h.display();
  for (Tree tr : trees4) tr.display();
  road.display();
  for (Flower f : flowers) f.display();

  // berhenti & berhadapan setelah dekat
  if (t > 10) {
    rangga.setState(IDLE); pakUstad.setState(IDLE);
    rangga.faceDir = -1;            // Rangga hadap Ustad
    pakUstad.faceDir = 1;           // Ustad hadap Rangga
  }
  rangga.sad = true;

  pakUstad.update(); pakUstad.display();
  rangga.update();   rangga.display();

  drawDialog(dq4, t);
  drawSceneLabel("Jalan Desa");
}

//  SCENE 5 — DEPAN MASJID: TAUBAT (senja)
void drawScene5(float t) {
  // langit senja
  drawSky(color(120, 96, 150), color(255, 178, 110));
  new Hill(478, 150, color(120, 110, 90)).display();
  // matahari rendah senja
  pushStyle(); noStroke();
  fill(255, 150, 90, 160); ellipse(1040, 360, 130, 130);
  fill(255, 170, 90);      ellipse(1040, 360, 90, 90);
  popStyle();
  for (Cloud c : clouds) c.display();
  for (Bird b : birds) b.display();
  grass.display();

  // jalan setapak ke masjid
  mosqueRoad.display();

  // masjid + pohon + bunga
  mosque.display();
  for (Tree tr : trees5) tr.display();
  for (Flower f : flowers5) f.display();

  // [TRANSFORMASI] dilatasi: zoom lembut menjelang klimaks
  float zoom = 1.0 + 0.03 * sin(t * 0.15);

  // Pak Budi datang untuk berdamai
  if (t >= 63) { pakBudi.visible = true; pakBudi.walkTo(880); }

  pushMatrix();
  translate(VW/2, GROUND_Y);
  scale(zoom);                                 // [TRANSFORMASI] dilatasi (zoom klimaks)
  translate(-VW/2, -GROUND_Y);
  pakUstad.update(); pakUstad.display();
  rangga.update();   rangga.display();
  pakBudi.update();  pakBudi.display();
  popMatrix();

  drawDialog(dq5, t);
  drawSceneLabel("Depan Masjid");
}

// siluet masjid satu-warna untuk skyline malam
// [SHAPE] kubah dari curveVertex, sama seperti class Mosque tapi monokrom
void drawMosqueSilhouette(float x, float y, float w, float h, color col) {
  pushStyle(); noStroke(); fill(col);
  rect(x - w/2, y - h, w, h, 3);
  beginShape();
  curveVertex(x - w*0.32, y - h);
  curveVertex(x - w*0.32, y - h);
  curveVertex(x - w*0.32, y - h - h*0.35);
  curveVertex(x,          y - h - h*0.62);
  curveVertex(x + w*0.32, y - h - h*0.35);
  curveVertex(x + w*0.32, y - h);
  curveVertex(x + w*0.32, y - h);
  endShape(CLOSE);
  rect(x - 1.5, y - h - h*0.78, 3, 12);          // tiang bulan-bintang
  for (int sgn = -1; sgn <= 1; sgn += 2) {       // menara kiri & kanan
    float mx = x + sgn * (w/2 + 14);
    rect(mx - 7, y - h - 28, 14, h + 28, 2);
    arc(mx, y - h - 28, 18, 18, PI, TWO_PI);
  }
  popStyle();
}

//  LAYAR PENUTUP — pesan dakwah (malam berbintang)
void drawClosing(float t) {
  // langit malam ke ungu kemerahan
  drawVerticalGradient(color(14, 13, 36), color(70, 46, 78), 0, VH);

  // bulan dengan corona lembut
  pushStyle(); noStroke();
  float moonX = VW - 190, moonY = 118;
  fill(255, 250, 230, 28); ellipse(moonX, moonY, 230, 230);
  fill(255, 250, 230, 55); ellipse(moonX, moonY, 145, 145);
  fill(250, 248, 235);     ellipse(moonX, moonY, 76, 76);
  fill(70, 46, 78);        ellipse(moonX - 20, moonY - 9, 68, 68);   // gigitan sabit
  popStyle();

  // bintang berkedip + sesekali berkilau
  pushStyle(); noStroke();
  for (int i = 0; i < 55; i++) {
    float sx = (i * 137) % VW;
    float sy = (i * 71) % 440;
    float phase = frameCount * 0.04 + i * 1.7;
    float twinkle = 0.5 + 0.5 * sin(phase);
    float tw = 1.2 + twinkle * 1.8;
    fill(255, 245, 215, 110 + twinkle * 140);
    ellipse(sx, sy, tw, tw);
    if (i % 9 == 0) {                          // kilau silang
      float flare = max(0, sin(phase * 0.5));
      stroke(255, 250, 225, flare * 170); strokeWeight(1);
      line(sx - 6, sy, sx + 6, sy);
      line(sx, sy - 6, sx, sy + 6);
      noStroke();
    }
  }
  popStyle();

  // ornamen bintang islami di sudut atas
  float ornRot = frameCount * 0.01;             // [TRANSFORMASI] rotasi
  drawStarOrnament(58, 58, 22, ornRot, 190);
  drawStarOrnament(VW - 58, 58, 22, -ornRot, 190);

  // siluet bukit & masjid
  pushStyle(); noStroke(); fill(11, 10, 24);
  rect(0, 632, VW, VH - 632);
  popStyle();
  drawMosqueSilhouette(220,  640, 90,  58,  color(11, 10, 24));
  drawMosqueSilhouette(1060, 640, 90,  58,  color(11, 10, 24));
  drawMosqueSilhouette(640,  632, 150, 104, color(8, 7, 18));

  //  PENUTUP 2 BABAK:
  //   Babak 1 (0-6.5 dtk) : pesan moral (fade-in lalu fade-out)
  //   Babak 2 (>5.5 dtk)  : end credits bergulir
  float moralOut = 1 - constrain((t - 5.0) / 1.5, 0, 1);
  if (moralOut > 0.001) drawMoralMessage(t, moralOut);

  if (t > 5.5) {
    float creditsIn = constrain((t - 5.5) / 1.5, 0, 1);
    drawEndCredits(t - 5.5, creditsIn);
  }

  // vignette tepi atas (kesan sinematik)
  pushStyle(); noStroke();
  for (int i = 0; i < 50; i++) {
    fill(0, map(i, 0, 50, 60, 0));
    rect(0, i, VW, 1);
  }
  popStyle();

  // petunjuk ulang di pojok bawah
  pushStyle();
  fill(255, 210, 120, 120); textSize(13); textAlign(RIGHT, BOTTOM);
  text("tekan 0 untuk mengulang", VW - 22, VH - 14);
  popStyle();
}

//  PESAN MORAL (babak 1 penutup) — ga = pengali alpha global
void drawMoralMessage(float t, float ga) {
  // JUDUL: membesar lembut + glow
  float k = constrain(t / 1.2, 0, 1);
  float s = lerp(0.5, 1.0, 1 - pow(1 - k, 3));           // [TRANSFORMASI] dilatasi
  float titleA = constrain(t / 1.0, 0, 1) * 255 * ga;
  float pulse = 1.0 + 0.025 * sin(frameCount * 0.06);

  pushMatrix(); pushStyle();
  translate(VW/2, 210);
  scale(s * pulse);                                      // [TRANSFORMASI] dilatasi
  textAlign(CENTER, CENTER);
  fill(255, 224, 130, titleA); textSize(36);
  text("MENCURI MERUGIKAN", 0, -32);
  text("DIRI & ORANG LAIN", 0, 14);
  popStyle(); popMatrix();

  // subjudul ajakan
  float subA = constrain((t - 0.6) / 1.0, 0, 1) * 255 * ga;
  pushStyle();
  textAlign(CENTER, CENTER);
  fill(255, subA); textSize(22);
  text("Carilah rezeki yang halal.", VW/2, 290);
  popStyle();

  // garis hias pemisah
  float lineA = constrain((t - 1.0) / 1.0, 0, 1) * 200 * ga;
  pushStyle();
  stroke(255, 224, 150, lineA); strokeWeight(2);
  line(VW/2 - 130, 330, VW/2 - 28, 330);
  line(VW/2 + 28, 330, VW/2 + 130, 330);
  noStroke(); fill(255, 224, 150, lineA);
  ellipse(VW/2, 330, 6, 6);
  popStyle();

  // pesan pendukung
  float hadithA = constrain((t - 1.4) / 1.2, 0, 1) * 255 * ga;
  pushStyle();
  fill(230, hadithA); textSize(18); textAlign(CENTER, CENTER);
  text("Rezeki halal, meski sedikit, jauh lebih berkah.", VW/2, 382);
  text("Pintu taubat selalu terbuka bagi yang mau memperbaiki diri.", VW/2, 414);
  popStyle();
}

//  END CREDITS — daftar nama & peran, bergulir naik
//  tc = detik sejak credits mulai, gin = fade-in global 0..1
//  kind: 0 = judul emas, 1 = nama (emas), 2 = peran (putih), 3 = teks kecil
class CRow {
  String txt; float size; int kind; float gap;
  CRow(String t, float s, int k, float g) { txt = t; size = s; kind = k; gap = g; }
}
ArrayList<CRow> creditRows = null;
float creditsLastOffset = 0;   // offset baris terakhir (untuk hentikan gulir)

void buildCreditRows() {
  creditRows = new ArrayList<CRow>();
  creditRows.add(new CRow("~ CREDITS ~",            34, 0, 78));
  creditRows.add(new CRow("AKIBAT MENCURI",         42, 0, 40));
  creditRows.add(new CRow("Animasi Dakwah Islami",  20, 3, 28));
  creditRows.add(new CRow("TIM Stickmation",        24, 1, 96));

  // anggota tim & peran
  creditRows.add(new CRow("Luqman Hakim Ar-Razi",           28, 1, 34));
  creditRows.add(new CRow("Programmer & Animator", 19, 2, 26));
  creditRows.add(new CRow("Pembuat Cerita & Dokumentasi", 17, 3, 82));

  creditRows.add(new CRow("Muhammad Farid Bin Junardi",     28, 1, 34));
  creditRows.add(new CRow("Pengisi Suara - Rangga",    19, 2, 26));
  creditRows.add(new CRow("Penyusun Laporan & Dokumentasi",           17, 3, 82));

  creditRows.add(new CRow("M. Bintang Satriaji Egidia",     28, 1, 34));
  creditRows.add(new CRow("Pengisi Suara - Pak Ustad", 19, 2, 82));

  creditRows.add(new CRow("Muhammad Farhan Yusuf Azizi",    28, 1, 34));
  creditRows.add(new CRow("Pengisi Suara - Pak Budi",  19, 2, 82));

  creditRows.add(new CRow("Muh. Syarif Hidayatullah",       28, 1, 34));
  creditRows.add(new CRow("Penyusun Laporan & Dokumentasi",           19, 2, 120));

  // penutup
  creditRows.add(new CRow("Terima Kasih",                   40, 0, 44));

  // offset baris terakhir = total gap semua baris sebelumnya
  creditsLastOffset = 0;
  for (int i = 0; i < creditRows.size() - 1; i++) creditsLastOffset += creditRows.get(i).gap;
}

// alpha tepi: teks memudar saat masuk (bawah) & keluar (atas) layar
float creditEdgeFade(float y) {
  float a = 1;
  if (y < 130)      a *= constrain(map(y, 50, 130, 0, 1), 0, 1);
  if (y > VH - 130) a *= constrain(map(y, VH - 50, VH - 130, 0, 1), 0, 1);
  return a;
}

void drawEndCredits(float tc, float gin) {
  if (creditRows == null) buildCreditRows();

  // panel gelap agar teks terbaca di atas langit malam
  pushStyle(); noStroke();
  fill(6, 6, 20, 120 * gin);
  rect(VW/2 - 430, 0, 860, VH);
  popStyle();

  float firstY   = VH + 40;                 // baris pertama mulai dari bawah
  float speed    = 60;                       // kecepatan gulir (px/dtk)
  float maxScroll = firstY + creditsLastOffset - VH * 0.5;  // berhenti saat baris akhir di tengah
  float scroll   = min(tc * speed, maxScroll);

  pushStyle();
  textAlign(CENTER, CENTER);
  float off = 0;
  for (CRow r : creditRows) {
    float y = firstY + off - scroll;
    off += r.gap;
    if (y < -50 || y > VH + 50) continue;    // di luar layar
    float a = 255 * gin * creditEdgeFade(y);
    if (a <= 1) continue;

    textSize(r.size);
    switch (r.kind) {
      case 0:                                // judul emas
        fill(255, 236, 150, a);
        break;
      case 1:                                // nama emas
        fill(255, 224, 140, a);
        break;
      case 2:                                // peran putih
        fill(240, 240, 245, a);
        break;
      default:                               // teks kecil
        fill(210, 205, 220, a * 0.95);
        break;
    }
    text(r.txt, VW/2, y);
  }
  popStyle();
}

// label nama lokasi (bawah layar)
void drawSceneLabel(String s) {
  pushStyle();
  textAlign(CENTER, CENTER);
  textSize(16);
  fill(0, 110); noStroke();
  float w = textWidth(s) + 40;
  rect(VW/2 - w/2, VH - 42, w, 28, 14);
  fill(255);
  text(s, VW/2, VH - 28);
  popStyle();
}
