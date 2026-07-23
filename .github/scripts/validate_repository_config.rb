# frozen_string_literal: true

require 'json'
require 'yaml'

JSON.parse(File.read('release-please-config.json'))
JSON.parse(File.read('.release-please-manifest.json'))

workflow_paths = Dir['.github/workflows/*.{yml,yaml}']
issue_form_paths = Dir['.github/ISSUE_TEMPLATE/*.{yml,yaml}']
config_paths = workflow_paths + issue_form_paths + ['.github/dependabot.yml']

config_paths.each do |path|
  YAML.safe_load(File.read(path), aliases: true)
end

issue_form_names = {}

issue_form_paths.each do |path|
  next if File.basename(path) == 'config.yml'

  form = YAML.safe_load(File.read(path), aliases: true)
  abort "#{path}: issue form must be a mapping" unless form.is_a?(Hash)

  %w[name description body].each do |key|
    abort "#{path}: missing #{key}" unless form[key]
  end

  name = form.fetch('name')
  if issue_form_names.key?(name)
    abort "#{path}: duplicate form name also used by #{issue_form_names.fetch(name)}"
  end
  issue_form_names[name] = path

  body = form.fetch('body')
  abort "#{path}: body must be an array" unless body.is_a?(Array)
  abort "#{path}: issue forms support at most 10 body elements" if body.length > 10

  ids = body.map { |item| item['id'] }.compact
  abort "#{path}: duplicate field ids" unless ids.uniq.length == ids.length
end

puts "Validated #{config_paths.length} repository configuration files."
