extends GutTest
func test_zero_one_and_many_counts():
 assert_eq(CollectionCount184.summary(0,0),"0 caballos · 0 apariencias")
 assert_eq(CollectionCount184.summary(1,1),"1 caballo · 1 apariencia")
 assert_eq(CollectionCount184.summary(2,1),"2 caballos · 1 apariencia")
 assert_eq(CollectionCount184.summary(3,2),"3 caballos · 2 apariencias")
 assert_eq(CollectionCount184.horses(1),"1 caballo")
