# Den — Context-aware Dendritic Nix (LLM Reference)

Source: <https://den.oeiuwq.com/> · Repo: <https://github.com/vic/den>

This is a single-file consolidation of Den's docs for use as LLM context. Code is Nix unless marked otherwise.

## Mental Model

Den is a **library** (`den.lib`) plus an opinionated **framework** (`den.hosts`/`den.homes`/`den.aspects`/`den.ctx`/`den.provides`) for aspect-oriented, context-driven Nix configs. It works with flake-parts, without flake-parts, or without flakes. It supports NixOS, nix-Darwin, Home Manager, hjem, nix-maid, WSL, MicroVM, custom module systems.

A **Dendritic aspect** bundles modules of multiple Nix *classes* under one cross-cutting concern:

```nix
gaming = {
  nixos       = { ... };
  darwin      = { ... };
  homeManager = { ... };
  hjem        = { ... };
};
```

A **context** is an evaluation-pipeline stage carrying data (`{ host }`, `{ host, user }`, `{ home }`, etc.). Aspect functions activate when their argument pattern matches a context's shape — this is how cross-class config is selected without `mkIf`/`enable`. The `host`/`user`/`home` you receive are **real function arguments**, not `_module.args` and not `specialArgs`, so config can depend on them without infinite loops.

Three lines summarize the runtime:

```nix
aspect      = den.ctx.host { host = den.hosts.x86_64-linux.igloo; };
nixosModule = den.lib.aspects.resolve "nixos" aspect;
nixosConfigurations.igloo = lib.nixosSystem { modules = [ nixosModule ]; };
```

Layers:

| Layer       | Purpose                  | Example                                                |
|-------------|--------------------------|--------------------------------------------------------|
| Schema      | Declare entities         | `den.hosts.x86_64-linux.laptop.users.alice = {}`       |
| Aspects     | Configure behavior       | `den.aspects.laptop.nixos.networking.hostName = "..."` |
| Context     | Transform data flow      | `den.ctx.host` -> `{host}`, fans out to `{host,user}`  |
| Batteries   | Reusable patterns        | `den.provides.primary-user`                            |

## Aspects

Aspect = attrset with per-class owned configs, an `includes` DAG, and named sub-aspects (`provides`, alias `_`):

```nix
den.aspects.igloo = {
  # Owned (per Nix class)
  nixos.networking.hostName = "igloo";
  darwin.nix-homebrew.enable = true;
  homeManager.programs.vim.enable = true;

  # DAG
  includes = [
    { nixos.programs.vim.enable = true; }                 # static (plain attrset)
    ({ host, ... }: { nixos.time.timeZone = "UTC"; })     # parametric
    den.aspects.tools                                     # other aspect
  ];

  # Sub-aspects
  provides.gpu = { host, ... }: lib.optionalAttrs (host ? gpu) {
    nixos.hardware.nvidia.enable = true;
  };
};
```

Three `includes` kinds: (1) static plain attrset, (2) static aspect-leaf taking `{ class, aspect-chain }`, (3) parametric — any function whose required args determine when it activates.

For every host/user/home declared, Den auto-creates a `parametric` aspect with the relevant class slots. You then *extend* it from any module.

To add custom options to an aspect, use the function-args form so `imports` is a real module import:

```nix
den.aspects.tux = { config, ... }: {
  imports = [{
    options.default-key = lib.mkOption { type = lib.types.str; };
  }];
  default-key = "Hello World!";
};
```

Self-reference works (fixed-point):

```nix
den.aspects.igloo = { config, ... }: {
  meta.default-key = "abc";
  homeManager.programs.gpg.settings.default-key = config.meta.default-key;
};
```

Manually resolve for a class: `module = den.lib.aspects.resolve "nixos" den.aspects.igloo;`.

## Parametric Dispatch

Den uses `builtins.functionArgs` to select includes:

```nix
({ host, ... }:        ...)  # matches any ctx with at least { host }
(den.lib.perUser ({ host, user }: ...))  # matches { host, user } exactly
(den.lib.perHome ({ home }: ...))        # matches { home } exactly
```

Variants of `den.lib.parametric`:

| Constructor              | Behavior                                                                              |
|--------------------------|---------------------------------------------------------------------------------------|
| `parametric`             | Default. Owned + static + atLeast-matching functions.                                 |
| `parametric.atLeast`     | **Excludes** owned & statics. Only atLeast-matching functions.                        |
| `parametric.exactly`     | Like atLeast but match must be exact.                                                 |
| `parametric.fixedTo X`   | Ignore actual ctx, always use `X`.                                                    |
| `parametric.expands X`   | Default + extends incoming ctx with `X` before dispatch.                              |
| `parametric.withOwn`     | Low-level: owned/statics at static stage, custom functor at parametric stage.         |

