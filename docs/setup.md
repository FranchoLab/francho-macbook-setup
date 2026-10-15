# Instalación desde un Mac nuevo

Esta guía configura un Mac personal de desarrollo con herramientas públicas y valores portables. No configura credenciales, preferencias privadas de aplicaciones ni ajustes de una organización.

## 1. Preparar macOS

1. Completa el asistente inicial de macOS e inicia sesión con una cuenta administradora.
2. Instala las Command Line Tools de Apple:

   ```sh
   xcode-select --install
   ```

   Si macOS indica que ya están instaladas, puedes continuar.
3. Abre Terminal y verifica que Git esté disponible:

   ```sh
   git --version
   ```

## 2. Obtener el repositorio

Sustituye el nombre de usuario de GitHub por el propietario del repositorio:

```sh
git clone https://github.com/<your-github-username>/francho-macbook-setup.git
cd francho-macbook-setup
```

Lee `bootstrap.sh` antes de ejecutarlo si quieres revisar exactamente qué cambios hace.

## 3. Ejecutar el bootstrap

```sh
./bootstrap.sh
```

El script:

1. Detecta Homebrew e instala el instalador oficial si falta.
2. Instala los paquetes enumerados en `Brewfile`.
3. Crea los enlaces de Zsh, Git, el ignore global y Starship en tu directorio personal. Si encuentra archivos existentes, los conserva con un sufijo `.backup.<fecha>`.
4. Instala las extensiones listadas en `vscode/extensions.txt`.
5. Ejecuta la validación de herramientas.

El comando puede tardar y Homebrew puede solicitar confirmación o la contraseña de administrador. Si VS Code no está disponible todavía como comando `code`, sigue el paso siguiente y vuelve a ejecutar el script.

## 4. Hacer disponible el comando `code`

Abre Visual Studio Code y, en la paleta de comandos (`Cmd+Shift+P`), ejecuta **Shell Command: Install 'code' command in PATH**. Abre una terminal nueva y comprueba:

```sh
code --version
```

Después, desde el repositorio, instala las extensiones:

```sh
./scripts/install-vscode-extensions.sh
```

## 5. Activar Ghostty y la fuente

El bootstrap instala FiraCode Nerd Font Mono y Ghostty, pero no reemplaza configuraciones de aplicaciones existentes. Para usar el archivo de ejemplo:

```sh
mkdir -p "${HOME}/.config/ghostty"
cp ghostty/config "${HOME}/.config/ghostty/config"
```

Reinicia Ghostty si estaba abierto. Cambia el tema o la fuente en el archivo si prefieres otros valores.

## 6. Reiniciar el shell y validar

Abre una terminal nueva para cargar `.zshrc`, los plugins, fzf y Starship. Después:

```sh
./scripts/verify-setup.sh
```

Los comandos de Azure y GitHub están instalados, pero requieren inicio de sesión antes de usar servicios autenticados:

```sh
gh auth login
az login
```

Podman y `podman compose` se usan en este entorno, pero no se instalan mediante Homebrew: se instalan siguiendo el paquete y las [instrucciones oficiales para macOS](https://podman.io/docs/installation#macos). El Brewfile omite tanto Podman como la fórmula `podman-compose`, porque esta depende de la versión de Podman de Homebrew.

Después de instalar Podman desde el paquete oficial, en macOS ejecuta los contenedores dentro de una máquina virtual. Inicialízala una vez y arráncala:

```sh
podman machine init
podman machine start
podman run --rm hello-world
```

Para levantar servicios definidos en `compose.yaml`, usa `podman compose up -d` después de instalar Podman y su soporte Compose siguiendo las instrucciones oficiales. El bootstrap no instala esos componentes.

## Raycast

No se importan ni exportan ajustes privados. Configura manualmente Quicklinks, snippets y flujos de productividad siguiendo la sección Raycast de [tools.md](tools.md#raycast).

## Repetir o actualizar

Es seguro volver a ejecutar `./bootstrap.sh`: Homebrew conserva los paquetes presentes y los enlaces que ya apuntan al repositorio no se reemplazan. Para actualizar fórmulas y casks:

```sh
brew update
brew upgrade
brew bundle --file="$PWD/Brewfile"
```

Para volver a instalar las extensiones declaradas:

```sh
./scripts/install-vscode-extensions.sh
```

## Recuperar archivos locales

Si el bootstrap apartó una configuración anterior, localiza el archivo de respaldo:

```sh
ls -la "${HOME}"/.zshrc.backup.*
```

Antes de restaurarlo, conserva cualquier contenido nuevo que quieras mantener. El script no borra archivos de respaldo.
