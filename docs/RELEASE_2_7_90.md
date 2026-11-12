# Rancho Prueba 2.7.90

Un APK acumulativo sobre2.7.89 desde la rama feat/open-world-test-20261107. Main intacto. Autorización de Ant de12/11/2026 12:15:16 para generar este APK con todo lo acumulado.

## Incluido desde2.7.89

- Reposo montado con patas apoyadas, gesto aleatorio cada5-10s y vuelta a reposo; marcha de9fotogramas conservada.
- Mapa con pinza/rueda anclada al punto, arrastre con un dedo/ratón, prevención de notas accidentales después de pinza, X dorada/localizar jinete, indicador de tamaño fijo y HUD marrón/dorado.
- Vuelo del lazo compartido de0,35s tanto en niveles como Frontera, sin aceleración oculta por progreso.
- Alerta animal por distancia/velocidad, aproximación lenta más discreta, obstáculos que reducen detección, huida/pánico y aviso a compañeros. El objetivo válido al aterrizar el lazo conserva su excepción; se mantiene soltar capturas al recibir el golpe correspondiente.
- Rebaños de cabras regionales en V3,2-4individuos por grupo, generados por semilla y registrados por ID para conservar capturas parciales sin respawn. V1/V2 conservan generador y progreso anteriores.
- Encargos junto a Menú, con panel desplazado y minimapa oculto mientras está abierto.
- Sombreros con selector de20colores y selector independiente de patrón/acabado, incluidos Arcoíris y Galaxia. Los tres antiguos siguen disponibles. Mismo coloreado en retrato y jinete real, solo apariencia y sin coste.
- Atlas r2: Los míos primero arriba y persistente también en variantes. Ambos órdenes conservan el mismo catálogo sin ocultar no conseguidos. Se preservan caballos propios con rasgos iguales y distintas variantes de una familia. Ordenar no activa filtros.
- Quitado el botón Unicornios del Atlas. Filtro Legendario con siluetas genéricas no conseguidas sin especie/nombre/pistas ni navegación a ficha oculta. Los conseguidos conservan nombre y retrato normal. Filtro de rareza adaptado sin cambiar precios/economía.

## Validación

- Export Android completado, un único APK nuevo.
- Unitarias551/551,1.659.196aserciones en la pasada final. El número de aserciones puede variar ligeramente por fixtures aleatorios.
- Integración pertinente17/17,915aserciones: alerta4, población de cabras1, notas de mapa1, reposo/beber5, huida/cruces1, inventario de animales1, montañas3, lazo/velocidad1. No se afirma haber ejecutado toda la campaña.
- Capturas896x414 de reposo/marcha con siete sombreros y Atlas antes/después inspeccionadas. No son prueba de Android físico. Galaxia se distingue sobre todo como violeta oscuro en el diminuto sombrero: los detalles finos se pierden a tamaño real.
- ZIP íntegro, recursos nuevos presentes. Manifest com.example.rancho.review, nombre Rancho Prueba, versionCode349, versionName2.7.90, mínimoAndroid24, target36, arm64-v8a.
- Firma V2/V3 verificada con el mismo certificado que2.7.89. Sigue siendo la compilación de prueba firmada para actualizar Rancho Prueba, no una app de producción de tienda.
- Sin dispositivo ADB conectado: no se afirma instalación, teclado, rendimiento ni táctil real. Persisten avisos conocidos de recursos retenidos al cerrar algunas pruebas. Exportador usa build-tools35 con target36 como en la versión anterior; export y verificación criptográfica terminan correctamente.

## Fuera y pendiente conocido

- No se añade nuevo arte raster. Caballos salvajes y cabras siguen sin animación genuina nueva de reposo/pastar sin jinete. Unicornios aún no tienen arte definitivo aprobado: los poseídos usan el retrato normal disponible.
- V3 solo se aplica a mundos nuevos; no se sobreescribe V1/V2 ni se reinicia progreso. No hay selector de varias partidas; no borres la partida para probar V3.
- Balance de alerta/lazo pendiente de sensación en móvil real. Las pruebas controladas no son una tasa de éxito garantizada para una persona.
- Sigue abierto lo ya documentado en2.7.89: economía/venta parcial de cerdos, anchura/arte final de puertos y biomas, colisión del lazo con roca, rodeo inteligente, premios/repetición de florista, recorte/cámara de fotos e iconos manuales de notas, pose exacta de caballo, varias partidas y escalabilidad sin techo. No se han dado por resueltos.
- Atlas tiene1.440familias base (20pelajes×12patrones×6crines) más variantes y registros propios; no hay cupo artificial de500caballos. No se añade cambio relacionado con una pantalla concreta de500 sin identificar aún a qué cifra se refiere el usuario.

## Integridad

- Tamaño:67.321.840bytes.
- SHA256 APK:fe5d155e30b34c96b491217d13462013ba5b44f67ede3bd4fc7f0e729140a093
- Certificado SHA256:46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb
