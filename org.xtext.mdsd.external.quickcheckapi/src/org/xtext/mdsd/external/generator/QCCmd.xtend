package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Model
import org.xtext.mdsd.external.quickCheckApi.Mtest

class QCCmd {
	
	
	
	def CharSequence initCmd(Test test){
		
		val first = '''
		type cmd =
			 «FOR request : test.requests »
			 | «QCUtils.toUpperCaseFunction(request.name)»«request.indexSnippet(test.model)»
			 «ENDFOR»
			 [@@deriving show { with_path = false }]
			 
		'''
		var second = '''«FOR request : test.requests »
		let «QCUtils.firstCharLowerCase(request.name)»URL="«request.url.protocol»://«QCWebUtils.compile(request.url.domain.host)»«QCWebUtils.compile(request.url.domain.port)»/«QCWebUtils.compile(request.url.domain.uri)»"
		«ENDFOR»'''
		first + second 
	}
	
	
	
	private def CharSequence indexSnippet(Request request, Mtest model){
		if (QCUtils.requireIndex(request)) {
			''' of int'''
		} else if(QCUtils.requireType(request)) {
			''' of «model.modelUnderTest.name»'''
		}
	}
	
}