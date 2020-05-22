package org.xtext.mdsd.external.util.json

import java.util.ArrayList
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.GenRef
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.JsonRef
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.NameStringGen
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue

class QCJsonUtils {
	
	
	def static dispatch boolean jsonContainsType(JsonDefRef json, Class<? extends Json> type){

		json.ref?.json?.jsonContainsType(type)
	}
	
	def static dispatch boolean jsonContainsType(Json json, Class<? extends Json> type){

		json.data?.jsonContainsType(type)
	}
	
	def static dispatch boolean jsonContainsType(JsonObject json, Class<? extends Json> type){
		for (pair : json.jsonPairs) {
			if (pair.jsonContainsType(type)){
				return true
			}
		}
		false
	}
	
	def static dispatch boolean jsonContainsType(JsonList json, Class<? extends Json> type){
		for (value : json.jsonValues) {
			if (value.jsonContainsType(type)){
				return true
			}
		}
		false
	}
	
	def static dispatch boolean jsonContainsType(JsonPair json, Class<? extends Json> type){
		json.value?.jsonContainsType(type)
	}
	
	def static dispatch boolean jsonContainsType(IntValue value, Class<? extends Json> type){
		if(type.isAssignableFrom(value?.class)){
			return true
		}
		false
	}
	
	def static dispatch boolean jsonContainsType(StringValue value, Class<? extends Json> type){
		if(type.isAssignableFrom(value?.class)){
			return true
		}
		false
	}
	
	def static dispatch boolean jsonContainsType(NestedJsonValue json, Class<? extends Json> type){
		json.value?.jsonContainsType(type)
	}
	
	def static dispatch boolean jsonContainsType(ListJsonValue json, Class<? extends Json> type){
		json.value?.jsonContainsType(type)
	}
	
	
	def static dispatch boolean jsonContainsType(CustomValue json, Class<? extends Json> type){
		json.value?.jsonContainsType(type)
	}
	
	def static dispatch boolean jsonContainsType(NameStringGen value, Class<? extends Json> type){
		if(type.isAssignableFrom(value?.class)){
			return true
		}
		false
	}
	
	def static dispatch boolean jsonContainsType(ExcludeValue value, Class<? extends Json> type){
		if(type.isAssignableFrom(value?.class)){
			return true
		}
		false
	}
	
	def static dispatch boolean jsonContainsType(GenRef value, Class<? extends Json> type){
		if(type.isAssignableFrom(value?.class)){
			return true
		}
		false
	}
	
	def static dispatch boolean jsonContainsType(ReuseValue value, Class<? extends Json> type){
		if(type.isAssignableFrom(value?.class)){
			return true
		}
		false
	}
	
	def static dispatch boolean jsonContainsType(IdentifierValue value, Class<? extends Json> type){
		if(type.isAssignableFrom(value?.class)){
			return true
		}
		false
	}
	
	

	
	def static jsonAllOfType(JsonRef json){
		QCJsonTypeUtil.jsonAllOfType(json)
	}
	
	def static jsonAllOfType(JsonRef json, Class<? extends Json> type){
		QCJsonTypeUtil.jsonAllOfType(json, type)
	}
	
		
	def static ArrayList<JsonPair>  getAllJsonPairs(JsonRef json){
		QCJsonPairUtil.getAllJsonPairs(json)
	}
	
	
}
