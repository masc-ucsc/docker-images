````markdown
# HAgent Formal Docker Flows (FIFO + CVA6 load_store_unit)

This document describes how to:

- Build Docker images for:
  - A simple **FIFO** design
  - **CVA6** (Ariane) core
- Run the **HAgent `cli_formal`** pipeline inside Docker
- Optionally run **JasperGold** inside the container by mounting an existing host installation

All paths below are **examples**. Replace `/path/to/...` with paths on your system.

---

## 0. Host Directory Layout (Example)

On the **host**, assume a workspace layout like:

```text
/path/to/workspace
├── hagent              # HAgent repo (Python code, cli_formal, etc.)
├── hagent-private      # Private repo with Jasper helpers (JG/fpv_tcl_writer.py, summarize_formal_coverage.py, etc.)
├── fifo                # Simple FIFO design (contains src/fifo.sv, etc.)
├── docker-images
│   ├── hagent-fifo
│   │   ├── Dockerfile
│   │   └── hagent.yaml
│   └── hagent-cva6
│       ├── Dockerfile
│       ├── hagent.yaml
│       └── cva6.patch
└── out                 # (optional) local output directory
````

Set a helper variable on the host:

```bash
export HAGENT_WS=/path/to/workspace
cd "$HAGENT_WS"
```

---

## 1. Build Docker Images

### 1.1 FIFO image

```bash
cd "$HAGENT_WS"

docker build \
  -f docker-images/hagent-fifo/Dockerfile \
  -t hagent-fifo-formal:local .
```

This image:

* Uses `mascucsc/hagent-builder:2025.10` as base
* Copies `fifo/` into `/code/workspace/repo` inside the container
* Copies `docker-images/hagent-fifo/hagent.yaml` into `/code/workspace/repo/hagent.yaml`

---

### 1.2 CVA6 image

```bash
cd "$HAGENT_WS"

docker build \
  -f docker-images/hagent-cva6/Dockerfile \
  -t hagent-cva6-formal:local .
```

This image:

* Uses `mascucsc/hagent-builder:2025.10` as base
* Clones the CVA6 repo into `/code/workspace/repo`
* Checks out a commit as of a specific date
* Applies `docker-images/hagent-cva6/cva6.patch`
* Touches `core/include/_config_pkg.sv`
* Copies `docker-images/hagent-cva6/hagent.yaml` into `/code/workspace/repo/hagent.yaml`

---

## 2. FIFO Flow in Docker (Sync_FIFO)

### 2.1 Run FIFO container (spec/properties only, no Jasper)

On the **host**:

```bash
cd "$HAGENT_WS"

docker run --rm -it \
  -v "$HAGENT_WS/hagent:/code/hagent" \
  -v "$HAGENT_WS/hagent-private:/code/hagent-private" \
  hagent-fifo-formal:local \
  bash
```

You will land in the container shell (e.g., `root@<id>:/code/workspace`).

---

### 2.2 Inside FIFO container: environment + PYTHONPATH

Inside the container:

```bash
# HAgent "design repo" (FIFO RTL copied by Dockerfile)
export HAGENT_REPO_DIR=/code/workspace/repo

# Build & cache directories for HAgent
export HAGENT_BUILD_DIR=/code/workspace/build
export HAGENT_CACHE_DIR=/code/workspace/cache

# Make hagent-private visible to Python
export PYTHONPATH=/code/hagent-private:/code
export OPENAI_API_KEY=<your apik key>
# Ensure build/cache directories exist
mkdir -p "$HAGENT_BUILD_DIR" "$HAGENT_CACHE_DIR"
```

---

### 2.3 Inside FIFO container: run cli_formal for Sync_FIFO

```bash
cd /code/hagent

uv run python3 -m hagent.tool.cli_formal \
  --slang /usr/local/bin/slang \
  --rtl   "${HAGENT_REPO_DIR}/src" \
  --top   Sync_FIFO \
  --out   "${HAGENT_BUILD_DIR}"
```

Inspect outputs:

```bash
ls -R /code/workspace/build
ls /code/workspace/build/fpv_Sync_FIFO
```

You should see things like `FPV.tcl`, `sva/`, `jgproject/` (after you enable Jasper), and coverage reports.

---

## 3. Using JasperGold from Host Inside Docker (FIFO)

The Docker image does **not** need to install Jasper. Instead, we:

1. Mount the host Jasper installation directory
2. Forward appropriate license environment variables (for example `LM_LICENSE_FILE` or `CDS_LIC_FILE`)
3. Pass the full path to `--jasper-bin` when calling `cli_formal`

### 3.1 Example: host Jasper installation

On the **host**, suppose you have:

```text
/path/to/jasper       # root directory of Jasper install
  ├── bin/jg         # JasperGold executable
  └── ...
