# Den: Aspect-Oriented Nix Framework

Den is a library + framework for composing Nix configurations across NixOS, nix-Darwin, and home-manager via aspect-oriented programming. It inverts the traditional host-first model: **aspects** (features) are the primary unit, configured once across all platforms.

Repo: `github:denful/den` · Built on `nix-effects` (algebraic effects pipeline).

---

## Core Concepts (Four Concerns)

| Concept | Role | Lives in |
|---|---|---|
| **Entity** | Typed data record (host/user/home) | `den.hosts`, `den.homes`, `den.schema` |
| **Aspect** | Composable config spanning Nix classes | `den.aspects` |
| **Policy** | How entities relate; routes data | `den.policies` |
| **Quirk** | Structured data emitted by aspects, aggregated via pipes | `den.quirks` |

**Key distinction:**
- **Class** (`nixos`, `darwin`, `homeManager`, `hjem`, `maid`, `user`): Nix module evaluation domain.
- **Entity kind** (`host`, `user`, `home`): Den data type driving policy dispatch.

**Den context ≠ NixOS module args.** Context (`{ host }`, `{ host, user }`, `{ home }`) flows as real function arguments *before* module evaluation — cannot cause infinite recursion. Distinct from `{ config, pkgs, lib, ... }` module args.

---

## Quick Example

```nix
# One aspect, all platforms
den.aspects.bluetooth = {
  nixos.hardware.bluetooth.enable = true;
  homeManager.services.blueman-applet.enable = true;
  darwin.homebrew.casks = [ "blueutil" ];
};

den.hosts.x86_64-linux.laptop.users.alice = {};
den.aspects.laptop.includes = [ den.aspects.bluetooth ];
```

---

## Entities & Schema

### `den.hosts`
Keyed by `<system>.<name>`. Produces `nixosConfigurations` / `darwinConfigurations`.

```nix
den.hosts.x86_64-linux.igloo = {
  users.alice = {};
  users.bob.classes = [ "homeManager" "hjem" ];
  gpu = "nvidia";  # freeform attribute
};
```

**Host options:**
| Option | Default | Description |
|---|---|---|
| `name` | attr key | Configuration name |
| `hostName` | `name` | Network hostname |
| `system` | parent key | `x86_64-linux`, `aarch64-darwin`, etc. |
| `class` | auto | `"nixos"` or `"darwin"` from system |
| `aspect` | `name` | Primary aspect name |
| `users` | `{}` | User definitions |
| `policies` | `[]` | Additional policies activated for this host |
| `instantiate` | auto | `lib.nixosSystem`, etc. |
| `intoAttr` | auto | Flake output path |
| `*` | freeform | Any attribute |

**User options** (declared inside host):
| Option | Default | Description |
|---|---|---|
| `userName` | `name` | System account name |
| `classes` | `[ "user" ]` | Home environment classes |
| `aspect` | `name` | Primary aspect name |

### `den.homes`
Standalone home-manager configs. Format `"user@host"` binds home to a hostname.

```nix
den.homes.x86_64-linux.alice = {};
den.homes.x86_64-linux."tux@igloo" = {};  # bound to hostname
```

### `den.schema`
Shared options across entity kinds. Adding a key registers a new entity kind.

```nix
den.schema.host.home-manager.enable = true;
den.schema.user = { user, lib, ... }: {
  options.groupName = lib.mkOption { default = user.userName; };
};
den.schema.conf = { ... };  # applied to host, user, AND home
```

**`strict` mode:** Set `den.schema.host.strict = true` to require all attributes be declared options (no freeform).

**Activation via includes:**
```nix
den.schema.host.includes = [ den.aspects.foo den.policies.bar ];
den.schema.user.includes = [ den._.mutual-provider ];
den.default.includes = [ ... ];  # applies to all entities
```

---

## Aspects

An aspect bundles per-class modules + `includes` + `provides`.

```nix
den.aspects.workstation = {
  # Owned configs per class
  nixos = { pkgs, ... }: { environment.systemPackages = [ pkgs.git ]; };
  darwin.nix-homebrew.enable = true;
  homeManager.programs.starship.enable = true;

  # Dependencies (DAG)
  includes = [
    den.aspects.dev-tools
    den.aspects.gaming.provides.emulation
    den.provides.primary-user
  ];

  # Sub-aspects
  provides.editors = {
    homeManager.programs.helix.enable = true;
  };
};
```

### Parametric Aspects
Functions whose arg shape determines when they apply. **No wrapper needed** — bare functions work directly.

