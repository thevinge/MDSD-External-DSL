package org.xtext.mdsd.external.util

import java.util.ArrayList
import java.util.HashMap
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import org.xtext.mdsd.external.quickCheckApi.IntGen
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.JsonRef
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.NameStringGen
import org.xtext.mdsd.external.quickCheckApi.NestedJsonDef
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.RandomStringGen
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
	
	def static dispatch boolean jsonContainsType(RandomStringGen value, Class<? extends Json> type){
		if(type.isAssignableFrom(value?.class)){
			return true
		}
		false
	}
	
	def static dispatch boolean jsonContainsType(IntGen value, Class<? extends Json> type){
		if(type.isAssignableFrom(value?.class)){
			return true
		}
		false
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
	
	
	
	
	
	
	private static HashMap<String, ArrayList<Json>> jsonDistribution
	private static String currentkey

	
	def static jsonAllOfType(JsonRef json){
		jsonDistribution = new HashMap
		json?.jsonCountType
		jsonDistribution
	}
	
	def static jsonAllOfType(JsonRef json, Class<? extends Json> type){
		jsonDistribution = new HashMap
		json?.jsonCountType
		var filtered = jsonDistribution.filter[k,v| v?.filter[lk| type.isAssignableFrom(lk?.class) ].size > 0]
		filtered
	}
	
	def static dispatch void jsonCountType(JsonDefRef json){

		json.ref?.json?.jsonCountType
	}
	
	def static dispatch void jsonCountType(Json json){

		json.data?.jsonCountType
	}
	
	def static dispatch void jsonCountType(JsonObject json){
		json.jsonPairs?.forEach[it?.jsonCountType]
	}
	
	def static dispatch void jsonCountType(JsonList json){
		json.jsonValues?.forEach[it?.jsonCountType]
	}
	
	def static dispatch void jsonCountType(JsonPair json){
		currentkey = json.key.value
		json.value?.jsonCountType
	}

	def static dispatch void jsonCountType(NestedJsonValue json){
		json.value?.jsonCountType
	}
	
	def static dispatch void jsonCountType(NestedJsonDef json){
		json.value?.json?.jsonCountType
	}
	
	def static dispatch void jsonCountType(ListJsonValue json){
		json.value?.jsonCountType
	}
	
	
	def static dispatch void jsonCountType(CustomValue json){
		json.value?.jsonCountType
	}
	
	def static dispatch void jsonCountType(IntValue value){
		addJsonCount(value)
	}
	
	def static dispatch void jsonCountType(StringValue value){
		addJsonCount(value)
	}
	
	def static dispatch void jsonCountType(RandomStringGen value){
		addJsonCount(value)
	}
	
	def static dispatch void jsonCountType(IntGen value){
		addJsonCount(value)
	}
	
	def static dispatch void jsonCountType(NameStringGen value){
		addJsonCount(value)
	}
	
	def static dispatch void jsonCountType(ExcludeValue value){
		addJsonCount(value)
	}
	
	def static dispatch void jsonCountType(ReuseValue value){
		addJsonCount(value)
	}
	
	def static dispatch void jsonCountType(IdentifierValue value){
		addJsonCount(value)
	}
	
	
	private def static void addJsonCount(Json json){
		if (jsonDistribution.containsKey(currentkey)){
			jsonDistribution.get(currentkey).add(json)
		}else{
			val ArrayList<Json> list = new ArrayList()
			list.add(json)
			jsonDistribution.put(currentkey, list)
		}
	}
	
	
	private static ArrayList<JsonPair> jsonPairs
	
	def static getAllJsonPairs(JsonRef json){
		jsonPairs = new ArrayList
		json?.getJsonPairs
		jsonPairs
	}
	
	private def static dispatch void getJsonPairs(JsonDefRef json){
		json.ref?.json?.getJsonPairs
	}
	
	private def static dispatch void getJsonPairs(Json json){
		json.data?.getJsonPairs
	}
	
	private def static dispatch void getJsonPairs(JsonObject json){
		json.jsonPairs?.forEach[it?.getJsonPairs]
	}
	
	private def static dispatch void getJsonPairs(JsonList json){
		json.jsonValues?.forEach[it?.getJsonPairs]
	}
	
	private def static dispatch void getJsonPairs(JsonPair json){
		jsonPairs.add(json)
		json.value?.getJsonPairs
	}
		
	private def static dispatch void getJsonPairs(NestedJsonValue json){
		json.value?.getJsonPairs
	}
	
	private def static dispatch void getJsonPairs(NestedJsonDef json){
		json.value?.json?.getJsonPairs
	}
	
	private def static dispatch void getJsonPairs(ListJsonValue json){
		json.value?.getJsonPairs
	}
	
	private def static dispatch void getJsonPairs(CustomValue json){}	
	private def static dispatch void getJsonPairs(RandomStringGen value){}	
	private def static dispatch void getJsonPairs(IntGen value){}	
	private def static dispatch void getJsonPairs(NameStringGen value){}	
	private def static dispatch void getJsonPairs(ExcludeValue value){}	
	private def static dispatch void getJsonPairs(ReuseValue value){}	
	private def static dispatch void getJsonPairs(IdentifierValue value){}
	private def static dispatch void getJsonPairs(IntValue value){}
	private def static dispatch void getJsonPairs(StringValue value){}
	
}
