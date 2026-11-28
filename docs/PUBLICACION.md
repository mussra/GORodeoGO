# Lista de publicacion (regla de Ant: nunca obligar al jugador a perder progreso)

1. Firma estable.
   - Clave de subida de Play: zumbel-upload.jks, copia en el Drive de Ant (carpeta privada "Zumbel - claves Play"); contrasena en el vault ("Zumbel upload key").
   - Clave de las APK de prueba: vault "Mussra Android debug keystore (base64)" (cert SHA-256 46bdcb22...). Nunca generar claves nuevas ni firmar con claves efimeras. Si falta, recuperarla del vault, no regenerarla.
   - Antes de publicar: apksigner verify --print-certs y comparar con la version anterior publicada.
2. Progreso guardado.
   - El guardado lleva meta/version (SAVE_VERSION) y migraciones; cualquier cambio de formato sube la version y migra.
   - Antes de publicar: ejecutar los tests de guardado (test_save_data, test_backup333, test_rodeo_save241, test_points_migration, test_herd_migration226) y probar cargar un guardado de la version anterior.
3. Mismo paquete (com.zumbel.gorodeogo) y versionCode mayor que el anterior.
