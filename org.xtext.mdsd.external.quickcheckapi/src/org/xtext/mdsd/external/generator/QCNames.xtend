package org.xtext.mdsd.external.generator

class QCNames {
	def static String LocalStateJsonDef(String name){
		QCUtils.firstCharLowerCase(name) + "LocalStateJsonDef"
	}
	
	def static String JsonDef(String name){
		QCUtils.firstCharLowerCase(name) + "JsonDef"
	}
	
	def static String LocalBodyJsonDef(String name){
		QCUtils.firstCharLowerCase(name) + "LocalBodyJsonDef"
	}
	
	def static String LocalPostConditionJsonDef(String name){
		QCUtils.firstCharLowerCase(name) + "LocalPostCondJsonDef"
	}
}