package org.xtext.mdsd.external.generator

import java.util.HashMap
import org.xtext.mdsd.external.util.QCNames

import static extension org.xtext.mdsd.external.util.QCUtils.*
import static extension org.xtext.mdsd.external.util.QCNames.*
enum defType {
		dtState,
		dtBody,
		dtCondition
	}
	
class QCJsonDef {
	
	new(String name, defType type ){
		this.name = name
		this.type = type
		reuseVars = new HashMap
		generators = new HashMap
		
	}	
	
	public String requestName
	public String name
	public CharSequence processedJson
	public HashMap<String,String> reuseVars
	public HashMap<String,String> generators
	public String IdentifierKey
	public defType type
	
	
	def CharSequence declaration(){
		'''let «declarationName» «declArguments» = fromJsonToStr («processedJson»)'''
	}
	
	def CharSequence declarationName(){
		'''«(requestName.firstCharLowerCase) + name»'''
	}
	
	def CharSequence declarationUse(){
		'''«declarationName» («valueTableUse»)'''
	}
	
	def CharSequence valueTableName(){
		switch (type) {
			case defType.dtBody: {
				'''«requestName.LocalBodyValueTable»'''
			}
			case defType.dtCondition: {
				'''«requestName.LocalPostConditionValueTable»'''
			}
			case defType.dtState: {
				'''«requestName.LocalStateValueTable»'''
			}
		}
	}
	
	def CharSequence valueTableDeclaration(){
		
		if (usesReuseArguments || !IdentifierKey.isEmpty) {
			'''
			let «valueTableName» json = 
			        let tbl = Hashtbl.create 100 in 
			        	«FOR reuseKey : reuseVars.keySet»
			        	Hashtbl.add tbl "«reuseKey»" (jsonElementExtractor "«reuseVars.get(reuseKey)»" (fromStrToJson json));
			        	«ENDFOR»
			        	«IF !IdentifierKey.isEmpty»
			        	Hashtbl.add tbl "«IdentifierKey»" (jsonElementExtractor "«IdentifierKey»" (fromStrToJson json));
			        	«ENDIF»
			            tbl
			'''
		} else {
			''''''
			
		}
		
	}
	
	def CharSequence valueTableUse(){
		if (usesReuseArguments) {
			'''«valueTableName» «arguments»'''
		} else {
			''''''
		}
		
	}
	
	def boolean usesReuseArguments(){
		(reuseVars.size > 0)
	}
	
	def CharSequence arguments(){
		if (usesReuseArguments) {
			'''(json)'''
		} else {
			'''()'''
		}
	}
	
	private def CharSequence declArguments(){
		if (usesReuseArguments || !IdentifierKey.isEmpty) {
			'''tbl'''
		} else {
			'''()'''
		}
	}
	
}