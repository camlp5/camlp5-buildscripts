```sh
 $ ../../src/join_meta -rewrite pa_ppx_regexp_runtime:pa_ppx_regexp.runtime -direct-include t/join_meta/pa_perl -wrap-subdir runtime:t/join_meta/runtime
 
   # Specifications for the "pa_ppx_regexp" preprocessor:
   requires = "camlp5,fmt,re,pa_ppx.base,pa_ppx_regexp.runtime,camlp5.parser_quotations"
   version = "0.01"
   description = "pa_ppx_regexp: pa_ppx_regexp rewriter"
 
   # For linking
   package "link" (
   requires = "camlp5,fmt,re,pa_ppx.base.link,camlp5.parser_quotations.link"
   archive(byte) = "pa_ppx_regexp.cma"
   archive(native) = "pa_ppx_regexp.cmxa"
   )
 
   # For the toploop:
   archive(byte,toploop) = "pa_ppx_regexp.cma"
 
     # For the preprocessor itself:
     requires(syntax,preprocessor) = "camlp5,fmt,re,pa_ppx.base,camlp5.parser_quotations"
     archive(syntax,preprocessor,-native) = "pa_ppx_regexp.cma"
     archive(syntax,preprocessor,native) = "pa_ppx_regexp.cmxa"
 
 
 package "runtime" (
 
   # Specifications for the "pa_ppx_regexp_runtime" package:
   requires = "fmt"
   version = "0.01"
   description = "pa_ppx_regexp runtime support"
 
   # For linking
   archive(byte) = "pa_ppx_regexp_runtime.cma"
   archive(native) = "pa_ppx_regexp_runtime.cmxa"
 
   # For the toploop:
   archive(byte,toploop) = "pa_ppx_regexp_runtime.cma"
 
 
 )
 ```

```sh
 $ env TOP=../.. ../../src/LAUNCH -- ocamlfind camlp5-buildscripts/join_meta -rewrite pa_ppx_regexp_runtime:pa_ppx_regexp.runtime -direct-include t/join_meta/pa_perl -wrap-subdir runtime:t/join_meta/runtime
 
   # Specifications for the "pa_ppx_regexp" preprocessor:
   requires = "camlp5,fmt,re,pa_ppx.base,pa_ppx_regexp.runtime,camlp5.parser_quotations"
   version = "0.01"
   description = "pa_ppx_regexp: pa_ppx_regexp rewriter"
 
   # For linking
   package "link" (
   requires = "camlp5,fmt,re,pa_ppx.base.link,camlp5.parser_quotations.link"
   archive(byte) = "pa_ppx_regexp.cma"
   archive(native) = "pa_ppx_regexp.cmxa"
   )
 
   # For the toploop:
   archive(byte,toploop) = "pa_ppx_regexp.cma"
 
     # For the preprocessor itself:
     requires(syntax,preprocessor) = "camlp5,fmt,re,pa_ppx.base,camlp5.parser_quotations"
     archive(syntax,preprocessor,-native) = "pa_ppx_regexp.cma"
     archive(syntax,preprocessor,native) = "pa_ppx_regexp.cmxa"
 
 
 package "runtime" (
 
   # Specifications for the "pa_ppx_regexp_runtime" package:
   requires = "fmt"
   version = "0.01"
   description = "pa_ppx_regexp runtime support"
 
   # For linking
   archive(byte) = "pa_ppx_regexp_runtime.cma"
   archive(native) = "pa_ppx_regexp_runtime.cmxa"
 
   # For the toploop:
   archive(byte,toploop) = "pa_ppx_regexp_runtime.cma"
 
 
 )
 ```
