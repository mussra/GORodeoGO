# Rancho 2.7.76 - estadísticas con barras

- Un único componente HorseStatBars presenta valores normalizados, sin porcentajes, cifras ni px.
- Ficha accesible desde Mi rancho/Colección, Atlas/mercado para caballos conseguidos, entrenamiento, HUD y resultado de entrenamiento.
- Los caballos no conseguidos indican que su rendimiento está por descubrir. No se inventan estadísticas.
- Cruzar conserva sus rasgos visuales A/B y centrado del potro. No mostraba estadísticas numéricas.
- Precios, tiempos, contadores y números de página siguen siendo números.
- Sin cambios en genética, valores de simulación, arte, formato de guardado ni paquete.

## Validación

- 446/446 pruebas unitarias, 54157 aserciones.
- Integración de entrenamiento en niveles: 4/4 pruebas, 22 aserciones; verifica barras de HUD y resultados, ganancias reales y pérdidas sin avance.
- Capturas y vídeo de QA revisados visualmente: Ficha normal, Atlas desplazado con las siete barras, entrenamiento, HUD y resultado. El vídeo fuerza un resultado para mostrar la presentación: no es una partida completa.
- APK arm64, versión 2.7.76, código335, paquete com.example.rancho.review.
- Firma verificada con el certificado habitual: 46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb.
- Sin prueba en dispositivo Android. Sin repetir toda la suite de integración. Las pruebas de Godot aún avisan de recursos/objetos retenidos al salir.
- Rama feat/open-world-test-20261107. Sin merge a main.
