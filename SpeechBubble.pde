//  SpeechBubble.pde
//  Balon kata yang mengikuti gerak karakter: kotak rounded, ekor menunjuk
//  ke kepala, teks auto-wrap, efek scale-in ([TRANSFORMASI] scale).
//  Berisi juga DialogQueue & DialogLine untuk percakapan otomatis.

class SpeechBubble {
  String lastText = "";
  float animStart = 0;     // waktu mulai animasi muncul (ms)

  // Gambar balon menunjuk ke (charX, charHeadTopY).
  void display(String txt, float charX, float charHeadTopY) {
    if (txt == null) return;

    // reset animasi saat teks berganti
    if (!txt.equals(lastText)) {
      lastText = txt;
      animStart = millis();
    }
    // scale-in: 0.6 -> 1.0 dalam ~0.22 dtk  [TRANSFORMASI] dilatasi
    float k = constrain((millis() - animStart) / 220.0, 0, 1);
    float animScale = lerp(0.6, 1.0, easeOut(k));

    pushStyle();
    textSize(19);
    float maxLineW = 250;
    ArrayList<String> lines = wrapText(txt, maxLineW);

    float lineH = 25;
    float pad = 16;
    float w = 0;
    for (String ln : lines) w = max(w, textWidth(ln));
    w += pad * 2;
    float h = lines.size() * lineH + pad * 2;

    // posisi balon di atas kepala, di-clamp agar tetap di layar
    float bx = constrain(charX, w / 2 + 12, VW - w / 2 - 12);
    float gap = 34;
    float bCenterY = charHeadTopY - gap - h / 2;
    bCenterY = max(bCenterY, h / 2 + 10);

    pushMatrix();
    translate(bx, bCenterY);
    scale(animScale);                          // [TRANSFORMASI] scale-in

    // EKOR menunjuk ke kepala (relatif ke pusat balon, jadi ikut bergerak)
    float tipX = charX - bx;
    float tipY = charHeadTopY - bCenterY;
    noStroke();
    fill(255);
    triangle(-14, h / 2 - 2, 14, h / 2 - 2, tipX, tipY);
    stroke(0); strokeWeight(2);
    line(-14, h / 2 - 2, tipX, tipY);
    line( 14, h / 2 - 2, tipX, tipY);

    // KOTAK BALON
    rectMode(CENTER);
    fill(255); stroke(0); strokeWeight(2.5);
    rect(0, 0, w, h, 16);
    noStroke(); fill(255);                      // tutup garis di sambungan ekor
    rect(0, h / 2 - 1, 26, 6);

    // TEKS
    fill(25); textAlign(CENTER, CENTER);
    float ty = -h / 2 + pad + lineH / 2;
    for (String ln : lines) {
      text(ln, 0, ty);
      ty += lineH;
    }

    popMatrix();
    popStyle();
  }

  float easeOut(float t) { return 1 - pow(1 - t, 3); }
}

//  DialogQueue: antrian dialog satu scene (otomatis bergantian)
class DialogQueue {
  ArrayList<DialogLine> lines = new ArrayList<DialogLine>();
  DialogLine lastActive = null;    // baris terakhir yang diputar suaranya

  // dialog dari karakter (tanpa suara)
  void add(Character spk, String txt, float start, float dur) {
    lines.add(new DialogLine(spk, txt, start, dur, 0, 0, false, null, 1.0, 0));
  }
  // dialog dari karakter + file suara dubbing
  void add(Character spk, String txt, float start, float dur, String soundPath) {
    lines.add(new DialogLine(spk, txt, start, dur, 0, 0, false, loadVoice(soundPath), 1.0, 0));
  }
  // dialog dari posisi tetap (mis. suara hewan), tanpa suara
  void addAt(float px, float py, String txt, float start, float dur) {
    lines.add(new DialogLine(null, txt, start, dur, px, py, true, null, 1.0, 0));
  }
  // dialog dari posisi tetap + file suara
  void addAt(float px, float py, String txt, float start, float dur, String soundPath) {
    lines.add(new DialogLine(null, txt, start, dur, px, py, true, loadVoice(soundPath), 1.0, 0));
  }
  // dialog dari posisi tetap + file suara + volume custom (0..1) + batas durasi suara (detik, 0 = full)
  void addAt(float px, float py, String txt, float start, float dur, String soundPath, float vol, float maxSoundDur) {
    lines.add(new DialogLine(null, txt, start, dur, px, py, true, loadVoice(soundPath), vol, maxSoundDur));
  }

  // dialog yang aktif pada waktu t (detik dalam scene)
  DialogLine active(float t) {
    for (DialogLine d : lines)
      if (t >= d.start && t < d.start + d.dur) return d;
    return null;
  }

  // reset penanda pemutaran (dipanggil saat scene dimasuki ulang)
  void resetPlayback() {
    lastActive = null;
  }
}

class DialogLine {
  Character speaker;     // boleh null (pakai posisi tetap)
  String text;
  float start, dur;      // detik dalam scene
  float px, py;          // posisi tetap (jika fixed)
  boolean fixed;
  SoundFile voice;        // suara baris ini (boleh null)
  float vol;              // volume suara (0..1)
  float maxSoundDur;      // batas durasi suara diputar (detik, 0 = sampai habis)

  DialogLine(Character spk, String txt, float st, float du, float px, float py, boolean fixed, SoundFile voice, float vol, float maxSoundDur) {
    this.speaker = spk; this.text = txt; this.start = st; this.dur = du;
    this.px = px; this.py = py; this.fixed = fixed; this.voice = voice;
    this.vol = vol; this.maxSoundDur = maxSoundDur;
  }
}

// gambar balon untuk dialog aktif + putar suaranya
void drawDialog(DialogQueue dq, float t) {
  DialogLine d = dq.active(t);
  if (d == null) return;

  // baru masuk baris ini -> putar suaranya sekali
  if (d != dq.lastActive) {
    dq.lastActive = d;
    playVoice(d.voice, d.vol, d.maxSoundDur);
  }

  if (d.fixed) {
    bubble.display(d.text, d.px, d.py);
  } else {
    bubble.display(d.text, d.speaker.x, d.speaker.headTopY());
  }
}
