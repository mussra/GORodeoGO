# Firma de Rancho Prueba

Desde 0.21.15 se usa la clave guardada de pruebas, no la firma de 0.21.14.

- Paquete: `com.example.rancho.review`.
- Certificado SHA-256 desde 0.21.15: `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`.
- Certificado anterior 0.21.14: `f8ffe0a294e6e0fd9b73edc6b5cbdb8db735039d35ea64ebf96bf049a7dd4fb6`.
- El cambio requiere desinstalar la versión anterior, perdiendo su progreso local. Antonio lo aceptó el 4 de noviembre de 2026 a las 21:31.
- Cartoon y Futurista comparten paquete, versión y firma: se sustituyen entre sí.
- En futuras compilaciones, recuperar la clave guardada y comparar este certificado antes de entregar. No generar otra clave de firma.
- La clave privada no se incluye en el repositorio, el APK ni la release.
