package org.xtext.mdsd.external.generator.ocaml

import org.eclipse.emf.common.util.EList
import org.xtext.mdsd.external.quickCheckApi.Builder
import org.xtext.mdsd.external.quickCheckApi.Test

import static extension org.xtext.mdsd.external.util.QCUtils.*

class QCMakeFile {
	
	
	def CharSequence CompileMakeFile(Builder builder){
		'''
			«builder.tests.phonyHeader»
			
			«FOR test : builder.tests» 
				«test.name.firstCharLowerCase»:
					ocamlbuild -r \
					-use-ocamlfind \
					-package \
					qcheck,\
					cohttp-lwt-unix,\
					cohttp,\
					lwt,\
					str,\
					yojson,\
					ppx_deriving.show,\
					qcstm,\
					curl \
					-tag thread \
					«test.name.firstCharLowerCase».native \
					http.native \
					«IF test.resetHook === null»
					«test.name.firstCharLowerCase»externals.native
					«ENDIF»
			
			«ENDFOR»
			run:
				«FOR test : builder.tests»   
					./«test.name.firstCharLowerCase».native
				«ENDFOR»		
			
			clean:
				ocamlbuild -clean
		'''

	}
	
	
	def CharSequence phonyHeader(EList<Test> tests){
		'''
			all: clean «FOR test : tests SEPARATOR ' '»«test.name.firstCharLowerCase»«ENDFOR»
			.PHONY: all
		'''
	}
}
