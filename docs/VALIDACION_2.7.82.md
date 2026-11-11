# Rancho Prueba2.7.82

Versión341. Rama feat/open-world-test-20261107, sin main. Aprobación de integrar la preview recibida11noviembre11:38. APK llamado Rancho-2.7.82.apk.

## Cambios
La transición real menú→Frontera muestra jinete al paso que deriva hacia la derecha frenando asintóticamente. Animales/granjero cruzan más rápido hacia la izquierda. Pelajes/patrones/crines y orden/intervalos son cosméticos, con RNG propio. No cambia colección ni genes ni semilla del mundo. Jinete mantiene ropa/sombrero existentes; granjero usa ilustración estática con balanceo, sin ciclo de piernas nuevo.

Escena compartida LoadingParade usada por preview y transición real, no copias. Solo9frames laterales por actor; no carga vistas frontal/trasera/diagonales para esta pantalla. Recicla cruces fuera del encuadre mientras llegan chunks iniciales. Al estar listo, carrera230px/s y fundido inmediato0,5s, sin esperar a salir ni obligar a completar una vuelta. No barra ni porcentaje.

Incluye trabajo de caminos/accesos a puertas y recintos apartados de caminos ya preparado en la rama. Ambiente/floristería y notas/fotos siguen como prototipos aislados, no funciones de juego. No exportación automática de fotos, ni nuevo puente Android de galería.

## Pruebas
469/469unitarias,56344aserciones, perfil limpio. Nueva cobertura de curva monótona/desaceleración/límites y aislamiento de estado cosmético.
Integración dirigida de encargos del granjero1/1,18aserciones.
Ruta REAL desde menú:9chunks al terminar y transición eliminada después del fundido. Inspección de vídeo real, captura de transición y mundo final.

Medición de escritorio con render Vulkan por software, no vídeo a FPS fijos:8,81shasta listo (8,85shasta la comprobación QA), después0,5sde fundido. Una medición previa antes de esta animación dio7,40s. No se afirma mejora del tiempo total, espera invisible, fluidez garantizada o equivalencia Android. Preparación/recolor de texturas aún puede superar el presupuesto por paso. Vídeo de muestra es grabación a30FPS, no benchmark.

Batería de integración amplia accidentalmente iniciada por mantener directorios del config se cortó por timeout. No toda integración aprobada. El test_bullet_time.gd falla aislado3/4tests,11/14aserciones:3aserciones de doble tap nativo de joystick en headless. Reproducido exactamente igual en copia separada del commit previof5be7f2con importación y perfil limpios. Preexistente respecto a esta integración, no atribuirlo a la nueva animación. Persisten avisos de recursos/objetos al cerrar QA.

No Android real. Pendientes tacto, rendimiento y espera reales en móvil.

## APK
com.example.rancho.review, arm64,2.7.82código341,SDKmínimo24/objetivo36. Firma idéntica a anterior:46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb. Firma v2/v3 verificada. Paquete de pruebas, no publicación en tienda.
Tamaño53104740bytes. SHA2564045693c1344ed158488da4fd9f7f95a3a4b5c693a47e26b9d7f2be7c993cd0d.
