# Follow recovery correction, 5 November2026
Reported by Antonio07:26 after0.21.17. Reproduced against original code: edge scenario leaves bull375px away; tight obstacle corner leaves it288px away. Rider rectangle can fit closer to walls than bull radius24; an unreachable first breadcrumb blocks consumption forever.

Fix: after0.2seconds of blocked movement, choose a later breadcrumb at least64px away, project only blocked endpoints onto nearby clear grid cells and route physically around geometry to rejoin that part of the retained history. Normal follow still consumes original rider history. No teleport, collision-mask changes, immunity or direct velocity copying. A nearby blocked breadcrumb is skipped to avoid cycling between tiny projected detours. Rider path after the rejoin remains intact.

20focused tests/347assertions pass: original follow-behind, orderedZ, capture, real delivery, physical corrals, two newly reproduced collisions. New checks assert continuous progress while alongside outer edge, return to50px leash, retained capture, per-physics-frame bounded displacement and no overlap with inflated test obstacle. Preview9seconds inspected for edge and obstacle recovery. Synthetic Linux test/render, not Android-device proof. Grid remains fixed to existing arena bounds; enlarged-map prototype is separate.

Menu correction is separate fix/menu-hd-style3ab24f3, design approved user07:30. Candidate may incorporate it after recovery review. No main changes.
