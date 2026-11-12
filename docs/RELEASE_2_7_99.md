# Rancho Prueba 2.7.99

## Hecho: Mi rancho

- Nuevo acceso desde Caballeriza para ver juntos los caballos de la colección, hasta 12 por página.
- Corrales por rareza: todos, común, poco frecuente, raro, ultra raro y legendario. Reutiliza la clasificación del Atlas, no añade ni cambia rarezas.
- Adultos animados con el mismo componente y los nueve fotogramas laterales usados en el mundo. No se ha generado arte nuevo.
- Potrillos estáticos, con acceso a la vista de sus dos progenitores junto a la cría. Un padre vendido aparece solo como registro familiar, nunca vuelve a la colección.
- Tocar el caballo o Ficha abre su ficha existente. Volver conserva el corral y la página. La lista de colección sigue disponible.
- Vista previa lateral y caché limitada a 36 apariencias/estados para no preparar las cinco orientaciones de cada adulto en los menús. Galaxy usa la maestría del caballo real.

## Sin cambios de reglas

No cambia partidas, genética, estadísticas, puntos, compras, crecimiento, adiestramiento ni equipamiento. No concede caballos ni transforma animales. El crecimiento normal y las decisiones pendientes de Galaxy continúan separados de esta vista. No es construcción/gestión física de ranchos ni movimiento de caballos fuera de la pantalla.

## Validación

- 588/588 pruebas unitarias, 2.556.312 aserciones.
- 21/21 pruebas de integración en seis scripts relacionados: nuevo rancho, orientaciones, mundo nominal, entrenamiento, manadas persistentes y primos. 4.944 aserciones.
- Otras cinco pruebas fallan en tres scripts antiguos de menús/genealogía. Se repitieron con los dos componentes modificados restaurados a 2.7.98: fallan igual, con las mismas cifras. No se presentan como regresiones nuevas ni se ocultan como pruebas aprobadas.
- Navegación real con eventos de puntero en simulación de escritorio: Caballeriza > Mi rancho > ficha > vuelta al corral > vuelta al menú.
- Inspección de capturas a 1280x720 y 960x540: corrales, segunda página, filtro legendario, familia y ficha.
- La creación de 12 adultos tarda aproximadamente 0,52 segundos en esta máquina. No es una medida de rendimiento Android.
- Conserva los avisos de recursos de la suite unitaria preexistente; el nuevo script de integración termina sin huérfanos.

## APK

- Paquete: `com.example.rancho.review`, versionCode 358, arm64, Android 7.0 o posterior.
- Mismo certificado que las versiones anteriores; firma V2/V3 verificada.
- SHA-256: `0c17232cea56d09a0ff9781a993bccd0eb26f1c66d9d19d6010558377224b146`.
- Tamaño: 69.659.795 bytes.
- Compilación de prueba, sin tocar main ni publicar en tienda. Instalar encima, sin desinstalar.
- No probado en un teléfono Android físico. La comprobación visual y de puntero es de escritorio.