Helpers: `canTake params fn` (atLeast), `canTake.exactly params fn`, `take.atLeast fn ctx`, `take.exactly fn ctx`, `perHost`, `perUser`, `perHome`, `statics`, `owned`, `isFn`, `isStatic`.

**Anti-pattern:** anonymous functions in `includes` break Nix error traces. Prefer named aspects.

## Context Pipeline

`den.ctx.<name>` defines a stage with:

- `_` / `provides.<x>` — aspect contributions
- `into.<other>` — transitions to other contexts (return list of new ctx values)
- `meta.adapter` — optional resolution adapter (composes with parents)
- `includes` — battery injection point
- `modules` — extra modules merged into resolved output

Built-ins:

```
host (data: {host})
  ├─ _.host = fixedTo {host} on host's aspect
  ├─ _.user = atLeast on host's aspect with {host,user}
  └─ into.user → user (data: {host,user})  →  _.user = fixedTo
     into.hm-host → hm-host (data: {host}) [if HM enabled]
       └─ into.hm-user → hm-user (data: {host,user}) — forwards homeManager → home-manager.users.<userName>
     into.wsl-host  [if host.wsl.enable]
     into.hjem-host [if hjem enabled]
     into.maid-host [if nix-maid enabled]
home (data: {home}) — separate path for standalone homes
```

Resolution: `collectPairs` walks `into.*` recursively, then `dedupIncludes` ensures the **first** appearance of a context type uses `parametric.fixedTo` (owned + statics + parametric), and **subsequent** appearances use `parametric.atLeast` (parametric only). This prevents `den.default` configs being applied twice.

Define a custom context:

```nix
den.ctx.gpu = {
  description = "GPU-enabled host";
  _.gpu = { host }: { nixos.hardware.nvidia.enable = true; };
};
den.ctx.host.into.gpu = { host }: lib.optional (host ? gpu) { inherit host; };
```

Output: `host.instantiate` (defaults: `lib.nixosSystem`/`darwinSystem`/`homeManagerConfiguration`) emits to `flake.<host.intoAttr>`.

## Schema (`den.hosts`, `den.homes`, `den.users`)

Hosts:

```nix
den.hosts.x86_64-linux.laptop.users.alice = {};
den.hosts.aarch64-darwin.mac = {
  users.alice = {};
  brew.apps   = [ "iterm2" ];     # custom freeform
};
```

Host options: `name`, `hostName` (= `name`), `system` (= parent key), `class` (auto from system), `aspect` (= `name`), `users`, `instantiate` (auto), `intoAttr` (auto), plus anything from `den.schema.host`, plus freeform extras.

Default `instantiate`: `nixos` → `inputs.nixpkgs.lib.nixosSystem`, `darwin` → `inputs.darwin.lib.darwinSystem`, `systemManager` → `inputs.system-manager.lib.makeSystemConfig`.

Default `intoAttr`: `[ "nixosConfigurations" name ]` / `[ "darwinConfigurations" name ]` / `[ "systemConfigs" name ]`. Set `intoAttr = []` to skip placement; override `instantiate` for custom builders.

Users (within a host):

```nix
den.hosts.x86_64-linux.laptop.users = {
  alice = {};
  bob.classes = [ "homeManager" "hjem" ];
};
```

User options: `name`, `userName` (= `name`), `classes` (default `[ "homeManager" ]`), `aspect` (= `name`), plus `den.schema.user` and freeform.

Standalone homes:

```nix
den.homes.x86_64-linux.alice = {};                  # → homeConfigurations.alice
den.homes.x86_64-linux."tux@igloo" = {};            # CLI auto-selects on igloo
```

Home options: `name`, `userName`, `system`, `class` (= `"homeManager"`), `aspect`, `pkgs` (= `inputs.nixpkgs.legacyPackages.${system}`), `instantiate` (= `inputs.home-manager.lib.homeManagerConfiguration`), `intoAttr` (= `[ "homeConfigurations" name ]`).

Base modules — apply to all entities of a kind:

```nix
den.schema.host = { host, lib, ... }: {
  options.hardened = lib.mkEnableOption "Is it secure";
  config.hardened  = lib.mkDefault true;
};
den.schema.user.classes = lib.mkDefault [ "homeManager" ];
den.schema.conf.options.copyright = lib.mkOption { default = "Copy-Left"; };
```

`schema.conf` applies to all three (host/user/home).

Use freeform attrs in aspects:

