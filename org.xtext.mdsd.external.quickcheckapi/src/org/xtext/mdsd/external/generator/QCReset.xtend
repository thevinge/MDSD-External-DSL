package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.ResetHook
import org.xtext.mdsd.external.quickCheckApi.Sql
import org.xtext.mdsd.external.quickCheckApi.Web
import org.xtext.mdsd.external.quickCheckApi.Pgsql
import org.xtext.mdsd.external.quickCheckApi.Mssql
import org.xtext.mdsd.external.quickCheckApi.Sqlight
import org.xtext.mdsd.external.quickCheckApi.Mysql
import org.xtext.mdsd.external.quickCheckApi.PUT
import org.xtext.mdsd.external.quickCheckApi.POST
import org.xtext.mdsd.external.quickCheckApi.GET
import org.xtext.mdsd.external.quickCheckApi.DELETE
import org.xtext.mdsd.external.quickCheckApi.PATCH
import org.xtext.mdsd.external.quickCheckApi.URL
import org.xtext.mdsd.external.quickCheckApi.Body

class QCReset {
	def CharSequence compile(ResetHook rh) {
		rh.driver.compileDriver
	}
	
	def dispatch CharSequence compileDriver(Web web) {
		'''let cleanup _  = ignore(Http.«web.method.compileMethod» («web.url.compileUrl») «IF web.body !== null» «web.body.compileBody» «ENDIF»)'''
	}
	
	def dispatch CharSequence compileDriver(Pgsql sql) {
		
	} 
	
	def dispatch CharSequence compileDriver(Mssql sql) {
		
	}
	
	def dispatch CharSequence compileDriver(Sqlight sql) {
		
	}
	
	def dispatch CharSequence compileDriver(Mysql sql) {
		
	}
	
	def CharSequence compileUrl(URL url) {
		'''«url.protocol»://«QCWebUtils.compile(url.domain.host)»«QCWebUtils.compile(url.domain.port)»/«QCWebUtils.compile(url.domain.uri)»'''
	}

	
	def CharSequence compileBody(Body body) {
		QCUtils.compileJson(body.value)
	}	
	
	def dispatch compileMethod (GET get) '''get'''
	def dispatch compileMethod (POST post) '''rawpost'''
	def dispatch compileMethod (PUT put) '''put'''
	def dispatch compileMethod (PATCH patch) '''patch'''
	def dispatch compileMethod (DELETE delete) '''delet'''
}