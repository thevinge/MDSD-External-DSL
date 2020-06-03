package org.xtext.mdsd.external.ui.hovering

import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.eclipse.emf.ecore.EObject
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Model
import org.xtext.mdsd.external.quickCheckApi.StringData
import org.xtext.mdsd.external.quickCheckApi.BooleanData
import org.xtext.mdsd.external.quickCheckApi.IntData
import org.xtext.mdsd.external.quickCheckApi.UserData
import org.xtext.mdsd.external.quickCheckApi.Feature

public class QuickCheckEObjectHoverProvider extends DefaultEObjectHoverProvider {
	override getHoverInfoAsHtml(EObject o) {
		if (o instanceof Test) {
			return '''
			<p>
			This is a Model and its name is : <b>«o.name»</b>
			</p>
			'''
		}
		else if (o instanceof Model) {
			return '''
			<p>
			
			«o.compileModel»
			</p>
			'''
		}
		else if (o instanceof StringData) {
			return '''
			<p>
			«IF o.regex !== null»
			regex «o.regex» example -
			«ELSE»
			«ENDIF»
			</p>
			'''
		}
		 else
			return super.getHoverInfoAsHtml(o)
	}
	
	def compileModel(Model m) {
		'''
		«m.name»
		«FOR feature:m.features SEPARATOR "\n"»
		<p>«feature.name» is «feature.typeData.compile»</p>
		«ENDFOR»
		'''
	}
	
	def dispatch compile(StringData d) '''
	«IF d.regex !== null»
	string regex «d.regex»
	«ELSE»
	string
	«ENDIF»
	'''
	def dispatch compile(BooleanData d) '''bool'''
	def dispatch compile(IntData d) '''int'''
	def dispatch compile(UserData d) '''	«d.type.compileModel»'''
}