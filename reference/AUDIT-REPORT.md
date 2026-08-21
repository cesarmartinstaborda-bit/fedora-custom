# Auditoria final do desktop Tahoe dark

## Resultado

O desktop está coeso, escuro e próximo da composição geral de um MacBook Pro
Space Black com macOS Tahoe. A linguagem visual é consistente entre wallpaper,
barra, Dock, ícones, janelas e aplicativos GNOME. A auditoria não encontrou
ganho objetivo em recalibrar novamente opacidade, blur, raios ou espaçamentos.

A única correção foi restaurar quatro atalhos aprovados do Ptyxis às variantes
Ctrl+Shift. Nenhum componente visual foi alterado.

## Referência Apple aplicada

A comparação considerou o material oficial Liquid Glass como uma camada de
controles e navegação que flutua sobre o conteúdo, com translucidez, profundidade,
reflexos discretos e legibilidade. Também considerou a barra de menus totalmente
transparente, Dock refinado, sidebars e toolbars translúcidas, e ícones escuros
com camadas, profundidade e realces especulares.

## Avaliação por área

| Área | Nota | Avaliação objetiva |
|---|---:|---|
| Wallpaper | 9,2 | Imagem Space Black 7164x4628, enquadramento correto e mesma imagem no lock screen. Não é o wallpaper azul/roxo padrão do Tahoe, por escolha aprovada. |
| Dock | 8,5 | Cápsula flutuante, 60 px, blur moderado, padding equilibrado e indicadores discretos. Faltam refração real, magnificação nativa, pilhas e animações físicas do macOS. |
| Ícones | 8,4 | Overrides escuros coerentes e dimensionalmente consistentes; Firefox preservado. Alguns dispositivos e apps herdados continuam sendo SVGs Linux/macOS-like, sem camadas Liquid Glass reais. |
| Menu Bar | 8,3 | Praticamente desaparece no wallpaper, Apple e app ativo alinhados, indicadores compactos. Não existe global menu nem Control Center idêntico ao macOS. |
| Janelas | 7,3 | Raios de 12 px e sombras são consistentes entre GTK4 e janelas não-libadwaita. Controles permanecem à direita por requisito e GTK/libadwaita não é AppKit. |
| Finder/Nautilus | 7,1 | Sidebar dark, Finder icon, pastas claras e espaçamento confortável. Estrutura, toolbar, colunas, tags e Quick Look não reproduzem integralmente o Finder. |
| Terminal | 8,2 | JetBrains Mono, fundo quase preto, transparência discreta e prompt rápido/minimalista. SF Mono e o Terminal/AppKit reais não são usados. |
| Navegação | 8,4 | Apple menu, Overview/Mission Control prático, Alt+Tab por aplicativo, janelas do mesmo app e workspaces dinâmicos. Gestos e animações não são idênticos ao macOS. |
| Pesquisa | 7,2 | Aplicativos, Configurações, arquivos e cálculo funcionam pela pesquisa GNOME. Faltam ações, quick keys, ranking e janela independente do Spotlight Tahoe. |
| Aparência geral | 8,2 | Resultado consistente e estável; as diferenças restantes vêm principalmente da arquitetura GNOME/GTK e não de ajustes mal calibrados. |

## Áreas preservadas por já estarem corretas

- Wallpaper preto Space Black e lock screen correspondente.
- Dock de largura dinâmica, blur, raio 24, padding, ícones e indicadores.
- Oito overrides Tahoe-Dark-Local e o Firefox personalizado.
- Menu Bar de 28 px, Apple, App Name Indicator e indicadores do sistema.
- ArcMenu 69.2 e separação entre clique da Apple e Overview.
- Overview, pesquisa GNOME, Alt+Tab e workspaces dinâmicos.
- Raios de 12 px, sombras e botões de janela à direita.
- WhiteSur GTK3, override WhiteSur GTK4/libadwaita e Shell WhiteSur.
- Nautilus, Ptyxis, prompt Zsh, fontes, cursor e atalhos globais.
- Fedora, Wayland, kernel e driver NVIDIA.

## Temas, extensões e overrides finais

- GTK3: `WhiteSur-Dark-blue`
- GTK4/libadwaita: `~/.config/gtk-4.0/gtk.css -> gtk-Dark.css`
- Shell: `WhiteSur-Dark-blue`
- Ícones: `Tahoe-Dark-Local`, herdando `MacTahoe-blue-dark,hicolor`
- Cursor: `WhiteSur-cursors`, 28 px
- UI: Inter 11; terminal: JetBrains Mono 12
- Extensões ativas: ArcMenu, Blur My Shell, Dash to Dock, Just Perfection,
  App Name Indicator, Rounded Windows e User Themes.
- Launcher local: `~/.local/share/applications/org.mozilla.firefox.desktop`
- Firefox protegido: `~/.local/share/icons/hicolor/256x256/apps/firefox-tahoe-dark.png`
- Overrides de aplicativos: `~/.local/share/icons/Tahoe-Dark-Local/`
- Apple SVG e Shell CSS: `~/.themes/WhiteSur-Dark-blue/gnome-shell/`

## Diferenças e limitações inevitáveis

- Mutter não implementa a refração dinâmica, highlights responsivos e a física
  completa do Liquid Glass de AppKit.
- GNOME Shell não possui global menu universal para GTK3, GTK4, Electron,
  Chromium e Flatpak.
- Quick Settings não é o Control Center do Tahoe.
- Overview não reproduz exatamente Mission Control, e a pesquisa GNOME não tem
  App Intents, ações contextuais, quick keys ou clipboard history do Spotlight.
- Nautilus não oferece as mesmas tags, column view, inspector e integração do Finder.
- Botões de janela ficam à direita por requisito explícito.
- A tela 1920x1080/1x não reproduz densidade e escala Retina de um MacBook Pro 16.
- Inter e JetBrains Mono são substitutos livres; SF Pro/SF Mono não foram instaladas.
- Chrome Flatpak usa sua própria interface e apenas segue o portal dark; não adota
  integralmente o GTK personalizado.
- O botão inferior do ArcMenu mostra `Power Off`: o catálogo pt_BR da versão 69.2
  traduz `Power Off...`, mas omite a string sem reticências. O catálogo binário não
  foi adulterado porque a correção seria frágil e sobrescrita por atualização.

## Dependências de atualizações futuras

- Revalidar as sete extensões antes de migrar para outra versão principal do GNOME.
- Aguardar correção upstream da tradução pt_BR do ArcMenu.
- Atualizações de WhiteSur/MacTahoe não devem ser aplicadas automaticamente sobre
  CSS ou overrides aprovados; comparar primeiro com este backup.
- Não instalar substitutos de Dock, global menu ou Spotlight sem suporte confirmado
  à versão corrente do GNOME e Wayland.

## Desempenho e estabilidade

O GNOME Shell ficou entre 9,6% e 10,2% de um núcleo nas amostras curtas antes e
depois, sem regressão causada pela correção. RSS final aproximado: 607 MiB. GPU:
16-18%, 395-485 MiB e 39-40 C durante testes/capturas. Não houve artefato visual,
erro recente de extensão, unidade de usuário com falha ou novo coredump.

## Evidências e restauração

- Estado anterior: `STATE-BEFORE.txt`
- Estado final: `STATE-AFTER.txt`
- Testes: `tests/VALIDATION.txt`
- Capturas: `visual/desktop-final.png`, `visual/overview-final.png` e
  `visual/apple-menu-final.png`
- Rollback: `README-ROLLBACK.txt`
- Dconf exato: `exact-state/all-before.dconf` e `exact-state/all-after.dconf`
