# Den — LLM Reference

Den is a Nix library/framework for aspect-oriented, context-driven configurations. It is most commonly used for NixOS, nix-darwin, and home-manager, but works with any Nix module class.

Source: https://github.com/vic/den · Docs: https://den.oeiuwq.com

---

## 1. Core Concepts

### Aspects

An **aspect** is an attrset that bundles configuration for one or more Nix *classes*. A class is the `class` attribute used by `lib.evalModules` (e.g. `nixos`, `darwin`, `homeManager`, or anything custom).

```nix
den.aspects.gaming = {
  nixos       = { programs.steam.enable = true; };
  darwin      = { homebrew.casks = [ "steam" ]; };
  homeManager = { programs.mangohud.enable = true; };
};
```

An aspect can also have:

- `includes` — a list of other aspects/modules forming a DAG.
- `provides` (alias `_`) — named sub-aspects scoped to this aspect.
- `meta` — freeform metadata (`name`, `loc`, `file`, `self`, `adapter`, `provider`).

### Contexts

A **context** is data that flows through the evaluation pipeline. Built-in contexts:

| Context | Data shape | Produced for |
|---|---|---|
| `den.ctx.host` | `{ host }` | each `den.hosts.<sys>.<name>` |
| `den.ctx.user` | `{ host, user }` | each user under a host |
| `den.ctx.home` | `{ home }` | each `den.homes.<sys>.<name>` |
| `den.ctx.hm-host` | `{ host }` | hosts with home-manager users |
| `den.ctx.hm-user` | `{ host, user }` | each HM user |
| `den.ctx.wsl-host` | `{ host }` | hosts with `wsl.enable` |
| `den.ctx.hjem-host`, `hjem-user`, `maid-host`, `maid-user` | analogous |

Contexts can transform into other contexts via `into.*`, and contribute aspects via `_.*` (provides).

### Parametric dispatch

Aspect functions match contexts by **argument introspection** (`builtins.functionArgs`). A function is invoked only if its required parameters are a subset (`atLeast`) of the current context.

```nix
den.aspects.foo.includes = [
  { nixos.x = 1; }                        # static, always included
  ({ host, ... }: { nixos.y = 2; })       # only when ctx has `host`
  ({ host, user }: { nixos.z = 3; })      # only when ctx has both
  ({ home }: { homeManager.w = 4; })      # only in standalone home ctx
];
```

This replaces `mkIf`/`enable` flags — the context shape *is* the condition. Functions can also be **static** (taking `{ class, aspect-chain }`), evaluated once during resolution rather than per context.

### Resolution

`den.lib.aspects.resolve "<class>" aspect` walks an aspect for a given class, collecting owned configs and recursing through includes. The result is a single deferred module passed to `lib.nixosSystem` / `darwinSystem` / `homeManagerConfiguration`.

The three-line essence:

```nix
aspect = den.ctx.host { host = den.hosts.x86_64-linux.igloo; };
nixosModule = den.lib.aspects.resolve "nixos" aspect;
nixosConfigurations.igloo = lib.nixosSystem { modules = [ nixosModule ]; };
```

Den's framework does this automatically and exposes results under `flake.nixosConfigurations` etc.

---

## 2. Project Structure

Den is typically loaded via [`import-tree`](https://github.com/vic/import-tree), which recursively imports every `.nix` file under `modules/` (skipping `_`-prefixed dirs).

### Flake (recommended)

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.import-tree.url = "github:vic/import-tree";
  inputs.den.url = "github:vic/den";

  outputs = inputs:
    (inputs.nixpkgs.lib.evalModules {
      modules = [ (inputs.import-tree ./modules) ];
      specialArgs = { inherit inputs; };
    }).config.flake;
}
```

### Without flakes (npins)

```nix
# default.nix
let
  sources = import ./npins;
  with-inputs = import sources.with-inputs sources { };
  outputs = inputs: (inputs.nixpkgs.lib.evalModules {
    modules = [ (inputs.import-tree ./modules) ];
    specialArgs.inputs = inputs;
  }).config.flake;
