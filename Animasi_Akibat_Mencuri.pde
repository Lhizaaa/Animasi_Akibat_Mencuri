//  ANIMASI DAKWAH ISLAMI — "AKIBAT MENCURI"
//  Processing (Java mode), full kode tanpa gambar raster.
//  File utama: settings(), setup(), draw(), palet, dan helper global.
//
//  Tombol: D = debug, 1..5 = loncat scene, 0 = ulang, P = pause, ←/→ = geser scene.

import processing.sound.*;

// Ukuran kanvas tetap. Semua gambar dirancang di ruang VW x VH.
final int VW = 1280;
final int VH = 720;

int fps = 60;
int[] sceneDuration = {40, 47, 41, 40, 75};   // durasi tiap scene (detik)

float GROUND_Y = 640;   // level tanah (kaki karakter)

// Objek global
SceneManager sceneManager;
SpeechBubble bubble;
Character rangga, pakBudi, pakUstad;

// State karakter
final int IDLE = 0;
final int WALK = 1;
final int RUN  = 2;

// Palet warna (diisi di setup)
color C_GRASS, C_GRASS_DARK, C_ROAD, C_SOIL;
color C_TRUNK, C_LEAF, C_LEAF2;

boolean showDebug = false;
boolean paused = false;

void settings() {
  size(VW, VH);
}

void setup() {
  frameRate(fps);
  surface.setTitle("Animasi Dakwah - Akibat Mencuri");
  textAlign(CENTER, CENTER);
  ellipseMode(CENTER);

  // palet pedesaan
  C_GRASS      = color(122, 190, 74);
  C_GRASS_DARK = color(96, 162, 58);
  C_ROAD       = color(196, 178, 150);
  C_SOIL       = color(150, 116, 80);
  C_TRUNK      = color(120, 82, 48);
  C_LEAF       = color(64, 150, 70);
  C_LEAF2      = color(46, 124, 58);

  rangga   = new Character("RANGGA",   -80, GROUND_Y);
  pakBudi  = new Character("PAKBUDI", 1360, GROUND_Y);
  pakUstad = new Character("PAKUSTAD",  -80, GROUND_Y);

  bubble = new SpeechBubble();

  initSceneObjects();
  initDialog();
  loadSceneMusic();

  sceneManager = new SceneManager();
  playIntroMusic();
}

void draw() {
  updateVoiceTrims();
  if (!paused) sceneManager.update();

  background(0);
  sceneManager.render();
  if (showDebug) drawDebugInfo();
}

//  HELPER GLOBAL

// Bayangan tanah: elips gelap tembus pandang di kaki objek.
//   (cx, cy) = pusat, w/h = lebar & tinggi elips.
void drawShadow(float cx, float cy, float w, float h) {
  pushStyle();
  noStroke();
  fill(0, 28);  ellipse(cx, cy, w, h);
  fill(0, 46);  ellipse(cx, cy, w * 0.68, h * 0.68);
  popStyle();
}

// Gradasi vertikal untuk langit (top -> bottom)
void drawVerticalGradient(color top, color bot, float y0, float y1) {
  pushStyle();
  noFill();
  for (float y = y0; y <= y1; y++) {
    float t = map(y, y0, y1, 0, 1);
    stroke(lerpColor(top, bot, t));
    line(0, y, VW, y);
  }
  popStyle();
}

// Pecah teks panjang jadi beberapa baris sesuai lebar maksimum.
ArrayList<String> wrapText(String s, float maxW) {
  String[] words = split(s, ' ');
  ArrayList<String> lines = new ArrayList<String>();
  String cur = "";
  for (String w : words) {
    String test = cur.equals("") ? w : cur + " " + w;
    if (textWidth(test) > maxW && !cur.equals("")) {
      lines.add(cur);
      cur = w;
    } else {
      cur = test;
    }
  }
  if (!cur.equals("")) lines.add(cur);
  return lines;
}

// Info debug di pojok kiri-atas
void drawDebugInfo() {
  pushStyle();
  fill(0, 180); noStroke();
  rect(0, 0, 430, 78);
  fill(255); textAlign(LEFT, TOP); textSize(15);
  String stat = sceneManager.inIntro ? "INTRO" : (sceneManager.finished ? "PENUTUP" : ("SCENE " + (sceneManager.currentScene + 1) + " / 5"));
  text(stat + (paused ? "   [PAUSE]" : ""), 12, 8);
  text("Waktu scene : " + nf(sceneManager.sceneElapsed(), 0, 1) + " dtk", 12, 30);
  text("Total       : " + nf(sceneManager.totalElapsed(), 0, 1) + " / 300 dtk", 12, 52);
  textAlign(RIGHT, TOP); textSize(12);
  text("[D] debug  [1-5] loncat  [0] ulang  [P] pause  [<-/->] geser", 420, 60);
  popStyle();
}

void keyPressed() {
  // intro: SPASI / ENTER untuk langsung mulai
  if (sceneManager.inIntro && (key == ' ' || key == ENTER || key == RETURN)) {
    sceneManager.skipIntro();
    return;
  }
  if (key == CODED) {
    if (keyCode == LEFT)  sceneManager.goPrev();
    if (keyCode == RIGHT) sceneManager.goNext();
    return;
  }
  if (key == 'd' || key == 'D') showDebug = !showDebug;
  if (key == 'p' || key == 'P') paused = !paused;
  if (key >= '1' && key <= '5') sceneManager.jumpToScene(key - '1');
  if (key == '0') sceneManager.restart();
}

void mousePressed() {
  if (sceneManager.inIntro) sceneManager.skipIntro();
}