```

Export license env (if not already done):

```bash
export LM_LICENSE_FILE=<your_license_string_or_server>
# or, if your setup uses CDS_LIC_FILE:
# export CDS_LIC_FILE=<your_license_string_or_server>
```

### 3.2 Run FIFO container with Jasper mounted

```bash
cd "$HAGENT_WS"

docker run --rm -it \
  -v "$HAGENT_WS/hagent:/code/hagent" \
  -v "$HAGENT_WS/hagent-private:/code/hagent-private" \
  -v /path/to/jasper:/opt/jasper:ro \
  -e LM_LICENSE_FILE="$LM_LICENSE_FILE" \
  --net=host \
  hagent-fifo-formal:local \
  bash
```

> Replace `/path/to/jasper` with your actual Jasper installation root.
> If you use `CDS_LIC_FILE`, also add `-e CDS_LIC_FILE="$CDS_LIC_FILE"`.

### 3.3 Inside FIFO container: run cli_formal with Jasper

```bash
# Environment (same as before)
export HAGENT_REPO_DIR=/code/workspace/repo
export HAGENT_BUILD_DIR=/code/workspace/build
export HAGENT_CACHE_DIR=/code/workspace/cache
export PYTHONPATH=/code/hagent-private:/code

# Jasper executable (mounted at /opt/jasper)
export JASPER_BIN=/opt/jasper/bin/jg

mkdir -p "$HAGENT_BUILD_DIR" "$HAGENT_CACHE_DIR"

# Optional sanity check:
$JASPER_BIN -help 2>/dev/null || echo "Jasper not runnable"

cd /code/hagent

uv run python3 -m hagent.tool.cli_formal \
  --slang /usr/local/bin/slang \
  --rtl   "${HAGENT_REPO_DIR}/src" \
  --top   Sync_FIFO \
  --out   "${HAGENT_BUILD_DIR}" \
  --run-jg \
  --jasper-bin "${JASPER_BIN}"
```

Then inspect summary & coverage:

```bash
ls /code/workspace/build/fpv_Sync_FIFO

cat /code/workspace/build/fpv_Sync_FIFO/results_summary.csv
cat /code/workspace/build/fpv_Sync_FIFO/formal_coverage_summary.txt
```

---

## 4. CVA6 Flow in Docker (load_store_unit)

> **Note:** The commands below show the correct wiring for CVA6 + `cli_formal`.
> You may still need to refine the slang filelist/config to avoid package errors (e.g., `riscv::SSTATUS_*`, `config_pkg::cva6_cfg_t`).

### 4.1 Run CVA6 container with HAgent + Jasper mounted

On the **host**:

```bash
cd "$HAGENT_WS"

docker run --rm -it \
  -v "$HAGENT_WS/hagent:/code/hagent" \
  -v "$HAGENT_WS/hagent-private:/code/hagent-private" \
  -v /path/to/jasper:/opt/jasper:ro \
  -e LM_LICENSE_FILE="$LM_LICENSE_FILE" \
  --net=host \
  hagent-cva6-formal:local \
  bash
```

Again, replace `/path/to/jasper` and `LM_LICENSE_FILE` with your actual paths and license info.

---

### 4.2 Inside CVA6 container: environment + PYTHONPATH

```bash
# CVA6 repo cloned by Dockerfile
export HAGENT_REPO_DIR=/code/workspace/repo

# HAgent build & cache dirs
export HAGENT_BUILD_DIR=/code/workspace/build
export HAGENT_CACHE_DIR=/code/workspace/cache

# Slang + Jasper inside container
export SLANG_BIN=/usr/local/bin/slang
export JASPER_BIN=/opt/jasper/bin/jg

# Make hagent-private visible to Python
export PYTHONPATH=/code/hagent-private:/code

mkdir -p "$HAGENT_BUILD_DIR" "$HAGENT_CACHE_DIR"

# Optional sanity
ls "$HAGENT_REPO_DIR/core"
ls "$HAGENT_REPO_DIR/core/include"
$SLANG_BIN --version || echo "slang not found"
$JASPER_BIN -help 2>/dev/null || echo "Jasper not runnable"
```

---

### 4.3 Inside CVA6 container: run cli_formal for load_store_unit

```bash
cd /code/hagent

