# Preview de campos extensos

Escena aislada: dos campos de2048×1024px, cada uno ocupa dos chunks contiguos. Rojo y violeta se ven como manchas en el mapa de muestra; el caballo atraviesa cada campo con las poses reales de movimiento. Cada campo contiene2556flores del arte existente, sin nuevos sprites. El clip de cuatro segundos es montaje de dos tomas de galope de la escena, no una partida Android ni una ruta jugable conectada. Los frames se muestrearon a20fps para el vídeo, no es un benchmark de FPS.

Mapa dibujado de preview usando los mismos límites de campos, no el minimapa de una partida. Ambas zonas se muestran descubiertas para comparar; no se activó revelado de mapa real. Caballo animado por script, sin controles ni captura. El renderer actual de esta escena usa pocos nodos y dibujo estático de flores; todavía necesita culling/lotes/LOD y perfil Android antes de integrar campos grandes en streaming real. No simula densidad infinita ni rendimiento del teléfono.

Las flores rojas reutilizadas son un símbolo de amapolas con el arte disponible, no una especie botánica nueva. Las violetas reutilizan su sprite existente. No se ha cambiado terreno, generador, SaveData, APK ni main. Inspección visual de mapa y tomas de ambos campos antes de publicar.
