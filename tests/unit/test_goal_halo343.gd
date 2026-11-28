extends GutTest
## 3.0.43: el halo del objetivo es un fade suave y lento (accesible), sin saltos.
func test_halo_stays_in_range_and_is_slow()->void:
	var lo:float=1.;var hi:float=0.;var max_step:float=0.
	var prev:float=WorldDiscoveryMap159.goal_halo_phase343(0.)
	for i in range(1,521):
		var v:float=WorldDiscoveryMap159.goal_halo_phase343(float(i)*.01)
		lo=minf(lo,v);hi=maxf(hi,v);max_step=maxf(max_step,absf(v-prev));prev=v
	assert_almost_eq(lo,0.,.001);assert_almost_eq(hi,1.,.001)
	assert_lt(max_step,.05,"cambio por 10 ms demasiado brusco")
func test_halo_cycle_is_longer_than_two_seconds()->void:
	assert_almost_eq(WorldDiscoveryMap159.goal_halo_phase343(0.),WorldDiscoveryMap159.goal_halo_phase343(2.6),.001)
	assert_gt(WorldDiscoveryMap159.goal_halo_phase343(1.3),.99)