```nix
# Activates only in {host} contexts
den.aspects.networking = { host, ... }: {
  nixos.networking.hostName = host.name;
};

# Activates only when both {host, user} present — silently skipped otherwise
den.aspects.user-groups = { host, user, ... }: {
  nixos.users.users.${user.userName}.extraGroups = [ "wheel" ];
};

# Static (always applies)
den.aspects.firewall = {
  nixos.networking.firewall.enable = true;
};
```

**Rule:** Argument shape IS the condition. No `mkIf`, no `enable` flags.

### Flat-Form Class Modules
Mix Den context args with NixOS module args in one function. Must include `...`:

```nix
den.aspects.my-aspect = {
  # host pre-applied by pipeline; rest flows to NixOS module system
  nixos = { host, config, pkgs, ... }: {
    networking.hostName = host.name;
  };
};
```

If all args are context args, function is called directly (no `...` needed):
```nix
nixos = { host }: { config, ... }: { networking.hostName = host.name; };
```

**Collision policy** (when Den arg name conflicts with module-system arg):
```nix
den.config.classModuleCollisionPolicy = "error";  # default
# Other values: "den-wins", "class-wins"
# Set per-aspect: meta.collisionPolicy
# Set per-entity: den.schema.host.collisionPolicy
```

### Aspect Auto-Generation
Den auto-creates aspects for each declared host/user/home:
```nix
den.hosts.x86_64-linux.igloo.users.tux = {};
# → den.aspects.igloo (with nixos class) auto-created
# → den.aspects.tux (with homeManager class) auto-created
```

### Cross-Entity Provides
```nix
den.aspects.igloo = {
  provides.to-users = { user, ... }: { ... };  # to ALL users
  provides.alice.homeManager = { ... };         # to specific user
};
den.aspects.tux = {
  provides.to-hosts = { host, ... }: { ... };  # to ALL hosts
  provides.igloo.nixos = { ... };               # to specific host
};
```

### Aspect Meta
```nix
aspect.meta.loc      # ["den" "aspects" "igloo"]
aspect.meta.name     # "den.aspects.igloo"
aspect.meta.file     # last definition file
aspect.meta.self     # reference to config
aspect.meta.collisionPolicy  # collision strategy
```

### `den.default`
Special aspect applied to every entity:
```nix
den.default = {
  nixos.system.stateVersion = "25.11";
  homeManager.home.stateVersion = "25.11";
  includes = [ den.provides.define-user den.provides.inputs' ];
};
```

---

## Policies

Policies define entity topology and route data. They are **registered** in `den.policies` but only **activate** when included.

### Policy Effects (via `den.lib.policy`)
| Effect | Purpose |
|---|---|
| `policy.resolve bindings` | Enrich current scope (non-entity keys) |
| `policy.resolve.to kind bindings` | Create child scope for entity kind |
| `policy.resolve.withIncludes includes bindings` | Attach includes to new scope |
| `policy.include aspect` | Inject aspect (walks tree) |
| `policy.exclude aspect` | Remove via constraint registry |
| `policy.route spec` | Route class content between scopes |
| `policy.provide spec` | Deliver module directly to class (bypass tree) |
| `policy.instantiate entity` | Request post-pipeline instantiation |
| `policy.pipe.from name stages` | Quirk data routing |

### Defining & Activating Policies
```nix
# Register
den.policies.host-to-users = { host, ... }:
  map (user: den.lib.policy.resolve.to "user" { inherit host user; })
    (lib.attrValues host.users);

# Activate
den.schema.host.includes = [ den.policies.host-to-users ];
```

### Conditional Wrappers
```nix
# Fire only for specific entity (matched by id_hash)
den.lib.policy.for den.hosts.x86_64-linux.igloo den.policies.igloo-only

# Fire only when predicate true
den.lib.policy.when ({ host, ... }: host.wsl.enable) den.policies.wsl-setup

# Inline policy
den.lib.policy.mkPolicy "my-name" ({ host, ... }: [ ... ])
```

### Excludes (Authoritative)
```nix
den.aspects.igloo.excludes = [ den.policies.blocked ];
# Parent excludes CANNOT be overridden by child includes
```

### Built-in Policies
| Policy | From → To | Purpose |
|---|---|---|
| `host-to-users` | `host` → `user` | Fan out per user |
| `to-systems` | `flake` → `flake-system` | Per-system fan out |
| `to-os-outputs` | `flake-system` → `host` | Generate host configs |
| `to-hm-outputs` | `flake-system` → `home` | Generate home configs |
| `host-to-hm-host` | `host` → `hm-host` | HM integration when enabled |
| `host-to-wsl-host` | `host` → `wsl-host` | When `wsl.enable` |

