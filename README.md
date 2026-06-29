# ⚗️ AromaLab — Casca PWA (GitHub Pages)

Esta pasta é uma **casca PWA**: uma página estática que embrulha o AromaLab (que continua
no Google Apps Script) dentro de um `<iframe>` em tela cheia. Hospedada no GitHub Pages,
ela permite **instalar o AromaLab como app** no celular — janela própria, **sem barra de URL**
e com ícone limpo (sem o selo do Chrome).

> Importante: a casca **não substitui** o app. O AromaLab continua publicado no Apps Script,
> exatamente como está. A casca só o exibe de forma elegante.

## 📁 Arquivos

| Arquivo | Função |
|---|---|
| `index.html` | A casca: iframe em tela cheia + tela de abertura. **É aqui que você cola a URL do app.** |
| `manifest.webmanifest` | Define nome, ícones e modo standalone (necessário para instalar) |
| `sw.js` | Service worker (necessário para instalar; faz cache só da casca) |
| `icon.svg` / `icon-192.png` / `icon-512.png` | Ícones do app (frasco AromaLab) |
| `gen-icons.ps1` | Script que gerou os PNGs (rode de novo se quiser mudar o ícone) |

## 🔧 Passo 1 — Configurar a URL do app

1. No Apps Script: **Implantar → Gerenciar implantações** → copie a URL terminada em **`/exec`**.
2. Abra `index.html`, localize a linha:
   ```js
   var APP_URL = 'COLE_AQUI_A_URL_EXEC_DO_SEU_APPS_SCRIPT';
   ```
   e troque pelo seu link `/exec`.

> ⚠️ O `Codigo.gs` do AromaLab **já** tem `setXFrameOptionsMode(ALLOWALL)` no `doGet` —
> é isso que permite exibir o app dentro do iframe. Não remova essa linha.

## 🚀 Passo 2 — Publicar no GitHub Pages

1. Crie uma conta no [github.com](https://github.com) (se ainda não tiver).
2. Crie um repositório **público** (ex.: `aromalab`). *No plano gratuito, o Pages exige repo público —
   sem problema, aqui não há segredos: a URL `/exec` já é pública por natureza.*
3. Envie os arquivos desta pasta para a **raiz** do repositório
   (`index.html`, `manifest.webmanifest`, `sw.js`, `icon.svg`, `icon-192.png`, `icon-512.png`).
   Pode ser pelo site: **Add file → Upload files** → arraste tudo → **Commit**.
4. No repositório: **Settings → Pages**.
5. Em *Build and deployment* → *Source*: **Deploy from a branch**;
   *Branch*: **main** / pasta **/ (root)** → **Save**.
6. Aguarde ~1 min. O endereço aparece no topo da página Pages:
   `https://SEU-USUARIO.github.io/aromalab/`

## 📱 Passo 3 — Instalar no celular

- **Android (Chrome)**: abra a URL do Pages → menu **⋮** → **Instalar app** (ou *Adicionar à tela inicial*).
  Agora abre em janela própria, sem barra de URL, com o ícone do frasco.
- **iPhone (Safari)**: abra a URL → **Compartilhar** → **Adicionar à Tela de Início**.

## 🔄 Atualizações

- **Mudou o AromaLab (Apps Script)?** Nada a fazer aqui — a casca sempre mostra a versão `/exec` atual.
- **Mudou algum arquivo da casca?** Suba o arquivo novo no GitHub e **incremente a versão do cache**
  em `sw.js` (ex.: `aromalab-casca-v1` → `v2`), senão o service worker pode servir a versão antiga.

## ⚠️ O que a casca resolve (e o que não resolve)

✅ Instala como app, janela própria, sem barra de URL, ícone limpo no Android.

❌ **Não** elimina o bug de múltiplas contas Google: o miolo ainda carrega de `script.google.com`,
   então, dentro do app, navegadores com 2+ contas logadas ainda podem falhar.
❌ **iOS**: o "ficar logado" pode ser afetado — o Safari às vezes isola o armazenamento de iframes
   de outra origem, o que pode encerrar a sessão entre aberturas. No Android (Chrome) funciona bem.

> A solução **definitiva** para esses dois pontos é a migração do frontend (servir o HTML/JS
> direto do GitHub Pages e usar o Apps Script só como API JSON). A casca é o caminho do meio:
> 90% da experiência de app nativo, com 10% do esforço.
