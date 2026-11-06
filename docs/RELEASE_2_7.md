# Rancho Prueba 2.7 - escudos personalizables

- Caballeriza > ficha de un caballo adulto > Escudo personalizado.
- Tres formas, tres divisiones, cinco símbolos por zona y cinco colores de ficha.
- Vista previa real sobre el caballo, marca de tinta en el muslo trasero, sin relleno.
- Contraste claro/oscuro y borde opuesto. Zonas de marca independientes de las máscaras de color.
- Guardar, quitar y confirmar al salir con cambios sin guardar. Guardado separado en Normal y Debug.
- Personalizar no cambia rareza, precio, padres ni herencia. La acreditación de linajes sigue pendiente de decidir.
- No incluye dibujo a mano ni importar imágenes. No asigna familias automáticamente.

## Comprobaciones

89 tests, 88.509 aserciones en 16 scripts pasan. Persistencia, retirada, rollback, validación de configuraciones, compatibilidad con partidas antiguas, neutralidad económica y aislamiento de píxeles probados. Persisten avisos y errores conocidos del addon GUT, no es una certificación global sin errores.

Editor y vista de contraste renderizados con Godot e inspeccionados. Revisadas hojas de fotogramas y direcciones; de frente o de espaldas el muslo queda oculto y no se dibuja sobre cola, jinete o equipo. No probado en dispositivo Android físico. Mantiene paquete y firma de pruebas; instalar como actualización.