### `policy.resolve` Semantics
- **Entity keys** (matching `den.schema` kinds): create **child scope**
- **Non-entity keys**: **enrich** current scope, drain deferred includes

### `policy.include` vs `policy.provide`
| | `include` | `provide` |
|---|---|---|
| Path | Through aspect tree | Bypasses tree |
| Dedup | Include dedup | Policy/class/path dedup |
| Use | Full resolution (constraints, parametric) | Direct class delivery |

---

## Quirks & Pipes

Decouple producers from consumers via named structured data.

### Declare a Quirk
```nix
den.quirks.firewall = { description = "Firewall ports"; };
```

Quirk names must NOT collide with class names.

### Producer
```nix
den.aspects.nginx = {
  nixos.services.nginx.enable = true;
  firewall = { ports = [ 80 443 ]; };
};
```

### Consumer (no pipe needed for same-scope)
```nix
den.aspects.networking = {
  nixos = { firewall, lib, ... }: {  # 'firewall' = list of all entries
    networking.firewall.allowedTCPPorts =
      lib.concatMap (f: f.ports or []) firewall;
  };
};
```

### Pipe Stages (`den.lib.policy.pipe`)
| Stage | Purpose |
|---|---|
| `pipe.from name stages` | Create pipe effect for named quirk |
| `pipe.filter pred` | Remove non-matching entries |
| `pipe.transform fn` | Map each entry |
| `pipe.fold fn init` | Reduce to single value (returned as `[result]`) |
| `pipe.append value` | Add synthetic entry |
| `pipe.for fn` | Replace entire list (max 1 per pipe per scope) |
| `pipe.expose` | Push child data to parent scope (terminal) |
| `pipe.collect predicate` | Harvest from sibling scopes (cross-host) |
| `pipe.to [aspects]` | Deliver only to named aspects |
| `pipe.withProvenance` | Tag entries with `{ value; source; }` |

### Cross-Host with `pipe.collect`
```nix
den.policies.fleet-backends = { host, ... }:
  let inherit (den.lib.policy) pipe; in
  [ (pipe.from "http-backends" [
      (pipe.collect ({ host, ... }: true))
    ])
  ];
den.schema.host.includes = [ den.policies.fleet-backends ];
```

### Config-Dependent Thunks
Quirk values can be functions of `{ config, ... }`:
```nix
den.aspects.my-svc = {
  firewall = { config, ... }: { ports = [ config.services.foo.port ]; };
};
```
- Local: resolved lazily inside `evalModules`
- Cross-host (via `pipe.collect`): resolved eagerly against source host's config

---

## Resolution Pipeline

```
flake → flake-system → host → user (per user)
                    → home (standalone)
                    
host → hm-host → hm-user (when HM enabled)
host → wsl-host (when wsl.enable)
host → hjem-host → hjem-user
host → maid-host → maid-user
```

1. **Walk** entity tree, collecting aspects, pipe data, routes
2. **Pipe assembly** post-walk (merges exposed data, applies effects)
3. **Per-host extraction** filters state to each host's subtree
4. **Instantiation** via `lib.nixosSystem`, `darwinSystem`, `homeManagerConfiguration`

### Scopes
Each entity gets a scope. Scope ID format: `"host=igloo,user=tux"` (sorted, comma-separated).
Scope-partitioned state isolates per-entity emissions. Siblings share parent scope (enables `pipe.collect`).

### Fleet
All hosts of same system are siblings under `flake-system` scope by default.
Custom fleet grouping possible by defining a `fleet` entity kind with custom policies.

---

## Built-in Batteries (`den.provides` / `den._`)

### System
| Battery | Purpose |
|---|---|
| `den._.define-user` | Creates `users.users.<name>` + sets HM `home.username`/`homeDirectory` |
| `den._.hostname` | Sets hostname from `host.hostName` |
| `den._.os-class` | `os.*` forwards to both `nixos` and `darwin` (auto-activated) |
| `den._.os-user` | `user.*` forwards to `users.users.<name>` (auto-activated) |
| `den._.primary-user` | Adds wheel/networkmanager groups, sets primaryUser/defaultUser |
| `den._.user-shell "fish"` | Sets login shell at OS + HM levels |
| `den._.mutual-provider` | Enables host↔user `provides.<name>` cross-config |
| `den._.host-aspects` | Projects host's `homeManager` keys onto users |
| `den._.tty-autologin "alice"` | NixOS TTY1 autologin |
| `den._.wsl` | WSL support (auto when `host.wsl.enable`) |
| `den._.forward {...}` | Generic class forwarding primitive |
| `den._.import-tree ./path` | Recursive non-dendritic file imports |

