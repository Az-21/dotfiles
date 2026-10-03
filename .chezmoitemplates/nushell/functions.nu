# Sort keys (recursively) and add trailing commas, in place
# @dependency { `jaq` }
export def nu-sort-json-with-trailing-commas [file: path] {
  let r = (
    open --raw $file
    | str replace --all --regex ',(\s*[}\]])' '$1'
    | jaq -S .
    | complete
  )
  if $r.exit_code == 0 {
    $r.stdout
    | str replace --all --regex '([^\s,{\[])(\n\s*[}\]])' '$1,$2'
    | save -f $file
  } else {
    error make { msg: $r.stderr }
  }
}
