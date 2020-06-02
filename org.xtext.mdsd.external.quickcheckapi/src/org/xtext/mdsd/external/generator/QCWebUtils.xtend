package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Host
import org.xtext.mdsd.external.quickCheckApi.Port
import org.xtext.mdsd.external.quickCheckApi.URI

class QCWebUtils {
 	static def CharSequence compile(Host host) {
		if(host.hostParts.empty) {
			'''«FOR ip : host.ips SEPARATOR "."»«ip.toString»«ENDFOR»'''
		} else {
			'''«FOR hostPart : host.hostParts SEPARATOR "."»«hostPart.toString»«ENDFOR»'''
		}	
	}
	
	 static def CharSequence compile(Port port) {
		'''
		«IF !(port === null)  »:« port.value.toString »«ENDIF»'''
	}
	
	 static def CharSequence compile(URI uri) {
		'''
		«IF uri !== null»
		«uri.name»/«FOR part : uri.path SEPARATOR "/"»«part.part»«ENDFOR»
		«ELSE»
		«ENDIF»
		'''.toString.trim
	}}