in with-inputs outputs
```

### Entry module

Every Den project has at least one module that imports `den.flakeModule`:

```nix
# modules/den.nix
{ inputs, ... }: {
  imports = [ inputs.den.flakeModule ];
}
```

This exposes `den` as a module argument and the `den.*` options.

---

## 3. Declaring Entities

### Hosts

```nix
den.hosts.x86_64-linux.igloo.users.tux = { };
den.hosts.aarch64-darwin.iceberg = {
  users.alice = { };
  users.bob.classes = [ "homeManager" "hjem" ];
};
```

Host options:

| Option | Default | Meaning |
|---|---|---|
| `name` | attr key | Configuration name |
| `hostName` | `name` | Network hostname |
| `system` | parent key | `x86_64-linux`, `aarch64-darwin`, ... |
| `class` | auto from system | `nixos` or `darwin` |
| `aspect` | `name` | Primary aspect name |
| `users` | `{}` | Submodule keyed by user name |
| `instantiate` | class-dependent | Builder function |
| `intoAttr` | class-dependent | Flake output path |
| `resolved` | auto | Resolved aspect from context pipeline |
| `*` | — | Freeform; readable via `host.*` in aspects |

`instantiate` defaults to `lib.nixosSystem` for nixos, `darwin.lib.darwinSystem` for darwin, `system-manager.lib.makeSystemConfig` for systemManager.

### Users (under a host)

| Option | Default | Meaning |
|---|---|---|
| `name` | attr key | User config name |
| `userName` | `name` | System account name |
| `classes` | `[ "homeManager" ]` | Home environment classes this user participates in |
| `aspect` | `name` | Primary aspect name |
| `*` | — | Freeform |

### Standalone homes

```nix
den.homes.x86_64-linux.alice = { };
# Naming "alice@igloo" auto-binds via `home-manager` CLI when whoami=alice && hostname=igloo
den.homes.x86_64-linux."alice@igloo" = { };
```

| Option | Default |
|---|---|
| `name` | attr key |
| `userName` | `name` |
| `class` | `"homeManager"` |
| `pkgs` | `inputs.nixpkgs.legacyPackages.${system}` |
| `instantiate` | `inputs.home-manager.lib.homeManagerConfiguration` |
| `intoAttr` | `[ "homeConfigurations" name ]` |

### Auto-generated aspects

For every host, user, and home, Den **automatically** creates a parametric aspect of the same name with the appropriate class slots empty. You then *extend* these aspects elsewhere — any module can contribute:

```nix
# host = igloo, user = tux on x86_64-linux
# auto-creates roughly:
#   den.aspects.igloo = parametric { nixos = {}; };
#   den.aspects.tux   = parametric { homeManager = {}; };
```

### Schema base modules

`den.schema.{conf,host,user,home}` adds shared options/defaults to all entities of each kind. Useful for typed metadata:

```nix
den.schema.host = { lib, ... }: {
  options.hardened = lib.mkEnableOption "secure profile";
  config.hardened = lib.mkDefault true;
};
den.schema.user.classes = lib.mkDefault [ "homeManager" ];
```

`den.schema.host` imports `den.schema.conf`; same for user and home.

---

## 4. Configuring Aspects

```nix
den.aspects.laptop = {
  # Owned configs — plain modules, one per class
  nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.git ];
    networking.hostName = "laptop";
  };
  darwin.nix-homebrew.enable = true;
  homeManager.programs.starship.enable = true;

  # DAG of dependencies
  includes = [
    den.provides.primary-user
    den.aspects.dev-tools
    den.aspects.gaming.provides.emulation
  ];

  # Sub-aspects (accessible via .provides.x or ._.x)
  provides.work-vpn = { host, ... }: {
    nixos.services.openvpn.servers.work.config = "...";
  };
};
```

### Three kinds of `includes` entries

1. **Plain attrset** — applied unconditionally.
2. **Static function** — `{ class, aspect-chain }: ...` — evaluated once during resolution.
3. **Parametric function** — any other shape — dispatched per context via `canTake`.

Avoid anonymous functions in `includes`; use named aspects so traces are readable.

### Custom submodules on aspects

Use the `{ config, ... }: { imports = [ ... ]; }` form to add typed options:

```nix
den.aspects.tux = { config, ... }: {
  imports = [{ options.default-key = lib.mkOption { type = lib.types.str; }; }];
  default-key = "ABC123";
};

