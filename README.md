# MediaP

A media processing library for handling cache for your image transformation service.

Use it as a proxy between your image transformation service and your application.

## Installation

Clone the repository and install dependencies:

```bash
git clone https://github.com/your-username/media_p.git
cd media_p
mix deps.get
```

## Configuration

Add the following configuration to your `config/config.exs`:

```elixir
path = Path.expand("../", __DIR__)

config :media_p,
  transformed_path: "#{path}/assets/transformed",
  original_path: "#{path}/assets/original",
  segments_before_flags: 0,
  origin: "your-domain.com",
  req_options: []
```

The configuration options are:

- `transformed_path` - Directory path for storing transformed images
- `original_path` - Directory path for storing original images
- `segments_before_flags` - Number of URL segments to skip before processing flags
- `origin` - Domain name for generating media URLs
- `req_options` - Request options for downloading images (keep it empty by default)

## Roadmap

- Improve error handling and logging
- Storage management: delete old files
- Make it work for video pipelines
- Storage management: set size limits for total storage
