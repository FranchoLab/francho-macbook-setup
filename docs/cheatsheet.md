# Cheatsheet diaria

Los ejemplos suponen que estás en la raíz de un proyecto. Ajusta rutas y nombres a tu repositorio.

| Comando | Descripción | Ejemplo |
|---|---|---|
| `eza` | Lista archivos; combina con `-la` para incluir ocultos y detalles. | `eza -la --git` |
| `fd` | Busca archivos por nombre o patrón. | `fd 'test' src` |
| `rg` | Busca texto recursivamente con contexto. | `rg -n -C 2 'TODO' src` |
| `bat` | Muestra un archivo con resaltado y números de línea. | `bat -n package.json` |
| `git` | Consulta el estado y revisa los cambios. | `git status --short && git diff` |
| `lazygit` | Abre la interfaz interactiva para preparar y confirmar cambios. | `lazygit` |
| `podman` | Ejecuta un contenedor y lo elimina al terminar. | `podman run --rm hello-world` |
| `podman machine` | Administra la máquina virtual necesaria para contenedores en macOS. | `podman machine start` |
| `gh` | Lista o inspecciona pull requests del repositorio actual. | `gh pr list` |
| `az` | Consulta la suscripción actualmente seleccionada. | `az account show --output table` |
| `jq` | Selecciona un campo en JSON. | `printf '%s' '{"name":"demo"}' \| jq -r '.name'` |
| `yq` | Consulta una propiedad en YAML. | `yq '.services' compose.yaml` |
| `mise` | Declara y activa una versión de runtime para el proyecto. | `mise use node@lts` |

## Flujos habituales

```sh
# Buscar una función y ver contexto alrededor de cada coincidencia
rg -n -C 3 'functionName' src

# Encontrar archivos Markdown y elegir uno interactivamente
fd -e md | fzf

# Consultar un diff coloreado
git diff

# Inicializar una máquina Podman (solo la primera vez), iniciarla y levantar servicios
podman machine init
podman machine start
podman compose up -d

# Inspeccionar los archivos JSON de un manifiesto de GitHub CLI
gh api repos/{owner}/{repo} | jq '{name, private, default_branch}'
```

`gh` y `az` pueden requerir iniciar sesión. No pegues tokens en comandos que queden guardados en el historial del shell.

En macOS, instala Podman y su soporte `podman compose` siguiendo las instrucciones oficiales. Este repositorio no los instala mediante Homebrew.