```nix
den.hosts.x86_64-linux.laptop.gpu = "nvidia";

den.aspects.laptop.includes = [
  ({ host, ... }: lib.optionalAttrs (host ? gpu) {
    nixos.hardware.nvidia.enable = true;
  })
];
```

## Global Defaults

```nix
den.default = {
  nixos.system.stateVersion       = "25.11";
  homeManager.home.stateVersion   = "25.11";
  includes = [ den.provides.define-user den.provides.inputs' ];
};
```

Owned configs in `den.default` are deduplicated across pipeline stages, but **parametric functions in `den.default.includes` run at every stage**. Use `den.lib.perHost`/`perUser`/`perHome` or `take.exactly` to restrict.

## Built-in Batteries (`den.provides.*`, alias `den._.*`)

| Battery                       | Purpose                                                                |
|-------------------------------|------------------------------------------------------------------------|
| `define-user`                 | `users.users.<n>` + `home.username`/`home.homeDirectory`.              |
| `hostname`                    | Sets `networking.hostName` from `host.hostName`.                       |
| `os-user`                     | Built-in `user` class → `users.users.<userName>`.                      |
| `primary-user`                | wheel+networkmanager, `isNormalUser`; Darwin `system.primaryUser`; WSL `defaultUser`. |
| `user-shell <shell>`          | Sets shell on OS + HM. E.g. `(den.provides.user-shell "fish")`.        |
| `mutual-provider`             | Bidirectional host↔user contributions via `.provides.`.                |
| `tty-autologin <name>`        | `services.getty.autologinUser`.                                        |
| `wsl`                         | Activates `den.ctx.wsl-host` if `host.wsl.enable`; imports NixOS-WSL.  |
| `forward`                     | Custom-class forwarder (see "Custom Classes" below).                   |
| `import-tree`                 | Loads non-dendritic dirs; `_nixos/`, `_darwin/`, `_homeManager/` auto. |
| `unfree [pkgs]`               | Allows specific unfree packages by name (any class).                   |
| `insecure [pkgs]`             | Allows specific insecure packages by name.                             |
| `inputs'` (flake-parts only)  | Provides system-specialized `inputs'` as module arg.                   |
| `self'` (flake-parts only)    | Provides system-specialized `self'` as module arg.                     |

Usage:

```nix
den.default.includes = [ den.provides.define-user den.provides.inputs' ];

den.aspects.alice.includes = [
  den.provides.primary-user
  (den.provides.user-shell "zsh")
  (den.provides.unfree [ "vscode" ])
];

# import-tree variants
den.ctx.host.includes = [ (den.provides.import-tree._.host ./hosts) ];
den.ctx.user.includes = [ (den.provides.import-tree._.user ./users) ];
den.aspects.laptop.includes = [ (den.provides.import-tree ./disko) ];
```

## Mutual Providers (Host ⇄ User)

Default Den is unidirectional. Enable bidirectional contribution:

```nix
den.ctx.user.includes = [ den._.mutual-provider ];

# user → host(s)
den.aspects.tux = {
  provides.igloo.nixos.programs.emacs.enable = true;
  provides.to-hosts = { host, ... }: {
    nixos.programs.nh.enable = host.name == "igloo";
  };
};

# host → user(s)
den.aspects.igloo = {
  provides.alice.homeManager.programs.vim.enable = true;
  provides.to-users = { user, ... }: {
    homeManager.programs.helix.enable = user.name == "alice";
  };
};
```

User-to-user peers and standalone-HM-to-host work the same way (with `den.ctx.home.includes = [ den._.mutual-provider ]` for the standalone case).

## Custom Nix Classes (Forwarding)

Custom classes forward into a target submodule path on another class (this is how `user`, `homeManager`, `hjem`, `maid` themselves are implemented).

```nix
{ host }: den.provides.forward {
  each       = lib.attrValues host.users;
  fromClass  = user: "user";
  intoClass  = user: host.class;
  intoPath   = user: [ "users" "users" user.userName ];
  fromAspect = user: den.aspects.${user.aspect};
}
```

| Param           | Description                                                       |
|-----------------|-------------------------------------------------------------------|
| `each`          | List of items to forward                                          |
| `fromClass`     | `item -> str` — custom class to read from                         |
| `intoClass`     | `item -> str` — target class to write into                        |
| `intoPath`      | `item -> path` (or `args -> path`) — target attribute path        |
| `fromAspect`    | `item -> aspect` — aspect to read the custom class from           |
| `guard`         | Optional `args -> bool` or `args -> item -> mkIf`                 |
| `adaptArgs`     | Optional `args -> attrs` to transform module args                 |
| `adapterModule` | Optional `deferredModule` for the forwarded submodule type        |

