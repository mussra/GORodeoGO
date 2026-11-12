# País del agua: estado de implementación

La petición original del12nov13:03:51 define mapa separado, otro césped/camino, árbol gigante regado por río y nacimiento río arriba.13:04:45 define regreso por capas y13:05:19la siesta entre sitios conocidos. Las condiciones de acceso, potencia de estela y detalles del ritual no están decididos. El diseño124contiene propuestas, no permisos adicionales.

## Disponible en2.7.104

`CountryRoute146`: topología determinista version1, agua/tronco sólidos, camino de aproximación y orilla continua. `CountryLedger146`: planes puros de entrada/salida, progreso independiente, retorno al portal enlazado, validación estricta. `SaveData.country_ledger146`: almacenamiento aditivo y atómico, NO usado por la maqueta. No duplica datos del mapa original ni cambia su versión. `CountryPreview146`: mundo de prueba temporal, usa WorldPlayer/TouchControls/arte existentes. La salida restaura la instancia original mediante el mismo mecanismo de vista de diseño93.

## Siguiente trabajo

1. Separar protocolo de carga/llegada de la actual SiestaTravel144 para que sirva a destinos del país sin duplicar animación, bloqueo de capturas ni rollback. Mantener pruebas de guardado prematuro.
2. Conectar registro de países a una escena persistente, detrás de entrada de prueba explícita. Resolver escena actual al reabrir, sin tocar world_position del mapa original mientras se está en otro país. Guardado de destino solo después de carga/llegada segura; fallo vuelve al mapa origen.
3. Mapa local con exploración/solo sitios visitados, entrada/árbol/fuente en el selector común y Volver a casa dirigido a la entrada local. No selector global entre países por inferencia.
4. Rastro y acceso en coordenadas transitables del mapa original, orientaciones de primos verificadas. No activar la puerta normal hasta resolver requisito de acceso.
5. Arte de árbol/fuente/río y pistas. El árbol ampliado actual es un placeholder borroso, no arte nuevo ni definitivo.
6. Ritual separado, con confirmación y conservación de identidad/ascendencia; sigue pendiente la mecánica exacta.

No dar por entregado el país final a partir de la maqueta. No cambiar adquisiciones Galaxy, crecimiento,20/40ni reglas de pureza para hacer encajar la entrada.

## Protocolo compartido147, preparación posterior a2.7.104

SiestaTravel144 usa ahora `TravelTransaction147`: carga → validación de llegada → commit, o una sola restauración. El origen sigue guardándose antes de pausar/cargar. La animación está en `SiestaCurtain147`, separada del adaptador de Frontera. Las12integraciones de siesta siguen pasando, incluida comprobación en disco del destino bloqueado, y tres pruebas nuevas cubren orden, cada fallo, restauración fallida y concurrencia. La revisión visual confirma la misma transición y llegada. Es un checkpoint de código, no un APK nuevo.

Siguiente: extraer búsqueda de llegada libre a un servicio común con callback de terreno, y adaptar la maqueta del país al mismo protocolo/selector. No usar WorldTerrain103 para validar coordenadas del país nuevo. Después mapa local con sitios visitados y regreso a la entrada. Mantener la maqueta sin guardado hasta completar el flujo de reentrada/recarga y la elección de entrada normal.

##2.7.105: mapa y viaje local148

Mapa explorado por celdas locales, selector solo de visitas, casa hacia entrada local. Maqueta todavía temporal. `TravelLanding148` comparte la comprobación de forma física con Frontera y recibe la validación de terreno por callback. Se corrige la transformación de la forma para respetar offset real de colisión. `SiestaConfirmation148` compartida.39integraciones/3.122aserciones y614unitarias pasan. Para persistencia: guardar explored148 como parte del ledger versionado, validar celdas y migrar versión1; no mezclar con world_discovered. Conectar escena activa en un flujo de prueba explícito sin activar aún puerta/ritual normales.

## Checkpoint149: datos, aún no escena persistente

LedgerV2 conserva exploración local y rechaza celdas fuera del país/datos malformados. V1 se migra solo en memoria conservando semilla, vínculos, notas, visitas y posición; no se inventa un camino explorado. Guardado desconocido sigue bloqueando reescrituras. Hooks de sesión preparados sin activar navegación, puerta ni guardado de la maqueta. Falta la escena/sesión con autosave/entrada/retorno y reanudación comprobadas antes de exponer modo persistente.
