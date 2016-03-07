FILE(REMOVE_RECURSE
  "libcom.ubuntu.developer.liu-xiao-guo.mailcheck_mailcheck.pdb"
  "libcom.ubuntu.developer.liu-xiao-guo.mailcheck_mailcheck.so"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/scope.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
