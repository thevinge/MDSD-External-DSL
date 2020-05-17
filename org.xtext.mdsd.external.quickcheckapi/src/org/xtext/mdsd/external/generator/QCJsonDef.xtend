package org.xtext.mdsd.external.generator

import java.util.HashMap


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
		
	}	
	
	public String requestName
	public String name
	public CharSequence processedJson
	public HashMap<String,String> reuseVars
	public String IdentifierKey
	public defType type
	
	
	def CharSequence declaration(){
		'''let «declarationName» «declArguments» = fromJsonToStr («processedJson»)'''
	}
	
	def CharSequence declarationName(){
		'''«QCUtils.firstCharLowerCase(requestName) + name»'''
	}
	
	def CharSequence declarationUse(){
		'''«declarationName» («valueTableUse»)'''
	}
	
	def CharSequence valueTableName(){
		switch (type) {
			case defType.dtBody: {
				'''«QCNames.LocalBodyValueTable(requestName)»'''
			}
			case defType.dtCondition: {
				'''«QCNames.LocalPostConditionValueTable(requestName)»'''
			}
			case defType.dtState: {
				'''«QCNames.LocalStateValueTable(requestName)»'''
			}
		}
	}
	
	def CharSequence valueTableDeclaration(){
		
		if (usesReuseArguments) {
			'''
			let «valueTableName» json = 
			        let tbl = Hashtbl.create 100 in 
			        	«FOR reuseKey : reuseVars.keySet»
			        	Hashtbl.add tbl "«reuseKey»" (jsonElementExtractor "«reuseVars.get(reuseKey)»" (fromStrToJson json));
			        	«ENDFOR»
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
	
	private def boolean usesReuseArguments(){
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
		if (usesReuseArguments) {
			'''tbl'''
		} else {
			'''()'''
		}
	}
	
}