# Then:
den.aspects.igloo.homeManager.programs.gpg.settings.default-key =
  den.aspects.tux.default-key;
```

### Aspects are fixed-point

```nix
den.aspects.igloo = { config, ... }: {
  meta.default-key = "ABC123";
  homeManager.programs.git.signing.key = config.meta.default-key;
};
```

### Global defaults

```nix
den.default = {
  nixos.system.stateVersion = "25.11";
  homeManager.home.stateVersion = "25.11";
  includes = [ den.provides.define-user den.provides.inputs' ];
};
```

`den.default` is applied to every host, user, and home. Owned configs are deduplicated across pipeline stages; parametric functions in `den.default.includes` evaluate at every stage. Use `den.lib.perHost`/`perUser`/`perHome` to scope.

---

## 5. den.lib API

```nix
den.lib.parametric           # default constructor (atLeast match)
den.lib.parametric.atLeast   # only run if ctx has at least the required args
den.lib.parametric.exactly   # only run if ctx exactly matches required args
den.lib.parametric.fixedTo   # ignore ctx, always use given attrs
den.lib.parametric.expands   # extend ctx with attrs before dispatch
den.lib.parametric.withOwn   # low-level: functor: self -> ctx -> aspect

den.lib.canTake          ctx fn  # true if fn's required args ⊆ ctx (atLeast)
den.lib.canTake.atLeast  ctx fn
den.lib.canTake.exactly  ctx fn

den.lib.take.atLeast fn ctx   # call fn ctx if compatible, else {}
den.lib.take.exactly fn ctx
den.lib.take.unused           # _: x: x  (helpers)

den.lib.perHost  aspect       # take.exactly with {host}
den.lib.perUser  aspect       # take.exactly with {host, user}
den.lib.perHome  aspect       # take.exactly with {home}

den.lib.statics  aspect ctx   # extract only static includes
den.lib.owned    aspect       # extract owned configs (no includes/__functor)
den.lib.isFn     v            # function or has __functor
den.lib.isStatic fn           # accepts {class, aspect-chain}

den.lib.__findFile            # angle bracket resolver
den.lib.aspects.resolve "class" aspect
den.lib.aspects.resolve.withAdapter adapter "class" aspect
den.lib.aspects.adapters      # { module, default, filter, map, mapAspect,
                              #   mapIncludes, filterIncludes }
```

### Adapters

Adapters control how an aspect tree is resolved. Each adapter gets `{ aspect, class, classModule, recurse, aspect-chain, resolveChild }`.

```nix
# Filter "noisy-exporter" out everywhere it appears in this subtree
den.aspects.monitoring.meta.adapter = inherited:
  den.lib.aspects.adapters.filter (a: a.name != "noisy-exporter") inherited;

# Same, applied at the context level (transitive across all hosts)
den.ctx.host.meta.adapter = inherited:
  den.lib.aspects.adapters.filter (a: a.name != "debug-tools") inherited;
```

Context adapters are outermost; aspect adapters innermost. Parents cannot be overridden by children.

### `meta.provider`

Tracks structural origin. Top-level aspects: `[]`. Aspect at `foo._.bar`: `["foo"]`. Useful in adapters to filter by origin.

---

## 6. Built-in Batteries (`den.provides` / `den._`)

| Battery | Purpose |
|---|---|
| `define-user` | Creates `users.users.<name>` (NixOS/Darwin/WSL/HM) with `isNormalUser`, home dir |
| `hostname` | Sets `networking.hostName` from `host.hostName` |
| `os-user` | The `user` class — forwards to `users.users.<userName>` (auto-enabled) |
| `primary-user` | wheel + networkmanager groups; `system.primaryUser` on Darwin; WSL `defaultUser` |
| `user-shell "fish"` | Sets login shell at OS level + `programs.fish.enable` in HM |
| `mutual-provider` | Enables `aspect.provides.<other-name>` cross-config between hosts and users |
| `tty-autologin "alice"` | `services.getty.autologinUser` |
| `wsl` | NixOS-WSL integration (auto when `host.wsl.enable`) |
| `forward { ... }` | Builds custom classes — see §7 |
| `import-tree` | Helpers using `inputs.import-tree` for legacy module trees |
| `import-tree._.host ./dir` | Per-host non-dendritic imports (auto-detects `_nixos/`, `_darwin/`, `_homeManager/`) |
| `import-tree._.user ./dir` | Per-user variant |
| `unfree [ "vscode" "steam" ]` | Whitelist unfree packages |
| `insecure [ "foo-1.2.3" ]` | Whitelist insecure packages |
| `inputs'` | Exposes flake-parts `inputs'` (system-qualified) |
| `self'` | Exposes flake-parts `self'` |
| `os-class` | A `os` class that forwards to both `nixos` and `darwin` |

Usage patterns:

```nix
# Global
den.default.includes = [ den.provides.define-user den.provides.inputs' ];

# Per aspect
den.aspects.alice.includes = [
  den.provides.primary-user
  (den.provides.user-shell "zsh")
  (den.provides.unfree [ "vscode" ])
];
```

---

## 7. Custom Classes via `forward`

`den.provides.forward` creates a new class whose contents get forwarded into a target attribute path on another class. This is how Den implements `user`, `homeManager`, `hjem`, `maid`, `wsl`.

```nix
den.provides.forward {
  each = [ item1 item2 ... ];           # things to fan out across
  fromClass  = item: "myclass";          # source class name
  intoClass  = item: "nixos";            # target class
  intoPath   = item: [ "users" "users" item.userName ];
                                          # target path (or function of args)
  fromAspect = item: den.aspects.${item.aspect};
                                          # which aspect to read from
  guard      = { config, options, ... }: item: <bool or mkIf>;  # optional
  adaptArgs  = args: { osConfig = args.config; };               # optional
  adapterModule = { ... };                                       # optional
}
```

When `fromAspect` is omitted, it defaults to `item.resolved` — the aspect produced by running the entity through its own context pipeline. This enables cross-entity forwarding (e.g., pulling SSH keys from sibling hosts).

### Worked examples

**`os` class — write once, apply to nixos and darwin** (already shipped as `den._.os-class`):

```nix
den._.forward {
  each = [ "nixos" "darwin" ];
  fromClass = _: "os";
  intoClass = lib.id;
  intoPath  = _: [ ];
  fromAspect = _: lib.head aspect-chain;
}
```

```nix
den.aspects.my-laptop.os.networking.hostName = "Yavanna";
# applied on both NixOS and macOS
```

**Role-based class — match host roles to user roles**:

```nix
roleClass = { host, user }: { class, aspect-chain }: den._.forward {
  each = lib.intersectLists (host.roles or []) (user.roles or []);
  fromClass = lib.id;
  intoClass = _: host.class;
  intoPath  = _: [ ];
  fromAspect = _: lib.head aspect-chain;
};
den.ctx.user.includes = [ roleClass ];

den.hosts.x86_64-linux.igloo = {
  roles = [ "devops" "gaming" ];
  users.alice.roles = [ "gaming" ];
};
den.aspects.alice = {
  gaming = { programs.steam.enable = true; };  # only runs when host has "gaming"
};
```

**Conditional class — only when an option exists in target**:

```nix
persys = { class, aspect-chain }: den._.forward {
  each = lib.singleton true;
  fromClass = _: "persys";
  intoClass = _: class;
  intoPath  = _: { config, ... }:
    [ "environment" "persistence" config.impermanence.dir ];
  fromAspect = _: lib.head aspect-chain;
  guard = { options, ... }: _: options ? environment.persistence;
};
```

`guard` semantics: return `true`/`false` to gate on **option presence** (use `lib.optionalAttrs`); return `lib.mkIf <bool>` to gate on **config values**.

---

## 8. Context Pipeline

```
den.hosts.<sys>.<name>
        │
        └──> den.ctx.host {host}
                │
                ├── _.host       : applies fixedTo {host} aspects.<host.aspect>
                ├── _.user       : applies atLeast {host, user} for each user
                ├── into.user    : fans out to {host, user}
                │     └── den.ctx.user {host, user}
                │           └── _.user : fixedTo {host, user} aspects.<user.aspect>
                ├── into.hm-host : if any user has "homeManager" class
                │     ├── imports home-manager OS module
                │     └── into.hm-user : forwards homeManager → home-manager.users.<n>
                ├── into.wsl-host : if host.wsl.enable
                ├── into.hjem-host : if hjem enabled
                └── into.maid-host : if nix-maid enabled
```

### Deduplication

`dedupIncludes` (in `modules/context/types.nix`):

- **First** occurrence of a context type → `parametric.fixedTo` (owned + statics + parametric).
- **Subsequent** occurrences → `parametric.atLeast` (parametric only).

This prevents `den.default` configs being applied twice.

### Defining a custom context

```nix
den.ctx.my-service = {
  description = "Custom service";
  provides.my-service = { host }: {
    nixos.services.my-service.hostName = host.hostName;
  };
};
den.ctx.host.into.my-service = { host }:
  lib.optional host.my-service.enable { inherit host; };
```

Now any host with `my-service.enable = true` gets the service config injected. The same pattern is used internally for WSL, hm-host, hjem, maid, microvm, and per-system flake outputs.

### Mutual providers

With `den.provides.mutual-provider` enabled on `den.ctx.user`, hosts can configure their users and users can configure their hosts:

```nix
den.ctx.user.includes = [ den._.mutual-provider ];

den.aspects.alice = {
  provides.igloo = { homeManager.programs.helix.enable = true; };
  provides.to-hosts = { host, ... }: {
    nixos.programs.nh.enable = host.name == "igloo";
  };
};

den.aspects.igloo = {
  provides.alice = { nixos.programs.emacs.enable = true; };
  provides.to-users = { user, ... }: {
    homeManager.programs.helix.enable = user.name == "alice";
  };
};
```

Names matching another entity in the same context act as targeted; `to-hosts`/`to-users` apply to all peers.

---

## 9. Home Environments

Den supports several home managers concurrently. All are opt-in.

```nix
# Per user
den.hosts.x86_64-linux.laptop.users.alice.classes = [ "homeManager" "hjem" ];

# Default for all users
den.schema.user.classes = lib.mkDefault [ "homeManager" ];
```

| Class | Required input | Forwards to |
|---|---|---|
| `homeManager` | `inputs.home-manager` | `home-manager.users.<userName>` |
| `hjem` | `inputs.hjem` | `hjem.users.<userName>` |
| `maid` | `inputs.nix-maid` (NixOS only) | `users.users.<userName>.maid` |
| `user` | — (built-in) | `users.users.<userName>` (lightweight OS-level) |

Override the HM module per host:

```nix
den.hosts.x86_64-linux.laptop.home-manager.module =
  inputs.home-manager-unstable.nixosModules.home-manager;
```

Standalone homes (no host) bypass the host pipeline:

```nix
den.homes.x86_64-linux.alice = { };
# → flake.homeConfigurations.alice
```

Host-bound standalone (host need not be a Den-managed NixOS):

```nix
den.homes.x86_64-linux."alice@igloo" = { };
# Aspect alice can use provides.igloo for host-specific config
```

---

## 10. Namespaces

Namespaces let aspects be shared across flakes/non-flakes.

```nix
# Local namespace (not exported)
imports = [ (inputs.den.namespace "my" false) ];

# Local + exported as flake.denful.eg
imports = [ (inputs.den.namespace "eg" true) ];

# Imported and merged from upstream sources
imports = [ (inputs.den.namespace "shared" [ inputs.team-config ]) ];
```

This creates `den.ful.<name>`, a module argument alias of the same name, and (if exported) `flake.denful.<name>`.

```nix
# Namespace contents — any module can contribute
{ eg, ... }: {
  eg.vim.homeManager.programs.vim.enable = true;
  eg.desktop = {
    includes = [ eg.vim ];
    nixos.services.xserver.enable = true;
  };
}

# Consumed elsewhere
den.aspects.laptop.includes = [ eg.desktop ];
```

---

## 11. Angle Brackets

Optional sugar via `den.lib.__findFile`:

```nix
{ den, ... }: {
  _module.args.__findFile = den.lib.__findFile;
}
```

Then `<...>` in any module that has `__findFile` in scope:

| Expression | Resolves to |
|---|---|
| `<den.x.y>` | `config.den.x.y` |
| `<aspect>` | `config.den.aspects.aspect` |
| `<aspect/sub>` | `config.den.aspects.aspect.provides.sub` |
| `<namespace>` | `config.den.ful.namespace` |
| `<namespace/path>` | `den.ful.namespace.path.provides.…` |

Identical in semantics to attribute access.

---

## 12. Output Generation

For each host:
```nix
host.instantiate {
  modules = [ host.mainModule { nixpkgs.hostPlatform = lib.mkDefault host.system; } ];
}
# → flake.<host.intoAttr>  (default: nixosConfigurations.<name>)
```

For each home:
```nix
home.instantiate { pkgs = home.pkgs; modules = [ home.mainModule ]; }
# → flake.<home.intoAttr>  (default: homeConfigurations.<name>)
```

Override either to use custom builders or skip generation (`intoAttr = []`).

When `inputs.flake-parts` is absent, Den defines its own `options.flake` so the same code works with or without flake-parts.

### Aspects can also produce per-system flake outputs

```nix
imports = [ inputs.den.flakeOutputs.packages ];

# Allow any host/user aspect to contribute packages
den.ctx.flake-system.into.host = { system }:
  map (h: { host = h; }) (lib.attrValues den.hosts.${system});

den.aspects.foo.packages = { pkgs, ... }: { inherit (pkgs) hello; };
```

Same pattern works for `checks`, `devShells`, `legacyPackages`.

---

## 13. Debugging

```bash
nix repl
:lf .
nixosConfigurations.igloo.config.networking.hostName
```

Temporarily expose Den itself for inspection:
```nix
flake.den = den;     # remove after debugging
```

```nix
# Resolve manually
module = den.lib.aspects.resolve "nixos" den.aspects.laptop
config = (lib.evalModules { modules = [ module ]; }).config

# Trace included aspects
den.lib.aspects.resolve.withAdapter den.lib.aspects.adapters.trace "nixos" aspect

# Trace context inline
({ host, ... }@ctx: builtins.trace ctx { nixos = { }; })

# Break into REPL
({ host, ... }@ctx: builtins.break ctx { nixos = { }; })
```

Common gotchas:

- Duplicate values in lists → parametric in `den.default.includes` runs at every stage; use `den.lib.perHost`/`perUser`/`perHome` to scope.
- "Missing attribute" → context lacks expected param; trace `ctx` keys.
- Wrong class → Darwin hosts have `class = "darwin"`, not `"nixos"`.

---

## 14. Templates

| Template | Use case | Flakes | flake-parts | HM |
|---|---|:-:|:-:|:-:|
| `minimal` | Smallest setup, one host one user | ✓ | ✗ | ✗ |
| `default` | Recommended starting point | ✓ | ✓ | ✓ |
| `example` | Showcases namespaces, brackets, mutual providers, NixOS+Darwin+standalone HM | ✓ | ✓ | ✓ |
| `noflake` | npins, stable Nix, nix-maid instead of HM | ✗ | ✗ | ✗ |
| `nvf-standalone` | Den outside NixOS — standalone Neovim app | ✓ | ✗ | ✗ |
| `microvm` | Custom contexts + schemas for MicroVM hosts/guests | ✓ | ✗ | ✗ |
| `flake-parts-modules` | Forward custom classes into 3rd-party perSystem modules | ✓ | ✓ | ✗ |
| `bogus` | Bug reproduction with `denTest` + nix-unit | ✓ | ✓ | ✓ |
| `ci` | Den's own ~180-test suite — best learning resource | ✓ | ✓ | ✓ |

Init: `nix flake init -t github:vic/den#<template>`

### Canonical worked example (default template)

```nix
# modules/hosts.nix
{ den.hosts.x86_64-linux.igloo.users.tux = { }; }

# modules/igloo.nix
{
  den.aspects.igloo = {
    nixos = { pkgs, ... }: { environment.systemPackages = [ pkgs.hello ]; };
    homeManager = { pkgs, ... }: { home.packages = [ pkgs.vim ]; };
  };
}

# modules/tux.nix
{ den, ... }: {
  den.aspects.tux = {
    includes = [ den.provides.primary-user (den.provides.user-shell "fish") ];
    homeManager = { pkgs, ... }: { home.packages = [ pkgs.htop ]; };
  };
}

# modules/defaults.nix
{
  den.default.nixos.system.stateVersion = "25.11";
  den.default.homeManager.home.stateVersion = "25.11";
}

# modules/den.nix
{ inputs, ... }: { imports = [ inputs.den.flakeModule ]; }
```

Build: `nix build .#nixosConfigurations.igloo.config.system.build.toplevel`
VM:    `nix run .#vm`  (when `vm.nix` is included)

---

## 15. Migrating to Den

1. Add `inputs.den` and import `den.flakeModule` from one module.
2. Move host declarations into `den.hosts`.
3. Pull existing modules in via `den.provides.import-tree._.host ./hosts` and `_.user ./users`. Files under `_nixos/`, `_darwin/`, `_homeManager/` auto-detect class.
4. Gradually extract features into named aspects.
5. Remove legacy directories as aspects replace them.

You can mix Den-produced `mainModule`s into existing `lib.nixosSystem` calls during migration:

```nix
nixosConfigurations.igloo = lib.nixosSystem {
  modules = [
    ./legacy-config.nix
    den.hosts.x86_64-linux.igloo.mainModule
  ];
};
```

---

## 16. Testing with `denTest`

```nix
{ denTest, ... }: {
  flake.tests.my-feature = {
    test-name = denTest ({ den, lib, igloo, tuxHm, ... }: {
      den.hosts.x86_64-linux.igloo.users.tux = { };
      den.aspects.igloo.nixos.environment.sessionVariables.FOO = [ "foo" "bar" ];

      expr = igloo.environment.sessionVariables.FOO;
      expected = "foo:bar";
    });
  };
}
```

Helpers in scope: `igloo`, `iceberg`, `tuxHm`, `pinguHm`, `funnyNames`, `trace`. Run via `nix flake check` or `just ci` / `just ci-deep`.

---

## 17. Quick reference

```nix
# Library entry points
den.lib.parametric{,.atLeast,.exactly,.fixedTo,.expands,.withOwn}
den.lib.canTake{,.atLeast,.exactly}
den.lib.take{.atLeast,.exactly,.unused}
den.lib.{perHost,perUser,perHome}
den.lib.{statics,owned,isFn,isStatic,__findFile}
den.lib.aspects.{resolve,resolve.withAdapter,adapters}

# Schema & data
den.hosts.<system>.<name>.{class,system,hostName,users,aspect,instantiate,intoAttr,resolved,*}
den.hosts.…users.<name>.{userName,classes,aspect,*}
den.homes.<system>.<name>.{userName,class,pkgs,instantiate,intoAttr,resolved,*}
den.schema.{conf,host,user,home}

# Aspects & contexts
den.aspects.<name>.{<class>,includes,provides,_,meta}
den.ctx.<name>.{description,provides,_,into,includes,meta.adapter}
den.default

# Batteries
den.provides.{define-user,hostname,os-user,primary-user,user-shell,
              mutual-provider,tty-autologin,wsl,forward,import-tree,
              unfree,insecure,inputs',self',os-class}

# Namespaces
inputs.den.namespace "<name>" (true|false|[sources])
den.ful.<name>
flake.denful.<name>
```
