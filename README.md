# github-achievements-lab

Repo sandbox untuk mengumpulkan achievement profil GitHub. Isinya cuma log
otomatis, bukan proyek sungguhan. Semua aktivitas dari `achieve.sh` terjadi di
repo ini saja.

## Cara pakai

```bash
bash achieve.sh                # Quickdraw + 16 PR merged (Pull Shark bronze, YOLO, Pair Extraordinaire)
PRS=128 bash achieve.sh pullshark
ALT_TOKEN=ghp_xxx bash achieve.sh galaxybrain   # butuh akun kedua
```

## Daftar achievement (per September 2026)

| Achievement | Syarat | Tier | Bisa diskrip? |
|---|---|---|---|
| Quickdraw | Tutup issue/PR dalam 5 menit setelah dibuka | 1 | Ya |
| YOLO | Merge PR sendiri tanpa review | 1 | Ya |
| Pull Shark | PR yang di-merge | 2 / 16 / 128 / 1024 | Ya |
| Pair Extraordinaire | Commit ber-`Co-authored-by` di PR yang di-merge | 1 / 10 / 24 / 48 | Ya, co-author harus akun GitHub sungguhan dengan email terverifikasi |
| Galaxy Brain | Jawaban ditandai "answer" di Discussions repo publik | 2 / 8 / 16 / 32 | Hanya dengan akun kedua; pertanyaan sendiri tidak dihitung |
| Starstruck | Satu repo dapat bintang | 16 / 128 / 512 / 4096 | Tidak. Beli/tukar bintang melanggar ToS GitHub |
| Public Sponsor | Sponsor siapa pun lewat GitHub Sponsors | 1 | Tidak. Bayar minimal 1 USD sekali, manual |
| Heart On Your Sleeve | Reaksi ❤️ | 4 | Belum dirilis, sempat muncul karena bug Maret 2026 |
| Open Sourcerer | PR merged di banyak repo publik | 4 | Belum dirilis |
| Arctic Code Vault Contributor | Kontribusi sebelum Feb 2020 | 1 | Sudah ditutup |
| Mars 2020 Helicopter Contributor | Kontribusi ke dependensi Ingenuity | 1 | Sudah ditutup |

Badge muncul di profil dengan jeda, dari beberapa menit sampai beberapa jam.
Badge baru dihitung untuk PR yang masuk ke default branch.

Sumber: [drknzz/GitHub-Achievements](https://github.com/drknzz/GitHub-Achievements),
[Schweinepriester/github-profile-achievements](https://github.com/Schweinepriester/github-profile-achievements),
[community discussion #175547](https://github.com/orgs/community/discussions/175547),
[community discussion #191031](https://github.com/orgs/community/discussions/191031),
[community discussion #158734](https://github.com/orgs/community/discussions/158734),
[community discussion #45578](https://github.com/orgs/community/discussions/45578).
