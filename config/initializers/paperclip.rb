paperclip_settings_file = File.join(Rails.root, "config", "paperclip.yml")

if File.exists?(paperclip_settings_file)
  paperclip_settings = YAML.load_file(paperclip_settings_file)
  Paperclip.options[:command_path] = paperclip_settings["path_to_imagemagick"]
end