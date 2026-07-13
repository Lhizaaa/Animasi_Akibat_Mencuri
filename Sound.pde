//  Sound.pde
//  Audio: dubbing dialog, efek suara hewan, dan backsound tiap scene
//  (+ intro & outro). Pakai library "Sound" bawaan Processing.
//
//  Semua mp3 ada di folder "data/" dengan nama & struktur persis:
//    data/music/Backsound intro.mp3, Backsound scene 1..5.mp3
//    data/dialog/Rangga/Rangga 1..10.mp3
//    data/dialog/Pak Budi/Pak budi 1..3.mp3
//    data/dialog/Pak Ustad/Pak Ustad 1..6.mp3
//    data/sfx/Suara kucing.mp3, Suara ayam.mp3

SoundFile[] sceneMusic = new SoundFile[5];
SoundFile   introMusic, outroMusic;
SoundFile   currentMusic = null;

// semua suara dialog/sfx, agar bisa distop serentak saat ganti scene
// (mencegah suara panjang "bocor" ke scene berikutnya)
ArrayList<SoundFile> allVoices = new ArrayList<SoundFile>();

void loadSceneMusic() {
  introMusic = loadMusic("music/Backsound intro.mp3");
  // outro pakai musik sama dengan intro, tapi instance terpisah
  outroMusic = loadMusic("music/Backsound intro.mp3");
  for (int i = 0; i < sceneMusic.length; i++) {
    sceneMusic[i] = loadMusic("music/Backsound scene " + (i + 1) + ".mp3");
  }
}

void playIntroMusic() {
  if (currentMusic != null) currentMusic.stop();
  currentMusic = introMusic;
  if (currentMusic != null) currentMusic.loop();
}

void playOutroMusic() {
  stopAllVoices();
  if (currentMusic != null) currentMusic.stop();
  currentMusic = outroMusic;
  if (currentMusic != null) currentMusic.loop();
}

// ganti backsound sesuai scene aktif (dipanggil dari onSceneEnter)
void playSceneMusic(int s) {
  stopAllVoices();
  if (currentMusic != null) currentMusic.stop();
  currentMusic = (s >= 0 && s < sceneMusic.length) ? sceneMusic[s] : null;
  if (currentMusic != null) currentMusic.loop();
}

// load 1 musik (tidak didaftarkan ke allVoices)
SoundFile loadMusic(String path) {
  return loadFile(path);
}

// load 1 dialog/sfx dan daftarkan agar bisa distop massal
SoundFile loadVoice(String path) {
  SoundFile sf = loadFile(path);
  if (sf != null) allVoices.add(sf);
  return sf;
}

// load aman walau file belum ada
SoundFile loadFile(String path) {
  try {
    return new SoundFile(this, path);
  } catch (Exception e) {
    println("[Sound] File belum ditemukan / gagal dimuat: data/" + path);
    return null;
  }
}

// putar 1 suara sekali dari awal
void playVoice(SoundFile sf) {
  playVoice(sf, 1.0, 0);
}

// putar 1 suara dengan volume custom (0..1) & batas durasi maks (detik, 0 = sampai habis)
void playVoice(SoundFile sf, float vol, float maxDur) {
  if (sf == null) return;
  if (sf.isPlaying()) sf.stop();
  sf.amp(vol);
  sf.play();
  if (maxDur > 0) {
    float stopAt = millis() + maxDur * 1000;
    voiceStopTimes.put(sf, stopAt);
  }
}

// map suara -> waktu (ms) kapan harus dihentikan otomatis (dipotong durasinya)
HashMap<SoundFile, Float> voiceStopTimes = new HashMap<SoundFile, Float>();

// dipanggil tiap frame (draw()) untuk memotong suara yang sudah lewat batas durasinya
void updateVoiceTrims() {
  float now = millis();
  ArrayList<SoundFile> done = new ArrayList<SoundFile>();
  for (SoundFile sf : voiceStopTimes.keySet()) {
    if (now >= voiceStopTimes.get(sf)) {
      if (sf.isPlaying()) sf.stop();
      done.add(sf);
    }
  }
  for (SoundFile sf : done) voiceStopTimes.remove(sf);
}

// hentikan semua dialog/sfx yang sedang berbunyi
void stopAllVoices() {
  for (SoundFile sf : allVoices) {
    if (sf != null && sf.isPlaying()) sf.stop();
  }
}
