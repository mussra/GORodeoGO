# Beber y pruebas Galaxy,11nov2026

Solicitud13:05-13:10:beber ante elementos de agua,cosmético,con colisión;pruebas Galaxy rosa/rojo mezclados con azul. PreviewantesdeAPK.

HorseDrink único para jugador de niveles/Frontera. Al estar parado0,6scerca de un agua registrada,muestra pose0durante0,45sycontinúa pose1. Usa las2poses suministradas,las máscaras/UVretocadas aprobadas y sus canales de sombrero. No modifica máscaras ni archivos fuente. Mirada lateral/reflejada con las2poses disponibles;no inventa posesverticales. No desplaza al actor,no atrae ni recupera energía. Movimiento,lazo,regate,salto,golpe o salir/cancelar acciones interrumpen. Recuperación pasiva previa del modo sigue independiente. Un nuevo elemento de agua debe registrarse comoHorseWatercon su huella. No haydetección semántica por nombre de textura.

Estanque del rancho y bebederos de niveles registrados;heno excluido. Colisión de aguaen capa64no saltada por habilidad de vallas. No se cambian físicas de cerdos/cabras. Estanque pasa a capa de suelo para no dibujarse sobre la cabeza,rectángulo sólido alineado con agua visible. Indicador de regate en Frontera sube al ancla de cabeza coherente con corrección de pivote de vallas. Vídeo controlado usando componentes reales;no pruebaAndroid.

Limitación visible heredada:la marcha nominalPixelLabno aplicaba sombreroAzul/Arena,mientras bebida sí. Nueva petición13:11autoriza añadir canales de sombrero separados preservando máscaras de Ant;trabajo siguiente,no ocultar esta diferencia en preview.

Galaxy:shaderdelretratoañade parámetros opt-inpara pruebas de paleta,defaultfalsemantiene fórmula anterior intacta. Imagen2x2rosa puro/rosa+azul/rojo puro/rojo+azul. No son unicornios terminados;no cambian genes,rareza,mercado,habilidades ni colección. No se generó arte nuevo.

QA475/475unitarias57210aserciones;12/12integraciones dirigidas93aserciones,incluye5pruebas nuevas bebida36aserciones:paro/cancelación,no efecto en colección,exclusiones,solidwaternojump,componente compartido en niveles,orilla izquierda,fuente liberada,caché y original inmutable. Persisten avisosfixtures/orphans. NoAPK,nomergemain.

Pendiente pedido:un río por mapa que bloquee avance hasta caballo especial,Atlas4unicorniosGalaxyazul/rosa/verde/rojoensiluetahastaobtenerlos,rastroarcoíris. Exige definir identidad/habilidad de unicornio y adaptar objetivos existentes para no generar misionesimposibles;no se ha insertado una barrera arbitraria.
