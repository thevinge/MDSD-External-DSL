package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Host
import org.xtext.mdsd.external.quickCheckApi.Port
import org.xtext.mdsd.external.quickCheckApi.URI
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.URL
import org.xtext.mdsd.external.quickCheckApi.URLDefRef

class QCCmd {
	def CharSequence initCmd(Test test){
		'''
		type cmd =
			 «FOR request : test.requests »
			 | «QCUtils.firstCharToUpperCase(request.name)»«request.indexSnippet»
			 «ENDFOR»
			 [@@deriving show { with_path = false }]
		
		«FOR request : test.requests »
		let «QCUtils.firstCharLowerCase(request.name)»URL="«request.url.chooseURL.protocol»://«request.url.chooseURL.domain.host.compile()»«request.url.chooseURL.domain.port.compile()»/«request.url.chooseURI.compile()»"
		«ENDFOR»
		'''
	}
	
	def dispatch URL chooseURL(URL url){
		return url
	}
	
	
	
	def dispatch URL chooseURL(URLDefRef url){
		
		return url.ref.url.chooseURL
	}
	
	def dispatch URI chooseURI(URL url){
		return url.uri
	}
	
	
	
	def dispatch URI chooseURI(URLDefRef url){
		
		return url.extraUri
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
		'''
	}
	
	
	
	private def CharSequence indexSnippet(Request request){
		if (QCUtils.requireIndex(request)) {
			''' of int'''
		} else {
			''''''
		}
	}
	
}