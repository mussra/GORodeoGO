class_name RiderStory322
extends RefCounted
## One story identity across the introduction and in-world conversations.
const NAME:String="Pablo"
static func greeting(role:String)->String:
 match role:
  "farmer":return "¡Hola, %s! Qué bien verte por el rancho. "%NAME
  "florist":return "¡Hola, %s! ¿Seguimos buscando flores? "%NAME
  "loco":return "%s, cada caballo tiene algo especial. Fíjate en sus manchas y su crin. "%NAME
  "saddler":return "¡Pasa, %s! Un buen equipo te ayudará en tus aventuras. "%NAME
  "gardener":return "%s, cuidar el huerto también es parte de la aventura. "%NAME
  "alma":return "%s, vamos a aprender a cuidar tu cuadra, paso a paso. "%NAME
 return "¡Hola, %s! "%NAME
static func address(text_:String,role:String)->String:
 return greeting(role)+text_
