import Config

path = Path.expand("../test", __DIR__)

config :media_p,
  mode: :proxy,
  transformed_path: "#{path}/assets/transformed",
  original_path: "#{path}/assets/original",
  test_path: "#{path}/assets/test",
  segments_before_flags: 0,
  origin: "media.com",
  known_flags: ["w", "h"],
  req_options: [
    plug: {Req.Test, MediaP.Source}
  ]
