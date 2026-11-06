# lillthors.dev

Personal site and CV of Christopher Lillthors, built with
[Hugo](https://gohugo.io), [Tailwind CSS](https://tailwindcss.com) and
[Typst](https://typst.app). Live at
[lillthors.dev](https://lillthors.dev).

- **Theme: "Silkscreen".** A circuit-board look: solder-mask surfaces, copper
  traces and silkscreen labels in dark mode, a schematic on paper in light
  mode (it follows the system setting). No JavaScript, self-hosted fonts
  (Space Grotesk, Inter, JetBrains Mono).
- **One source for the CV**, [`data/cv.yaml`](data/cv.yaml), rendered as:
  - HTML at `/cv/` by Hugo ([`layouts/cv.html`](layouts/cv.html)), and on
    the home page;
  - PDF at `/cv.pdf` by Typst ([`cv/cv.typ`](cv/cv.typ)), using the
    [basic-resume](https://typst.app/universe/package/basic-resume) template;
  - a contact card at `/christopher-lillthors.vcf` and a
    [JSON Resume](https://jsonresume.org) at `/cv.json`, both by Hugo
    (`layouts/home.vcard.vcf`, `layouts/home.resume.json`).

## Setup

The tools are pinned with [mise](https://mise.jdx.dev): Hugo, Typst, the
standalone Tailwind CLI, htmltest and Pandoc, all single binaries, so no
Node.js is involved.

```sh
mise install   # versions from mise.toml, checksums from mise.lock
```

The build steps are mise tasks, defined in `mise.toml`: `mise tasks` lists
them, and `mise run <task>` runs one with the pinned tools on `PATH`.

To upgrade a tool, change its version in `mise.toml` and run `mise lock` to
refresh `mise.lock`.

## Working on the site

```sh
mise run serve   # PDF + CSS, then hugo server with drafts on :1313; Tailwind recompiles on change
mise run build   # production build into public/
mise run check   # build, then fail on any broken internal link or anchor (htmltest)
mise run cv      # only the PDF, into static/cv.pdf (skipped when it is up to date)
mise run css     # only the CSS, into assets/css/site.css
mise run clean   # remove everything the tasks generate
```

The stylesheet is [`assets/css/main.css`](assets/css/main.css): Tailwind v4
plus the typography plugin, with the color tokens for both schemes at the
top. Tailwind scans `layouts/` and `content/` for the classes in use.

Hugo's own Tailwind integration (`css.TailwindCSS`) runs Tailwind through
Node.js, so the site compiles its CSS with the standalone CLI instead, and
Hugo only fingerprints the result.

### Writing a post

```sh
hugo new content posts/my-post/index.md
```

Posts start as drafts (`draft: true`) and only show up with `mise run serve`.
Remove the line to publish. Images and other files can sit next to
`index.md` in the post's folder. Front matter options:

| Key       | Purpose                                                      |
| --------- | ------------------------------------------------------------ |
| `summary` | One sentence for lists, the RSS feed and link previews.      |
| `tags`    | Topics, listed under `/tags/`.                               |

Markdown is rendered by [Pandoc](https://pandoc.org), not Hugo's own renderer.
` ```{.go .numberLines} ` numbers a code block's lines, and ASCII diagrams go
in ` ```text ` blocks, which shrink to fit a phone (about 56 columns).

Each post gets its own link-preview image: its date and title, drawn by Hugo
onto `assets/images/og-post.png` with `assets/fonts/SpaceGrotesk-SemiBold.ttf`.

### Citations

Pandoc resolves citations and adds a bibliography, as LaTeX does. Hugo doesn't
pass front matter to Pandoc, so the bibliography goes in a second metadata
block in the body, with paths from the repository root:

```markdown
---
title: My post
---

Logical clocks order events [@lamport1978], and TeX typesets them
[see @knuth1984, p. 12].

---
bibliography: content/posts/my-post/refs.bib
link-citations: true
---

## References
```

The references go at the end of the post, or wherever a `<div id="refs"></div>`
is. A `csl:` line picks a citation style, such as an IEEE `.csl` file from the
[CSL styles](https://github.com/citation-style-language/styles); the default
is Chicago author-date.

## Deployment

[`.github/workflows/publish.yaml`](.github/workflows/publish.yaml) runs on
pushes to `main`, weekly (so future-dated posts go live) and on demand.
[mise-action](https://github.com/jdx/mise-action) installs mise and the tools
in `mise.lock`, `mise run check` builds and checks the site, and it is deployed
to GitHub Pages. Pull requests are built but not deployed.

The site is served at `lillthors.dev`, set as the custom domain under the
repository's Settings → Pages.

## Layout

```
content/        Markdown: home intro, posts, page front matter
data/cv.yaml    CV content (shared by Hugo and Typst)
cv/cv.typ       PDF layout for the CV
layouts/        Hugo templates (home, posts, CV, RSS)
assets/css/     main.css, the Tailwind source; site.css is generated
assets/images/  og-post.png, the background of a post's link preview
static/         Fonts (SIL OFL), favicon, og.png (the 1200×630 link preview); the PDFs are generated here
mise.toml       Tool versions and the build tasks; mise.lock pins the downloads
```
