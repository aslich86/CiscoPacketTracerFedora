# Cara Menginstall Cisco Packet Tracer di Fedora, dan Linux RPM Lainnya

Cara install :
- Download installer .deb di web Netacad pastikan simpan di directory apapun, namun tetap berada di `/home`
- Clone repository ini ke komputer lokal yang berisi `install.sh` dan `uninstall.sh`
- cd ke tempat clone tadi berada kemudian lakukan permission agar executable `chmod +x install.sh`
- Jalankan `bash install.sh` atau `sudo bash install.sh`, ini akan mencari dan menjalankan sendiri installar .deb Cisco Packet Tracer.
- Selesai


Cara Uninstall :

- cd ke tempat clone berada.
- Lakukan permission agar executable `chmod +x uninstall.sh`
- Jalankan `sudo bash uninstall.sh`
- Selesai

NB : Berjalan sukses di Nobara Linux 39