uv run python3 -m hagent.tool.cli_formal \
  --slang "${SLANG_BIN}" \
  --rtl   "${HAGENT_REPO_DIR}/core" \
  --top   load_store_unit \
  --out   "${HAGENT_BUILD_DIR}" \
  -I      "${HAGENT_REPO_DIR}/core/include" \
  --run-jg \
  --jasper-bin "${JASPER_BIN}"
```

* If slang is happy with your filelist/config, the pipeline will produce:

  * Spec (`*_spec.md`, `*_spec.csv`)
  * Properties (`properties.sv`)
  * SVA + `FPV.tcl`
  * Jasper log (`jg.log`) and coverage report (`formal_coverage.html`)
  * Text and CSV summaries parsed by your helper scripts in `hagent-private/JG`.

* If you see errors like `unknown class or package 'riscv'` or `config_pkg`, you’ll need to:

  * Include the appropriate `*_config_pkg.sv` and `riscv_pkg.sv` in the slang invocation (via flist or CLI), or
  * Adjust your spec-builder’s file-collection logic to use `Flist.cva6` as source.

---

## 5. Quick Cheat Sheet

### FIFO (Sync_FIFO) – in container (no Jasper)

```bash
docker run --rm -it \
  -v "$HAGENT_WS/hagent:/code/hagent" \
  -v "$HAGENT_WS/hagent-private:/code/hagent-private" \
  hagent-fifo-formal:local \
  bash

# Inside container:
export HAGENT_REPO_DIR=/code/workspace/repo
export HAGENT_BUILD_DIR=/code/workspace/build
export HAGENT_CACHE_DIR=/code/workspace/cache
export PYTHONPATH=/code/hagent-private:/code
mkdir -p "$HAGENT_BUILD_DIR" "$HAGENT_CACHE_DIR"

cd /code/hagent
uv run python3 -m hagent.tool.cli_formal \
  --slang /usr/local/bin/slang \
  --rtl   "${HAGENT_REPO_DIR}/src" \
  --top   Sync_FIFO \
  --out   "${HAGENT_BUILD_DIR}"
```

### FIFO (Sync_FIFO) – with Jasper

```bash
docker run --rm -it \
  -v "$HAGENT_WS/hagent:/code/hagent" \
  -v "$HAGENT_WS/hagent-private:/code/hagent-private" \
  -v /path/to/jasper:/opt/jasper:ro \
  -e LM_LICENSE_FILE="$LM_LICENSE_FILE" \
  --net=host \
  hagent-fifo-formal:local \
  bash

# Inside:
export HAGENT_REPO_DIR=/code/workspace/repo
export HAGENT_BUILD_DIR=/code/workspace/build
export HAGENT_CACHE_DIR=/code/workspace/cache
export PYTHONPATH=/code/hagent-private:/code
export JASPER_BIN=/opt/jasper/bin/jg
mkdir -p "$HAGENT_BUILD_DIR" "$HAGENT_CACHE_DIR"

cd /code/hagent
uv run python3 -m hagent.tool.cli_formal \
  --slang /usr/local/bin/slang \
  --rtl   "${HAGENT_REPO_DIR}/src" \
  --top   Sync_FIFO \
  --out   "${HAGENT_BUILD_DIR}" \
  --run-jg \
  --jasper-bin "${JASPER_BIN}"
```

### CVA6 (load_store_unit) – baseline

```bash
docker run --rm -it \
  -v "$HAGENT_WS/hagent:/code/hagent" \
  -v "$HAGENT_WS/hagent-private:/code/hagent-private" \
  -v /path/to/jasper:/opt/jasper:ro \
  -e LM_LICENSE_FILE="$LM_LICENSE_FILE" \
  --net=host \
  hagent-cva6-formal:local \
  bash

# Inside:
export HAGENT_REPO_DIR=/code/workspace/repo
export HAGENT_BUILD_DIR=/code/workspace/build
export HAGENT_CACHE_DIR=/code/workspace/cache
export SLANG_BIN=/usr/local/bin/slang
export JASPER_BIN=/opt/jasper/bin/jg
export PYTHONPATH=/code/hagent-private:/code
mkdir -p "$HAGENT_BUILD_DIR" "$HAGENT_CACHE_DIR"

cd /code/hagent
uv run python3 -m hagent.tool.cli_formal \
  --slang "${SLANG_BIN}" \
  --rtl   "${HAGENT_REPO_DIR}/core" \
  --top   load_store_unit \
  --out   "${HAGENT_BUILD_DIR}" \
  -I      "${HAGENT_REPO_DIR}/core/include" \
  --run-jg \
  --jasper-bin "${JASPER_BIN}"
```

```
::contentReference[oaicite:0]{index=0}
```

