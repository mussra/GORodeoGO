class_name CollectionCount184
extends RefCounted
static func horses(count:int)->String:return "%d %s"%[count,"caballo" if count==1 else "caballos"]
static func appearances(count:int)->String:return "%d %s"%[count,"apariencia" if count==1 else "apariencias"]
static func summary(horse_count:int,appearance_count:int)->String:return horses(horse_count)+" · "+appearances(appearance_count)