### Home Environments (auto-activated)
- `den._.home-manager` — when users have `homeManager` class
- `den._.hjem` — when users have `hjem` class
- `den._.maid` — when users have `maid` class (NixOS only)

### Package
- `den._.unfree [ "vscode" "steam" ]` — allow specific unfree packages
- `den._.insecure [ "openssl-1.1.1w" ]` — allow specific insecure packages

### Flake-Parts
- `den._.inputs'` — provides `inputs'` module arg
- `den._.self'` — provides `self'` module arg

### Usage
```nix
den.default.includes = [ den.provides.define-user ];
den.aspects.alice.includes = [
  den.provides.primary-user
  (den.provides.user-shell "zsh")
  (den.provides.unfree [ "vscode" ])
];
```

---

## Custom Classes via `forward`

Create new classes that forward into target submodule paths.

```nix
den.provides.forward {
  each = lib.attrValues host.users;          # items to forward
  fromClass = user: "user";                  # source class name
  intoClass = user: host.class;              # target class
  intoPath = user: [ "users" "users" user.userName ];
  fromAspect = user: den.aspects.${user.aspect};
  guard = { options, ... }: options ? wsl;   # optional predicate
  adaptArgs = args: { osConfig = args.config; };  # optional arg transform
}
```

### Examples
```nix
# git class forwarding
gitClass = { class, aspect-chain }: den._.forward {
  each = lib.singleton true;
  fromClass = _: "git";
  intoClass = _: "homeManager";
  intoPath = _: [ "programs" "git" ];
  fromAspect = _: lib.head aspect-chain;
  guard = { config, ... }: _: lib.mkIf config.programs.git.enable;
};

# Then use:
den.aspects.tux = {
  includes = [ gitClass ];
  git.userEmail = "root@linux.com";
};
```

---

## Home Manager Integration

```nix
# Enable per user
den.hosts.x86_64-linux.laptop.users.alice.classes = [ "homeManager" "hjem" ];

# Or default for all
den.schema.user.classes = lib.mkDefault [ "homeManager" ];

# Configure
den.aspects.alice.homeManager = { pkgs, ... }: {
  home.packages = [ pkgs.htop ];
  programs.git.enable = true;
};
```

User's `homeManager` class auto-forwards to `home-manager.users.<name>`.

### Standalone homes bound to host
```nix
den.homes.x86_64-linux."tux@igloo" = {};
# Activates with: home-manager switch (auto-detects user@host)
```

---

## Namespaces (Sharing Aspects)

```nix
# Create namespace (false = local, true = exported)
imports = [ (inputs.den.namespace "my" false) ];
imports = [ (inputs.den.namespace "eg" true) ];  # exposes flake.denful.eg

# Import upstream
imports = [ (inputs.den.namespace "shared" [ inputs.team-config ]) ];

# Use
{ eg, ... }: {
  eg.vim.homeManager.programs.vim.enable = true;
  den.aspects.laptop.includes = [ eg.vim ];
}
```

---

## Angle Brackets `<aspect/path>`

Optional shorthand. Enable per file:
```nix
{ den, __findFile, ... }: {
  _module.args.__findFile = den.lib.__findFile;
  den.aspects.laptop.includes = [
    <tools/editors>          # = den.aspects.tools.provides.editors
    <alice/work-vpn>         # = den.aspects.alice.provides.work-vpn
    <den.provides.primary-user>
  ];
}
```

---

## `den.lib` Reference

| Function | Purpose |
|---|---|
| `den.lib.__findFile` | Angle bracket resolver |
| `den.lib.aspects.resolve class aspect` | Internal: resolve aspect for class |
| `den.lib.policy.{resolve,include,exclude,route,provide,instantiate}` | Policy effect constructors |
| `den.lib.policy.pipe.*` | Pipe stages (filter/transform/fold/etc.) |
| `den.lib.policy.mkPolicy name fn` | Inline named policy |
| `den.lib.policy.for entity policy` | Conditional: specific entity |
| `den.lib.policy.when pred policy` | Conditional: predicate |
| `den.lib.policyInspect.inspect { kind, context }` | Debug: which policies match |
| `den.lib.diag.*` | Diagram/visualization library |
| `den.lib.nh.denPackages args pkgs` | Generate nh wrapper packages |

