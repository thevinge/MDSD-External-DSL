package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Host
import org.xtext.mdsd.external.quickCheckApi.Port
import org.xtext.mdsd.external.quickCheckApi.URI
import org.xtext.mdsd.external.quickCheckApi.Request

class QCCmd {
	
	
	
	def CharSequence initCmd(Test test){
		
		val first = '''
		type cmd =
			 «FOR request : test.requests »
			 | «QCUtils.toUpperCaseFunction(request.name)»«request.indexSnippet»
			 «ENDFOR»
			 [@@deriving show { with_path = false }]
		'''
		var second = '''«FOR request : test.requests »
		let «QCUtils.firstCharLowerCase(request.name)»URL="«request.url.protocol»://«request.url.domain.host.compile()»«request.url.domain.port.compile()»/«request.url.domain.uri.compile()»"
		«ENDFOR»'''
		first + second 
	}
			
	 private def CharSequence compile(Host host) {
		if(host.hostParts.empty) {
			'''«FOR ip : host.ips SEPARATOR "."»«ip.toString»«ENDFOR»'''
		} else {
			'''«FOR hostPart : host.hostParts SEPARATOR "."»«hostPart.toString»«ENDFOR»'''
		}	
	}
	
	 private def CharSequence compile(Port port) {
		'''
		«IF !(port === null)  »:« port.value.toString »«ENDIF»'''
	}
	
	 private def CharSequence compile(URI uri) {
		'''
		«IF uri !== null»
		«uri.name»/«FOR part : uri.path SEPARATOR "/"»«part.part»«ENDFOR»
		«ELSE»
		«ENDIF»
		'''.toString.trim
	}
	
	
	
	private def CharSequence indexSnippet(Request request){
		if (QCUtils.requireIndex(request)) {
			''' of int'''
		} else {
			''''''
		}
	}
	
}