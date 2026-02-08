#!/usr/bin/env ruby
# frozen_string_literal: true

require "find"

ROOT = ARGV[0] || "."

# captura apenas o conteúdo do t("...")
PATTERN = /<%=\s*(t\(".*?"\))\s*%>/

changed_files = 0
total_replacements = 0

Find.find(ROOT) do |path|
  next unless File.file?(path)
  next unless File.extname(path) == ".erb"

  begin
    original = File.binread(path)
  rescue => e
    warn "⚠️  Não consegui ler #{path}: #{e.message}"
    next
  end

  count = original.scan(PATTERN).length
  next if count == 0

  updated = original.gsub(PATTERN, '\1')

  begin
    File.binwrite(path, updated)
  rescue => e
    warn "⚠️  Não consegui escrever #{path}: #{e.message}"
    next
  end

  changed_files += 1
  total_replacements += count
  puts "✅ #{path} (#{count} substituição(ões))"
end

puts "\nResumo: #{total_replacements} substituição(ões) em #{changed_files} arquivo(s)."
