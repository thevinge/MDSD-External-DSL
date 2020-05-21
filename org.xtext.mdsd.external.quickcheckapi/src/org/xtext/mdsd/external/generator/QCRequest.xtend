package org.xtext.mdsd.external.generator

import java.util.ArrayList
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.Body
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.JsonRef
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.Postproposition
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.util.QCJsonReuse
import org.xtext.mdsd.external.util.QCNames

class QCRequest {
	
	new (){
		postCondJsonDefs = new ArrayList
	}
	public String requestName
	public QCJsonDef bodyJsonDef
	public QCJsonDef stateJsonDef
	public ArrayList<QCJsonDef> postCondJsonDefs
	
	def processRequest(Request request){
		
		requestName = request.name
		request.postconditions?.process
		request.body?.process
		request.action?.process
		
	}
	
	
	private def dispatch process(Postproposition condition){
		postCondJsonDefs = new ArrayList
		for (jsonDef : QCJsonCompiler.compileConditionBodies(condition)) {
			jsonDef.requestName = requestName
			postCondJsonDefs.add (jsonDef)
		}
		
	}
	
	private def dispatch process(Body body){
		bodyJsonDef = new QCJsonDef(QCNames.LocalBodyJsonDef, defType.dtBody)		
		bodyJsonDef.processedJson = QCJsonCompiler.compileJson(body.value)
		bodyJsonDef.requestName = requestName
		QCJsonReuse.resetKeys
		QCJsonReuse.isReuseJson(body.value)
		bodyJsonDef.reuseVars = QCJsonReuse.reuseKeys
		bodyJsonDef.IdentifierKey = QCJsonIDExtractor.compileJsonID(body.value).toString
		
	}
	
	private def dispatch process(CreateAction action){
		action.processAction(action.value)
	}
	
	private def dispatch process(DeleteAction action){
		action.processAction(action.value)
	}
	
	private def dispatch process(UpdateAction action){
		action.processAction(action.value)
	}
	
	private def dispatch process(NoAction action){
		
	}
	
	private def processAction(Action action, JsonRef json){
		stateJsonDef = new QCJsonDef(QCNames.LocalStateJsonDef, defType.dtState)		
		stateJsonDef.processedJson = QCJsonCompiler.compileJsonAction(action)
		stateJsonDef.requestName = requestName
		QCJsonReuse.resetKeys
		QCJsonReuse.isReuseJson(json)
		stateJsonDef.reuseVars = QCJsonReuse.reuseKeys
		stateJsonDef.IdentifierKey = QCJsonIDExtractor.compileJsonID(json).toString
	}
	
	
	
}