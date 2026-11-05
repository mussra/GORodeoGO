# Pending work integrated to main

User confirmed merge to main on 2026-11-05 after the clarification about publishing temporary branches.

The current selected-flat-splash line includes sequential work through 0.21.26: follow recovery, performance/lasso, hay/water, spacious 15-20 arenas and minimap, screen-edge dodge, grouped herds, persistent courier sequence puzzle and selected flat Zumbel logo with complete text.

Two non-ancestor historical branches are preserved without restoring older behavior:
- fix/menu-hd-style commit 3ab24f3: same rider_hd.png bytes as current line (reapplied as 2b1734f), no missing artwork.
- improve/scrolling-arenas commit 64e611b: earlier arena prototype expanding 11-20. Current 0.21.21+ line supersedes it with requested 15-20 expansion, later minimap and readable trails. Original prototype and tests remain on its published branch; merging it literally would regress current map rules and presentation. No branch deleted.

Common 1080 square Zumbel splash normalization was recovered from stash. It changes only empty background extension, blue surround and landscape fit. No new APK published for this source-only normalization: existing 0.21.26 remains the delivered installer.

Review-only logo drafts outside the repository were not selected and are not shipped. Gameplay balancing remains subject to user feedback. The merge does not certify Android feel or previously reported campaign warnings.
