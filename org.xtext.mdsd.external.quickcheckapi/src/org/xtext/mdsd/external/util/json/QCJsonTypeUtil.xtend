package org.xtext.mdsd.external.util.json

import java.util.ArrayList
import java.util.HashMap
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
import org.xtext.mdsd.external.quickCheckApi.NestedJsonDef
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue

class QCJsonTypeUtil {
	
	
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
	
	def static dispatch void jsonCountType(GenRef value){
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
	}}