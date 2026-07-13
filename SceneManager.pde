//  SceneManager.pde
//  Mengatur scene aktif, waktu, durasi, dan pindah scene otomatis
//  berdasarkan millis(). Total >= 300 detik.

class SceneManager {
  int currentScene = 0;          // index scene aktif (0..4)
  int lastEntered  = -1;         // deteksi pergantian scene
  float startMs;                 // waktu mulai animasi (ms)
  float sceneStartMs;            // waktu mulai scene aktif (ms)
  float pauseOffset = 0;
  boolean finished = false;      // true = sudah lewat scene 5 (penutup)

  boolean inIntro = true;
  float introDuration = 8;       // durasi intro (detik)

  float transitionDuration = 0.6;  // durasi fade antar scene
  float loopHold = 4.0;            // jeda (detik) setelah credits selesai sebelum mengulang

  SceneManager() {
    startMs = millis();
    sceneStartMs = millis();
  }

  // keluar dari intro menuju scene 1
  void startShow() {
    inIntro = false;
    currentScene = 0;
    startMs = millis();
    sceneStartMs = millis();
    lastEntered = -1;
  }

  void skipIntro() { if (inIntro) startShow(); }

  // hitung waktu & pindah scene bila perlu
  void update() {
    if (inIntro) {
      if (sceneElapsed() >= introDuration) startShow();
      return;
    }
    if (finished) {
      // penutup selesai (pesan moral + credits bergulir + jeda) -> ulang otomatis
      if (sceneElapsed() >= closingDuration() + loopHold) restart();
      return;
    }
    float elapsed = sceneElapsed();
    if (elapsed >= sceneDuration[currentScene]) {
      currentScene++;
      sceneStartMs = millis();
      if (currentScene >= sceneDuration.length) {
        currentScene = sceneDuration.length - 1;
        finished = true;
      }
    }
  }

  // gambar scene aktif (panggil onEnter saat scene berganti)
  void render() {
    if (inIntro) {
      drawIntro(sceneElapsed());
      return;
    }
    if (finished) {
      if (lastEntered != 99) { lastEntered = 99; playOutroMusic(); }   // masuk penutup
      drawClosing(sceneElapsed());
      drawTransitionOverlay(sceneElapsed(), -1);
      return;
    }

    // pergantian scene -> reset posisi karakter & dialog
    if (currentScene != lastEntered) {
      onSceneEnter(currentScene);
      lastEntered = currentScene;
    }

    float t = sceneElapsed();
    switch (currentScene) {
      case 0: drawScene1(t); break;
      case 1: drawScene2(t); break;
      case 2: drawScene3(t); break;
      case 3: drawScene4(t); break;
      case 4: drawScene5(t); break;
    }

    drawTransitionOverlay(t, sceneDuration[currentScene] - t);
  }

  // overlay fade hitam: fade-in saat scene mulai & fade-out menjelang habis,
  // agar pergantian scene tidak patah. remaining < 0 = tanpa fade-out.
  void drawTransitionOverlay(float elapsed, float remaining) {
    float fadeIn  = 1 - constrain(elapsed / transitionDuration, 0, 1);
    float fadeOut = (remaining >= 0) ? 1 - constrain(remaining / transitionDuration, 0, 1) : 0;
    float a = max(fadeIn, fadeOut);
    if (a <= 0.001) return;
    a = a * a * (3 - 2 * a);             // smoothstep
    pushStyle(); noStroke(); fill(0, a * 255); rect(0, 0, VW, VH); popStyle();
  }

  // detik sejak penutup mulai sampai end credits selesai bergulir
  // (rumus disamakan dengan drawEndCredits di Scenes.pde)
  float closingDuration() {
    if (creditRows == null) buildCreditRows();
    float firstY    = VH + 40;
    float speed     = 60;
    float maxScroll = firstY + creditsLastOffset - VH * 0.5;
    return 5.5 + maxScroll / speed;
  }

  float sceneElapsed() { return (millis() - sceneStartMs) / 1000.0; }   // detik sejak scene mulai
  float totalElapsed() { return (millis() - startMs) / 1000.0; }        // detik sejak animasi mulai

  // navigasi manual
  void jumpToScene(int s) {
    inIntro = false;
    finished = false;
    currentScene = constrain(s, 0, sceneDuration.length - 1);
    sceneStartMs = millis();
    lastEntered = -1;
  }

  void restart() {
    inIntro = true;
    finished = false;
    currentScene = 0;
    startMs = millis();
    sceneStartMs = millis();
    lastEntered = -1;
    playIntroMusic();
  }

  // geser scene dengan tombol arrow
  void goNext() {
    if (inIntro) { skipIntro(); return; }
    if (finished) return;
    if (currentScene >= sceneDuration.length - 1) {
      finished = true;                                  // scene terakhir -> penutup
      sceneStartMs = millis();
    } else {
      jumpToScene(currentScene + 1);
    }
  }

  void goPrev() {
    if (inIntro) return;
    if (finished) { jumpToScene(sceneDuration.length - 1); return; }
    if (currentScene <= 0) {
      inIntro = true;                                     // scene 1 -> intro
      sceneStartMs = millis();
      lastEntered = -1;
    } else {
      jumpToScene(currentScene - 1);
    }
  }
}
