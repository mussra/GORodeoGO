# Rancho Prueba 2.7.184: puntos ganados y varias mejoras

APK de prueba, código 443. Mismo paquete y firma, instalar encima. Solo rama de pruebas, sin main ni tienda.

Cada propiedad que mejora muestra el incremento real junto a su nombre: +2 pts, +10 pts o, si corresponde, +0,83 pts. Son puntos normalizados de la propiedad, no unidades internas de física ni una cantidad decorativa. El crecimiento sigue siendo determinista y con rendimientos decrecientes: la cantidad depende del progreso previo de esa propiedad.

Asignación elegida para este cambio:
- Duelo: Manejo y Serenidad.
- Justa: Agilidad, Manejo y Serenidad.
- Ninguno de estos dos juegos aumenta Velocidad ni Fuerza. Carrera y Toros conservan esas especialidades.

La ficha aparece al finalizar la victoria que se acaba de jugar, después de guardar las mejoras. Las propiedades afectadas se animan juntas, cada una con su tramo turquesa redondeado y estrella. Se conserva el caballo participante de esa partida, aunque la selección cambie después. El guardado es atómico: si falla, no queda aplicada solo una parte del premio ni se duplica al reintentar.

## Validación

269/269 pruebas, 44.167 aserciones y 45 scripts. Comprobaciones de ficha inmediata en las rutas reales de final de carrera, duelo y justa; varios atributos sin velocidad/fuerza; formato de números enteros y fraccionarios; animación simultánea; reversión y reintento del guardado múltiple.

Ficha de Justa revisada visualmente durante la animación y al terminar, con tres mejoras +2 pts. Vídeo inspeccionado. Continuar responde a entrada táctil simulada en escritorio. No probado en Android físico. Cuatro deprecaciones, avisos UID de GUT, errores de guardado intencionados en pruebas de reversión y aviso de dos ObjectDB al cerrar la batería. No se han medido FPS en Android.
