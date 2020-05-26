package org.xtext.mdsd.external.generator.ocaml

import org.xtext.mdsd.external.quickCheckApi.Host
import org.xtext.mdsd.external.quickCheckApi.Port
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.URI
import org.xtext.mdsd.external.quickCheckApi.URL
import org.xtext.mdsd.external.quickCheckApi.URLDefRef
import org.xtext.mdsd.external.util.QCUtils

import static extension org.xtext.mdsd.external.util.QCUtils.*

class QCCmd {
	def CharSequence initCmd(Test test){
		'''
			type cmd =
				 «FOR request : test.requests »
				 	| «request.name.firstCharToUpperCase»«request.argumentsSnippet»
				 «ENDFOR»
				 [@@deriving show { with_path = false }]
			
			«FOR request : test.requests »
				let «request.name.firstCharLowerCase»URL="«request.compileURL»"
			«ENDFOR»
		'''
	}
	
	
	def CharSequence compileURL(Request request){
		'''«request.url.chooseURL.protocol»://«request.url.chooseURL.domain.host.compile()»«request.url.chooseURL.domain.port.compile()»/«request.url.chooseURI.compile()»'''
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
		'''.toString.trim
	}
	
	
	
	private def CharSequence argumentsSnippet(Request request){
		if (QCUtils.requireIndex(request)) {
			''' of int'''
		} else {
			''' of string'''
		}
	}
	
}
