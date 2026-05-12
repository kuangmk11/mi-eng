# mi-eng

Adaptations of some popular eurorack modules for norns

Based on the supercollider UGens by Volker Bohm https://github.com/v7b1/mi-UGens

This is NOT a project by Mutable Instruments.

Ugens can be downloaded here: https://llllllll.co/t/mi-ugens-for-norns/31781

### installation

Pre-built norns (armhf) UGen binaries are included in the `Extensions/` folder. Copy them to norns:

```bash
scp -r Extensions/* we@norns.local:/home/we/.local/share/SuperCollider/Extensions/
```

Then SLEEP and restart your norns.

> If you need to rebuild `MiBraids` from source, clone [v7b1/mi-UGens](https://github.com/v7b1/mi-UGens) with submodules on norns and compile against SC headers matching your installed `scsynth` version (`scsynth -v` to check).

### norns engines

Clone this repo to `~/dust/code/mi-eng/` on norns (the folder name must be `mi-eng`):

```bash
cd ~/dust/code
git clone https://github.com/kuangmk11/mi-eng mi-eng
```
