package org.xtext.mdsd.external.util.json

import java.util.ArrayList
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.GenRef
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.JsonKey
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.JsonRef
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonDef
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue

class QCJsonPairUtil {
	private static ArrayList<JsonPair> jsonPairs
	
	def static ArrayList<JsonPair>  getAllJsonPairs(JsonRef json){
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
	
	private def static dispatch void getJsonPairs(GenRef value){}	
	private def static dispatch void getJsonPairs(ExcludeValue value){}	
	private def static dispatch void getJsonPairs(ReuseValue value){}	
	private def static dispatch void getJsonPairs(IdentifierValue value){}
	private def static dispatch void getJsonPairs(IntValue value){}
	private def static dispatch void getJsonPairs(StringValue value){}
	
	
	
	
	def Iterable<JsonKey> getJsonKeys(JsonRef json) {
		var ArrayList<JsonKey> list = new ArrayList
		if (json === null) {
			return list
		}
		QCJsonUtils.getAllJsonPairs(json).map[it.key]
	}
	
	}