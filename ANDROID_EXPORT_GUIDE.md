# ANDROID EXPORT GUIDE — GO Rodeo GO

No puedo generar el APK desde aquí — no tengo Godot, Android SDK ni Java instalados en
este entorno. Esta guía te deja listo para generarlo tú mismo con un clic una vez
configurado (la configuración solo se hace una vez, no en cada build).

## 1. Instalar OpenJDK 17 (exacto, no otra versión)
Descarga e instala OpenJDK 17 (Temurin recomendado): https://adoptium.net/temurin/releases/?version=17
Anota la ruta de instalación (la necesitarás en el paso 3).

## 2. Instalar Android SDK
Opción simple: instala **Android Studio** (incluye el SDK Manager con interfaz gráfica) — https://developer.android.com/studio

En el SDK Manager, instala exactamente:
- Android SDK Platform-Tools
- Android SDK Build-Tools **34.0.0**
- Android SDK Platform **34**
- Android SDK Command-line Tools (latest)
- CMake **3.10.2.4988404**
- NDK **23.2.8568313** (r23c)

Anota la ruta del SDK (normalmente `%LOCALAPPDATA%\Android\Sdk` en Windows).

## 3. Configurar Godot (una sola vez)
1. Abre Godot → **Editor → Editor Settings** (no Project Settings — es la configuración global del editor, no del proyecto).
2. Busca **Export → Android**.
3. Rellena:
   - **Java SDK Path**: la carpeta donde instalaste OpenJDK 17.
   - **Android SDK Path**: la carpeta del SDK del paso 2.
4. Cierra Editor Settings.

## 4. Añadir el preset de exportación al proyecto
1. **Project → Export...**
2. **Add...** → **Android**.
3. En **Options → Keystore**, sección **Debug**: deja que Godot use el keystore de debug automático (botón "Create" o "Manage Export Templates" si te lo pide) — es suficiente para probar en tu móvil, no hace falta firma de release todavía.
4. Si Godot pide **instalar las plantillas de exportación (Export Templates)**: **Project → Install Android Build Template**, y si faltan las plantillas generales: **Editor → Manage Export Templates → Download and Install** (deben coincidir con tu versión exacta, 4.7.2).

## 5. Generar el APK
1. Con el preset Android seleccionado en el diálogo de Export → **Export Project**.
2. Nombra el archivo (ej. `rancho_debug.apk`) y guarda.
3. Copia ese `.apk` a tu móvil (por USB, o súbelo a Drive/similar y descárgalo en el móvil) y ábrelo para instalar — necesitarás permitir "instalar apps de origen desconocido" la primera vez.

## Alternativa más rápida para iterar: "One-Click Deploy"
Si conectas el móvil por USB con **depuración USB (Developer Options)** activada, Godot puede instalar y lanzar directamente:
1. Conecta el móvil, autoriza la depuración USB si el móvil lo pide.
2. En Godot, el botón de "Play" tiene un desplegable de dispositivo — selecciona tu móvil en vez de "Editor".
3. Ejecuta — Godot compila, instala y lanza el juego en el móvil directamente, sin pasos manuales de copiar el APK. Mucho más rápido para iterar mientras pruebas el `MANUAL_TEST_PLAN.md`.

## Nota sobre el botón "Finalizar"
`get_tree().quit()` cierra la app. Funciona, pero ten en cuenta que Android generalmente
desaconseja que las apps se cierren a sí mismas (el sistema gestiona el ciclo de vida) —
es un patrón común igualmente en muchos juegos casuales/indie, lo dejo tal como lo pediste,
solo lo flago por si prefieres cambiarlo más adelante (por ejemplo, volver a un menú en
vez de cerrar la app).