### Deprecated (still works, don't use in new code)
- `den.lib.parametric` — bare attrsets/functions work directly
- `den.lib.parametric.{atLeast,exactly,fixedTo,expands}`
- `den.lib.canTake` / `den.lib.take.*`
- `den.lib.perHost` / `den.lib.perUser` / `den.lib.perHome` — bare functions instead

---

## Flake Setup Patterns

### With flake-parts
```nix
inputs.den.url = "github:denful/den";
inputs.import-tree.url = "github:denful/import-tree";

outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
  (inputs.import-tree ./modules);
```

```nix
# modules/den.nix
{ inputs, ... }: {
  imports = [ inputs.den.flakeModule ];
  den.hosts.x86_64-linux.igloo.users.tux = {};
}
```

### Without flake-parts
```nix
outputs = inputs:
  (inputs.nixpkgs.lib.evalModules {
    modules = [ (inputs.import-tree ./modules) ];
    specialArgs.inputs = inputs;
  }).config.flake;
```

### No flakes (npins)
```nix
# default.nix
let
  sources = import ./npins;
  with-inputs = import sources.with-inputs sources {};
  outputs = inputs: (inputs.nixpkgs.lib.evalModules {
    modules = [ (inputs.import-tree ./modules) ];
    specialArgs.inputs = inputs;
  }).config.flake;
in with-inputs outputs
```

---

## Output Generation

For each `den.hosts.<sys>.<name>`:
```nix
host.instantiate {
  modules = [ host.mainModule { nixpkgs.hostPlatform = lib.mkDefault host.system; } ];
}
# → flake.nixosConfigurations.<name> (or flake.darwinConfigurations.<name>)
```

For each `den.homes.<sys>.<name>`:
```nix
home.instantiate { pkgs = home.pkgs; modules = [ home.mainModule ]; }
# → flake.homeConfigurations.<name>
```

### Custom outputs (packages, checks, etc.)
```nix
imports = [ inputs.den.flakeOutputs.packages ];
den.schema.flake-packages.includes = [ den.aspects.foo ];
den.aspects.foo.packages = { pkgs, ... }: { inherit (pkgs) hello; };
```

### Override
```nix
den.hosts.x86_64-linux.myhost = {
  intoAttr = [ "nixosConfigurations" "custom-name" ];
  instantiate = inputs.nixos-unstable.lib.nixosSystem;
};
```

---

## Debugging

### REPL inspection
```bash
nix repl
:lf .
nixosConfigurations.igloo.config.networking.hostName
```

Expose `den` for debugging:
```nix
{ den, ... }: { flake.den = den; }  # remove after
```

### Trace
```nix
den.aspects.laptop.includes = [
  ({ host, ... }@ctx: builtins.trace ctx { nixos = {}; })
];
```

### Diagrams
```nix
diag = den.lib.diag;
diag.toMermaid (diag.hostContext { inherit host; })
diag.toMermaid (diag.graph.simplified (diag.hostContext { inherit host; }))
diag.toMermaid (diag.graph.classSlice "nixos" (diag.hostContext { inherit host; }))
```

### Common Issues
- **Duplicate values**: Parametric in `den.default.includes` runs every stage. Use bare functions with right args.
- **Missing attribute**: Context lacks expected param. Trace context.
- **Wrong class**: Darwin hosts have `class = "darwin"` not `"nixos"`.

---

## Migration Notes

### From `den.ctx` (deprecated)
| Old | New |
|---|---|
| `den.ctx.<name> = {...}` | `den.aspects.<name> = {...}` |
| `den.ctx.<name>.includes` | `den.schema.<kind>.includes` |
| `den.ctx.<name>.into` | `den.policies.<name>` |
| `den.ctx.<name>.provides` | `den.policies` with `policy.include` |
| `meta.adapter` | Removed (handled by pipeline) |

A compat shim forwards `den.ctx` with deprecation warnings (will be removed post-1.0).

---

## Algebraic Effects (Internal)

Den's pipeline is built on `nix-effects`. Aspects compile to effectful computations:
- `fx.send "name" param` — request from outside world
- Handlers respond with values
- `fx.bind.fn {} myFunc` — auto-converts `{ pkgs, hostName }: ...` into effect-using computation
- Same computation, different handlers = testing/mocking

Users don't interact with this directly — Den's declarative syntax abstracts it.
