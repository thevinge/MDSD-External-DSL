package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Builder
import org.eclipse.emf.common.util.EList
import org.xtext.mdsd.external.quickCheckApi.Test

class QCMakeFile {
	
	
	def CharSequence CompileMakeFile(Builder builder){
		'''
		�builder.tests.phonyHeader�
		
		�FOR test : builder.tests� 
		�QCUtils.firstCharLowerCase(test.name)�:
			ocamlbuild -r \
			-use-ocamlfind \
			-package \
			qcheck,\
			cohttp-lwt-unix,\
			cohttp,\
			lwt,\
			yojson,\
			ppx_deriving.show,\
			qcstm,\
			curl \
			-tag thread \
			�QCUtils.firstCharLowerCase(test.name)�.native \
			http.native \
			�QCUtils.firstCharLowerCase(test.name)�externals.native

		�ENDFOR�
		run:
			�FOR test : builder.tests�   
			./�QCUtils.firstCharLowerCase(test.name)�.native
			�ENDFOR�		
		
		clean:
			ocamlbuild -clean
		'''

	}
	
	
	def CharSequence phonyHeader(EList<Test> tests){
		'''
		all: clean �FOR test : tests SEPARATOR ' '��QCUtils.firstCharLowerCase(test.name)��ENDFOR�
		.PHONY: all
		'''
	}
}