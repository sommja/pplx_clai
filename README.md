# Perplexity CLI (pplx)

A command-line interface for Perplexity AI, providing conversation management, image generation, and export capabilities.

## [Features](pplx://action/followup)

- Interactive conversation mode
- Thread management
- Image generation
- Markdown and PDF export
- Command completion
- XDG-compliant configuration

## [Installation](pplx://action/followup)

```
git clone https://github.com/sommja/pplx_clai.git
cd pplx-cli
./install.sh
```

## [Requirements](pplx://action/followup)

- bash 4.0+
- jq
- curl
- pandoc
- fzf (optional, but recommended)

## [Configuration](pplx://action/followup)

First-time setup:

```
pplx init
```

This will prompt for your Perplexity AI API key and create necessary configuration files.

## [Usage](pplx://action/followup)

### [Interactive Mode](pplx://action/followup)

Simply run:

```
pplx
```

### [Thread Management](pplx://action/followup)

### List threads

```
pplx thread list
```

### Create new thread

```
pplx thread new "Initial question"
```

### Switch thread

```
pplx thread switch <thread_id>
```


## [Image Generation](pplx://action/followup)

### Generate image

```
pplx image generate "A cyberpunk cat in neon colors"
```

### List images in current thread

```
pplx image list 
```

## [Export](pplx://action/followup)

### Export to markdown

```
pplx export md
```

### Export to PDF

```
pplx export pdf
```

## [Directory Structure](pplx://action/followup)

~/.config/pplx/
└── config.json # Configuration file

~/.local/share/pplx/
├── scripts/ # Script files
├── completions/ # Bash completion
└── threads/ # Thread storage


## [Contributing](pplx://action/followup)

Contributions are welcome! Please feel free to submit a Pull Request.

## [License](pplx://action/followup)

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.

