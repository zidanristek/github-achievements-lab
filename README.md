# github-achievements-lab

Repo sandbox untuk mengumpulkan achievement profil GitHub. Isinya cuma log
otomatis, bukan proyek sungguhan. Semua aktivitas dari `achieve.sh` terjadi di
repo ini saja.

## Cara pakai

Git Bash:

```bash
bash achieve.sh                # Quickdraw + 16 PR merged (Pull Shark bronze, YOLO)

# Dengan akun kedua: co-author diambil otomatis dari token, satu perintah
# menutup Pair Extraordinaire, Pull Shark, dan Galaxy Brain sekaligus.
export ALT_TOKEN=ghp_xxx
PRS=48 bash achieve.sh pullshark        # Pair Extraordinaire emas
ANSWERS=32 bash achieve.sh galaxybrain  # Galaxy Brain emas
```

`PRS` dan `ANSWERS` menentukan tier. Pull Shark 2 / 16 / 128 / 1024,
Pair Extraordinaire 1 / 10 / 24 / 48, Galaxy Brain 2 / 8 / 16 / 32.

PowerShell. Jangan pakai `bash` polos, yang ada di PATH milik WSL dan akan
gagal dengan `execvpe(/bin/bash) failed`. Panggil Git Bash lewat jalur penuh:

```powershell
$env:ALT_TOKEN = "ghp_xxx"
$env:PRS = "48"
& "C:\Program Files\Git\bin\bash.exe" achieve.sh pullshark
& "C:\Program Files\Git\bin\bash.exe" achieve.sh galaxybrain
```

Butuh `ALT_TOKEN` dengan scope `repo`, dan akun kedua tersebut harus akun
manusia, bukan bot.

## Daftar achievement (per September 2026)

| Achievement | Syarat | Tier | Bisa diskrip? |
|---|---|---|---|
| Quickdraw | Tutup issue/PR dalam 5 menit setelah dibuka | 1 | Ya |
| YOLO | Merge PR sendiri tanpa review | 1 | Ya |
| Pull Shark | PR yang di-merge | 2 / 16 / 128 / 1024 | Ya |
| Pair Extraordinaire | Commit ber-`Co-authored-by` di PR yang di-merge | 1 / 10 / 24 / 48 | Ya, tapi co-author wajib akun manusia. Diuji 14 September 2026: akun bot Copilot diparse GitHub sebagai co-author namun badge tidak keluar |
| Galaxy Brain | Jawaban ditandai "answer" di Discussions repo publik | 2 / 8 / 16 / 32 | Hanya dengan akun kedua; pertanyaan sendiri tidak dihitung |
| Starstruck | Satu repo dapat bintang | 16 / 128 / 512 / 4096 | Tidak. Beli/tukar bintang melanggar ToS GitHub |
| Public Sponsor | Sponsor siapa pun lewat GitHub Sponsors | 1 | Tidak. Bayar minimal 1 USD sekali, manual |
| Heart On Your Sleeve | Reaksi ❤️ | 4 | Belum dirilis, sempat muncul karena bug Maret 2026 |
| Open Sourcerer | PR merged di banyak repo publik | 4 | Belum dirilis |
| Arctic Code Vault Contributor | Kontribusi sebelum Feb 2020 | 1 | Sudah ditutup |
| Mars 2020 Helicopter Contributor | Kontribusi ke dependensi Ingenuity | 1 | Sudah ditutup |

Jeda kemunculan badge tidak seragam. Pull Shark, Quickdraw, YOLO, dan Galaxy
Brain terbit dalam hitungan menit. Pair Extraordinaire dihitung ulang pada
siklus terpisah, 24 sampai 48 jam, jadi profil yang masih kosong sehari
setelah PR merged belum tentu gagal. Semua badge hanya menghitung aktivitas
yang masuk ke default branch repo publik.

Jangan jalankan dua proses `achieve.sh` sekaligus di klon yang sama. Loopnya
berpindah branch dan menjalankan `git pull --ff-only`, jadi proses kedua akan
menimpa perubahan proses pertama.

Sumber: [drknzz/GitHub-Achievements](https://github.com/drknzz/GitHub-Achievements),
[Schweinepriester/github-profile-achievements](https://github.com/Schweinepriester/github-profile-achievements),
[community discussion #175547](https://github.com/orgs/community/discussions/175547),
[community discussion #191031](https://github.com/orgs/community/discussions/191031),
[community discussion #158734](https://github.com/orgs/community/discussions/158734),
[community discussion #45578](https://github.com/orgs/community/discussions/45578).
