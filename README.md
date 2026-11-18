# frigate

A Nix flake providing a Nixpkgs overlay for [Frigate](https://github.com/blakeblackshear/frigate) whose GenAI review step is permitted to say that nothing in a clip was noteworthy.

## Outputs

| Attribute          | What you get                                                                                             |
| ------------------ | -------------------------------------------------------------------------------------------------------- |
| `overlays.default` | An overlay that replaces `pkgs.frigate` with a build whose GenAI reviews are allowed to come back empty. |

```nix
nixpkgs.overlays = [ inputs.frigate.overlays.default ];
```

## Requirements and notes

- Apply it to a Nixpkgs that already provides `frigate`; it only overrides that package and contributes nothing else to the package set.
- What changes is how a review is described. A quiet clip now comes back as an empty `observations` list with the scene, title and summary reading "Nothing to report", instead of a minimum-length paragraph accounting for parked vehicles, permanent fixtures and closed doors. A clip with something genuinely active in it is still described in full.
- Detection, event creation and review generation itself are unchanged — the same reviews are produced, they are simply allowed to be empty. Anything downstream that consumes a review report must therefore tolerate zero observations and a one-line summary, where the field lengths enforced by stock Frigate guaranteed a paragraph.
- The override is anchored to Frigate's source layout at a particular revision. Against a Nixpkgs carrying a Frigate that has moved, it fails at build time rather than quietly yielding the unpatched package.
- It also turns off both check phases (`doCheck` and `doInstallCheck`), so Nixpkgs does not run Frigate's pytest suite while building the package. Nixpkgs runs that suite as the install check for this package, so `doCheck` alone leaves it running. The import check still runs.

See [LICENSE.md](LICENSE.md) for licensing and copyright, and [NOTICE.md](NOTICE.md) for the terms of upstream and distributed artifacts.
