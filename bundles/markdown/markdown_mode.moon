-- Copyright 2013-2015 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

is_header = (line) ->
  return true if line\match('^%#+%s')
  next = line.next
  return next and next\match('^[-=]+%s*$')

{
  lexer: bundle_load('markdown_lexer')

  default_config:
    word_pattern: r'\\b\\w[\\w\\d_-]+\\b'
    cursor_line_highlighted: false

  auto_pairs: {
      '(': ')'
      '[': ']'
      '{': '}'
      '"': '"'
    }

  code_blocks:
    multiline: {
      { r'```(\\w+)?\\s*$', '^```', '```'}
    }

  is_paragraph_break: (line) ->
    return true if line.is_blank or is_header line
    prev = line.previous
    return true if prev and (is_header(prev) or prev\match('^```'))
    line\umatch r'^(?:[\\s-*[]|```)'

  line_is_reflowable: (line) =>
    no_break = { '^```', '^%s*#' }
    for p in *no_break
      return false if line\find p

    true

  structure: (editor) =>
    [l for l in *editor.buffer.lines when is_header(l)]
}
