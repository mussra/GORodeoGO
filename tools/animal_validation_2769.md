# Rancho 2.7.69 (328): carrera PixelLab de animales

## Incluido
- Cerdo: lateral, frontal y trasera, 9 fotogramas por vista a 9 fps. Las diagonales usan la lateral, no son vistas nuevas.
- Cabra: lateral, frontal y trasera, 9 fotogramas por vista a 9 fps. Las diagonales usan la lateral.
- Toro: 5 vistas reales de carrera, 9 fotogramas por vista a 9 fps. Se cubren 8 sentidos con espejos.
- Interruptores independientes de cerdo, cabra y toro en Ajustes; los cambios se aplican al entrar a jugar. El arte clásico sigue disponible.
- Reposo, cansancio, beber, captura y demás estados no recibieron animaciones nuevas. El cerdo PixelLab es rosa también en la variante marrón durante la carrera.
- Caballo/jinete, máscaras v5, lazo y reglas conservados. Los retoques nuevos del editor v6 no se han aplicado al juego.

## Comprobado en PC
- 417/417 pruebas unitarias pasan.
- Arte y reversibilidad: 3/3 pruebas, 54 aserciones, salida limpia.
- Integración: mundo con 9 zonas, captura/proximidad, tiempo de cuerda y liberación de cerdo/cabra; 8 direcciones; toros de la escena real de nivel 01: 1/1 prueba, 77 aserciones.
- 90 fotogramas nuevos contrastados con las hojas originales: recorte exacto salvo espejo sin pérdida de la lateral de cabra. Las 90 referencias importadas están presentes en el APK.
- Imagen y vídeo de 8 direcciones, mundo, nivel y Ajustes inspeccionados.
- APK exportado, alineado y firma verificada. Paquete com.example.rancho.review; versionCode 328; mismo certificado que 2.7.68.

## Límites conocidos
- No es una batería de salida limpia: el conjunto unitario deja 1757 objetos y 128 recursos al cerrar. La integración deja 2 objetos. Las aserciones pasan, pero estos avisos de limpieza siguen pendientes.
- No se ha probado instalación, controles táctiles ni rendimiento en un Android físico. PC y empaquetado no los certifican.
- No se afirma que estén completas todas las animaciones de todos los animales.

APK: 57.350.401 bytes.
SHA-256: 1469cfc0ceeddc1cde699fecb4607938cc00d697f869eaa99a5e322aed381fff
Certificado SHA-256: 46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb
