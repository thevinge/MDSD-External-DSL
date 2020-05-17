package org.xtext.mdsd.external.generator

class QCNames {
	def static String LocalStateJsonDef(String name){
		QCUtils.firstCharLowerCase(name) + LocalStateJsonDef()
	}
	
	def static String LocalStateValueTable(String name){
		QCUtils.firstCharLowerCase(name) + LocalStateValueTable()
	}
	
	def static String JsonDefName(String name){
		QCUtils.firstCharLowerCase(name) + JsonDefName()
	}
	
	def static String JsonDefValueTable(String name){
		QCUtils.firstCharLowerCase(name) + JsonDefValueTable()
	}
	
	def static String LocalBodyJsonDef(String name){
		QCUtils.firstCharLowerCase(name) + LocalBodyJsonDef()
	}
	def static String LocalBodyValueTable(String name){
		QCUtils.firstCharLowerCase(name) + LocalBodyValueTable()
	}
	
	def static String LocalPostConditionJsonDef(String name){
		QCUtils.firstCharLowerCase(name) + LocalPostConditionJsonDef()
	}
	
	def static String LocalPostConditionValueTable(String name){
		QCUtils.firstCharLowerCase(name) + LocalPostConditionValueTable()
	}
	
	
	
	
	def static String LocalStateJsonDef(){
		"LocalStateJsonDef"
	}
	
	def static String LocalStateValueTable(){
		"LocalStateValueTbl"
	}
	
	def static String JsonDefName(){
		"JsonDef"
	}
	
	def static String JsonDefValueTable(){
		"ValueTbl"
	}
	
	def static String LocalBodyJsonDef(){
		"LocalBodyJsonDef"
	}
	def static String LocalBodyValueTable(){
		"LocalBodyValueTbl"
	}
	
	def static String LocalPostConditionJsonDef(){
		"LocalPostCondJsonDef"
	}
	
	def static String LocalPostConditionValueTable(){
		"LocalPostCondValueTbl"
	}
}