package org.xtext.mdsd.external.util

import org.xtext.mdsd.external.quickCheckApi.Request

import static extension org.xtext.mdsd.external.util.QCUtils.*

class QCNames {
	def static String LocalStateJsonDef(String name){
		name.firstCharLowerCase + LocalStateJsonDef()
	}
	
	def static String LocalStateValueTable(String name){
		name.firstCharLowerCase + LocalStateValueTable()
	}
	
	def static String JsonDefName(String name){
		name.firstCharLowerCase + JsonDefName()
	}
	
	def static String JsonDefValueTable(String name){
		name.firstCharLowerCase + JsonDefValueTable()
	}
	
	def static String LocalBodyJsonDef(String name){
		name.firstCharLowerCase + LocalBodyJsonDef()
	}
	def static String LocalBodyValueTable(String name){
		name.firstCharLowerCase + LocalBodyValueTable()
	}
	
	def static String LocalPostConditionJsonDef(String name){
		name.firstCharLowerCase + LocalPostConditionJsonDef()
	}
	
	def static String LocalPostConditionValueTable(String name){
		name.firstCharLowerCase + LocalPostConditionValueTable()
	}
	
	
	def static urlName(String name){
		name.firstCharLowerCase + "URL"
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