Guards: use `lib.optionalAttrs` for *option existence*, `lib.mkIf` for *config values*.

When `forward` is called without `fromAspect`, it defaults to `item.resolved` (resolves the source entity through *its own* pipeline). Useful for cross-host operations like collecting SSH host keys.

Useful patterns: cross-OS class (`os` — already shipped, forwards into both `nixos` and `darwin`), platform-specific HM classes (`hmLinux`/`hmDarwin` guarded on `pkgs.stdenv.isLinux/isDarwin`), role-based (`each = lib.intersectLists host.roles user.roles`), guarded `git` class (only when `programs.git.enable = true`), `nix` class propagating settings to both NixOS and HM, `persys` impermanence class guarded on `options ? environment.persistance`.

## Home Environments

Supported: `homeManager`, `hjem`, `maid`, `user`. All opt-in except `user`.

```nix
# per user
den.hosts.x86_64-linux.igloo.users.tux.classes = [ "homeManager" "hjem" ];
# default for all
den.schema.user.classes = lib.mkDefault [ "homeManager" ];
```

Home Manager requires `inputs.home-manager`. Den auto-imports the HM OS module and forwards `homeManager.*` to `home-manager.users.<userName>`. Override per host: `den.hosts.<sys>.<name>.home-manager.module = inputs.foo.nixosModules.home-manager;`.

hjem requires `inputs.hjem`; nix-maid requires `inputs.nix-maid` and a NixOS host.

A user can participate in multiple environments:

```nix
den.hosts.x86_64-linux.laptop = {
  users.alice.classes = [ "homeManager" "hjem" ];
  home-manager.enable = true;
  hjem.enable         = true;
};
```

## Namespaces (`den.ful.*`)

Scoped aspect libraries, also exposed as a module argument of the same name.

```nix
{ inputs, den, ... }: {
  imports = [ (inputs.den.namespace "my" false) ];   # local-only
  imports = [ (inputs.den.namespace "eg" true)  ];   # exported as flake.denful.eg
}

# populate
{ eg.vim.homeManager.programs.vim.enable = true; }
{ eg, ... }: { eg.desktop = { includes = [ eg.vim ]; nixos.services.xserver.enable = true; }; }

# consume
{ eg, ... }: { den.aspects.laptop.includes = [ eg.desktop eg.vim ]; }

# import upstream
{ inputs, ... }: {
  imports = [ (inputs.den.namespace "shared" [ inputs.team-config ]) ];
}
```

`upstream.flake.denful.shared` is merged into `den.ful.shared`.

## Angle Brackets (Optional Sugar)

```nix
{ den, ... }: { _module.args.__findFile = den.lib.__findFile; }
{ den, __findFile, ... }: { ... }
```

Resolution: `<den.x.y>` → `config.den.x.y`; `<aspect>` → `config.den.aspects.aspect`; `<aspect/sub>` → `config.den.aspects.aspect.provides.sub` (`/` ↔ `.provides.`); `<namespace>` → `config.den.ful.namespace`.

## `den.lib` API Summary

- `parametric` family — see Parametric Dispatch above.
- `canTake` / `canTake.exactly` — args-compatibility check.
- `take.atLeast fn ctx` / `take.exactly fn ctx` — conditional application.
- `perHost` / `perUser` / `perHome aspect` — restrict to ctx shape.
- `statics aspect { class; aspect-chain; }` — extract only static includes.
- `owned aspect` — extract owned configs (no includes, no functor).
- `isFn` / `isStatic`.
- `__findFile` — angle-bracket resolver.
- `aspects.resolve class aspect`; `aspects.resolve.withAdapter adapter class aspect`.
- `aspects.adapters` — composable: `module`, `default` (= `filterIncludes module`), `filter pred adapter`, `map`, `mapAspect`, `mapIncludes`, `filterIncludes`.

## Aspect `meta.adapter`

Aspects can declare a subtree adapter that controls how includes are resolved; it composes with parents:

```nix
den.aspects.monitoring = {
  meta.adapter = inherited:
    den.lib.aspects.adapters.filter (a: a.name != "noisy-exporter") inherited;
  includes = [ den.aspects.prometheus den.aspects.noisy-exporter den.aspects.grafana ];
};

# Context-level (transitive across all aspects resolved within):
den.ctx.host.meta.adapter = inherited:
  den.lib.aspects.adapters.filter (a: a.name != "debug-tools") inherited;
```

`meta.provider` tracks structural origin: top-level `[]`; `foo._.bar` has `["foo"]`; `foo._.bar._.baz` has `["foo" "bar"]`.

