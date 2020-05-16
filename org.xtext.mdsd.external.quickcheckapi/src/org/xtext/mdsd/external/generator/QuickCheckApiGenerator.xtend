/*
 * generated by Xtext 2.20.0
 */
package org.xtext.mdsd.external.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.mdsd.external.quickCheckApi.Builder
import org.xtext.mdsd.external.quickCheckApi.Test


/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class QuickCheckApiGenerator extends AbstractGenerator {


	QCBoilerplate boilerplate = new QCBoilerplate;
	QCModelSystem modelSystem = new QCModelSystem;
	QCCmd cmd = new QCCmd;
	QCArbCmd arbCmd = new QCArbCmd;
	QCNextState nextState = new QCNextState;
	QCRunCmd runCmd = new QCRunCmd;
	QCPreconditions preconditions = new QCPreconditions;
	QCMakeFile makeFile = new QCMakeFile;
	QCSetup setup = new QCSetup;
	QCJSONHandler jsonHandler = new QCJSONHandler;
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val builder = resource.allContents.filter(Builder).next;
		
		createFile(fsa, builder);
		setupFile(fsa);
		createMakeFile(fsa, builder);
		createBoilerPlate(fsa, builder);
		
	}
	
	def createBoilerPlate(IFileSystemAccess2 fsa,  Builder builder) {
		boilerplate.initBoilerPlateFiles(fsa, builder);
	}
	
	def createMakeFile(IFileSystemAccess2 fsa, Builder builder) {
		fsa.generateFile("Makefile", makeFile.CompileMakeFile(builder));
	}
	
	def setupFile(IFileSystemAccess2 fsa) {
        fsa.generateFile("setup.sh", setup.setup);
    }
	
	
	def createFile(IFileSystemAccess2 fsa, Builder builder) {
		
		for (test : builder.tests) {
			fsa.generateFile(QCUtils.firstCharLowerCase(test.name) + ".ml", test.compile());
		}	
	}
	
	
	def CharSequence compile(Test test ) {
		'''
		�initDependencies(test)�
		
			
		module APIConf =
		struct
		
		  type sut = (string list) ref
		  type state = string list
		
		  �cmd.initCmd(test)�
		  
		  �jsonHandler.InitJsonVariables(test)�
		 
		  �modelSystem.initModelSystem()�
		  
		  �boilerplate.initUtilities()�
		  
		  �QCJsonIDExtractor.InitExtractIdImpl�
		  
		  �QCJsonExcluder.InitJsonExcluder�
		 
		  �arbCmd.initArb_cmd(test)�
		 
		  �nextState.initNext_State(test)�
		 
		  �runCmd.initRun_cmd(test)�
		 
		  �preconditions.initPreconditions(test)�
		 
		 end
		 
		 
		 module APItest = QCSTM.Make(APIConf)
		 ;; 
		 
		 QCheck_runner.run_tests ~verbose:true
		   [APItest.agree_test ~count:500 ~name:"�test.name�"]
		 '''
	
	}
	
	def initDependencies(Test test) {
		'''
		open QCheck
		open Yojson.Basic
		open Yojson.Basic.Util
		open Str
		open Curl
		open Format
		open Http
		open �QCUtils.firstCharToUpperCase(test.name)�externals
		'''
	}
	
	
}
