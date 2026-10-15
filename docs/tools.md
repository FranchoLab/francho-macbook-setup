# Herramientas incluidas

Este documento describe las herramientas declaradas en `Brewfile` y los ejemplos de personalización recomendados. Comprueba `brew info <paquete>` si necesitas detalles de instalación específicos.

## Línea de comandos

| Herramienta | Qué es y para qué sirve | Ejemplo |
|---|---|---|
| `gh` | CLI oficial de GitHub para repositorios, issues y pull requests. | `gh pr list` |
| `azure-cli` (`az`) | CLI para administrar servicios y recursos de Azure. | `az account show` |
| `jq` | Consulta y transforma JSON desde la terminal. | `gh api user \| jq '.login'` |
| `yq` | Consulta y transforma YAML; la fórmula de Homebrew incluye soporte para formatos comunes. | `yq '.services' compose.yaml` |
| `ripgrep` (`rg`) | Búsqueda recursiva rápida de texto. | `rg "TODO" src` |
| `fd` | Búsqueda de archivos con sintaxis sencilla. | `fd package.json` |
| `eza` | Listado de archivos moderno con colores e información adicional. | `eza -la --git` |
| `bat` | Visor de archivos con resaltado de sintaxis y paginación. | `bat README.md` |
| `fzf` | Selector difuso interactivo para archivos, historial y más. | `fd -t f \| fzf` |
| `lazygit` | Interfaz de terminal para operaciones Git habituales. | `lazygit` |
| `git-delta` (`delta`) | Pager con resaltado de sintaxis para diffs Git. | `git diff` |
| `mise` | Gestor de versiones de runtimes y herramientas por proyecto. | `mise use node@lts` |
| `podman` | Motor de contenedores OCI sin daemon central. Se instala manualmente desde el paquete oficial recomendado; en macOS usa una máquina virtual administrada por Podman. | `podman machine start` |
| `podman compose` | Soporte Compose usado junto con Podman. En este entorno se instala siguiendo las instrucciones oficiales, fuera de Homebrew; la fórmula Homebrew `podman-compose` depende de Podman instalado por Homebrew. | `podman compose up -d` |
| `starship` | Prompt multiplataforma que muestra contexto útil del proyecto. | `starship explain` |
| `powershell` | Shell multiplataforma PowerShell. | `pwsh` |
| `zsh-autosuggestions` | Sugiere comandos a partir del historial mientras escribes. | Escribe parte de un comando usado antes. |
| `zsh-syntax-highlighting` | Resalta la sintaxis de comandos en Zsh. | Observa el color al escribir un comando. |

## Aplicaciones

| Aplicación | Uso |
|---|---|
| Visual Studio Code | Editor de código y extensiones declaradas en `vscode/extensions.txt`, incluida Container Tools con soporte para Podman. |
| Ghostty | Emulador de terminal. El archivo `ghostty/config` es una plantilla que se activa copiándola manualmente. |
| Raycast | Lanzador, búsqueda y automatización de productividad. Configúralo manualmente; no se versionan preferencias privadas. |
| Rectangle | Gestión de ventanas mediante atajos de teclado. |
| FiraCode Nerd Font Mono | Fuente monoespaciada con ligaduras y glifos adicionales para terminales y prompts. |
| Firefox y Google Chrome | Navegadores web instalados como aplicaciones de usuario. |
| Obsidian | Aplicación de notas en Markdown; el Brewfile instala la app, no los vaults ni sus datos privados. |

## Ajustes de Visual Studio Code

`vscode/settings.json` es una plantilla: el bootstrap instala extensiones, pero no modifica los ajustes activos de VS Code. Puedes incorporar sus valores manualmente desde **Preferences: Open User Settings (JSON)**, conservando una copia de tus ajustes anteriores.

- FiraCode con ligaduras, tema Vitesse Dark, terminal a 12 y consola de depuración a 10.
- Prettier se selecciona por lenguaje para JavaScript, TypeScript, JSX, TSX, JSON, JSONC y Markdown, no globalmente. Python usa cuatro espacios sin imponer un formateador.
- Prettier permite formatear manualmente sin configuración de proyecto usando sus valores predeterminados; si existe configuración, la respeta. No se imponen reglas globales de comillas, ancho ni comas finales; la regla visual a 100 columnas es solo una guía.
- ESLint y Prettier se instalan como extensiones del editor, no como paquetes npm globales. En proyectos que los utilicen, declara las herramientas como dependencias de desarrollo y versiona sus configuraciones y el lockfile para mantener editor y CI alineados.
- No se activa autofix global de ESLint. Si el proyecto lo necesita, configura `editor.codeActionsOnSave` en sus ajustes de workspace. Los ajustes por lenguaje del proyecto pueden seleccionar otro formateador, como Biome. La detección de indentación sigue habilitada por defecto.
- Se guarda automáticamente al cambiar de foco (`files.autoSave: "onFocusChange"`), sin formatear al guardar (`editor.formatOnSave: false`). Usa **Format Document** para formatear manualmente, o activa el formato al guardar en los ajustes del proyecto cuando corresponda. La limpieza de espacios y líneas finales sigue activa, con la excepción de espacios finales en Markdown.
- Markdown conserva los espacios finales, que pueden representar saltos de línea, y usa la previsualización predeterminada.
- Dev Containers utiliza `podman` y conserva desactivado el volumen de caché. Podman debe estar instalado y su máquina iniciada; cada proyecto puede necesitar ajustes de compatibilidad.
- El corrector usa inglés y español. No se incluyen vocabulario corporativo ni permisos automáticos para herramientas de IA.

## Raycast

Mantén Quicklinks y snippets deliberadamente genéricos. Sustituye dominios de ejemplo localmente y no publiques URLs internas, nombres de clientes ni datos de cuenta.

### Quicklinks recomendados

| Nombre | Destino sugerido |
|---|---|
| `github` | `https://github.com` |
| `ado` | `https://dev.azure.com` |
| `wiki` | Portal de documentación elegido por ti; evita publicar enlaces privados. |
| `docs` | Documentación oficial o un buscador de documentación. |

Usa el campo de búsqueda de Raycast para abrirlos por nombre. No se incluyen rutas específicas de organizaciones o proyectos.

### Snippets recomendados

- **Firma profesional:** nombre, rol y datos de contacto públicos que quieras compartir.
- **Plantilla de PR:** resumen, motivación, cambios, validación y checklist.
- **Plantilla de commit:** `tipo(ámbito): descripción`, por ejemplo `fix(cli): handle empty input`.

No guardes credenciales, direcciones privadas, números de teléfono personales ni datos de clientes en snippets sincronizados.

### Productividad diaria para desarrollo

- Abre aplicaciones y Quicklinks por nombre.
- Usa snippets para redactar descripciones repetitivas y revisa el contenido antes de enviarlo.
- Aprovecha el historial del portapapeles solo si la política y sensibilidad de los datos lo permiten.
- Revisa permisos de extensiones y acciones de terceros antes de habilitarlos.