## Per-System Flake Outputs (`packages`, `checks`, ...)

```nix
# only needed without flake-parts
{ inputs, ... }: { imports = [ inputs.den.flakeOutputs.packages ]; }

# allow aspects to produce packages
den.ctx.flake-system.into.host = { system }:
  map (host: { inherit host; }) (lib.attrValues den.hosts.${system});

den.ctx.flake-packages.includes = [ den.aspects.foo ];

den.aspects.foo.packages = { pkgs, ... }: { inherit (pkgs) hello; };
```

## Bootstrap Snippets

### Minimal (existing flake — drop in alongside)

```nix
# add inputs:
inputs.import-tree.url = "github:vic/import-tree";
inputs.den.url         = "github:vic/den";

# in outputs:
let
  den = (inputs.nixpkgs.lib.evalModules {
    modules = [ (inputs.import-tree ./modules) ];
    specialArgs.inputs = inputs;
  }).config;
  inherit (den.den.hosts.x86_64-linux) igloo;
in {
  nixosConfigurations.igloo = nixosSystem {
    modules = [ <existing modules> igloo.mainModule ];
  };
}
```

If using flake-parts, also add `inputs.den.flakeOutputs.flake` to the modules list. Once everything migrates, `flake.nix` collapses to:

```nix
outputs = inputs:
  (inputs.nixpkgs.lib.evalModules {
    modules = [ (inputs.import-tree ./modules) ];
    specialArgs.inputs = inputs;
  }).config.flake;
```

### Hello-Den `modules/den.nix`

```nix
{ inputs, den, lib, ... }: {
  imports = [ inputs.den.flakeModule ];

  den.default.nixos.system.stateVersion     = "25.11";
  den.default.homeManager.home.stateVersion = "25.11";
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.hosts.x86_64-linux.igloo.users.tux = {};

  den.aspects.igloo = {
    includes = [ den.provides.hostname ];
    nixos = { pkgs, ... }: { environment.systemPackages = [ pkgs.hello ]; };
  };

  den.aspects.tux = {
    includes = [
      den.provides.define-user
      den.provides.primary-user
      (den.provides.user-shell "fish")
    ];
    homeManager = { pkgs, ... }: { home.packages = [ pkgs.vim ]; };
  };
}
```

### Templates

`nix flake init -t github:vic/den#<template>` — `minimal`, `default` (recommended; flake-parts + HM + VM), `example` (namespaces + cross-platform), `noflake` (npins instead of flakes), `microvm`, `bogus` (bug repros), `ci` (Den's own tests; best feature gallery).

## Debugging

```sh
nix repl
:lf .
nixosConfigurations.igloo.config.networking.hostName
```

Expose `den` for inspection: `flake.den = den;` (remove after).

Trace/break:

```nix
({ host, ... }@ctx: builtins.trace ctx { ... })
({ host, ... }@ctx: builtins.break ctx { nixos = {}; })
```

Manually resolve:

```sh
module = den.lib.aspects.resolve "nixos" [] den.aspects.laptop
config = (lib.evalModules { modules = [ module ]; }).config

# parametric: apply context first
aspect = den.aspects.laptop { host = den.hosts.x86_64-linux.laptop; }
module = den.lib.aspects.resolve "nixos" [] aspect

# host main module
module = den.hosts.x86_64-linux.igloo.mainModule
cfg    = (lib.nixosSystem { modules = [ module ]; }).config
```

## Pitfalls

- **Anonymous functions in `includes`** lose error-trace location — use named aspects.
- **Parametric `den.default.includes`** runs at *every* context stage. Restrict with `perHost`/`perUser`/`perHome` or `take.exactly`.
- **Den contexts ≠ `_module.args`/`specialArgs`** — they're real function args, free of infinite-loop risk.
- **Aspect needing real `imports`** — use the function-args form so `imports` isn't read as a class.
- **Files prefixed `_`** are ignored by `import-tree`. Keep legacy `configuration.nix` etc. under `_nixos/`.
- **Class mismatch** — Darwin hosts have `class = "darwin"`, not `"nixos"`.
- **`forward.guard`** — `lib.optionalAttrs` for *option existence*, `lib.mkIf` for *config values*.
- **Cross-OS settings** — use the built-in `os` class instead of duplicating into both `nixos` and `darwin`.
- Includes use real aspect references (type-checked), not stringly-typed tags.

## Deep Links

- Reference index: <https://den.oeiuwq.com/overview/>
- Built-in batteries source: <https://github.com/vic/den/tree/main/modules/aspects/provides/>
- CI tests (best feature gallery): <https://github.com/vic/den/tree/main/templates/ci>
